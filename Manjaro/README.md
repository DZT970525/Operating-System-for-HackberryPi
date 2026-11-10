# Manjaro ARM Xfce for HackberryPi

![Manjaro logo](Manjaro_HackberryPi.png)

Customized **Manjaro ARM Xfce/X11** for **HackberryPi CM5**, based on the official **20261012** development image.

- Default **900 × 900** workspace on the native **720 × 720** screen.
- English **Display Scale** desktop app, adjustable from **480 × 480** to **1080 × 1080**.
- HackberryPi display and touchscreen configuration, font antialiasing, and MAX17048 battery integration with UPower and the Xfce power manager.
- Login-screen hint: **Default Password: pi**.
- Tested Wi-Fi compatibility settings and public DNS defaults. Configure your own network after first boot.
- Automatic screensaver, screen blanking, DPMS, idle dimming and idle suspend are disabled by default on both AC and battery power. Manual screen locking and login authentication remain available.

Default username: **pi**. Default password: **pi**. Both are lowercase. Use `sudo` for administrator commands and change the password after your first login.

## Raspberry Pi Imager

Use the repository's [Imager online catalog](https://raw.githubusercontent.com/DZT970525/Operating-System-for-HackberryPi/main/os_list_imager.json), or [download the complete image](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/manjaro-displayscale-hackberrypi-2026-11-10/Manjaro-ARM-Xfce-HackberryPi-CM5-DisplayScale-20261110.img.xz) and choose **Use custom** in Imager. Manual decompression is not needed.

Read the [Manjaro Imager installation guide](../Imager/Manjaro.md). The standalone edition uses the selected SD card as a whole disk; use a **16 GB or larger card**.

## Display Scale

Double-click **Display Scale** on the desktop. Drag the slider, release it to apply, and use **Save as default** to keep the selected size for later logins. **Reset to 900** restores the factory workspace.

The physical panel remains **720 × 720 pixels**. These values change software scaling: a smaller workspace enlarges text and controls, while a larger workspace fits more content. The app supports the tested internal display in its normal orientation. No desktop pinch-to-zoom service is included.

The login hint describes the factory password. If you change your password, log in with the new password.

## Screen stays on by default

The release disables automatic screensaver activation and automatic locking on screensaver activation. Automatic screen blanking, DPMS display sleep/off, idle dimming and idle suspension are disabled on both AC and battery power to avoid idle display transitions on the internal DPI screen.

You can still lock the screen manually and unlock it with your password. Login authentication, critical-battery handling, lid/power-button actions and explicit user suspend actions retain their normal behavior. These are factory defaults, and deliberate changes in Xfce settings remain possible.

Physical verification of the new idle-display defaults: **not performed; configuration and disposable loop installer verified, physical AC/battery idle test remains a preview**.

## First-boot identity and package trust

Each installation creates its own machine identity and SSH host keys. Personal network credentials and application sessions are excluded from the factory image.

Public distribution signing keyrings are retained. This computer's local package-signing private master key is excluded from the release; a native Manjaro package-trust initialization runs automatically in the background, scheduled about **20 seconds after boot**. It does not block the LightDM login screen. Allow that initialization to finish before the first package-management operation.

The package-trust task initializes this installation's local trust key and populates the packaged public keyrings. It does not restore the OEM account setup or OEM partition-resize process. First-boot runtime validation: **native offline temporary-filesystem initialization passed; first boot on the fresh physical image not performed**.

## Release and validation

The owner tested and accepted the installed system on HackberryPi CM5, including the repaired network connection. The public image is prepared from that tested configuration after removing personal data.

Factory-image audit: **passed: fresh filesystems, excluded private state and offline audit**. Clean-image boot-test status: **not performed; fresh factory-image physical boot remains a preview**.

| Artifact | Bytes | SHA-256 |
| --- | --- | --- |
| `Manjaro-ARM-Xfce-HackberryPi-CM5-DisplayScale-20261110.img.xz` | `1399527532` | `1d662e74bdd356b55a23c3aefdf595ba348c37cec1339cab152384ca22d1a2fe` |
| Expanded `.img` | `9127854080` | `20c9136ebc1396a6de9cb8574f193982b60cfe1bc6cf161ed70ac64fdc2699e0` |

Release: [manjaro-displayscale-hackberrypi-2026-11-10](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/tag/manjaro-displayscale-hackberrypi-2026-11-10). Checksums are provided in `SHA256SUMS` in the same release.

## Upstream software

The base comes from the [official Manjaro ARM release](https://github.com/manjaro-arm/rpi4-images/releases/tag/20261012). Its build date is **20261012**; it is not a Manjaro version number. The tested native kernel is **6.12.41-1-MANJARO-RPI5**.

The upstream ARM package baseline predates the image build date. ARM package updates depend on Manjaro ARM's maintenance status; the x86 Manjaro release schedule does not describe this image. Keep the configured Manjaro ARM repositories when maintaining this installation. See the [upstream ARM update discussion](https://forum.manjaro.org/t/status-of-gcc-llvm-and-kernel-updates-for-arm64/189887).

## PINN installation preview

Use a CM5-capable PINN build with HackberryPi display support and the repository's [combined PINN source](https://raw.githubusercontent.com/DZT970525/Operating-System-for-HackberryPi/main/os_list_v3.json). Select **Manjaro ARM Xfce for HackberryPi** under **General**. PINN needs at least **8704 MiB** for this system, in addition to PINN and any other installed systems.

The PINN edition uses `hbm_boot.tar.xz` and `hbm_root.tar.xz`, followed by a partition adapter that updates the installed boot and root identifiers for PINN's allocation. It preserves the native `/boot` layout, internal display and battery setup. The complete `.img.xz` standalone image is intended for Imager and is not a PINN tarball.

PINN physical installation and multiboot remain previews pending a physical test. Backup-restore fixture status: **adapter fixture passed; installed backup identity is preserved; physical backup/restore not performed**. The standalone owner test does not validate PINN installation.

## Source and license notices

[Integration source](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/manjaro-displayscale-hackberrypi-2026-11-10/Manjaro-HackberryPi-Integration-Source-20261110.tar.gz) contains the Display Scale app, no-idle defaults, first-boot growth and package-trust helpers. [Component sources and license notices](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/manjaro-displayscale-hackberrypi-2026-11-10/Manjaro-HackberryPi-Source-Notices-20261110.tar.gz) include the actual customized battery source, login-hint source, native logo provenance, upstream license notices and verified source-project references. The exact upstream kernel build-recipe commit and battery base commit were not identified; the bundle does not claim a guessed revision.
