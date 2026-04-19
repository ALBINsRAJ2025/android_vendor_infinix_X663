#!/bin/bash
set -euo pipefail

MY_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${MY_DIR}/../../../.." && pwd)"
SRC_DIR="${ROOT_DIR}/stock_rom/fs_unpacked"
LIST_FILE="${MY_DIR}/proprietary-files.txt"
OUT_DIR="${MY_DIR}/proprietary"

if [[ "${1:-}" == "--src" ]]; then
	if [[ -z "${2:-}" ]]; then
		echo "Missing path after --src"
		exit 1
	fi
	SRC_DIR="${2}"
fi

if [[ ! -f "${LIST_FILE}" ]]; then
	echo "Missing list: ${LIST_FILE}"
	exit 1
fi

if [[ ! -d "${SRC_DIR}" ]]; then
	echo "Missing source directory: ${SRC_DIR}"
	exit 1
fi

mkdir -p "${OUT_DIR}"

missing=0
copied=0
while IFS= read -r raw_line || [[ -n "${raw_line}" ]]; do
	line="${raw_line%%#*}"
	line="${line%%;*}"
	line="$(echo "${line}" | sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//')"
	[[ -z "${line}" ]] && continue

	if [[ "${line}" == *":"* ]]; then
		src_rel="${line%%:*}"
		dst_rel="${line##*:}"
	else
		src_rel="${line}"
		dst_rel="${line}"
	fi

	src_path="${SRC_DIR}/${src_rel}"
	dst_path="${OUT_DIR}/${dst_rel}"

	if [[ ! -f "${src_path}" ]]; then
		echo "MISSING: ${src_rel}"
		missing=$((missing + 1))
		continue
	fi

	mkdir -p "$(dirname "${dst_path}")"
	cp -f "${src_path}" "${dst_path}"
	copied=$((copied + 1))
done < "${LIST_FILE}"

echo "Copied ${copied} files into ${OUT_DIR}."
if (( missing > 0 )); then
	echo "Encountered ${missing} missing files."
	exit 2
fi

echo "Extraction complete."
