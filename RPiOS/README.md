# RPiOS — Raspberry Pi OS for HackberryPi

This **2026-11-17 battery update** keeps the existing **64-bit Raspberry Pi OS Bookworm**, **labwc desktop**, native **6.6.51+rpt-rpi-2712** kernel and its `v8` companion. It is rebuilt from the verified sanitized 2026-11-09 image, rather than from a used card. The base Raspberry Pi reference build remains **2024-11-19 / Debian 12.8**; this is a battery-support update, not a full operating-system upgrade.

## Included

- **900×900** default equivalent workspace on the physical **720×720** panel.
- English **Display Scale** app, with manual **480–1080** scaling; touchscreen desktop pinch zoom stays disabled.
- Native HackberryPi CM5 display, touchscreen, Wi-Fi, Bluetooth and MAX17048 battery support.
- **`hackberrypi-battery-dkms` 1.2+hbpi2**, matching Raspberry Pi kernel-header dependencies and the signed battery update source, already installed for a fresh flash.
- Default login **`pi` / `pi`**, both lowercase. Change your password after first login and configure your own network/accounts.

## Battery support after kernel updates

The original image installed its battery module only for its original kernel. Replacing that kernel could make the battery indicator disappear. This image retains the driver source under `/usr/src` and registers it with DKMS, so ordinary kernel/header updates rebuild and install the battery module automatically. New reviewed driver packages are offered through normal system updates.

The shipping kernel stays **6.6.51** so the owner can test one normal kernel update. The disposable upgrade check targets **6.12.115+rpt-rpi-2712**. A successful module build does not substitute for observing the battery percentage after physically booting the updated card; the separate statuses are recorded below.

The source is already configured in this new image:

```sh
sudo apt install hackberrypi-battery-dkms
```

Existing installations can use the [one-command retrofit](../drivers/battery/apt/README.md) without reflashing or clearing their data. Future incompatible kernel interfaces may still need a small driver source/package update.

## Raspberry Pi Imager installation

