# 📦 Vendor Blobs for Infinix Note 11 (X663)

**Source-built vendor repository for the Infinix Note 11 — MediaTek MT6768 / Helio G88 (MT6769H), Android 12.**

The vendor partition is compiled directly from `proprietary/` by `X663-vendor.mk` and `Android.mk`. **No raw prebuilt `vendor.img` is required.**

---

## Device Specifications

| | |
| --- | --- |
| **Model** | Infinix Note 11 (X663) |
| **SoC** | MediaTek MT6768 / Helio G88 (MT6769H) (2× Cortex-A75 + 6× Cortex-A55) |
| **Display** | 6.7" 1080×2400, 393 dpi, 60 Hz |
| **Stock ROM** | XOS 10.6.0, Android 12, `X663-H6915ABCEFGHIO-S-GL-230918V670` |
| **Partitions** | Virtual A/B, dynamic (`system`, `system_ext`, `product`, `vendor`) |
| **First API level** | 30 |
| **Vendor VNDK** | 31 |

## 🚦 Current State / Status

- **Compilation**: **Build completed successfully** (`lineage-19.1` compiles cleanly to flashable zip via `mka bacon`).
- **Boot Status**: **Stuck at splash screen** (device reaches the initial Infinix boot splash logo, currently under active bring-up / early init debugging).

## 🔨 Build

Build with the official LineageOS guide, cloning the device and vendor repositories into the source tree:

```bash
mkdir -p ~/android/lineage
cd ~/android/lineage

repo init -u https://github.com/LineageOS/android.git -b lineage-19.1 --git-lfs
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags

git clone https://github.com/ALBINsRAJ2025/android_device_infinix_X663 \
    -b lineage-19.1 device/infinix/X663
git clone https://github.com/ALBINsRAJ2025/android_vendor_infinix_X663 \
    -b lineage-19.1 vendor/infinix/X663

source build/envsetup.sh
lunch lineage_X663-userdebug
mka bacon -j$(nproc --all)
```

## 📁 Repository Contents

```
proprietary/             stock /vendor tree (committed, ~961 MB)
proprietary-files.txt    flat blob list
extract-files.sh         re-extract proprietary/ from a stock dump
setup-makefiles.sh       validates the source-built vendor layout
X663-vendor.mk           blob install, inherited by device.mk
Android.mk               recreates the 196 vendor symlinks
symlinks.dummy           input for the symlink module
```

`proprietary/` mirrors the stock factory `/vendor` tree: 2,222 regular files, 196 symlinks, and 87 subdirectories byte-identical to factory firmware.

## ⚙️ Build Wiring

* `device/infinix/X663/device.mk` inherits `X663-vendor.mk`.
* `X663-vendor.mk` installs the regular files and adds the `x663_vendor_symlinks` module (recreates the 196 links, stock link text).
* `configs/fs_config` supplies stock ownership and modes.
* The empty stock `fs_config_files`, `fs_config_dirs`, `passwd`, `group` and the matching `odm` copies are filtered so platform-generated files win.
* AOSP packages that overwrite stock files are filtered from `PRODUCT_PACKAGES`.
* Stock `vendor_sepolicy.cil` and context files are installed as-is (`PRODUCT_PRECOMPILED_SEPOLICY := false` in the device tree; `X663_SEPOLICY_PORT` gates the source policy).
* VNDK is pinned to 31, `vendor.prop` carries the stock vendor properties, and `VENDOR_SECURITY_PATCH := 2023-09-05` preserves the stock security patch.

## ⚖️ Licensing

Original makefiles, scripts, and documentation are licensed under **Apache-2.0** (see `LICENSE` and `NOTICE`). `proprietary/` contains stock firmware blobs extracted from Infinix/Transsion firmware and remains subject to OEM terms.
