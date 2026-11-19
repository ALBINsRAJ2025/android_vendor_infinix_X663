# SPDX-License-Identifier: Apache-2.0
# Copyright (C) 2026 ALBINsRAJ2025
# BoardConfigVendor.mk - Infinix Note 11 (X663)

# cas: dedupe the factory vintf fragment
DEVICE_MANIFEST_FILE += \
    vendor/infinix/X663/proprietary/etc/vintf/manifest.xml \
    $(filter-out %/android.hardware.cas@1.2-service-lazy.xml, \
        $(wildcard vendor/infinix/X663/proprietary/etc/vintf/manifest/*.xml))
