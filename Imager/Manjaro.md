# Manjaro: standalone installation with Raspberry Pi Imager

**Manjaro ARM Xfce/X11** for **HackberryPi CM5**, based on official development build **20261012**, with the tested internal display, touchscreen, MAX17048 battery support and English Display Scale app.

## Online download in Imager

1. Open [Raspberry Pi Imager](https://www.raspberrypi.com/software/) and choose **App Options → Content Repository → Edit**.
2. Choose **Use custom URL** and enter:

   ```
   https://raw.githubusercontent.com/DZT970525/Operating-System-for-HackberryPi/main/os_list_imager.json
   ```

3. Choose **Apply & Restart**.
4. Select **HackberryPi CM5**, then **Manjaro ARM Xfce for HackberryPi**.
5. Select the intended **16 GB or larger SD card**, confirm writing and let verification finish. Imager downloads and decompresses the image automatically.

The selected card is erased during writing. Insert the finished card in HackberryPi CM5 and boot.

## Download first, then Use custom

1. [Download `Manjaro-ARM-Xfce-HackberryPi-CM5-DisplayScale-20261110.img.xz`](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/manjaro-displayscale-hackberrypi-2026-11-10/Manjaro-ARM-Xfce-HackberryPi-CM5-DisplayScale-20261110.img.xz).
2. In Imager choose **Use custom** and select that `.img.xz` file directly. Manual decompression is not needed.
3. Select the intended SD card, confirm writing and let verification finish.

## First start

Log in with username **pi** and password **pi**, both lowercase. Use `sudo` for administrator commands and change the default password after first login. Set up your own Wi-Fi connection and application accounts.

Each installation generates a new machine identity and SSH host keys. Package trust is initialized automatically in the background, scheduled about **20 seconds after boot**, using Manjaro's native tooling and the retained public distribution keyrings. It does not delay the LightDM login screen. Allow that task to finish before the first package-management operation. No local private package-signing master key from the source computer is shipped.

Standalone filesystem expansion: **first boot extends only the standalone MMC root partition and filesystem; exact-helper online loop growth and deferred-refresh resume passed; physical first boot remains a preview**.

## Display Scale

The default desktop workspace is **900 × 900**. Double-click **Display Scale** on the desktop to open the English app. Drag its slider from **480 × 480** to **1080 × 1080** and release to apply. **Save as default** remembers a selection; **Reset to 900** restores the factory value.

The physical screen remains **720 × 720 pixels**. This is software scaling: smaller workspace values enlarge text and controls; larger values fit more content. Font antialiasing and the tested direct-touch mapping are included. No desktop pinch-to-zoom service is installed.

The login screen shows **Default Password: pi**. This is a factory-password hint and does not change authentication.

## Screen stays on by default

Automatic screensaver activation, automatic lock-on-screensaver, screen blanking, DPMS display sleep/off, idle dimming and idle suspend are disabled by default on both AC and battery power. This avoids automatic idle display transitions on the internal DPI screen.

Manual screen locking and password-based unlocking remain available. Login authentication, critical-battery handling and explicit user power actions are preserved. Physical idle-display validation: **not performed; configuration and disposable loop installer verified, physical AC/battery idle test remains a preview**.

## Artifact and validation

| Item | Value |
| --- | --- |
| Release | [manjaro-displayscale-hackberrypi-2026-11-10](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/tag/manjaro-displayscale-hackberrypi-2026-11-10) |
| Complete compressed image | `Manjaro-ARM-Xfce-HackberryPi-CM5-DisplayScale-20261110.img.xz` |
| Compressed bytes | `1399527532` |
| Compressed SHA-256 | `1d662e74bdd356b55a23c3aefdf595ba348c37cec1339cab152384ca22d1a2fe` |
| Expanded image bytes | `9127854080` |
| Expanded image SHA-256 | `20c9136ebc1396a6de9cb8574f193982b60cfe1bc6cf161ed70ac64fdc2699e0` |

The owner tested and accepted the installed Manjaro system and repaired networking. Factory-image audit: **passed: fresh filesystems, excluded private state and offline audit**. Clean-image boot-test status: **not performed; fresh factory-image physical boot remains a preview**.

The new screen-idle policy and per-device background package-trust initialization have separate validation status recorded in `factory-status.json`; the earlier working-card acceptance does not establish their physical first-boot results.

The native Manjaro Pi 5 kernel, display configuration, touchscreen and battery integration are retained. [Read the system notes](../Manjaro/README.md), including the upstream ARM package baseline and available installation methods.

The separate [PINN edition](../Manjaro/README.md#pinn-installation-preview) uses filesystem archives. Its installation and multiboot validation status is separate from this standalone image.
