PRODUCT_SOONG_NAMESPACES += \
    vendor/infinix/X663

# Vendor integration entrypoint for X663.
# Populate with PRODUCT_PACKAGES and PRODUCT_COPY_FILES as blobs are brought in.
$(call inherit-product, vendor/infinix/X663/vendor-blobs.mk)
