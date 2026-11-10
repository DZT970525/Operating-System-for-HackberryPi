# Kali: standalone installation with Raspberry Pi Imager

Kali Linux **2026.3**, ARM64 GNOME/Wayland for **HackberryPi CM5**, with **Display Scale v1.1**, touchscreen configuration, ChatGPT and MAX17048 battery support.

## Download and write

1. [Download **Kali-Imager-Download-Tools-20261110.zip**](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/kali-displayscale-hackberrypi-2026-11-10/Kali-Imager-Download-Tools-20261110.zip) and extract it into a computer folder with **at least 11 GB free**. The disk must support files larger than 4 GB.
2. Run the launcher in that extracted folder:
   - Windows: double-click `download-kali.cmd`.
   - macOS: open `download-kali.command`.
   - Linux: run `sh ./download-kali.sh`.
3. Wait for all **37 parts** to download, pass their SHA-256 checks, and merge. Interrupted downloads can resume by running the same launcher again.
4. Open [Raspberry Pi Imager](https://www.raspberrypi.com/software/), choose **Use custom**, and select the completed file directly:

   ```
   Kali-2026.3-HackberryPi-CM5-DisplayScale-20261110.img.xz
   ```

5. Select the intended **32 GB or larger SD card**, confirm writing, and let verification finish. Manual decompression is not needed. Insert the card in HackberryPi CM5 and boot.

Kali uses the download-and-merge helper followed by **Use custom**, like Omarchy. It is not an entry in the Imager online JSON catalog. The helper only prepares a local image file; Imager selects and writes the SD card.

## First start

Log in with username **kali** and password **kali**, both lowercase. Use `sudo` for administrator commands and the same password when prompted. Change the password with `passwd` after your first login. Configure your own network and application accounts after boot.

The root filesystem expands on first boot to use the standalone card. This image is intended to occupy the selected card; use the separate [PINN edition](../Kali/README.md) for PINN multiboot.

## Display Scale

After sign-in, the default desktop workspace is **900 × 900**. Double-click **Display Scale** on the desktop to open the English app. Drag its slider from **480 × 480** to **1080 × 1080**, then release to apply. Use **Save as default** to keep a chosen size for later logins.

The physical screen remains **720 × 720**. These values describe software scaling: a smaller workspace enlarges text and controls; a larger workspace fits more content. Nearby values can snap by one or two pixels to a supported scale. Native Wayland touch scrolling and the existing battery support are retained. No desktop pinch-to-zoom service is installed.

The login screen displays **Default Password: kali** below the password field. This is a factory-password hint; it does not change authentication.

## Artifact and validation

| Item | Value |
| --- | --- |
| Release | [kali-displayscale-hackberrypi-2026-11-10](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/tag/kali-displayscale-hackberrypi-2026-11-10) |
| Completed compressed image | `Kali-2026.3-HackberryPi-CM5-DisplayScale-20261110.img.xz` |
| Compressed bytes | `4909370740` |
| Compressed SHA-256 | `3ca97a95c0b37a1f50d15b847c9e0802f057b9062f718a9af7a7f16640aab83e` |
| Expanded image bytes | `22012755968` |
| Expanded image SHA-256 | `fd5da1dd6a848795e2742027f847bb5c6a221de2f93e9a1793ec5d0bc3e07117` |

The owner boot-tested and accepted the repaired default scaling, desktop Display Scale application and login hint on HackberryPi CM5. This release applies those same changes to the sanitized factory image. Saved personal accounts, browser sessions, network credentials and user history are excluded. A new machine identity and SSH host keys are generated on first boot.

The original GNOME Shell and Mutter packages, native panel timings, touch configuration and battery drivers are preserved. The scaling adapter targets the tested GNOME Shell 50.4 / Mutter 50.5 binaries; after a GNOME upgrade, matching support is required for the custom scale range.

The PINN edition uses filesystem archives and a final Display Scale overlay, rather than this complete disk image. Full physical installation and multiboot validation through PINN remain pending.