Choose RPiOS in the existing [Imager online catalog](https://raw.githubusercontent.com/DZT970525/Operating-System-for-HackberryPi/main/os_list_imager.json), or download [RPiOS-HackberryPi-CM5-BatteryDKMS-20261117.img.xz](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/rpios-battery-dkms-hackberrypi-2026-11-17/RPiOS-HackberryPi-CM5-BatteryDKMS-20261117.img.xz) (1.37 GiB) and choose **Use custom** in [Raspberry Pi Imager](https://www.raspberrypi.com/software/). The complete image needs a **16 GB or larger SD card**. Select the intended card, write and verify it, then boot HackberryPi CM5. Manual decompression or merging is not needed.

Use the supplied `pi` account; skip Imager's optional OS customization. The standalone edition expands only its own root filesystem and initializes a fresh machine/SSH identity at first boot. Writing an image replaces the selected card.

## PINN multiboot installation

Download the [updated HackberryPi PINN installer](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/pinn-multiboot-hackberrypi-2026-11-16/HackberryPi-PINN-12OS-CM5-20261117.img.xz) (103.1 MiB), write it with Imager **Use custom**, connect Wi-Fi and select RPiOS. It caches the new battery-ready RPiOS recipe and the other 11 entries. Read the [PINN installation notes](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/pinn-multiboot-hackberrypi-2026-11-16/PINN-Installation-20261117.txt) and verify `PINN-RUNTIME-SHA256SUMS-20261117`. Keep the network connected throughout **Install**; **Download** alone is not a complete offline installer.

For a fresh card, use the updated prepared **2026-11-17 installer** above. To retain an existing multiboot card, update its catalog selectors instead of writing the installer over it. First back up `repo_list.json` and `catalog/repo_list.json` from PINN's RECOVERY boot partition. Create or replace **both files** with this identical content, keeping the existing `cmdline.txt` and installed-system partitions:

```json
{
  "repo_list": [
    {"name": "HackberryPi cached catalog", "url": "/tmp/hackberrypi-catalog/os_list_v3.json"},
    {"name": "HackberryPi online updates", "url": "https://raw.githubusercontent.com/DZT970525/Operating-System-for-HackberryPi/main/os_list_v3.json"}
  ]
}
```

The boot partition's root `repo_list.json` takes priority over command-line source settings, so changing `alt_image_source` alone does not update an old local-only selector. The [repository's public `repo_list.json`](https://raw.githubusercontent.com/DZT970525/Operating-System-for-HackberryPi/main/repo_list.json) is an HTTPS-only selector for network access; it does not include the prepared installer's local cache. Connect Wi-Fi to fetch the newer recipe, then select **RPiOS — Raspberry Pi OS for HackberryPi** under **General**. Allocate at least **8.5 GiB**, plus PINN and any other selected systems.

The updated adapter verifies and assembles the original four unchanged root payloads, then applies the new **fifth battery-support payload**. All payloads go into PINN's assigned root partition; no full disk image is extracted into it. Standalone whole-card expansion remains disabled in PINN. Only CM5 SD-card installation is advertised; USB boot/root is not enabled.

For offline preparation, follow the exact URLs and hashes in [archives.json](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/rpios-battery-dkms-hackberrypi-2026-11-17/archives.json): the original boot and four payload archives remain in the 2026-11-09 release, while the updated bootstrap and fifth payload are in this release. PINN's ordinary two-tarball export does not include all supplemental payloads. Backup/restore continues to preserve an existing installed user's identity and state.

Native-package assembly compared 146,649 paths and 562 hardlink groups: file contents, ownership, ACLs, xattrs and hardlinks matched. There are 27 explicitly checked preboot metadata differences: 25 directory timestamps, one timestamp on the standalone grow helper removed during PINN finalization, and `/var/log/journal` mode `02755 → 0755` with its ACL unchanged. The existing boot tmpfiles policy restores journal mode `02755`. Physical PINN installation and multiboot remain separate pending checks.

The [current PINN adapter and verification source (v2)](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/rpios-battery-dkms-hackberrypi-2026-11-17/RPiOS-BatteryDKMS-PINN-Source-20261117-v2.tar.xz) corresponds to these assembly checks. The earlier source attachment is retained as historical evidence.

## Privacy, source and verification

The clean base excludes saved Wi-Fi credentials, Bluetooth pairings, browser profiles, application logins, histories, personal files and original machine/SSH identities. This update imports only the reviewed driver packages and public update-source files. Private signing keys are excluded; installations create their own device identity. Read [factory-status.json](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/rpios-battery-dkms-hackberrypi-2026-11-17/factory-status.json) and `SHA256SUMS` for the exact release facts.

The complete [battery package source](https://raw.githubusercontent.com/DZT970525/Operating-System-for-HackberryPi/main/drivers/battery/apt/hackberrypi-battery-package-source.tar.xz) retains the driver/build/packaging files and notices. The existing [display-scale source](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/rpios-hackberrypi-2026-11-09/display-scale-source.tar.gz) remains unchanged. Original package licenses and source-package metadata stay under `/usr/share/doc`; base-system sources are supplied by Debian and Raspberry Pi repositories. The reference base was generated with [pi-gen 891df1e21ed2b6099a2e6a13e26c91dea44b34d4](https://github.com/RPi-Distro/pi-gen/tree/891df1e21ed2b6099a2e6a13e26c91dea44b34d4), stage 4.

| Check | Status |
| --- | --- |
| Shipping-kernel battery module and autoload metadata | passed |
| Filesystem and compressed-image verification | passed |
| Disposable kernel update to 6.12.115+rpt-rpi-2712: automatic module rebuild | passed |
| Physical fresh-flash desktop and battery test | pending |
| Physical battery percentage after the kernel update | pending |
| Updated PINN adapter disposable installation | passed |
| Physical PINN installation and multiboot | pending |

