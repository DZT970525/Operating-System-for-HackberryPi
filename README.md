# Operating Systems for HackberryPi

Customized ARM64 systems for **HackberryPi CM5**, with separate download sources for **PINN** and **Raspberry Pi Imager**.

| System | Documentation | Default login |
| --- | --- | --- |
| RPiOS — Raspberry Pi OS for HackberryPi | [RPiOS](RPiOS/README.md) | Username `pi`, password `pi` — both lowercase; use `sudo` for administrator commands |
| Ubuntu 24.04.5 for HackberryPi | [Ubuntu](Ubuntu/README.md) | Create an account using native first-boot setup |
| Kali Linux 2026.3 for HackberryPi | [PINN](Kali/README.md) · [Imager](Imager/Kali.md) | Username `kali`, password `kali` — both lowercase; use `sudo` for administrator commands |
| Fyde OS for HackBerry Pi (FydeOS 23.0) | [PINN](FydeOS/README.md) · [Imager](Imager/FydeOS.md) | Native first-run setup with your own account and any required vendor license |
| Omarchy 4.5.0 for HackberryPi | [Omarchy](Omarchy/README.md) | Username `pi`, password `pi` — both lowercase; use `sudo` for administrator commands |
| Manjaro ARM Xfce for HackberryPi | [Manjaro](Manjaro/README.md) · [Imager](Imager/Manjaro.md) | Username `pi`, password `pi` — both lowercase; use `sudo` for administrator commands |
| Fedora Remix 45 Xfce for HackberryPi | [Fedora](Fedora/README.md) · [Imager](Imager/Fedora.md) | Username `pi`, password `pi` — both lowercase; use `sudo` for administrator commands |

Change the RPiOS, Kali, Omarchy, Manjaro or Fedora Remix default password after first login. Saved application logins, network credentials and personal histories are excluded from the published copies.

## PINN download source

Use a PINN build with CM5 and HackberryPi display support. Add this to the existing single line in `recovery.cmdline`:

```
alt_image_source=https://raw.githubusercontent.com/DZT970525/Operating-System-for-HackberryPi/main/os_list_v3.json
```

The six existing PINN systems appear in **General**. Fedora Remix is provided separately as a standalone Raspberry Pi Imager image; it is not in the PINN feed. The older `Ubuntu/os_list_v3.json` endpoint is also maintained as a combined feed for cards already using it. `repo_list.json` points to the combined catalog.

Packages and checksums are under [Releases](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases). Read each system's installation notes before downloading. PINN packages contain filesystem archives and supplemental application archives. Read each release's notes for standalone image availability; PINN filesystem archives cannot be flashed as a whole disk image. Keep the network connected throughout online installation.

The customized Kali and sanitized Omarchy standalone systems have been boot-tested by the owner. The installed Manjaro configuration and repaired networking have also been tested and accepted by the owner; its factory-image validation status is recorded in the Manjaro release notes. All six PINN packages remain previews until installation and multiboot have been tested through PINN on the device. Ubuntu needs at least 16.5 GiB, Kali at least 20.5 GiB and Omarchy at least **16.25 GiB**, plus PINN and other systems. Fyde OS needs at least 12.2 GiB and supports SD installation only. Its four-partition PINN edition disables native whole-disk OTA and Powerwash; reset or upgrade by reinstalling through PINN. Read the RPiOS notes for its minimum storage allocation of **8.5 GiB** and the Omarchy notes for its Btrfs setup requirements. Manjaro needs at least **8704 MiB**; see its [PINN notes](Manjaro/README.md).

## Raspberry Pi Imager download source

