# SPDX-License-Identifier: Apache-2.0
# Copyright (C) 2026 ALBINsRAJ2025
# Vendor makefile

PRODUCT_COPY_FILES += \
    $(filter-out %.apk \
        vendor/infinix/X663/proprietary/bin/applypatch:% \
        vendor/infinix/X663/proprietary/etc/NOTICE.xml.gz:% \
        vendor/infinix/X663/proprietary/odm/etc/NOTICE.xml.gz:% \
        vendor/infinix/X663/proprietary/odm_dlkm/etc/NOTICE.xml.gz:% \
        vendor/infinix/X663/proprietary/vendor_dlkm/etc/NOTICE.xml.gz:% \
        vendor/infinix/X663/proprietary/etc/init/vendor_flash_recovery.rc:% \
        vendor/infinix/X663/proprietary/etc/vintf/% \
        vendor/infinix/X663/proprietary/etc/selinux/precompiled_sepolicy:% \
        vendor/infinix/X663/proprietary/etc/selinux/precompiled_sepolicy.%,
        $(call find-copy-subdir-files,*,vendor/infinix/X663/proprietary,$(TARGET_COPY_OUT_VENDOR)))

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
