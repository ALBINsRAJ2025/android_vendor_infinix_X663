#!/bin/bash
# SPDX-License-Identifier: Apache-2.0
# Copyright (C) 2026 ALBINsRAJ2025
#
# Check that the source-built vendor tree is ready.
# The makefiles are checked in; there is no generated vendor makefile here.
#
set -e

HERE="$(cd "$(dirname "$0")" && pwd)"

if [ ! -f "$HERE/proprietary-files.txt" ]; then
    echo "error: $HERE/proprietary-files.txt is missing" >&2
    exit 1
fi

if [ ! -d "$HERE/proprietary" ]; then
    echo "note: proprietary/ is not present." >&2
    echo "      Run $HERE/extract-files.sh /path/to/stock_dump before building." >&2
    exit 0
fi

echo "Vendor tree is ready: proprietary/ and proprietary-files.txt are present."
