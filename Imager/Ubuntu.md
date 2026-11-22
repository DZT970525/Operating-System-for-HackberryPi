# Ubuntu: standalone installation with Raspberry Pi Imager

**Ubuntu 24.04.5 LTS GNOME for HackberryPi** uses Ubuntu 24.04.5 LTS Noble ARM64 with GNOME 46 Wayland preinstalled.

## Automatic download and merge

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
5. Keep Imager's OS customisation disabled for this preconfigured image. Select the intended **16 GB or larger SD card**, confirm writing, and let verification finish before booting HackberryPi CM5.

The helper only downloads and combines files on the computer; Imager chooses and writes the SD card. The download needs space for the parts and completed compressed image at the same time. The folder's filesystem must support a file of **3190467412 bytes**. After successful writing, the hidden `.ubuntu-download-parts` cache can be removed.

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
| `Ubuntu-24.04.5-GNOME-HackberryPi-CM5-DisplayScale-Neofetch-20261122.img.xz` | `3190467412` | `5ca2ce54cfd54642971fc0dc5fd743b071a411024b26d68e0ef42145dc6f8bf5` |
| Expanded `.img` | `9318694912` | `996fac2304fa55fea9c4a80731bb0d03ee0d5f4ce1bd23fd22a50008f7da7950` |

The owner confirmed Firefox starts on the repaired Ubuntu PINN card. This release is rebuilt from the previously published clean factory image; no files or personal data were copied from that card. The patch retains only public Snap model identity and restores an empty native Mesa content directory. Native content-mount profile regeneration and headless Firefox rendering passed in disposable tests. The isolated browser test exercised the native GPU wrapper, GNOME libraries and Firefox binary directly; it did not exercise the GNOME desktop wrapper or full Snap confinement. The clean-source file delta, unchanged boot partition and geometry, filesystem checks, complete XZ decode and all delivery-part hashes passed.

The newly rebuilt clean release image still awaits a separate physical flash and first-boot test. The repaired-card result and isolated browser checks do not establish a complete physical test of this new image. Native hardware integration, package versions and factory identity/root-growth setup are retained. Prior isolated root-growth checks remain applicable to the unchanged helper.

Read the [Ubuntu system notes](../Ubuntu/README.md) for the corrected PINN multiboot package, retained hardware integration and source notices.

Helper validation: small offline Linux/POSIX integrity/resume fixtures passed. Windows and macOS launchers received static checks; native Windows/macOS runtime and a full public-network download/resume test remain separate.
