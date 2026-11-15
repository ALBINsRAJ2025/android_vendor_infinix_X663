# vendor/infinix/X663

Source-built vendor tree for the Infinix Note 11 (X663), MediaTek MT6768 /
Helio G88, stock Android 12 (SP1A.210812.016), virtual A/B.

The vendor partition is installed from `proprietary/` by `X663-vendor.mk` and
`Android.mk`. **No `vendor.img` is shipped, used or required.**

## Contents

```
proprietary/             stock /vendor tree (committed, ~961 MB)
proprietary-files.txt    flat blob list
extract-files.sh         re-extract proprietary/ from a stock dump
setup-makefiles.sh       validates the source-built vendor layout
X663-vendor.mk           blob install, inherited by device.mk
Android.mk               recreates the 196 vendor symlinks
symlinks.dummy           input for the symlink module
```

`proprietary/` mirrors the stock `/vendor` tree: 2,222 regular files, 196
symlinks and 87 subdirectories. Verify it against the stock firmware package;
every path is unchanged.

## Extracting the blobs

```bash
./extract-files.sh /path/to/stock_dump
```

Expects a directory with `vendor/` inside, not `vendor.img`.

## Build wiring

* `device/infinix/X663/device.mk` inherits `X663-vendor.mk`.
* `X663-vendor.mk` installs the regular files and adds the
  `x663_vendor_symlinks` module (recreates the 196 links, stock link text).
* `configs/fs_config` supplies stock ownership and modes.
* The empty stock `fs_config_files`, `fs_config_dirs`, `passwd`, `group` and
  the matching `odm` copies are filtered so platform-generated files win.
* AOSP packages that overwrite stock files are filtered from
  `PRODUCT_PACKAGES`.
* Stock `vendor_sepolicy.cil` and context files are installed as-is;
  `PRODUCT_PRECOMPILED_SEPOLICY := false` in the device tree, AOSP's vendor
  policy package is filtered, and `BOARD_VENDOR_SEPOLICY_DIRS` is gated behind
  `X663_SEPOLICY_PORT` (see `device/infinix/X663/sepolicy/README.md`).
* VNDK is pinned to 31, `vendor.prop` carries the stock vendor properties and
  `VENDOR_SECURITY_PATCH := 2023-09-05` preserves the stock security patch.

## Licensing

Original makefiles, scripts and documentation are Apache-2.0; see `LICENSE`
and `NOTICE`. `proprietary/` is stock firmware, not Apache-2.0; it remains
subject to Infinix/Transsion terms.
