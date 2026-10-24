# Ubuntu for HackberryPi — PINN installation preview

Ubuntu 24.04.5 LTS Desktop ARM64, prepared from the factory SD card for HackberryPi with Raspberry Pi Compute Module 5.

This is a PINN installation preview. Filesystem and package configuration checks have been performed; an actual PINN installation, first boot and multiboot test on HackberryPi CM5 are still required. Use a PINN build supporting CM5 and the device display.

## Included

- Google Chrome as the default browser; Chrome and ChatGPT launchers on the desktop and Dock.
- Touch Dock: reveal from the left edge, hide after five seconds or an outside mouse/touch click.
- Matrix screensaver, with a default idle time of ten minutes.
- Native Ubuntu first-boot setup for language, region, device name and a new customer account.
- English, German, French and Spanish GNOME language packs. Pinyin and Clash Verge removed.
- Seller accounts and saved login information removed. New machine identity and SSH host keys are generated for each installation.

## Online installation with PINN

Add this option to PINN `recovery.cmdline` (keep its existing options on the same line):

```
alt_image_source=https://raw.githubusercontent.com/DZT970525/Operating-System-for-HackberryPi/main/Ubuntu/os_list_v3.json
```

PINN consumes the JSON index, rather than the GitHub HTML release page. Anonymous installation requires this repository and its release assets to be public.

Select **Ubuntu 24.04.5 for HackberryPi**. Allow at least 16.5 GiB for this OS, plus space for PINN and any other systems. The root partition can use additional allocated space.

PINN downloads the boot and base-root tarballs. The included `partition_setup.sh` then downloads six supplemental system/application archives, verifies each SHA-256 checksum and extracts them into the new root. These separate payloads keep each GitHub Release asset below the 2 GiB limit. Keep the network connected throughout installation. The setup script updates boot and fstab references using the partition identifiers assigned by PINN.

## Offline installation

Download all eight `hbu_*.tar.gz` assets, `marketing.tar`, `SHA256SUMS` and the metadata in this Ubuntu folder. Place them together in a PINN OS folder such as `os/Ubuntu_HackberryPi/` on a supported USB drive. Verify the checksums before installation. PINN's ordinary download/export of only the two core partition tarballs is insufficient: all six supplemental archives must also be present next to `partition_setup.sh`.

A PINN backup made after a successful installation contains the assembled root filesystem. Its restore path preserves the customer's account and machine identity.

## Source and limits

This package comes from the prepared removable SD card. It does not use or update an older local raw image. The release is a preview until hardware installation tests pass. Installation erases the target partitions selected in PINN; keep a separate backup of needed data.
