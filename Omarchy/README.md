# Omarchy 4.5.0 for HackberryPi

ARM64 Omarchy **4.5.0** for **HackberryPi CM5**, with the native Raspberry Pi kernel **6.18.57-1-rpi-16k**, Hyprland, the 720×720 DPI touchscreen and MAX17048 battery support.

The owner successfully boot-tested the sanitized standalone image on another device. **The PINN package remains a preview until installation, first boot and multiboot have been tested through PINN on HackberryPi CM5.** Other Raspberry Pi models are not supported by this hardware-specific package.

## Included

- Display Scale: an English settings app with a default equivalent workspace of **900×900**, adjustable from **480×480 to 1080×1080**. The physical screen remains **720×720**; this setting changes software scaling. Spread two fingers to enlarge the interface and pinch to fit more content.
- HackberryPi menus, screen recording, microphone-audio recording and Bluetooth settings.
- Codex CLI **0.167.0**, Claude Code **2.1.319** and Grok **1.0.77**, with browser sign-in launch support.
- **Vox / Codex Voice**: the microphone control for a focused Codex terminal, its launcher and autostart entry, and the existing Codex **F11/F12 `toggle_voice` bindings**. The Vox source and tests are retained under `/home/pi/Work/vox`.
- Clash Verge, ready for the new user's own configuration. No subscriptions are included, and automatic startup, system proxy and TUN are disabled by default.

Codex voice requires the user's own Codex sign-in, service access and an available microphone. The seller's account and conversation data are not included.

## Default login and privacy

| Item | Value |
| --- | --- |
| Username | `pi` |
| Password | `pi` |
| Administrator commands | `sudo`, using the same password |

Both values are lowercase. Change the password after first login with `passwd`. Root password login is locked.

The published copy excludes private Clash subscriptions and their service-runtime copies, browser profiles and saved logins, Agent credentials and chat/voice histories, Wi-Fi/VPN passwords, Bluetooth pairings, personal recordings, clipboard history and original machine/private keys. Each installation initializes its own machine identity and local package-keyring and SSH identities. Configure your own network, accounts and subscriptions after login. Functional Codex and Vox changes are preserved separately from account data.

## Install through PINN

Use a PINN build supporting **CM5, the HackberryPi display and this package's Btrfs setup**. Add the following to the existing single line in `recovery.cmdline`:

```
alt_image_source=https://raw.githubusercontent.com/DZT970525/Operating-System-for-HackberryPi/main/os_list_v3.json
```

Select **Omarchy 4.5.0 for HackberryPi** in **General**. Allocate at least **16.25 GiB** for Omarchy, plus PINN and other operating systems. Existing cards using this repository's Ubuntu feed will receive the same entry.

Keep the network connected throughout installation. PINN downloads the boot and base-root archives, then `partition_setup.sh` downloads and verifies **10 supplemental archives**. Every asset stays below GitHub's 2 GiB limit. The setup script creates the required Btrfs subvolumes, updates the native kernel command line and all root/home/log/cache mount references to PINN's actual partition identifiers, and disables the standalone image's whole-card expansion path.

These Release assets are **PINN filesystem archives**, not a standalone raw `.img` for Raspberry Pi Imager. Install this package through PINN.

## Offline installation and checksums

Download every Release asset: all **12 `hbo_*.tar.gz` files**, `marketing.tar`, `vox-source.tar.gz`, `SHA256SUMS` and the metadata in this folder. Put them together in a PINN OS directory such as `os/Omarchy_HackberryPi/` on a supported USB drive. Run `sha256sum -c SHA256SUMS` from that directory before installation. PINN's ordinary two-tarball download/export does not include the supplemental archives.

This initial preview advertises SD installation only; USB boot/root is not enabled.

PINN backup/restore is not enabled for this initial Btrfs preview. Keep needed files separately before reinstalling this edition.

Vox source, its license and build/test instructions are also available as [vox-source.tar.gz](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/omarchy-hackberrypi-2026-11-09/vox-source.tar.gz) in the Release. Codex voice third-party notices, licenses and source references are retained in the installed Agent payload.

## Validation

The standalone image passed filesystem/data checksums and a complete card-write/readback verification before the owner's successful boot test. Sixty-three preserved feature files were compared with the source, all three Agent version commands succeeded, and Vox's eleven existing checks passed, including QML clicks and voice-state transitions. The actual PINN adapter and all payloads were also installed into a disposable seven-partition Btrfs layout, with file hashes, subvolumes and unrelated-partition sentinels checked. These checks do not replace the pending physical PINN installation and multiboot test.
