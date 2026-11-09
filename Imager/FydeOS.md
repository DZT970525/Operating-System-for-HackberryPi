# FydeOS: standalone installation with Raspberry Pi Imager

FydeOS **23.0**, build **16700.56.23.8**, ARM64 for **HackberryPi CM5 / CM5 Lite**, with **Display Scale v1.2**. This complete disk image preserves the source card's display, touch, keyboard scrolling, battery, network/time helpers and ChatGPT web-app integration.

## Download and write

Use a **16 GB or larger SD card** and [Raspberry Pi Imager](https://www.raspberrypi.com/software/).

1. Open Imager and choose **App Options → Content Repository → Edit**.
2. Select **Use custom URL** and paste:

   ```
   https://raw.githubusercontent.com/DZT970525/Operating-System-for-HackberryPi/main/os_list_imager.json
   ```

3. Choose **Apply & Restart**.
4. Select **HackberryPi CM5**, **FydeOS**, and the intended SD card.
5. Let Imager download, write and verify the image. Insert the card in HackberryPi and boot.

Alternatively, [download the complete compressed image](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/fydeos-imager-hackberrypi-2026-11-10/FydeOS-23.0-HackberryPi-CM5-DisplayScale-20261110.img.xz), choose **Use custom** in Imager, and select that compressed image directly. Manual decompression is not required. Imager writes a complete disk image, including its partition table; the `hbf_*.tar.gz` PINN filesystem archives are a separate installation format.

## First start

Complete FydeOS's native first-run setup with your own language, region, network and account. There is no shared `pi / pi` desktop account. Imager's account and Wi-Fi customization is not used for this system. Use your own account and any license or activation required by FydeOS; this release does not transfer the source card owner's account or license.

The release copy uses fresh user data. Saved accounts, browser sessions, login tokens, Wi-Fi credentials, personal Android/Linux environments and private histories from the source card are excluded. The source card is retained separately during image preparation.

## Display Scale

After sign-in, the default desktop workspace is **900 × 900**. Open the English **Display Scale** app from the FydeOS application launcher to adjust it from **640 × 640** to **1080 × 1080**. Release the slider to apply; the selected value is saved for the next login.

- **Default · 900 × 900** restores the supplied default.
- **Native · 720 × 720** restores native-size scaling.
- A smaller workspace makes text and controls larger; a larger workspace fits more content.

The physical panel remains **720 × 720**. The app changes software scaling across the desktop and applications, rather than changing the panel's physical resolution. Display Scale v1.2 calls the local display controls directly instead of depending on the previous background message connection.

## Disk layout and first boot

This standalone image keeps the native **12-partition GPT layout**. The fresh STATE filesystem starts at **4 GiB**, with the stock first-boot expansion prepared for a **16 GB or larger card**. The OEM filesystem is fresh and empty.

This release boots from **ROOT-A**. The unused ROOT-B partition is cleared and its kernel slot has priority zero. A fallback system is not supplied; alternate-slot boot, rollback, native OTA updates and first-boot expansion have not been verified on the sanitized release image.

## Artifact and validation

| Item | Value |
| --- | --- |
| Release | [fydeos-imager-hackberrypi-2026-11-10](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/tag/fydeos-imager-hackberrypi-2026-11-10) |
| Compressed image | `FydeOS-23.0-HackberryPi-CM5-DisplayScale-20261110.img.xz` |
| Download bytes | `2080986044` |
| Download SHA-256 | `201e6ffa4a5d9507537d7dfebfd662433ad385784535fe0046ba91e8a79f9028` |
| Expanded image bytes | `10224664576` |
| Expanded image SHA-256 | `5413fb46b6dd91b3a55fbb060d5b58b0c59634c6fabe4256a5bf11a424facb0d` |

The owner tested and accepted the source card's system with Display Scale v1.2. The sanitized release image has not yet completed a separate physical flash, native first-run and boot test. File, filesystem, image-layout and checksum validation results are recorded with the release.

The older [FydeOS PINN edition](../FydeOS/README.md) remains a separate preview package. Its four-filesystem layout and PINN-specific update/reset restrictions should not be applied to this standalone image. The existing PINN archives are unchanged by this release.
