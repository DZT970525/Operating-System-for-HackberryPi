# Ubuntu: standalone installation with Raspberry Pi Imager

**Ubuntu 24.04.5 LTS GNOME for HackberryPi** uses Ubuntu 24.04.5 LTS Noble ARM64 with GNOME 46 Wayland preinstalled.

## Automatic download and merge

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
5. Keep Imager's OS customisation disabled for this preconfigured image. Select the intended **16 GB or larger SD card**, confirm writing, and let verification finish before booting HackberryPi CM5.

The helper only downloads and combines files on the computer; Imager chooses and writes the SD card. The download needs space for the parts and completed compressed image at the same time. The folder's filesystem must support a file of **3017984912 bytes**. After successful writing, the hidden `.ubuntu-download-parts` cache can be removed.

The complete compressed image is split for GitHub delivery. The helper performs all merging automatically; users do not type merge commands. This Ubuntu release is not in the online JSON catalog. Existing online entries for other systems remain unchanged.

## First start

Log in with **pi / pi**, both lowercase. The login screen displays **Default Password: pi**. Change the password after first login; use `sudo` for administrator commands. Initial preparation expands the root filesystem and creates fresh machine/SSH identities.

Use the existing top-right system menu's **Wi-Fi Settings** and **Bluetooth Settings** buttons for network selection and device pairing. The native audio and battery controls remain available. The native USB 2.0 controller uses Host mode for external peripherals.

## Display Scale

The default workspace is **900 × 900**. The physical screen remains **720 × 720 pixels**. Open the English **Display Scale** desktop app and use its **480–1080** slider or presets. Smaller numbers enlarge controls; larger numbers fit more content. Choose **Save as default**, or **Reset to 900**. Automatic idle screen transitions are disabled, and manual locking remains available.

Open a terminal and run `neofetch` for original Neofetch 7.1.0 system information.

## Artifact and validation

| Artifact | Bytes | SHA-256 |
| --- | --- | --- |
| `Ubuntu-24.04.5-GNOME-HackberryPi-CM5-DisplayScale-Neofetch-20261113.img.xz` | `3017984912` | `afdd7664a3fc3c6ea389d429fcf5a4f45a1e335b30d13f8d3d485043b5cf9a7b` |
| Expanded `.img` | `9318694912` | `56dadec8025ee6026f6feec66da7d40245e5ceb03e4d0ec7bc5a8f579d78b1d9` |

The owner tested and accepted the configured source card. Factory privacy audit: **passed: fresh filesystems and excluded personal state**. Final filesystem/offline audit: **passed: native filesystem and retained integration checks**. Complete compressed-to-raw verification: **passed: complete XZ integrity and compressed-to-raw SHA-256 round-trip**. Standalone root expansion: **passed using the shipped helper in an isolated loop test; physical first boot remains pending**.

The rebuilt sanitized release image has not received a separate physical flash and first-boot test. Actual Wi-Fi association, Bluetooth pairing, audio output and idle/manual-lock checks on that final image remain separate from offline and isolated-compositor checks.

Read the [Ubuntu system notes](../Ubuntu/README.md) for source licenses, kernel/desktop maintenance and the old PINN preview's migration. This release supports standalone Imager installation; it is not a replacement PINN filesystem package.

Helper validation: small offline Linux/POSIX integrity/resume fixtures passed. Windows and macOS launchers received static checks; native Windows/macOS runtime and a full public-network download/resume test remain separate.
