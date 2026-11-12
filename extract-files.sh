#!/bin/bash
#
# Re-extract the proprietary files for the Infinix Note 11 (X663).
#
# Usage:
#   ./extract-files.sh /path/to/stock_dump
#
# The argument must be the directory containing the stock vendor/ folder.
#
set -e

HERE="$(cd "$(dirname "$0")" && pwd)"
SRC="${1:-}"

if [ -z "$SRC" ]; then
    echo "usage: $0 /path/to/stock_dump  (directory containing vendor/)" >&2
    exit 1
fi
if [ ! -d "$SRC/vendor" ]; then
    echo "error: $SRC/vendor does not exist" >&2
    exit 1
fi

LIST="$HERE/proprietary-files.txt"
DEST="$HERE/proprietary"

echo "Extracting from $SRC/vendor ..."
while IFS= read -r line; do
    case "$line" in
        ''|'#'*) continue ;;
    esac
    [ "${line#vendor/}" != "$line" ] || continue
    src="$SRC/$line"
    dst="$DEST/${line#vendor/}"
    if [ -e "$src" ] || [ -L "$src" ]; then
        mkdir -p "$(dirname "$dst")"
        cp -a "$src" "$dst"
    else
        echo "  missing: $line" >&2
    fi
done < "$LIST"

# Replace the two host-path vulkan symlinks with device-relative links.
for f in lib/hw/vulkan.mt6768.so lib64/hw/vulkan.mt6768.so; do
    p="$DEST/$f"
    rm -f "$p"
    mkdir -p "$(dirname "$p")"
    ln -s ../egl/libGLES_mali.so "$p"
done

echo "Done. Blobs are in $DEST"
