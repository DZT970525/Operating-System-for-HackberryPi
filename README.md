# Operating Systems for HackberryPi

Customized ARM64 systems for **HackberryPi CM5**, with separate download sources for **PINN** and **Raspberry Pi Imager**.

| System | Documentation | Default login |
| --- | --- | --- |
| Twister OS 3.1.0 Xfce for HackberryPi | [Twister OS](TwisterOS/README.md) · [Imager](Imager/TwisterOS.md) | Username `pi`, password `pi` — both lowercase; use `sudo` for administrator commands |
| LineageOS 24.0 / Android 17 for HackberryPi | [LineageOS](LineageOS/README.md) · [Imager](Imager/LineageOS.md) | Android first-run setup; choose your own optional screen lock |
| RPiOS — Raspberry Pi OS for HackberryPi | [RPiOS](RPiOS/README.md) | Username `pi`, password `pi` — both lowercase; use `sudo` for administrator commands |
| Ubuntu 24.04.5 LTS GNOME for HackberryPi | [Ubuntu](Ubuntu/README.md) · [Imager](Imager/Ubuntu.md) | Username `pi`, password `pi` — both lowercase; use `sudo` for administrator commands |
| Kali Linux 2026.3 for HackberryPi | [PINN](Kali/README.md) · [Imager](Imager/Kali.md) | Username `kali`, password `kali` — both lowercase; use `sudo` for administrator commands |
| Fyde OS for HackBerry Pi (FydeOS 23.0) | [PINN](FydeOS/README.md) · [Imager](Imager/FydeOS.md) | Native first-run setup with your own account and any required vendor license |
| Omarchy 4.5.0 for HackberryPi | [Omarchy](Omarchy/README.md) | Username `pi`, password `pi` — both lowercase; use `sudo` for administrator commands |
| Manjaro ARM Xfce for HackberryPi | [Manjaro](Manjaro/README.md) · [Imager](Imager/Manjaro.md) | Username `pi`, password `pi` — both lowercase; use `sudo` for administrator commands |
| Fedora Remix 45 Xfce for HackberryPi | [Fedora](Fedora/README.md) · [Imager](Imager/Fedora.md) | Username `pi`, password `pi` — both lowercase; use `sudo` for administrator commands |
| Arch Linux ARM Xfce for HackberryPi | [Arch](Arch/README.md) · [Imager](Imager/Arch.md) | Username `pi`, password `pi` — both lowercase; use `sudo` for administrator commands |
| DietPi Xfce for HackberryPi | [DietPi](DietPi/README.md) · [Imager](Imager/DietPi.md) | Username `pi`, password `pi` — both lowercase; use `sudo` for administrator commands |
| Buildroot Openbox for HackberryPi | [Buildroot](Buildroot/README.md) · [Imager](Imager/Buildroot.md) | Username `pi`, password `pi` — both lowercase; use `sudo` for administrator commands |

Change the Twister OS, RPiOS, Ubuntu, Kali, Omarchy, Manjaro, Fedora Remix, Arch Linux ARM, DietPi or Buildroot default password after first login. Saved application logins, network credentials and personal histories are excluded from the published copies.

## PINN download source

The [HackberryPi CM5 PINN multiboot preview](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/tag/pinn-multiboot-hackberrypi-2026-11-16) provides these **12 systems** in **General**: **RPiOS, Ubuntu, Kali, FydeOS, Omarchy, Manjaro, Fedora Remix, Arch Linux ARM, DietPi, Buildroot, LineageOS and Twister OS**. Select the systems that fit your card, install them together, then choose an installed system from PINN's boot menu. The prepared HackberryPi PINN card includes this catalog and the CM5 display, touch, battery and USB Host support.