Install one system directly on an SD card with [Raspberry Pi Imager](https://www.raspberrypi.com/software/). The two methods below produce or download a **complete disk image**, including its partition layout.

| System | Download method | Installation notes |
| --- | --- | --- |
| RPiOS — Raspberry Pi OS for HackberryPi | [Imager online catalog](https://raw.githubusercontent.com/DZT970525/Operating-System-for-HackberryPi/main/os_list_imager.json) or [complete `.img.xz`](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/rpios-hackberrypi-2026-11-09/RPiOS-HackberryPi-CM5-20261109.img.xz) | [RPiOS](RPiOS/README.md) |
| Kali Linux 2026.3 for HackberryPi | Automatic download-and-merge tool: [Download helper ZIP](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/kali-displayscale-hackberrypi-2026-11-10/Kali-Imager-Download-Tools-20261110.zip) | [Kali](Imager/Kali.md) |
| FydeOS 23.0 for HackberryPi | [Imager online catalog](https://raw.githubusercontent.com/DZT970525/Operating-System-for-HackberryPi/main/os_list_imager.json) or [complete image](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/fydeos-imager-hackberrypi-2026-11-10/FydeOS-23.0-HackberryPi-CM5-DisplayScale-20261110.img.xz) | [FydeOS](Imager/FydeOS.md) |
| Omarchy 4.5.0 for HackberryPi | Automatic download-and-merge tool ZIP: [Download helper ZIP](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/omarchy-imager-hackberrypi-2026-11-09/Omarchy-Imager-Download-Tools-20261109.zip) | [Omarchy](Imager/Omarchy.md) |
| Manjaro ARM Xfce for HackberryPi | [Imager online catalog](https://raw.githubusercontent.com/DZT970525/Operating-System-for-HackberryPi/main/os_list_imager.json) or [complete `.img.xz`](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/manjaro-displayscale-hackberrypi-2026-11-10/Manjaro-ARM-Xfce-HackberryPi-CM5-DisplayScale-20261110.img.xz) | [Manjaro](Imager/Manjaro.md) |
| Fedora Remix 45 Xfce for HackberryPi | [Imager online catalog](https://raw.githubusercontent.com/DZT970525/Operating-System-for-HackberryPi/main/os_list_imager.json) or [complete `.img.xz`](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/fedora-displayscale-hackberrypi-2026-11-11/Fedora-45-Xfce-HackberryPi-CM5-DisplayScale-20261111.img.xz) | [Fedora](Imager/Fedora.md) |

**The online catalog contains RPiOS, FydeOS, Manjaro and Fedora Remix.** Kali and Omarchy use their download-and-merge helpers followed by **Use custom**; they are not online JSON entries.

### RPiOS, FydeOS, Manjaro and Fedora Remix: online download in Imager

1. Open Raspberry Pi Imager and choose **App Options → Content Repository → Edit**.
2. Select **Use custom URL** and paste:

   ```
   https://raw.githubusercontent.com/DZT970525/Operating-System-for-HackberryPi/main/os_list_imager.json
   ```

3. Choose **Apply & Restart**.
4. Select **HackberryPi CM5**, choose **RPiOS**, **FydeOS**, **Manjaro ARM Xfce** or **Fedora Remix 45 Xfce for HackberryPi**, and select your SD card. Continue writing and verification; Imager downloads the complete image automatically.

Alternatively, download a complete compressed image from the table and select it with **Use custom** in Imager. Read the [FydeOS installation notes](Imager/FydeOS.md) for its first-run setup and Display Scale controls.

### Manjaro: online download or complete image

Choose **Manjaro ARM Xfce for HackberryPi** in the Imager catalog, or [download the complete image](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/manjaro-displayscale-hackberrypi-2026-11-10/Manjaro-ARM-Xfce-HackberryPi-CM5-DisplayScale-20261110.img.xz) and select it with **Use custom**. Use a **16 GB or larger SD card** and let writing and verification finish.

Log in with **pi / pi**. The default workspace is **900 × 900**; the English **Display Scale** desktop app provides **480–1080** scaling on the native **720 × 720** screen. Automatic screensaver, blanking, DPMS, idle dimming and idle suspend are disabled by default on AC and battery; manual locking and login authentication remain available. Read the [Manjaro installation guide](Imager/Manjaro.md) for first-boot package-trust initialization, tested hardware, network setup and upstream software notes.

### Fedora Remix: online download or complete image

Choose **Fedora Remix 45 Xfce for HackberryPi** in the Imager catalog, or [download the complete image](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/fedora-displayscale-hackberrypi-2026-11-11/Fedora-45-Xfce-HackberryPi-CM5-DisplayScale-20261111.img.xz) and select it with **Use custom**. Use a **16 GB or larger SD card** and wait for writing and verification.

Log in with **pi / pi**. The default workspace is **900 × 900** with an English **Display Scale** app for **480–1080** on the native **720 × 720** panel. Touch, MAX17048 battery support, Bluetooth controls and screen-idle defaults are included; SELinux remains enforcing. This is a community **Fedora Remix** with modified Fedora software; unmodified Fedora is available from [the Fedora Project](https://fedoraproject.org/). Read the [installation guide](Imager/Fedora.md), including the final-image validation status and hardware-kernel maintenance notes. Fedora is standalone only in this release.

### Kali: automatic download and merge

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

Log in with **kali / kali**. The default workspace is **900 × 900**; open **Display Scale** on the desktop to choose **480–1080**. Read the [Kali installation notes](Imager/Kali.md).

### Omarchy: automatic download and merge

1. Download and extract **Omarchy-Imager-Download-Tools-20261109.zip** into a computer folder with **about 11 GB of free working space**. The disk must support files larger than 4 GB.
2. Run the launcher for your computer as a normal user; the download helper needs no administrator rights:
   - Windows: double-click `download-omarchy.cmd`.
   - macOS: open `download-omarchy.command`.
   - Linux: run `sh ./download-omarchy.sh` from that extracted folder.
3. Let the helper download **10 parts**, verify their SHA-256 values, and merge them. It verifies the completed compressed image before reporting success. The output appears in the same folder:

   ```
   Omarchy-4.5.0-HackberryPi-CM5-20261109.img.gz
   ```

4. In Raspberry Pi Imager choose **Use custom** and select that **`.img.gz` file directly**. Manual decompression is not needed.
5. Select a **16 GB or larger SD card**, confirm writing and let verification finish. Insert the card in HackberryPi CM5 and boot.

The helper prepares a local image file; SD-card selection and writing take place in Imager. The `hbr_*.tar.gz` and `hbo_*.tar.gz` PINN filesystem archives belong to the PINN method and are not whole-disk images for **Use custom**.

The FydeOS source card with Display Scale was tested and accepted by the owner; the sanitized standalone release image awaits a separate physical flash and first-run test. The rebuilt RPiOS image still awaits a physical boot test. The Omarchy helper reconstructs the same sanitized standalone image that the owner boot-tested. Read each release's current validation status before installing; the PINN installation and multiboot preview limits above remain separate.
