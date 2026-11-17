# SPDX-License-Identifier: Apache-2.0
# Copyright (C) 2026 ALBINsRAJ2025
# Vendor makefile for the Infinix Note 11 (X663).
#
# Installs the stock vendor tree from proprietary/ and recreates its symlinks.
# Inherited by device/infinix/X663/device.mk.

# vendor/bin/applypatch and vendor/etc/init/vendor_flash_recovery.rc are not
# copied: Android 12's base_vendor.mk lists the AOSP `applypatch` module, which
# installs both files to the same paths, and kati refuses two rules for one
# target ("overriding commands"). The blobs stay in proprietary/ (the stock
# payload is unchanged); the image carries AOSP's binary and its full init rc,
# which is what the platform's update_engine expects.
#
# The four stock etc/NOTICE.xml.gz files are not copied either: the build
# generates them per image, and a copy makes vendor/etc/NOTICE.xml.gz part of
# ALL_DEFAULT_INSTALLED_MODULES before the notice lists are computed, so
# obj/NOTICE_VENDOR.xml depends on the very file it generates (ninja:
# "dependency cycle: vendor/etc/NOTICE.xml.gz -> obj/NOTICE_VENDOR.xml.gz ->
# obj/NOTICE_VENDOR.xml -> vendor/etc/NOTICE.xml.gz").
PRODUCT_COPY_FILES += \
    $(filter-out %.apk \
        vendor/infinix/X663/proprietary/bin/applypatch:% \
        vendor/infinix/X663/proprietary/etc/NOTICE.xml.gz:% \
        vendor/infinix/X663/proprietary/odm/etc/NOTICE.xml.gz:% \
        vendor/infinix/X663/proprietary/odm_dlkm/etc/NOTICE.xml.gz:% \
        vendor/infinix/X663/proprietary/vendor_dlkm/etc/NOTICE.xml.gz:% \
        vendor/infinix/X663/proprietary/etc/init/vendor_flash_recovery.rc:% \
        vendor/infinix/X663/proprietary/etc/vintf/% \
        vendor/infinix/X663/proprietary/etc/selinux/precompiled_sepolicy \
        vendor/infinix/X663/proprietary/etc/selinux/precompiled_sepolicy.%,\
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
