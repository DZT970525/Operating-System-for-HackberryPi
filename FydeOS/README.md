# Fyde OS for HackBerry Pi

FydeOS **23.0**, build **16700.56.23.8**, ARM64 for **HackBerry Pi CM5 / CM5 Lite**. This package preserves the supplied card's system-level customizations: 720×720 DPI display, touchscreen, keyboard scrolling, battery compatibility, network/time helpers, and the ChatGPT web app with shelf setup.

## First start and privacy

The image uses a fresh user-data partition. Customers should complete FydeOS's native first-run setup, choose their language and region, connect their own network and create/sign in with their own account. No seller account is preselected and no shared desktop password is provided. Developer console password hashes are locked in the published copy.

The original OEM activation/license file is also excluded. The original encrypted home, user profiles, browser data, login tokens, saved Wi-Fi connections, logs and installed personal Android/Linux environments are not copied. System Android components and the system developer-tool directory are retained. Account-specific apps, browser extensions and settings must be set up by the customer. The original source card is read-only during export and is not reset.

## PINN installation preview — important differences

**A physical PINN installation, first-run setup and multiboot test have not yet been performed. This is a preview port, not a production-tested image.**

The original FydeOS GPT/A-B arrangement is converted to four PINN filesystems: boot, root, fresh STATE and OEM. The installation script patches both native startup JSON dictionaries and shell partition variables to PINN's assigned numbers. The system root remains read-only. The supplied kernel includes ext4 and MBR support.

To protect other installed systems, this PINN edition disables native whole-disk OTA/A-B updates (a loopback no-update responder keeps the genuine update-engine API available for setup), automatic partition expansion, firmware-update jobs, the disk installer and native Powerwash/clobber operations. **Reset or replace this edition by reinstalling it through PINN.** This is a material difference from the original standalone card. Do not re-enable the stock whole-disk tools on a multiboot card.

## Online download

Use a PINN build supporting CM5 and the HackBerry Pi display. This preview is limited to **SD-card installation**, not USB-root installation. Add this to the existing single line in `recovery.cmdline`:

```
alt_image_source=https://raw.githubusercontent.com/DZT970525/Operating-System-for-HackberryPi/main/os_list_v3.json
```

Choose **Fyde OS for HackBerry Pi** in **General**. Allocate at least **12.2 GiB**, plus PINN and other operating systems; additional storage is assigned to STATE. Keep the network connected until installation finishes.

PINN installs four partition archives; `partition_setup.sh` downloads and verifies three supplemental root-system archives. These are PINN filesystem archives, not a raw `.img` for Raspberry Pi Imager. Do not write them directly to a disk.

## Offline installation

Download all **seven `hbf_*.tar.gz` assets**, `marketing.tar`, `SHA256SUMS` and the metadata in this folder. Put them together under a PINN OS folder such as `os/FydeOS_HackBerryPi/` on a supported USB drive. Run `sha256sum -c SHA256SUMS` there. PINN's ordinary download of only the four partition tarballs is not sufficient without the three supplemental archives.

Use your own FydeOS account and any subscription/activation required by the vendor. The package does not transfer the seller's account or license.
