# Twister OS: standalone installation with Raspberry Pi Imager

**Twister OS 3.1.0 Xfce for HackberryPi** uses Debian 12 Bookworm ARM64 with the Xfce/X11 desktop already installed.

## Automatic download and merge

1. [Download **TwisterOS-Imager-Download-Tools-20261116.zip**](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/twisteros-displayscale-hackberrypi-2026-11-16/TwisterOS-Imager-Download-Tools-20261116.zip) and extract the entire ZIP into a normal computer folder with **at least 5 GB free**. Keep all launcher and manifest files together.
2. Run the launcher as a normal user:
   - Windows: double-click `download-twisteros.cmd`.
   - macOS: open `download-twisteros.command`.
   - Linux: run `sh ./download-twisteros.sh`.
3. Let all **16 parts** download and pass their SHA-256 checks. The helper automatically combines them and checks the complete compressed file. Running the same launcher again resumes interrupted downloads and reuses verified parts. It creates:

   ```
   TwisterOS-3.1.0-Xfce-HackberryPi-CM5-DisplayScale-Neofetch-20261116.img.xz
   ```

4. Open [Raspberry Pi Imager](https://www.raspberrypi.com/software/), choose **Use custom**, and select that completed `.img.xz` file directly. Do not select the helper ZIP or an individual part; do not manually decompress it.
5. Keep Imager's OS customization disabled, select the intended **16 GB or larger SD card**, and finish writing and verification before booting.

The helper only downloads and combines files on your computer. Imager chooses and writes the card, replacing its contents. The folder must support a single file of **2321279728 bytes** and hold the parts and completed image together. After successful writing, the `.twisteros-download-parts` cache may be removed. This oversized image uses the same helper method as Ubuntu/Kali/Omarchy; it is not an online JSON catalog entry.

## First start

Log in with **pi / pi**, both lowercase. The login page displays **Default Password: pi**. Use `sudo` for administrator commands and change the password after first login. Connect your own Wi-Fi and Bluetooth devices.

The compact image expands its root filesystem and creates fresh machine and SSH identities on first start. Allow this preparation to finish. Xfce and the hardware/desktop controls are already installed; configure your own networks after logging in.

## Display Scale and theme switching

The default workspace is **900 × 900**; the physical panel stays **720 × 720 pixels**. The English **Display Scale** app on the desktop provides **480–1080** scaling. Smaller numbers enlarge controls; larger numbers fit more content. Choose **Save as default**, or **Reset to 900**. Automatic screen-idle transitions are disabled, with manual locking retained.

Use **ThemeTwister** for its native desktop themes. Its 15 choices, including **Windows XP**, now apply their matching wallpaper to the actual DPI screen. Save your work before confirming the session restart. Native Wi-Fi, Bluetooth, volume and battery controls follow the selected theme's panel layout. No separate desktop theme download is required.

Open a terminal and run `neofetch` for original upstream 7.1.0 system information (Debian package 7.1.0-4).

## Artifact and validation

| Artifact | Bytes | SHA-256 |
| --- | --- | --- |
| `TwisterOS-3.1.0-Xfce-HackberryPi-CM5-DisplayScale-Neofetch-20261116.img.xz` | `2321279728` | `5548c40f709f0212d65ff803de08c72c13e356d75a2dfb7d59702591f25a08e0` |
| Expanded `.img` | `11253317632` | `faeeb2eded19cbf5ba8ecb433bcf5ae79001fb817537b9b78d2d8046e1a86216` |

The owner accepted the configured source card for publication. The sanitized image passed private-state exclusion, native filesystem/integration checks, complete XZ compressed-to-raw SHA-256 verification, and an isolated test of its shipped root-expansion helper.

The final sanitized image has not received a separate physical flash/first-boot test. Actual wireless association, Bluetooth pairing and audio output on that final copy remain separate from the offline checks.

Read the [Twister OS system notes](../TwisterOS/README.md) for hardware, native kernel and source details. This release is standalone only and is not added to the PINN feed.
