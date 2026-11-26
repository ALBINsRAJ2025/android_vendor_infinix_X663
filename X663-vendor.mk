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
        vendor/infinix/X663/proprietary/etc/init/chipinfo_init.rc:% \
        vendor/infinix/X663/proprietary/etc/init/trustonic.rc:% \
        vendor/infinix/X663/proprietary/etc/init/android.hardware.keymaster@4.1-service.trustonic.rc:% \
        vendor/infinix/X663/proprietary/etc/init/hw/init.mt6768.rc:% \
        vendor/infinix/X663/proprietary/etc/init/hw/factory_init.rc:% \
        vendor/infinix/X663/proprietary/etc/init/hw/meta_init.rc:% \
        vendor/infinix/X663/proprietary/lib64/libtinycompress.so:% \
        vendor/infinix/X663/proprietary/etc/permissions/handheld_core_hardware.xml:% \
        vendor/infinix/X663/proprietary/etc/fs_config_files:% \
        vendor/infinix/X663/proprietary/etc/fs_config_dirs:% \
        vendor/infinix/X663/proprietary/etc/passwd:% \
        vendor/infinix/X663/proprietary/etc/group:% \
        vendor/infinix/X663/proprietary/odm/etc/passwd:% \
        vendor/infinix/X663/proprietary/odm/etc/group:% \
        vendor/infinix/X663/proprietary/etc/vintf/% \
        vendor/infinix/X663/proprietary/etc/selinux/precompiled_sepolicy:% \
        vendor/infinix/X663/proprietary/etc/selinux/precompiled_sepolicy.% \
        vendor/infinix/X663/proprietary/etc/fstab.mt6768:%,\
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
