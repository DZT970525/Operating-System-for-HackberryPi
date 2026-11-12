# DietPi: standalone installation with Raspberry Pi Imager

**DietPi Xfce for HackberryPi** uses DietPi v10.8.2 / Debian 13 Trixie ARM64, with Xfce/X11 already installed.

## Online download in Imager

1. Open [Raspberry Pi Imager](https://www.raspberrypi.com/software/) and choose **App Options → Content Repository → Edit**.
2. Select **Use custom URL** and enter:

   ```
   https://raw.githubusercontent.com/DZT970525/Operating-System-for-HackberryPi/main/os_list_imager.json
   ```

3. Choose **Apply & Restart**.
4. Select **HackberryPi CM5 → DietPi Xfce for HackberryPi**.
5. Select the intended **16 GB or larger SD card**. Continue writing and verification; Imager downloads and decompresses the complete image automatically.

Writing erases the selected card. This catalog keeps the image's existing account and settings; configure your Wi-Fi in the running desktop.

## Download first, then Use custom

1. [Download `DietPi-Trixie-Xfce-HackberryPi-CM5-DisplayScale-Neofetch-20261113.img.xz`](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/dietpi-displayscale-hackberrypi-2026-11-13/DietPi-Trixie-Xfce-HackberryPi-CM5-DisplayScale-Neofetch-20261113.img.xz).
2. Choose **Use custom** in Imager and select the `.img.xz` directly. No manual merge or decompression is needed.
3. Select your SD card, confirm writing, and wait for writing and verification before booting.

## First start

Default username: **pi**. Default password: **pi**, both lowercase. Use `sudo` for administrator commands and change the password after first login. Connect your own Wi-Fi and Bluetooth devices; the public image excludes saved personal connections, pairings, account sessions and histories.

Root expansion and fresh machine/SSH identity initialization run on first start. The desktop and basic Wi-Fi/Bluetooth/volume controls are preinstalled. Choose Wi-Fi from the top-right icon, pair devices through the Bluetooth icon and adjust sound through the volume slider. The native USB 2.0 controller is configured in Host mode for external peripherals.

## Display Scale and Neofetch

The physical panel always remains **720 × 720 pixels**. Display Scale changes the software workspace: smaller numbers enlarge text and controls; larger numbers fit more content. Double-click **Display Scale**, drag and release the slider, then use **Save as default** to retain a selection. **Reset to 900** restores the factory workspace. No global desktop pinch-to-zoom service is included.

The default workspace is **900 × 900**. Automatic screen-idle transitions are disabled; manual screen locking and login authentication remain available. Open a terminal and run:

```sh
neofetch
```

This is original upstream Neofetch 7.1.0. DietPi is based on Debian, so Debian identification in tools is expected.

## Artifact and validation

| Artifact | Bytes | SHA-256 |
| --- | --- | --- |
| `DietPi-Trixie-Xfce-HackberryPi-CM5-DisplayScale-Neofetch-20261113.img.xz` | `618265540` | `83a3db22c72a385b99a11c1bbf1b949e810691423811fb743b60f8484f8e9211` |
| Expanded `.img` | `4204789760` | `f732fb5b2dad3ec2a19d37d85a69e9f102acbdb2355e000d45a1ef1640c1e0a9` |

The owner accepted the configured source card for publication. Factory privacy and offline audit: **passed: fresh filesystems, private state excluded, factory account and retained integration checked**. Complete compressed/expanded image verification: **passed: native filesystem/offline checks and complete compressed-to-raw SHA-256 round-trip**. Standalone filesystem expansion: **passed using the shipped standalone growth helper in an isolated two-partition loop test; physical first boot remains pending**.

The rebuilt sanitized image has not received a separate physical flash/first-boot test. Physical Wi-Fi association, Bluetooth pairing, audio output and AC/battery idle/manual-lock testing remain separate from the offline checks. Source-card acceptance does not establish those final-image hardware tests.

Read the [DietPi system notes](../DietPi/README.md) for sources, kernel maintenance and detailed controls. This DietPi release is standalone only; it is not added to the PINN feed.
