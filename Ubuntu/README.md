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

1. [Download **Ubuntu-Imager-Download-Tools-20261122.zip**](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/ubuntu-firefox-hackberrypi-2026-11-22/Ubuntu-Imager-Download-Tools-20261122.zip) and extract the entire ZIP into a normal computer folder with **at least 7 GB free**. Keep its launcher and manifest files together.
2. Run the launcher for your computer as a normal user:
   - Windows: double-click `download-ubuntu.cmd`.
   - macOS: open `download-ubuntu.command`.
   - Linux: run `sh ./download-ubuntu.sh` in that folder.
3. Let the helper download **7 parts**, verify each SHA-256, and combine them automatically. Running the same launcher again resumes interrupted downloads and reuses verified parts. It creates:

   ```
   Ubuntu-24.04.5-GNOME-HackberryPi-CM5-DisplayScale-Neofetch-20261122.img.xz
   ```

4. Open [Raspberry Pi Imager](https://www.raspberrypi.com/software/), choose **Use custom**, and select that completed **`.img.xz` file directly**. Do not choose the helper ZIP or an individual part; manual decompression is not needed.
5. Select the intended **16 GB or larger SD card**, confirm writing, and let verification finish before booting HackberryPi CM5.

The helper only downloads and combines files on the computer; Imager chooses and writes the SD card. The download needs space for the parts and completed compressed image at the same time. The folder's filesystem must support a file of **3190467412 bytes**. After successful writing, the hidden `.ubuntu-download-parts` cache can be removed.

This image uses the same download-and-merge method as Omarchy and Kali. Ubuntu is **not an online `os_list_imager.json` entry**: first run the helper, then choose **Use custom** in Imager. Read the [installation guide](../Imager/Ubuntu.md).

## Display Scale and connections

The physical screen always remains **720 × 720 pixels**. Smaller workspace numbers enlarge controls; larger numbers fit more content. Open **Display Scale** on the desktop, drag and release the slider or use **1080 / 900 / 720 / 480**, then choose **Save as default**. **Reset to 900** restores the factory workspace. Some slider positions use the nearest scale supported by the compositor. No global desktop pinch-to-zoom service is included.

After a scale change, ordinary windows are kept reachable, and desktop icons follow the new workspace size. These changes use native Wayland rendering and preserve the panel's physical timing.

Click the existing top-right system menu, then **Wi-Fi Settings** to select a network, or **Bluetooth Settings** to pair/connect a device. These are settings shortcuts; available radios and their actual state are managed by native NetworkManager/BlueZ. Use the native volume slider or sound settings for audio.

## First start and maintenance

The compact image expands its own root filesystem on first start and creates fresh machine/SSH identities. Allow preparation to finish. The desktop is already installed; account creation is not repeated through the old Ubuntu factory first-run wizard. Configure your own Wi-Fi after logging in.

The retained native kernel is **6.8.0-1064-raspi**, with matching Ubuntu headers and MAX17048 DKMS source. Keep the native kernel, headers and boot files coherent during updates. The battery module must rebuild for the selected kernel. The display adapter is scoped to the exact tested GNOME Shell/Mutter pair; an unrecognized runtime uses stock behavior until compatibility is updated.

## Validation

The owner confirmed Firefox starts on the repaired Ubuntu PINN card. This release is rebuilt from the previously published clean factory image; no files or personal data were copied from that card. The patch retains only public Snap model identity and restores an empty native Mesa content directory. Native content-mount profile regeneration and headless Firefox rendering passed in disposable tests. The isolated browser test exercised the native GPU wrapper, GNOME libraries and Firefox binary directly; it did not exercise the GNOME desktop wrapper or full Snap confinement. The clean-source file delta, unchanged boot partition and geometry, filesystem checks, complete XZ decode and all delivery-part hashes passed.

The newly rebuilt clean release image still awaits a separate physical flash and first-boot test. The repaired-card result and isolated browser checks do not establish a complete physical test of this new image. Native hardware integration, package versions and factory identity/root-growth setup are retained. Prior isolated root-growth checks remain applicable to the unchanged helper.

## Checksums

| Artifact | Bytes | SHA-256 |
| --- | --- | --- |
| `Ubuntu-24.04.5-GNOME-HackberryPi-CM5-DisplayScale-Neofetch-20261122.img.xz` | `3190467412` | `5ca2ce54cfd54642971fc0dc5fd743b071a411024b26d68e0ef42145dc6f8bf5` |
| Expanded `.img` | `9318694912` | `996fac2304fa55fea9c4a80731bb0d03ee0d5f4ce1bd23fd22a50008f7da7950` |

Release: [ubuntu-firefox-hackberrypi-2026-11-22](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/tag/ubuntu-firefox-hackberrypi-2026-11-22). `SHA256SUMS`, `factory-status.json` and `image-verification.json` accompany the image.

## PINN multiboot

The corrected Ubuntu package is also available as **Ubuntu for HackberryPi** in the prepared HackberryPi CM5 PINN combined catalog:

```
alt_image_source=https://raw.githubusercontent.com/DZT970525/Operating-System-for-HackberryPi/main/os_list_v3.json
```

Keep the network connected while PINN installs its verified supplemental payload. Use the prepared HackberryPi PINN edition and select the systems that fit the card. Read the [PINN installation guide](../Imager/PINN.md). The refreshed Ubuntu recipe affects new installations; it does not update an Ubuntu installation already on a card. All other systems' entries and payloads remain unchanged by this Ubuntu refresh.

The standalone Imager file is a complete disk image. Writing it replaces the selected card and its existing PINN layout; choose the PINN package for multiboot installation. Never use an individual `.partNN` or the helper ZIP as an Imager image.

## Sources and notices

The [2026-11-22 Firefox correction source](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/ubuntu-firefox-hackberrypi-2026-11-22/Ubuntu-Firefox-Fix-Sources-20261122.tar.gz) contains the reproducible clean-image patch, publication tools and verification support. Native packages, kernel and previous integration binaries are unchanged; the original matching source archives and notices linked below remain available.

The [integration source archive](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/ubuntu-displayscale-hackberrypi-2026-11-13/Ubuntu-HackberryPi-Integration-Source-20261113.tar.gz) includes the exact Display Scale frontend/controller, native Wayland scale adapter C source and build instructions, screen/touch overlay, MAX17048 DKMS driver, window-placement extension, Wi-Fi/Bluetooth Settings action extension, and complete patched DING source. Original component notices and licenses remain with the sources.

The [source-notices archive](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/ubuntu-displayscale-hackberrypi-2026-11-13/Ubuntu-HackberryPi-Source-Notices-20261113.tar.gz) contains the installed native package source/version inventory, package copyrights, Ubuntu base-image provenance and upstream notices. The exact native kernel corresponds to Ubuntu **`linux-raspi 6.8.0-1064.68`**. Its authenticated original source artifacts accompany this release: [original source](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/ubuntu-displayscale-hackberrypi-2026-11-13/linux-raspi_6.8.0.orig.tar.gz), [Ubuntu patch](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/ubuntu-displayscale-hackberrypi-2026-11-13/linux-raspi_6.8.0-1064.68.diff.gz), [source descriptor](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/ubuntu-displayscale-hackberrypi-2026-11-13/linux-raspi_6.8.0-1064.68.dsc).

This is an independently maintained HackberryPi customization of [Ubuntu](https://ubuntu.com/), based on the official Ubuntu 24.04.5 Desktop ARM64 Raspberry Pi image. It is not an official Canonical image. Native package copyrights remain under `/usr/share/doc`; upstream trademarks and component licenses remain with their owners.
