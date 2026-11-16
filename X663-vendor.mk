# SPDX-License-Identifier: Apache-2.0
# Copyright (C) 2026 ALBINsRAJ2025
# Vendor makefile for the Infinix Note 11 (X663).
#
# Installs the stock vendor tree from proprietary/ and recreates its symlinks.
# Inherited by device/infinix/X663/device.mk.

PRODUCT_COPY_FILES += \
    $(filter-out %.apk %etc/vintf%,$(call find-copy-subdir-files,*,vendor/infinix/X663/proprietary,$(TARGET_COPY_OUT_VENDOR)))

PRODUCT_PACKAGES += \
    x663_vendor_symlinks \
    GoogleNetworkStackResOverlay \
    GoogleTetheringResOverlay \
    InProcessTetheringResOverlay \
    NetworkStackInProcessResOverlay \
    NetworkStackResOverlay \
    TetheringResOverlay \
    CellbroadcastUIResOverlay \
    ConnectivityResOverlay \
    FrameworkResOverlay \
    FrameworkResOverlayExt \
    MtkSettingsResOverlay \
    SettingsProviderResOverlay \
    SystemUIResOverlay \
    WifiResMainlineOverlay \
    WifiResOverlay