Download the [fresh 2026-11-21 v2 PINN installer](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/pinn-multiboot-hackberrypi-2026-11-16/HackberryPi-PINN-12OS-CM5-20261121-v2.img.xz), or select **PINN Multiboot Installer for HackberryPi** in the [Imager online catalog](https://raw.githubusercontent.com/DZT970525/Operating-System-for-HackberryPi/main/os_list_imager.json). For a downloaded file, use Imager **Use custom** and select the `.img.xz` directly. This image contains **only PINN, with no systems installed and no saved private data**. Connect Wi-Fi, select the systems that fit and choose **Install**. Read the [PINN installation notes](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/pinn-multiboot-hackberrypi-2026-11-16/PINN-Installation-20261121-v2.txt), the [Imager guide](Imager/PINN.md) and `PINN-RUNTIME-SHA256SUMS-20261121-v2`. The refresh adds the offline Add OS gate and Omarchy installer tool while retaining the native gray **Recovery Mode** button, hover/pressed feedback, RPiOS startup icon and system-management features. The existing twelve-system catalog and OS payloads remain unchanged. Older dated assets remain archived; choose **20261121-v2** for a new card.

The **20261121-v2 update** makes **Add OS gray until the network is ready**, automatically updates it after connection changes, and includes the **base64** tool required by Omarchy's embedded installation script. It retains the earlier fresh-card **Install** fix. **Install still requires a network connection** for the cached online catalog. Use **20261121-v2** for new cards or apply the file-only update below.

For an existing prepared **HackberryPi CM5 PINN 20261118, 20261120 or 20261121** card, use the [file-only runtime update ZIP](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/pinn-multiboot-hackberrypi-2026-11-16/HackberryPi-PINN-Runtime-Update-20261121-v2.zip) and its **`UPGRADE.txt`**. Back up the card, shut it down and replace **only `pinn.rfs` in the RECOVERY partition's root**. Preserve SETTINGS, all installed systems, the partition layout and every other file. **Do not flash the empty installer image to upgrade an existing card:** image writing replaces its systems and data.

If an earlier Omarchy attempt failed with **`base64: command not found`**, update PINN before retrying Omarchy. The runtime ZIP does not finish incomplete systems, restore their payloads, change installed-OS metadata or reclaim partitions. Use **Add OS** when suitable free space is available to preserve existing systems. If failed space remains allocated but is not listed for system management, keep the card and obtain layout-specific recovery.

Select **Recovery Mode** in the startup menu to manage PINN. **Add OS** installs one new online choice at a time into supported free space at the end of the card; follow the explicit **Restart PINN / Resume Add OS** prompts. **Delete OS** removes the confirmed selected system and requires a restart. Remaining systems are not resized. Use **Add OS** to preserve existing installations; the ordinary **Install** action repartitions. See the guide for supported layouts and validation limits.

**Add OS is gray while the network is not ready** and automatically recovers after connection or reconnection. A pending installation remains manageable offline through **Manage Add OS**: **Cancel Add** is available, while continuing installation requires the network.

This catalog requires the prepared HackberryPi PINN edition, including its bundled installer tools and CM5 hardware support. The prepared installer already uses the [current combined root catalog](https://raw.githubusercontent.com/DZT970525/Operating-System-for-HackberryPi/main/os_list_v3.json); keep its catalog selectors when applying the runtime ZIP. Older per-system preview catalogs are not the current combined feed. If an older cached recipe needs refreshing, follow the separate [RPiOS catalog instructions](RPiOS/README.md#pinn-multiboot).

The current [PINN release](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/tag/pinn-multiboot-hackberrypi-2026-11-16) contains the native installation metadata, per-system payloads, checksums, adapter sources and validation report. Raspberry Pi Imager's complete disk images remain a separate installation method below.

**Keep the network connected throughout installation.** Eleven entries require extra verified payloads during **Install**; PINN's **Download** button alone does not create a complete offline installer for them. The prepared PINN interface explains this and enables online installation after a network connection is ready. Manjaro's complete native archives can also be downloaded for offline use.

The catalog lists all 12 choices even when the card cannot hold all of them. A **32 GB card can hold only a suitable subset**; PINN checks the selected systems' combined allocation before installation. Kali needs at least **20.5 GiB**, Omarchy **16.25 GiB**, RPiOS **8.5 GiB** and Manjaro **8.5 GiB**, plus PINN and any other selected systems. Other allocations are recorded in each entry's partition metadata. This edition supports **Compute Module 5 and SD-card installation**.

These remain **PINN multiboot previews**. The 20261121-v2 Add OS gate passed **9 ARM32 Qt4 tests / 109 checks**, and its base64 tool passed **62 ARM32 BusyBox checks**, including exact Omarchy-script decoding and runtime dependencies. The retained fresh-card helper fix previously passed 33 ARM32 tests. **A separate physical v2 fresh-flash and complete Omarchy reinstallation test remains pending.** Earlier owner sessions accepted Recovery Mode and the RPiOS startup icon, completed RPiOS Add while retaining three prior systems, completed RPiOS and Arch installation, and checked DietPi's repaired post-install stage. See the dated verification report for artifact checks. All twelve fresh installs, every combination and every Add/Delete layout are not claimed as physically tested. LineageOS/FydeOS keep native whole-disk reset/update paths disabled; reinstall or update those adapted editions through PINN. FydeOS retains the accepted Display Scale 1.2 integration; each adapter preserves its source system's hardware support and customization.

## Raspberry Pi Imager download source

Install one system directly on an SD card with [Raspberry Pi Imager](https://www.raspberrypi.com/software/). The two methods below produce or download a **complete disk image**, including its partition layout.

| System | Download method | Installation notes |
| --- | --- | --- |
| PINN Multiboot Installer for HackberryPi | [Imager online catalog](https://raw.githubusercontent.com/DZT970525/Operating-System-for-HackberryPi/main/os_list_imager.json) or [fresh installer image](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/pinn-multiboot-hackberrypi-2026-11-16/HackberryPi-PINN-12OS-CM5-20261121-v2.img.xz) | [PINN](Imager/PINN.md) — no OS preinstalled |
| Twister OS 3.1.0 Xfce for HackberryPi | Automatic download-and-merge tool: [Download helper ZIP](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/twisteros-displayscale-hackberrypi-2026-11-16/TwisterOS-Imager-Download-Tools-20261116.zip) | [Twister OS](Imager/TwisterOS.md) |
| LineageOS 24.0 / Android 17 for HackberryPi | [Imager online catalog](https://raw.githubusercontent.com/DZT970525/Operating-System-for-HackberryPi/main/os_list_imager.json) or [complete `.img.xz`](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/lineageos-displayscale-hackberrypi-2026-11-16/LineageOS-24.0-Android17-HackberryPi-CM5-DisplayScale-Neofetch-20261116.img.xz) | [LineageOS](Imager/LineageOS.md) |
| RPiOS — Raspberry Pi OS for HackberryPi | [Imager online catalog](https://raw.githubusercontent.com/DZT970525/Operating-System-for-HackberryPi/main/os_list_imager.json) or [complete `.img.xz`](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/rpios-clash-power-hackberrypi-2026-11-17/RPiOS-HackberryPi-CM5-20261117-v2.img.xz) | [RPiOS](RPiOS/README.md) |
| Ubuntu 24.04.5 LTS GNOME for HackberryPi | Automatic download-and-merge tool: [Download helper ZIP](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/ubuntu-firefox-hackberrypi-2026-11-22/Ubuntu-Imager-Download-Tools-20261122.zip) | [Ubuntu](Imager/Ubuntu.md) |
| Kali Linux 2026.3 for HackberryPi | Automatic download-and-merge tool: [Download helper ZIP](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/kali-displayscale-hackberrypi-2026-11-10/Kali-Imager-Download-Tools-20261110.zip) | [Kali](Imager/Kali.md) |
| FydeOS 23.0 for HackberryPi | [Imager online catalog](https://raw.githubusercontent.com/DZT970525/Operating-System-for-HackberryPi/main/os_list_imager.json) or [complete image](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/fydeos-imager-hackberrypi-2026-11-10/FydeOS-23.0-HackberryPi-CM5-DisplayScale-20261110.img.xz) | [FydeOS](Imager/FydeOS.md) |
| Omarchy 4.5.0 for HackberryPi | Automatic download-and-merge tool ZIP: [Download helper ZIP](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/omarchy-imager-hackberrypi-2026-11-09/Omarchy-Imager-Download-Tools-20261109.zip) | [Omarchy](Imager/Omarchy.md) |
| Manjaro ARM Xfce for HackberryPi | [Imager online catalog](https://raw.githubusercontent.com/DZT970525/Operating-System-for-HackberryPi/main/os_list_imager.json) or [complete `.img.xz`](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/manjaro-displayscale-hackberrypi-2026-11-10/Manjaro-ARM-Xfce-HackberryPi-CM5-DisplayScale-20261110.img.xz) | [Manjaro](Imager/Manjaro.md) |
| Fedora Remix 45 Xfce for HackberryPi | [Imager online catalog](https://raw.githubusercontent.com/DZT970525/Operating-System-for-HackberryPi/main/os_list_imager.json) or [complete `.img.xz`](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/fedora-displayscale-hackberrypi-2026-11-11/Fedora-45-Xfce-HackberryPi-CM5-DisplayScale-20261111.img.xz) | [Fedora](Imager/Fedora.md) |
| Arch Linux ARM Xfce for HackberryPi | [Imager online catalog](https://raw.githubusercontent.com/DZT970525/Operating-System-for-HackberryPi/main/os_list_imager.json) or [complete `.img.xz`](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/archlinux-displayscale-hackberrypi-2026-11-12/ArchLinux-ARM-Xfce-HackberryPi-CM5-DisplayScale-Neofetch-20261112.img.xz) | [Arch](Imager/Arch.md) |
| DietPi Xfce for HackberryPi | [Imager online catalog](https://raw.githubusercontent.com/DZT970525/Operating-System-for-HackberryPi/main/os_list_imager.json) or [complete `.img.xz`](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/dietpi-displayscale-hackberrypi-2026-11-13/DietPi-Trixie-Xfce-HackberryPi-CM5-DisplayScale-Neofetch-20261113.img.xz) | [DietPi](Imager/DietPi.md) |
| Buildroot Openbox for HackberryPi | [Imager online catalog](https://raw.githubusercontent.com/DZT970525/Operating-System-for-HackberryPi/main/os_list_imager.json) or [complete `.img.xz`](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/buildroot-displayscale-hackberrypi-2026-11-15/Buildroot-2026.08.1-Openbox-HackberryPi-CM5-DisplayScale-Neofetch-20261115.img.xz) | [Buildroot](Imager/Buildroot.md) |

**The online catalog contains the fresh PINN installer plus LineageOS, RPiOS, FydeOS, Manjaro, Fedora Remix, Arch Linux ARM, DietPi and Buildroot standalone images.** Twister OS, Ubuntu, Kali and Omarchy use their download-and-merge helpers followed by **Use custom**; they are not online JSON entries.

### Twister OS: automatic download and merge

Use the [automatic download-and-merge helper ZIP](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/twisteros-displayscale-hackberrypi-2026-11-16/TwisterOS-Imager-Download-Tools-20261116.zip) to download **16 parts**, verify them and create the complete **`TwisterOS-3.1.0-Xfce-HackberryPi-CM5-DisplayScale-Neofetch-20261116.img.xz`**. Then select that file through **Use custom** in Raspberry Pi Imager. Windows, macOS and Linux launchers are included; interrupted downloads can resume. Manual decompression and manual merge commands are not needed.

Log in with **pi / pi**. The default workspace is **900 × 900**, with the English **Display Scale (480–1080)** app on the native **720 × 720** panel. Screen/touch, USB Host, MAX17048 battery, Neofetch and native Wi-Fi/Bluetooth/volume controls are included. All 15 theme choices now set the DPI screen's matching wallpaper. Read the [installation guide](Imager/TwisterOS.md). This is the standalone Imager release; a separate PINN multiboot adapter is linked above.

### LineageOS: online download or complete image

Choose **LineageOS 24.0 / Android 17 for HackberryPi** in the Imager catalog, or [download the complete image](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/lineageos-displayscale-hackberrypi-2026-11-16/LineageOS-24.0-Android17-HackberryPi-CM5-DisplayScale-Neofetch-20261116.img.xz) and select it with **Use custom**. Use an **8 GB or larger SD card** and wait for writing and verification; no manual decompression or merge is needed.

Complete Android’s own setup wizard; no Linux `pi / pi` login is configured. The default logical workspace is **900 × 900**, with the English **Display Scale (480–1080)** app on the native **720 × 720** panel. Screen/touch, USB 2.0 Host, MAX17048 battery capacity, top Quick Settings Wi-Fi/Bluetooth/Volume, official Firefox and genuine Neofetch in Termux are included. The configured source was owner-tested; the sanitized factory image awaits a separate physical first-run test. This is an **unofficial noncommercial** adaptation of [KonstaKANG’s LineageOS build](https://konstakang.com/devices/rpi5/LineageOS24/), with component-specific licenses and matching sources retained. Read the [installation guide](Imager/LineageOS.md) for first-start preparation, compact storage, browser updates and validation. This is the standalone Imager release; a separate PINN multiboot adapter is linked above.

### RPiOS: updated kernel, battery, power menu and Clash Verge

The [2026-11-17 v2 RPiOS image](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/rpios-clash-power-hackberrypi-2026-11-17/RPiOS-HackberryPi-CM5-20261117-v2.img.xz) includes the updated **6.12.115 kernel**, **labwc desktop**, **900 × 900** workspace, MAX17048 DKMS battery package and signed driver source. The owner confirmed battery percentage after a kernel update and the physical CM5 power-key menu. Clash Verge remains in the application menu with no desktop shortcut or private profiles. The sanitized release has separate filesystem/compression/native-package checks; read the [RPiOS guide](RPiOS/README.md) for installation and validation status.

### LineageOS, RPiOS, FydeOS, Manjaro, Fedora Remix, Arch Linux ARM, DietPi and Buildroot: online download in Imager

1. Open Raspberry Pi Imager and choose **App Options → Content Repository → Edit**.
2. Select **Use custom URL** and paste:

   ```
   https://raw.githubusercontent.com/DZT970525/Operating-System-for-HackberryPi/main/os_list_imager.json
   ```

3. Choose **Apply & Restart**.
4. Select **HackberryPi CM5**, choose **LineageOS**, **RPiOS**, **FydeOS**, **Manjaro ARM Xfce**, **Fedora Remix 45 Xfce for HackberryPi**, **Arch Linux ARM Xfce for HackberryPi**, **DietPi Xfce for HackberryPi** or **Buildroot Openbox for HackberryPi**, and select your SD card. Continue writing and verification; Imager downloads the complete image automatically.

Alternatively, download a complete compressed image from the table and select it with **Use custom** in Imager. Read the [FydeOS installation notes](Imager/FydeOS.md) for its first-run setup and Display Scale controls.

### Ubuntu: automatic download and merge

Use the [download helper ZIP](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/ubuntu-firefox-hackberrypi-2026-11-22/Ubuntu-Imager-Download-Tools-20261122.zip) to fetch and automatically merge **7 parts**, then choose the completed **`Ubuntu-24.04.5-GNOME-HackberryPi-CM5-DisplayScale-Neofetch-20261122.img.xz`** through **Use custom** in Raspberry Pi Imager. Windows, macOS and Linux launchers are included; interrupted downloads can resume. Use a computer folder with **at least 7 GB free** and a **16 GB or larger SD card**. Read the [step-by-step guide](Imager/Ubuntu.md).

Log in with **pi / pi**. Native GNOME 46 Wayland, default **900 × 900** workspace, English **Display Scale (480–1080)**, the native **720 × 720** panel/touch, MAX17048 battery, USB 2.0 Host and Neofetch 7.1.0 are retained. The existing top-right menu includes **Wi-Fi Settings** and **Bluetooth Settings**. Automatic idle screen transitions are disabled; manual locking remains available. The 2026-11-22 refresh fixes Firefox startup while keeping the native Ubuntu packages and hardware integration. The owner confirmed Firefox on the repaired PINN card. Ubuntu is available through the combined PINN catalog and this standalone download helper; the newly rebuilt clean image still awaits a separate physical first-boot test.

### Manjaro: online download or complete image

Choose **Manjaro ARM Xfce for HackberryPi** in the Imager catalog, or [download the complete image](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/manjaro-displayscale-hackberrypi-2026-11-10/Manjaro-ARM-Xfce-HackberryPi-CM5-DisplayScale-20261110.img.xz) and select it with **Use custom**. Use a **16 GB or larger SD card** and let writing and verification finish.

Log in with **pi / pi**. The default workspace is **900 × 900**; the English **Display Scale** desktop app provides **480–1080** scaling on the native **720 × 720** screen. Automatic screensaver, blanking, DPMS, idle dimming and idle suspend are disabled by default on AC and battery; manual locking and login authentication remain available. Read the [Manjaro installation guide](Imager/Manjaro.md) for first-boot package-trust initialization, tested hardware, network setup and upstream software notes.

### Fedora Remix: online download or complete image

Choose **Fedora Remix 45 Xfce for HackberryPi** in the Imager catalog, or [download the complete image](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/fedora-displayscale-hackberrypi-2026-11-11/Fedora-45-Xfce-HackberryPi-CM5-DisplayScale-20261111.img.xz) and select it with **Use custom**. Use a **16 GB or larger SD card** and wait for writing and verification.

Log in with **pi / pi**. The default workspace is **900 × 900** with an English **Display Scale** app for **480–1080** on the native **720 × 720** panel. Touch, MAX17048 battery support, Bluetooth controls and screen-idle defaults are included; SELinux remains enforcing. This is a community **Fedora Remix** with modified Fedora software; unmodified Fedora is available from [the Fedora Project](https://fedoraproject.org/). Read the [installation guide](Imager/Fedora.md), including the final-image validation status and hardware-kernel maintenance notes. A separate Fedora PINN multiboot adapter is linked above.

### Arch Linux ARM: online download or complete image

Choose **Arch Linux ARM Xfce for HackberryPi** in the Imager catalog, or [download the complete image](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/archlinux-displayscale-hackberrypi-2026-11-12/ArchLinux-ARM-Xfce-HackberryPi-CM5-DisplayScale-Neofetch-20261112.img.xz) and select it with **Use custom**. Use a **16 GB or larger SD card** and wait for writing and verification; no manual merge or decompression is needed.

Log in with **pi / pi**. The default workspace is **900 × 900** with the English **Display Scale** desktop app for **480–1080** on the native **720 × 720** panel. Screen/touch, MAX17048 battery support, Wi-Fi/Bluetooth controls and original **Neofetch 7.1.0** are included. Automatic idle display transitions are disabled; manual locking remains available. This is the Arch Linux ARM community distribution with native CM5 integration. The configured source was accepted for publication; its physical boot was not independently confirmed during preparation. Read the [installation guide](Imager/Arch.md), including first-start preparation and the final-image validation status. A separate Arch PINN multiboot adapter is linked above; the final sanitized standalone image awaits separate physical first-boot testing.

### DietPi: online download or complete image

Choose **DietPi Xfce for HackberryPi** in the Imager catalog, or [download the complete image](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/dietpi-displayscale-hackberrypi-2026-11-13/DietPi-Trixie-Xfce-HackberryPi-CM5-DisplayScale-Neofetch-20261113.img.xz) and select it with **Use custom**. Use a **16 GB or larger SD card** and wait for writing and verification; manual decompression and merging are not needed.

Log in with **pi / pi**. DietPi v10.8.2 / Debian 13 Trixie comes with **Xfce/X11 preinstalled**, default **900 × 900** workspace, English **Display Scale (480–1080)**, native **720 × 720** display/touch, USB 2.0 Host, MAX17048 battery and genuine Neofetch 7.1.0. The top-right panel provides Wi-Fi, Bluetooth and volume controls. Automatic idle display transitions are disabled; manual locking remains available. Read the [installation guide](Imager/DietPi.md), including privacy and final-image validation status. A separate DietPi PINN multiboot adapter is linked above.

### Buildroot: online download or complete image

Choose **Buildroot Openbox for HackberryPi** in the Imager catalog, or [download the complete image](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/buildroot-displayscale-hackberrypi-2026-11-15/Buildroot-2026.08.1-Openbox-HackberryPi-CM5-DisplayScale-Neofetch-20261115.img.xz) and select it with **Use custom**. Use a **16 GB or larger SD card** and wait for writing and verification; manual decompression and merging are not needed.

Log in with **pi / pi**. The preinstalled Openbox/X11 desktop provides a default **900 × 900** workspace, English **Display Scale (480–1080)** launcher at the desktop's bottom-right, screen/touch, MAX17048 battery, USB 2.0 Host and genuine Neofetch 7.1.0. The top-right shell offers Wi-Fi, Bluetooth and sound entry points. This is Buildroot 2026.08.1 userspace with the matching Raspberry Pi/Armbian 6.18.44 BSP; it has no distribution package manager. The owner accepted the configured source; the repackaged sanitized image awaits separate physical first-boot testing. Read the [installation guide](Imager/Buildroot.md), including validation and maintenance notes. A separate Buildroot PINN multiboot adapter is linked above.

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

The FydeOS source card with Display Scale was tested and accepted by the owner; the sanitized standalone release image awaits a separate physical flash and first-run test. The configured RPiOS source card was owner-tested after its kernel update and power-menu fix; the sanitized v2 image awaits a separate fresh-flash test. The Omarchy helper reconstructs the same sanitized standalone image that the owner boot-tested. Read each release's current validation status before installing; the PINN installation and multiboot preview limits above remain separate.



