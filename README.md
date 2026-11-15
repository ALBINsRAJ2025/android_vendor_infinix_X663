# vendor/infinix/X663

Vendor tree for the **Infinix Note 11 (X663)** — MediaTek MT6768
(Helio G88), stock Android 12 (SP1A.210812.016), virtual A/B.

This is a conventional source-built vendor tree: the vendor partition is
installed from `proprietary/` by `X663-vendor.mk` and `Android.mk`.  **No
`vendor.img` is shipped, used or required.**

## Contents

```
proprietary/             stock /vendor tree (included in Git)
proprietary-files.txt    flat blob list
extract-files.sh         re-extract proprietary/ from a stock dump
X663-vendor.mk           stock blob install, inherited by device.mk
Android.mk               recreates the 196 vendor symlinks
BoardConfigVendor.mk     empty; board configuration lives in the device tree
setup-makefiles.sh       validates the source-built vendor layout
symlinks.dummy           input for the symlink module
LICENSE                  Apache-2.0
NOTICE                   third-party blob notice
```

`proprietary/` mirrors the stock `/vendor` tree, including `/vendor/odm`,
`/vendor/odm_dlkm` and `/vendor/vendor_dlkm`:

* 2,222 regular files, 196 symlinks and 87 subdirectories, about 961 MB;
* all symlinks are recreated after installation because
  `PRODUCT_COPY_FILES` cannot preserve them.

`proprietary/` is committed to this repository, so a clone contains the full
961 MB blob tree.  The local delivery tarball contains the same tree for
offline use; no separate stock dump is required.  Git stores the 196 symlinks
as links, so they survive a clone.

## Stock naming and provenance

The source of truth is the **stock firmware**
`stock_firmware/spflashtool_firmware/super.img`.  The vendor partition was
unpacked from it with the Android 12 otatools and compared with this tree:

```bash
simg2img stock_firmware/spflashtool_firmware/super.img super.raw.img
lpunpack super.raw.img parts/
debugfs -R "rdump / vendor" parts/vendor_a.img
```

Result:

* **every path in `proprietary/` is the stock `/vendor` path, unchanged** —
  no renaming, no flattening, no case changes;
* **2,222 of 2,222 regular files are byte-identical** (SHA-256);
* **196 of 196 symlinks exist in both trees with identical targets**, including
  the two that the stock device uses as absolute links
  (`lib/hw/vulkan.mt6768.so` → `/vendor/lib/egl/libGLES_mali.so` and
  `lib64/hw/vulkan.mt6768.so` → `/vendor/lib64/egl/libGLES_mali.so`);
* the stock vendor root additionally contains the generated `build.prop` and
  the ext4 `lost+found` directory; neither is a blob and neither is shipped.

The stock file list in `installed-files-vendor.txt` has 2,419 entries — the
2,418 payload files and links plus the generated `/vendor/build.prop` — which
matches this tree exactly.

`Android.mk` recreates the symlinks with the **stock link text**, absolute
where the device uses absolute links and relative where it uses relative
ones.  `proprietary-files.txt` lists the same 2,418 paths in stock order.


## Extracting the blobs

`extract-files.sh` expects a directory containing the stock `vendor/` tree:

```bash
./extract-files.sh /path/to/stock_dump
```

The argument must be a directory with `vendor/` inside it, not a
`vendor.img`.  A stock firmware dump can be unpacked with the usual MTK
tools; the image itself is deliberately not part of this tree.

## Build wiring

* `device/infinix/X663/device.mk` inherits `X663-vendor.mk`.
* `X663-vendor.mk` installs the stock regular files with
  `PRODUCT_COPY_FILES` and adds the `x663_vendor_symlinks` module.
* `Android.mk` creates the 196 symlinks under `$(TARGET_OUT_VENDOR)`.
* `device/infinix/X663/configs/fs_config` supplies stock ownership and modes.
* The stock empty `etc/fs_config_files`, `etc/fs_config_dirs`, `etc/passwd`,
  `etc/group` and the matching `vendor/odm` copies are filtered so the
  platform-generated files win.
* The stock `vendor_sepolicy.cil`, context files and `precompiled_sepolicy`
  are installed as-is.  `selinux_policy_nonsystem` is filtered and
  `PRODUCT_PRECOMPILED_SEPOLICY := false` keeps AOSP from replacing the stock
  policy.
* AOSP vendor packages that would overwrite stock binaries, libraries,
  symlinks or VINTF data are filtered from `PRODUCT_PACKAGES`.
* VNDK is pinned to 31 on SDK 32 and `vendor.prop` plus
  `VENDOR_SECURITY_PATCH := 2023-09-05` preserve the stock vendor properties.

## Licensing

Original makefiles, scripts, file lists and documentation are licensed under
**Apache-2.0**; see `LICENSE` and `NOTICE`.  `proprietary/` is stock firmware
and is **not** licensed under Apache-2.0; it remains subject to
Infinix/Transsion terms, and no additional license is granted by this
repository.

## Limitations

The vendor image has not been compiled or booted in this environment.  The
stock policy is version 31 while the LineageOS 19.1 platform policy is
version 32; runtime policy fallback, linkerconfig mapping and vendor HAL
loading still need a device test.
