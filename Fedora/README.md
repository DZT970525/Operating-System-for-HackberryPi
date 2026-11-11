# Fedora Remix 45 Xfce for HackberryPi

![Fedora Remix logo](Fedora_HackberryPi.png)

This is a community **Fedora Remix** containing modified Fedora software and additional HackberryPi integration. Obtain unmodified Fedora software from [the Fedora Project](https://fedoraproject.org/).

Customized ARM64 **Xfce/X11** for **HackberryPi CM5**, using official Fedora 45 packages and a matching community Raspberry Pi 5/CM5 kernel.

- Default **900 × 900** desktop workspace on the native **720 × 720** panel.
- English **Display Scale** desktop app, adjustable from **480 × 480** to **1080 × 1080**, with font antialiasing.
- HackberryPi CM5 DPI display, direct touchscreen and MAX17048 battery integration with UPower and Xfce Power Manager.
- Login-screen hint: **Default Password: pi**.
- Native NetworkManager, systemd-resolved, Bluetooth pairing controls and PipeWire audio components.
- Automatic screensaver, screen blanking, DPMS, idle dimming and idle suspend disabled on AC and battery. Manual locking and login authentication remain available.
- SELinux remains **enforcing**.

Default username: **pi**. Default password: **pi**. Both are lowercase. Use `sudo` for administrator commands and change the password after first login. Configure your own Wi-Fi and application accounts.

## Raspberry Pi Imager

Use the repository’s [Imager online catalog](https://raw.githubusercontent.com/DZT970525/Operating-System-for-HackberryPi/main/os_list_imager.json) and select **HackberryPi CM5 → Fedora Remix 45 Xfce for HackberryPi**, or [download the complete image](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/fedora-displayscale-hackberrypi-2026-11-11/Fedora-45-Xfce-HackberryPi-CM5-DisplayScale-20261111.img.xz) and choose **Use custom**. Select the compressed `.img.xz` directly; manual decompression is not needed.

Use a **16 GB or larger SD card**. Writing replaces the selected card. Let Imager finish both writing and verification, then insert the card in HackberryPi CM5 and boot. See the [installation guide](../Imager/Fedora.md).

## Display Scale and screen-idle defaults

The default workspace is **900 × 900**. Double-click **Display Scale** on the desktop, drag the slider and release to apply. **Save as default** remembers a selection; **Reset to 900** restores the factory workspace.

The physical screen remains **720 × 720 pixels**. Smaller workspace values enlarge text and controls; larger values fit more content. The range **480–1080** changes software scaling. No desktop pinch-to-zoom service is included.

Automatic idle display transitions are disabled to keep the DPI screen on. Manual screen locking and password-based unlocking remain available. The login hint describes the factory password; use your new password after changing it.

## First start and updates

Each installation creates a fresh machine identity and SSH host keys. Personal network profiles, Bluetooth pairings, application sessions and histories are excluded from the public image. The final standalone root filesystem expands to available card space: **passed in a disposable three-partition loop test, including identity refusal, online ext4 growth and deferred-refresh resume; physical first boot remains untested**.

The image keeps Fedora’s native authentication and SELinux enforcing. Its hardware kernel is **6.18.57-1.rpi5.fc45.aarch64**, supplied by the community [dwrobel/kernel-rpi project](https://github.com/dwrobel/kernel/tree/dw-6.18.y). Hardware kernel updates require matching RPi5 kernel/development packages and a successful battery-module and boot-bundle rebuild. The official Fedora ARM image alone does not establish HackberryPi CM5 DPI support.

## Validation

The owner tested and accepted the configured source card on HackberryPi CM5. The release is prepared from that card after removing personal state.

- Factory privacy and offline audit: **passed: fresh filesystems, private state excluded before capture, factory account and residual audit verified**.
- Final compressed-image and expanded-image verification: **passed: native filesystem/offline checks and complete compressed-to-raw SHA-256 round-trip**.
- First-boot standalone filesystem expansion: **passed in a disposable three-partition loop test, including identity refusal, online ext4 growth and deferred-refresh resume; physical first boot remains untested**.
- Physical boot of the final sanitized release image: **not performed; final sanitized factory image awaits a separate physical flash/boot test**.
- Separate AC/battery idle-display and manual-lock test: **not performed; native configuration verified, separate physical AC/battery idle and manual-lock test remains pending**.

Working-card acceptance and software/loop checks do not establish a physical first boot of a newly flashed sanitized image.

## Checksums

| Artifact | Bytes | SHA-256 |
| --- | --- | --- |
| `Fedora-45-Xfce-HackberryPi-CM5-DisplayScale-20261111.img.xz` | `1303816784` | `30d93e91c32ef2ea84c5fc31018ee75707eaae9b33bb47143b9537bbd15e817f` |
| Expanded `.img` | `8649703424` | `a16cd3a18ee3db082c8a4e7e8e0fa7de259acfcb78a7deaf3fe4c337d7a4e8e9` |

Release: [fedora-displayscale-hackberrypi-2026-11-11](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/tag/fedora-displayscale-hackberrypi-2026-11-11). `SHA256SUMS` and `factory-status.json` accompany the image.

## PINN

This Fedora release is a **standalone Raspberry Pi Imager image**. It has no Fedora PINN catalog entry or tested PINN partition adapter. The repository’s six existing PINN systems keep their current installation method. A complete `.img.xz` is not a PINN filesystem archive.

## Sources and notices

The [integration source](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/fedora-displayscale-hackberrypi-2026-11-11/Fedora-HackberryPi-Integration-Source-20261111.tar.gz) includes the actual customized battery module, hardware helper, display app, login-hint UI/loader, no-idle defaults and standalone growth helper. [Source and license notices](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/fedora-displayscale-hackberrypi-2026-11-11/Fedora-HackberryPi-Source-Notices-20261111.tar.gz) identify the base, firmware, community kernel and bundled components. The exact matching [kernel source RPM](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/fedora-displayscale-hackberrypi-2026-11-11/kernel-rpi5-6.18.57-1.rpi5.fc45.src.rpm) accompanies this release.

The Fedora Remix logo is an unmodified image from the signed `fedora-remix-logos-1.0.0-31.fc45` package. Its [COPYING notice](Fedora_Remix_COPYING.txt) is retained. Fedora and Fedora Remix are trademarks of Red Hat, Inc.; this community image is independently maintained.
