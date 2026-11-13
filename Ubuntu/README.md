# Ubuntu 24.04.5 LTS GNOME for HackberryPi

Ubuntu **24.04.5 LTS Noble ARM64**, with the native **GNOME 46 Wayland** desktop already installed for **HackberryPi CM5**.

## Included

- Default **900 × 900** software workspace on the native **720 × 720** DPI panel.
- English **Display Scale** desktop app for **480–1080**, font antialiasing and saved startup defaults.
- Screen/touch integration, **USB 2.0 Host**, and MAX17048 battery support using the native Ubuntu kernel.
- The existing top-right system menu includes persistent **Wi-Fi Settings** and **Bluetooth Settings** buttons. Native radio, volume and battery controls remain in use.
- **Neofetch 7.1.0**; run `neofetch` in a terminal.
- Login-screen hint: **Default Password: pi**.
- Automatic screen blanking, idle dimming and idle suspend disabled. Manual locking and login authentication remain available.

Default username: **pi**. Default password: **pi**, both lowercase. Use `sudo` for administrator commands and change the password after first login. The public copy excludes saved Wi-Fi connections/passwords, Bluetooth pairings, browser sessions, keyrings and personal histories.

## Raspberry Pi Imager: automatic download and merge

1. [Download **Ubuntu-Imager-Download-Tools-20261113.zip**](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/ubuntu-displayscale-hackberrypi-2026-11-13/Ubuntu-Imager-Download-Tools-20261113.zip) and extract the entire ZIP into a normal computer folder with **at least 7 GB free**. Keep its launcher and manifest files together.
2. Run the launcher for your computer as a normal user:
   - Windows: double-click `download-ubuntu.cmd`.
   - macOS: open `download-ubuntu.command`.
   - Linux: run `sh ./download-ubuntu.sh` in that folder.
3. Let the helper download **6 parts**, verify each SHA-256, and combine them automatically. Running the same launcher again resumes interrupted downloads and reuses verified parts. It creates:

   ```
   Ubuntu-24.04.5-GNOME-HackberryPi-CM5-DisplayScale-Neofetch-20261113.img.xz
   ```

