# Vendor makefile for the Infinix Note 11 (X663).
#
# Installs the stock vendor tree from proprietary/ and recreates its symlinks.
# Inherited by the source-built vendor image variant.

PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,vendor/infinix/X663/proprietary,$(TARGET_COPY_OUT_VENDOR))

PRODUCT_PACKAGES += \
    x663_vendor_symlinks
