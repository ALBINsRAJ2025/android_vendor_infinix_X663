#!/bin/bash
set -euo pipefail

MY_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${MY_DIR}/../../.." && pwd)"
SRC_DIR="${ROOT_DIR}/stock_rom/fs_unpacked"
PROP_DIR="${MY_DIR}/proprietary"
OUT_DIR="${ROOT_DIR}/docs"
ALLOWLIST_FILE="${MY_DIR}/dependency-allowlist.txt"

if [[ "${1:-}" == "--src" ]]; then
    if [[ -z "${2:-}" ]]; then
        echo "Missing path after --src"
        exit 1
    fi
    SRC_DIR="${2}"
fi

if [[ ! -d "${PROP_DIR}" ]]; then
    echo "Missing proprietary extraction directory: ${PROP_DIR}"
    exit 1
fi

if [[ ! -d "${SRC_DIR}" ]]; then
    echo "Missing source directory: ${SRC_DIR}"
    exit 1
fi

mkdir -p "${OUT_DIR}"

REPORT_TSV="${OUT_DIR}/vendor_dependency_report.tsv"
REPORT_TXT="${OUT_DIR}/vendor_dependency_report.txt"

SEARCH_DIRS=(
    "${SRC_DIR}/vendor/lib64"
    "${SRC_DIR}/vendor/lib"
    "${SRC_DIR}/vendor/lib64/hw"
    "${SRC_DIR}/vendor/lib/hw"
    "${SRC_DIR}/vendor/lib64/egl"
    "${SRC_DIR}/vendor/lib/egl"
    "${SRC_DIR}/system/system/lib64"
    "${SRC_DIR}/system/system/lib"
    "${SRC_DIR}/system/system/lib64/bootstrap"
    "${SRC_DIR}/system/system/lib/bootstrap"
    "${SRC_DIR}/system_ext/lib64"
    "${SRC_DIR}/system_ext/lib"
    "${SRC_DIR}/product/lib64"
    "${SRC_DIR}/product/lib"
)

mapfile -t EXISTING_DIRS < <(for d in "${SEARCH_DIRS[@]}"; do [[ -d "$d" ]] && echo "$d"; done)
if [[ ${#EXISTING_DIRS[@]} -eq 0 ]]; then
    echo "No dependency search directories found under ${SRC_DIR}"
    exit 1
fi

is_elf() {
    local f="$1"
    file -b "$f" 2>/dev/null | grep -q "ELF"
}

find_provider() {
    local dep="$1"
    local d=""
    for d in "${EXISTING_DIRS[@]}"; do
        if [[ -f "${d}/${dep}" ]]; then
            echo "${d#${SRC_DIR}/}/${dep}"
            return 0
        fi
    done
    return 1
}

{
    echo -e "blob\tdependency\tprovider"
} > "${REPORT_TSV}"

checked=0
missing=0
exceptions=0

is_allowlisted_dep() {
    local dep="$1"
    [[ -f "${ALLOWLIST_FILE}" ]] || return 1
    grep -Fxq "${dep}" "${ALLOWLIST_FILE}"
}

# Check shared libraries and executable services that can carry DT_NEEDED.
while IFS= read -r f; do
    if ! is_elf "$f"; then
        continue
    fi

    rel="${f#${PROP_DIR}/}"
    checked=$((checked + 1))

    while IFS= read -r dep; do
        [[ -z "$dep" ]] && continue

        if provider="$(find_provider "$dep")"; then
            echo -e "${rel}\t${dep}\t${provider}" >> "${REPORT_TSV}"
        elif is_allowlisted_dep "$dep"; then
            echo -e "${rel}\t${dep}\tALLOWLIST" >> "${REPORT_TSV}"
            exceptions=$((exceptions + 1))
        else
            echo -e "${rel}\t${dep}\tMISSING" >> "${REPORT_TSV}"
            missing=$((missing + 1))
        fi
    done < <(readelf -d "$f" 2>/dev/null | awk '/NEEDED/ {gsub(/\[|\]/, "", $5); print $5}' | sort -u)

done < <(find "${PROP_DIR}/vendor" -type f \( -path "*/lib/*.so" -o -path "*/lib64/*.so" -o -path "*/bin/*" -o -path "*/bin/hw/*" \) 2>/dev/null | sort)

resolved=$(( $(wc -l < "${REPORT_TSV}") - 1 - missing - exceptions ))

{
    echo "Vendor dependency scan report"
    echo "Source root: ${SRC_DIR}"
    echo "Checked ELF blobs: ${checked}"
    echo "Resolved dependencies: ${resolved}"
    echo "Allowlisted exceptions: ${exceptions}"
    echo "Missing dependencies: ${missing}"
    echo ""
    echo "Search roots used:"
    for d in "${EXISTING_DIRS[@]}"; do
        echo "- ${d#${SRC_DIR}/}"
    done
    echo ""
    echo "Top missing dependencies:"
    awk -F '\t' 'NR>1 && $3=="MISSING" {print $2}' "${REPORT_TSV}" | sort | uniq -c | sort -nr | head -40
    echo ""
    echo "Allowlisted dependency exceptions:"
    awk -F '\t' 'NR>1 && $3=="ALLOWLIST" {print $1" -> "$2}' "${REPORT_TSV}" | sort | uniq | head -80
    echo ""
    echo "Blobs with missing dependencies:"
    awk -F '\t' 'NR>1 && $3=="MISSING" {print $1}' "${REPORT_TSV}" | sort | uniq | head -120
} > "${REPORT_TXT}"

echo "Wrote ${REPORT_TSV}"
echo "Wrote ${REPORT_TXT}"
if (( missing > 0 )); then
    echo "Dependency scan finished with missing entries."
    exit 2
fi

if (( exceptions > 0 )); then
    echo "Dependency scan finished with allowlisted exceptions and no hard missing entries."
else
    echo "Dependency scan finished with no missing entries."
fi