4. Open [Raspberry Pi Imager](https://www.raspberrypi.com/software/), choose **Use custom**, and select that completed **`.img.xz` file directly**. Do not choose the helper ZIP or an individual part; manual decompression is not needed.
5. Select the intended **16 GB or larger SD card**, confirm writing, and let verification finish before booting HackberryPi CM5.

The helper only downloads and combines files on the computer; Imager chooses and writes the SD card. The download needs space for the parts and completed compressed image at the same time. The folder's filesystem must support a file of **3017984912 bytes**. After successful writing, the hidden `.ubuntu-download-parts` cache can be removed.

This image uses the same download-and-merge method as Omarchy and Kali. Ubuntu is **not an online `os_list_imager.json` entry**: first run the helper, then choose **Use custom** in Imager. Read the [installation guide](../Imager/Ubuntu.md).

## Display Scale and connections

The physical screen always remains **720 × 720 pixels**. Smaller workspace numbers enlarge controls; larger numbers fit more content. Open **Display Scale** on the desktop, drag and release the slider or use **1080 / 900 / 720 / 480**, then choose **Save as default**. **Reset to 900** restores the factory workspace. Some slider positions use the nearest scale supported by the compositor. No global desktop pinch-to-zoom service is included.

After a scale change, ordinary windows are kept reachable, and desktop icons follow the new workspace size. These changes use native Wayland rendering and preserve the panel's physical timing.

Click the existing top-right system menu, then **Wi-Fi Settings** to select a network, or **Bluetooth Settings** to pair/connect a device. These are settings shortcuts; available radios and their actual state are managed by native NetworkManager/BlueZ. Use the native volume slider or sound settings for audio.

## First start and maintenance

The compact image expands its own root filesystem on first start and creates fresh machine/SSH identities. Allow preparation to finish. The desktop is already installed; account creation is not repeated through the old Ubuntu factory first-run wizard. Configure your own Wi-Fi after logging in.

The retained native kernel is **6.8.0-1064-raspi**, with matching Ubuntu headers and MAX17048 DKMS source. Keep the native kernel, headers and boot files coherent during updates. The battery module must rebuild for the selected kernel. The display adapter is scoped to the exact tested GNOME Shell/Mutter pair; an unrecognized runtime uses stock behavior until compatibility is updated.

## Validation

The owner tested and accepted the configured source card. Factory privacy audit: **passed: fresh filesystems and excluded personal state**. Final filesystem/offline audit: **passed: native filesystem and retained integration checks**. Complete compressed-to-raw verification: **passed: complete XZ integrity and compressed-to-raw SHA-256 round-trip**. Standalone root expansion: **passed using the shipped helper in an isolated loop test; physical first boot remains pending**.

The rebuilt sanitized release image has not received a separate physical flash and first-boot test. Actual Wi-Fi association, Bluetooth pairing, audio output and idle/manual-lock checks on that final image remain separate from offline and isolated-compositor checks.

## Checksums

| Artifact | Bytes | SHA-256 |
| --- | --- | --- |
| `Ubuntu-24.04.5-GNOME-HackberryPi-CM5-DisplayScale-Neofetch-20261113.img.xz` | `3017984912` | `afdd7664a3fc3c6ea389d429fcf5a4f45a1e335b30d13f8d3d485043b5cf9a7b` |
| Expanded `.img` | `9318694912` | `56dadec8025ee6026f6feec66da7d40245e5ceb03e4d0ec7bc5a8f579d78b1d9` |

Release: [ubuntu-displayscale-hackberrypi-2026-11-13](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/tag/ubuntu-displayscale-hackberrypi-2026-11-13). `SHA256SUMS`, `factory-status.json` and `image-verification.json` accompany the image.

## PINN migration

This release is **standalone for Raspberry Pi Imager**. It replaces the old Ubuntu PINN preview, whose entry and obsolete partition-archive metadata have been withdrawn. A complete `.img.xz` is not a PINN filesystem archive; do not put it in a PINN `tarballs` list.

The old `Ubuntu/os_list_v3.json` address remains a valid empty catalog. Existing PINN users who want the other systems should use the combined root source:

```
alt_image_source=https://raw.githubusercontent.com/DZT970525/Operating-System-for-HackberryPi/main/os_list_v3.json
```

The other five PINN systems keep their existing packages. Installing this standalone Ubuntu image replaces the whole selected card, including any existing PINN layout; keep a separate backup of needed files first.

## Sources and notices

The [integration source archive](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/ubuntu-displayscale-hackberrypi-2026-11-13/Ubuntu-HackberryPi-Integration-Source-20261113.tar.gz) includes the exact Display Scale frontend/controller, native Wayland scale adapter C source and build instructions, screen/touch overlay, MAX17048 DKMS driver, window-placement extension, Wi-Fi/Bluetooth Settings action extension, and complete patched DING source. Original component notices and licenses remain with the sources.

The [source-notices archive](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/ubuntu-displayscale-hackberrypi-2026-11-13/Ubuntu-HackberryPi-Source-Notices-20261113.tar.gz) contains the installed native package source/version inventory, package copyrights, Ubuntu base-image provenance and upstream notices. The exact native kernel corresponds to Ubuntu **`linux-raspi 6.8.0-1064.68`**. Its authenticated original source artifacts accompany this release: [original source](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/ubuntu-displayscale-hackberrypi-2026-11-13/linux-raspi_6.8.0.orig.tar.gz), [Ubuntu patch](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/ubuntu-displayscale-hackberrypi-2026-11-13/linux-raspi_6.8.0-1064.68.diff.gz), [source descriptor](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/ubuntu-displayscale-hackberrypi-2026-11-13/linux-raspi_6.8.0-1064.68.dsc).

This is an independently maintained HackberryPi customization of [Ubuntu](https://ubuntu.com/), based on the official Ubuntu 24.04.5 Desktop ARM64 Raspberry Pi image. It is not an official Canonical image. Native package copyrights remain under `/usr/share/doc`; upstream trademarks and component licenses remain with their owners.
