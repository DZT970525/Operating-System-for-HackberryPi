# Fedora Remix: standalone installation with Raspberry Pi Imager

**Fedora Remix 45 Xfce for HackberryPi**, with the native 720 × 720 HackberryPi CM5 display, touchscreen, MAX17048 battery integration and English Display Scale app.

This is a community **Fedora Remix** containing modified Fedora software and additional HackberryPi integration. Obtain unmodified Fedora software from [the Fedora Project](https://fedoraproject.org/).

## Online download in Imager

1. Open [Raspberry Pi Imager](https://www.raspberrypi.com/software/) and choose **App Options → Content Repository → Edit**.
2. Select **Use custom URL** and enter:

   ```
   https://raw.githubusercontent.com/DZT970525/Operating-System-for-HackberryPi/main/os_list_imager.json
   ```

3. Choose **Apply & Restart**.
4. Select **HackberryPi CM5**, then **Fedora Remix 45 Xfce for HackberryPi**.
5. Choose the intended **16 GB or larger SD card**. Continue writing and verification; Imager downloads and decompresses the complete image automatically.

The selected card is erased. Insert the finished card in HackberryPi CM5 and boot. The catalog uses the image’s existing account and settings; configure Wi-Fi and other personal choices in the running system.

## Download first, then Use custom

1. [Download `Fedora-45-Xfce-HackberryPi-CM5-DisplayScale-20261111.img.xz`](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/fedora-displayscale-hackberrypi-2026-11-11/Fedora-45-Xfce-HackberryPi-CM5-DisplayScale-20261111.img.xz).
2. In Imager select **Use custom** and choose the `.img.xz` file directly. Manual decompression is not needed.
3. Select your card, confirm writing and let verification finish.

## First start

Log in with **pi / pi**, both lowercase. Use `sudo` for administrator commands and change the factory password. Set up your own Wi-Fi and Bluetooth devices. Machine identity and SSH host keys are fresh for each installation.

Standalone root expansion: **passed in a disposable three-partition loop test, including identity refusal, online ext4 growth and deferred-refresh resume; physical first boot remains untested**.

## Display Scale

The default workspace is **900 × 900**. Double-click **Display Scale** on the desktop, drag the slider and release to apply. **Save as default** remembers a selection; **Reset to 900** restores the factory workspace.

The physical screen remains **720 × 720 pixels**. Smaller workspace values enlarge text and controls; larger values fit more content. The range **480–1080** changes software scaling. No desktop pinch-to-zoom service is included.

Automatic idle display transitions are disabled to keep the DPI screen on. Manual screen locking and password-based unlocking remain available. The login hint describes the factory password; use your new password after changing it.

## Artifact and validation

| Artifact | Bytes | SHA-256 |
| --- | --- | --- |
| `Fedora-45-Xfce-HackberryPi-CM5-DisplayScale-20261111.img.xz` | `1303816784` | `30d93e91c32ef2ea84c5fc31018ee75707eaae9b33bb47143b9537bbd15e817f` |
| Expanded `.img` | `8649703424` | `a16cd3a18ee3db082c8a4e7e8e0fa7de259acfcb78a7deaf3fe4c337d7a4e8e9` |

Release: [fedora-displayscale-hackberrypi-2026-11-11](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/tag/fedora-displayscale-hackberrypi-2026-11-11). `SHA256SUMS` and `factory-status.json` accompany the image.

The owner tested and accepted the configured source card on HackberryPi CM5. The release is prepared from that card after removing personal state.

- Factory privacy and offline audit: **passed: fresh filesystems, private state excluded before capture, factory account and residual audit verified**.
- Final compressed-image and expanded-image verification: **passed: native filesystem/offline checks and complete compressed-to-raw SHA-256 round-trip**.
- First-boot standalone filesystem expansion: **passed in a disposable three-partition loop test, including identity refusal, online ext4 growth and deferred-refresh resume; physical first boot remains untested**.
- Physical boot of the final sanitized release image: **not performed; final sanitized factory image awaits a separate physical flash/boot test**.
- Separate AC/battery idle-display and manual-lock test: **not performed; native configuration verified, separate physical AC/battery idle and manual-lock test remains pending**.

Working-card acceptance and software/loop checks do not establish a physical first boot of a newly flashed sanitized image.

Read the [Fedora Remix system notes](../Fedora/README.md) for hardware-kernel maintenance and component sources. Fedora PINN installation is not included in this release.
