# LineageOS: standalone installation with Raspberry Pi Imager

**LineageOS 24.0 / Android 17 for HackberryPi CM5** is an unofficial, noncommercial adaptation of [KonstaKANG’s build dated 2026-10-16](https://konstakang.com/devices/rpi5/LineageOS24/). Read the [system notes](../LineageOS/README.md) and [component licenses/sources](../LineageOS/SOURCES.md).

## Online download in Imager

1. Open [Raspberry Pi Imager](https://www.raspberrypi.com/software/) and choose **App Options → Content Repository → Edit**.
2. Select **Use custom URL** and enter:

   ```
   https://raw.githubusercontent.com/DZT970525/Operating-System-for-HackberryPi/main/os_list_imager.json
   ```

3. Choose **Apply & Restart**.
4. Select **HackberryPi CM5 → LineageOS 24.0 / Android 17 for HackberryPi**.
5. Select the intended **8 GB or larger SD card**, then let writing and verification finish. Imager downloads and decompresses the complete image automatically.

Writing replaces the selected card. Linux OS customization in Imager is not supported for this Android image. Set up Wi-Fi in Android after boot.

## Download first, then Use custom

1. [Download `LineageOS-24.0-Android17-HackberryPi-CM5-DisplayScale-Neofetch-20261116.img.xz`](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/lineageos-displayscale-hackberrypi-2026-11-16/LineageOS-24.0-Android17-HackberryPi-CM5-DisplayScale-Neofetch-20261116.img.xz).
2. Choose **Use custom** in Imager and select the `.img.xz` directly. No manual decompression or merge is needed.
3. Select the intended SD card, confirm writing and wait for verification. Insert the card in HackberryPi CM5 and boot.

## First start

Complete Android’s normal setup wizard, including your own Wi-Fi settings and optional screen lock. **No `pi / pi` login or default Android PIN is configured.** Local preparation installs Termux and its offline Neofetch environment after user 0 is unlocked; after setup it adds Display Scale and Firefox desktop shortcuts. Allow a few minutes on the first start. If preparation was interrupted, reboot to retry. If the desktop shortcuts have not appeared after completing setup, restart once to retry the unfinished desktop step. Later display choices and app data are retained.

The compact image contains a **3 GiB userdata partition** and occupies about **7.0 GB** when expanded. It does not automatically allocate the rest of a larger card. Advanced users can expand **partition 3 and its ext4 filesystem offline on Linux**, preserving the start sector **7383040** and all other partitions. Back up the card first. Upstream also documents a recovery resize package; follow its display/recovery requirements before using it. This adaptation does not claim a tested automatic expansion feature.

All previous owner data and Android metadata are excluded: saved Wi-Fi passwords, Bluetooth pairings, accounts, browser sessions/history, Termux home/history, Android identities, authorized ADB keys and private logs are recreated on first start.

## Display, battery and volume

The physical DPI panel stays **720 × 720**. The default logical workspace is **900 × 900**, with density160. Smaller workspace numbers enlarge controls; larger numbers fit more content.

Open the English **Display Scale** desktop app, preview **480–1080**, then press **Apply**. The slider does not change the screen while you drag it. **Restore Default 900** restores the default. There is no global pinch gesture that silently changes the workspace.

Swipe down from the top to see Wi-Fi, Bluetooth and the **Volume** Quick Settings tile. Volume opens Android’s native sound controls. The status bar shows real MAX17048 battery capacity, refreshed roughly every three seconds; charging state is inferred and the complete upstream Health HAL is not replaced. Native screen/touch configuration and USB 2.0 Host for an external keyboard are included.

Open **Termux** and run `neofetch` for genuine Neofetch7.1.0. This is an Android app environment, not a Linux desktop login shell.

## Firefox updates

Firefox160.0 is the original Mozilla-signed ARM64 APK with its unmodified matching native libraries. It was current when this image was prepared. Google Play is not included, so **Firefox updates must be installed manually**; do not assume Android’s system updater updates this browser.

Use [Mozilla’s official Android installation guidance](https://support.mozilla.org/en-US/kb/install-firefox-your-phone-or-tablet) and [Mozilla’s official Fenix download server](https://archive.mozilla.org/pub/fenix/releases/). Choose the newest **stable** release (not a beta/nightly), then `android-arm64-v8a` and its multi-language `.apk`. Open the downloaded APK in Android, allow installation from that app if Android prompts, and choose **Update**. Keep the same official Mozilla signing identity; do not uninstall Firefox to update it. Android verifies the signature and retains the existing profile. The APK installer handles the updated native libraries.

This image does not alter Firefox preferences, search codes or branding. HackberryPi Controls is a separate bounded handler for supported Baidu/Bilibili links; it does not make every app-specific URL scheme into a web page.

## Validation

| Artifact | Bytes | SHA-256 |
| --- | --- | --- |
| `LineageOS-24.0-Android17-HackberryPi-CM5-DisplayScale-Neofetch-20261116.img.xz` | `1089547944` | `a6c16d9bb6bb7c25d9e6265fe1611690cad36088f50b7e0353a084432229667d` |
| Expanded `.img` | `7001341952` | `281bd4cbcf683a3b65b394990516a6352e1edc5a59cbd3c3fd370dcd7f624a14` |

The owner tested and accepted the configured source card. The freshly sanitized publication image preserves the accepted boot/system payload but replaces all userdata/metadata and consolidates factory preparation. Offline filesystem checks, native-library/app hashes, privacy separation and full XZ-to-raw SHA-256 verification passed. **A separate physical flash and first-run test of the sanitized image has not yet been performed.**

This is a standalone complete disk image, not a PINN filesystem package. Base security properties remain those of the unofficial upstream build, including SELinux permissive mode and no supported userdata encryption. Stock OTA updates may replace the custom screen/battery/scale integration; back up your card and use a compatible adapted release when available.
