# RPiOS — Raspberry Pi OS for HackberryPi

Raspberry Pi OS Desktop **64-bit, Bookworm**, customized for **HackberryPi CM5**. The source card identifies itself as the Raspberry Pi reference build dated **2024-11-19**, based on **Debian 12.8**, with the native **6.6.51+rpt-rpi-2712** kernel and labwc desktop.

This hardware-specific edition retains the factory HackberryPi display, touchscreen and battery configuration. Other Raspberry Pi models are not supported by this package. **The published PINN edition is a preview until installation, first boot and multiboot have been tested through PINN on HackberryPi CM5.**

## Included

- Default equivalent workspace: **900×900**. The physical panel stays at **720×720**; this changes software scaling, not the screen's physical resolution.
- **Display Scale**, an English desktop app with a slider and presets covering **480×480 to 1080×1080**. Use the app to change scaling or save a different default.
- **Touchscreen two-finger desktop zoom is disabled.** Touch gestures do not change the desktop's scale.
- Native touchscreen scrolling in the preinstalled Chromium browser, with Wayland touch input enabled.
- The source card's Raspberry Pi OS desktop, HackberryPi hardware overlay and device support.

## Default login and privacy

| Item | Value |
| --- | --- |
| Username | `pi` |
| Password | `pi` |
| Administrator commands | `sudo`, using the same password |

Both values are lowercase. Change the password after first login with `passwd`. Configure your own network and application accounts.

The release is made from a sanitized copy of the removable card. Personal browser profiles and saved logins, application credentials, private subscriptions, network passwords, Bluetooth pairings, shell and application histories, personal files, caches and original device identities are excluded. Hardware support and the display/touch behavior listed above are retained. Each installation initializes its own machine identity and SSH host keys.

## Standalone installation with Raspberry Pi Imager

Download [RPiOS-HackberryPi-CM5-20261109.img.xz](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/rpios-hackberrypi-2026-11-09/RPiOS-HackberryPi-CM5-20261109.img.xz) from this release (about **1.29 GiB**). This is the complete disk image for a **16 GB or larger SD card**; it does not require PINN.

1. Install and open [Raspberry Pi Imager](https://www.raspberrypi.com/software/).
2. In the operating system selection, choose **Use custom** and select the downloaded image.
3. Select the intended SD card, confirm writing and let verification finish.
4. Insert the card in HackberryPi CM5 and boot. The standalone edition expands only its own root filesystem and initializes a new device identity on first boot.

Use the supplied `pi` account; skip Imager's optional OS customization and configure your network and accounts in the installed desktop. Writing this image replaces the target card.

## Install through PINN

Use a PINN build supporting **CM5 and the HackberryPi display**. Add this option to the existing single line in `recovery.cmdline`:

```
alt_image_source=https://raw.githubusercontent.com/DZT970525/Operating-System-for-HackberryPi/main/os_list_v3.json
```

Select **RPiOS — Raspberry Pi OS for HackberryPi** in **General**. It is the first entry in this repository's catalog, before Ubuntu. Cards using the older `Ubuntu/os_list_v3.json` endpoint receive the same combined catalog.

Allocate at least **8.5 GiB** for RPiOS, plus space for PINN and any other operating systems. Keep the network connected throughout online installation. PINN downloads the boot and base-root archives; `partition_setup.sh` obtains **4 supplemental archives**, verifies their SHA-256 checksums and extracts them into the assigned root partition.

The adapter updates the kernel command line and mount references to the identifiers assigned by PINN. Standalone whole-card expansion is disabled for the PINN edition, so it only uses the partitions allocated by PINN.

## Offline installation and checksums

Download all **6 `hbr_*.tar.gz` archives**, `marketing.tar`, `SHA256SUMS` and the metadata from this release. Put them together in a PINN OS directory such as `os/RPiOS_HackberryPi/` on a supported USB drive. PINN's ordinary two-tarball download/export does not include supplemental archives.

For complete release verification, download every Release asset and run `sha256sum -c SHA256SUMS`. If you downloaded only the PINN files, GNU `sha256sum --ignore-missing -c SHA256SUMS` verifies that subset without requiring the optional source archive or standalone disk image. Check that all PINN filesystem archives listed above are present before installing.

PINN backup/restore preserves the assembled ext4 root filesystem and the installed user's identity. A restored backup does not reinitialize an existing user account.

This initial preview advertises SD installation only; USB boot/root is not enabled.

## Source and build information

The base card identifies the Raspberry Pi reference build **2024-11-19**, generated using [pi-gen commit 891df1e21ed2b6099a2e6a13e26c91dea44b34d4](https://github.com/RPi-Distro/pi-gen/tree/891df1e21ed2b6099a2e6a13e26c91dea44b34d4), stage 4. The customized release date is separate from that base-system date.

The custom display code, launchers, retained C helper source and build notes are supplied in [display-scale-source.tar.gz](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/rpios-hackberrypi-2026-11-09/display-scale-source.tar.gz). The current configuration leaves touchscreen desktop zoom disabled. This source archive contains only the listed display components and does not include personal user files.

Installed packages retain their version/source-package metadata and upstream notices under `/usr/share/doc/<package>/copyright`. Corresponding base-system sources are provided through the Debian and Raspberry Pi source-package repositories; the source archive's README describes the build dependencies and package-source workflow. The factory HackberryPi overlay and hardware helpers are retained from the supplied card. Existing third-party licenses and notices remain with their packages.

## Source and validation

The release is prepared from the removable Raspberry Pi OS card, with cleanup and resizing performed on a separate copy. The compact image uses fresh filesystems, so deleted source-card free blocks are not included. FAT/ext4 checks and a full file-checksum, ownership and permissions comparison with the sanitized tree passed. Online standalone root expansion was tested on a disposable disk layout, preserving its data, boot partition and partition identifiers.

The actual PINN archives and adapter passed installation into a disposable layout with boot partition 6 and root partition 7. Checks verified 23 root feature files, 381 boot files, 562 hardlink groups, normal-user access and the target Python CLI. The identity helper ran in the assembled system, generated new SSH/SSL keys and passed repeat-run checks. Backup restore and repair preserved existing customer state; four unrelated partitions and the MBR/EBR sectors remained unchanged.

Read `factory-status.json` for the detailed status. **Physical boot testing of the rebuilt sanitized image and physical PINN installation/multiboot testing are still pending.**
