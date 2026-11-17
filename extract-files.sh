#!/bin/bash
# SPDX-License-Identifier: Apache-2.0
# Copyright (C) 2026 ALBINsRAJ2025
# Vendor extraction script
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

echo "Done. Blobs are in $DEST"
