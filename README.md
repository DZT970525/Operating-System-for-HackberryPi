# Operating Systems for HackberryPi

Customized ARM64 systems for **HackberryPi CM5**, with separate download sources for **PINN** and **Raspberry Pi Imager**.

| System | Documentation | Default login |
| --- | --- | --- |
| RPiOS — Raspberry Pi OS for HackberryPi | [RPiOS](RPiOS/README.md) | Username `pi`, password `pi` — both lowercase; use `sudo` for administrator commands |
| Ubuntu 24.04.5 for HackberryPi | [Ubuntu](Ubuntu/README.md) | Create an account using native first-boot setup |
| Kali Linux 2026.3 for HackberryPi | [Kali](Kali/README.md) | Username `kali`, password `kali` — both lowercase; use `sudo` for administrator commands |
| Fyde OS for HackBerry Pi (FydeOS 23.0) | [PINN](FydeOS/README.md) · [Imager](Imager/FydeOS.md) | Native first-run setup with your own account and any required vendor license |
| Omarchy 4.5.0 for HackberryPi | [Omarchy](Omarchy/README.md) | Username `pi`, password `pi` — both lowercase; use `sudo` for administrator commands |

Change the RPiOS, Kali or Omarchy default password after first login. Saved application logins, network credentials and personal histories are excluded from the published copies.

## PINN download source

Use a PINN build with CM5 and HackberryPi display support. Add this to the existing single line in `recovery.cmdline`:

```
alt_image_source=https://raw.githubusercontent.com/DZT970525/Operating-System-for-HackberryPi/main/os_list_v3.json
```

All five systems appear in **General**. The older `Ubuntu/os_list_v3.json` endpoint is also maintained as a combined feed for cards already using it. `repo_list.json` points to the combined catalog.

Packages and checksums are under [Releases](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases). Read each system's installation notes before downloading. PINN packages contain filesystem archives and supplemental application archives. Read each release's notes for standalone image availability; PINN filesystem archives cannot be flashed as a whole disk image. Keep the network connected throughout online installation.

The customized Kali and sanitized Omarchy standalone systems have been boot-tested by the owner. All five PINN packages remain previews until installation and multiboot have been tested through PINN on the device. Ubuntu needs at least 16.5 GiB, Kali at least 20.5 GiB and Omarchy at least **16.25 GiB**, plus PINN and other systems. Fyde OS needs at least 12.2 GiB and supports SD installation only. Its four-partition PINN edition disables native whole-disk OTA and Powerwash; reset or upgrade by reinstalling through PINN. Read the RPiOS notes for its minimum storage allocation of **8.5 GiB** and the Omarchy notes for its Btrfs setup requirements.

## Raspberry Pi Imager download source

Install one system directly on an SD card with [Raspberry Pi Imager](https://www.raspberrypi.com/software/). The two methods below produce or download a **complete disk image**, including its partition layout.

| System | Download method | Installation notes |
| --- | --- | --- |
| RPiOS — Raspberry Pi OS for HackberryPi | [Imager online catalog](https://raw.githubusercontent.com/DZT970525/Operating-System-for-HackberryPi/main/os_list_imager.json) or [complete `.img.xz`](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/rpios-hackberrypi-2026-11-09/RPiOS-HackberryPi-CM5-20261109.img.xz) | [RPiOS](RPiOS/README.md) |
| FydeOS 23.0 for HackberryPi | [Imager online catalog](https://raw.githubusercontent.com/DZT970525/Operating-System-for-HackberryPi/main/os_list_imager.json) or [complete image](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/fydeos-imager-hackberrypi-2026-11-10/FydeOS-23.0-HackberryPi-CM5-DisplayScale-20261110.img.xz) | [FydeOS](Imager/FydeOS.md) |
| Omarchy 4.5.0 for HackberryPi | Automatic download-and-merge tool ZIP: [Download helper ZIP](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/omarchy-imager-hackberrypi-2026-11-09/Omarchy-Imager-Download-Tools-20261109.zip) | [Omarchy](Imager/Omarchy.md) |

**The online catalog contains RPiOS and FydeOS.** Omarchy uses the download-and-merge helper followed by **Use custom**; it is not an online JSON entry.

### RPiOS and FydeOS: online download in Imager

1. Open Raspberry Pi Imager and choose **App Options → Content Repository → Edit**.
2. Select **Use custom URL** and paste:

   ```
   https://raw.githubusercontent.com/DZT970525/Operating-System-for-HackberryPi/main/os_list_imager.json
   ```

3. Choose **Apply & Restart**.
4. Select **HackberryPi CM5**, choose **RPiOS** or **FydeOS**, and select your SD card. Continue writing and verification; Imager downloads the complete image automatically.

Alternatively, download a complete compressed image from the table and select it with **Use custom** in Imager. Read the [FydeOS installation notes](Imager/FydeOS.md) for its first-run setup and Display Scale controls.

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

