# Buildroot: standalone installation with Raspberry Pi Imager

**Buildroot Openbox for HackberryPi** includes the desktop before first boot. Buildroot 2026.08.1 supplies the ARM64 userspace; the matching Raspberry Pi/Armbian 6.18.44 BSP provides the CM5 kernel and hardware support.

## Online download in Imager

1. Open [Raspberry Pi Imager](https://www.raspberrypi.com/software/) and choose **App Options → Content Repository → Edit**.
2. Select **Use custom URL** and enter:

   ```
   https://raw.githubusercontent.com/DZT970525/Operating-System-for-HackberryPi/main/os_list_imager.json
   ```

3. Choose **Apply & Restart**.
4. Select **HackberryPi CM5 → Buildroot Openbox for HackberryPi**.
5. Select the intended **16 GB or larger SD card** and continue writing and verification. Imager downloads and decompresses the complete image automatically.

Writing replaces the selected card. Keep the image's prepared factory account; Imager OS customization is not supported. Configure Wi-Fi in the running desktop.

## Download first, then Use custom

1. [Download `Buildroot-2026.08.1-Openbox-HackberryPi-CM5-DisplayScale-Neofetch-20261115.img.xz`](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/buildroot-displayscale-hackberrypi-2026-11-15/Buildroot-2026.08.1-Openbox-HackberryPi-CM5-DisplayScale-Neofetch-20261115.img.xz).
2. Choose **Use custom** in Imager and select the `.img.xz` directly. Manual decompression and merging are not needed.
3. Select the intended SD card, confirm writing, and let writing and verification finish before booting.

## First start

Log in as **pi** with password **pi**, both lowercase. The login screen displays **Default Password: pi**. Change the password after first login and use `sudo` for administrator commands.

The compact image starts with a **2 GiB root filesystem**. It does not automatically expand to fill a larger SD card. Additional space can be allocated by expanding the root partition and ext4 filesystem offline on Linux, preserving its start sector and PARTUUID.

Saved Wi-Fi credentials, Bluetooth pairings, private home files, sessions, identities and diagnostic histories are excluded from the public copy; the factory pi account and default 900 workspace are retained.

## Display Scale and desktop controls

The physical panel stays **720 × 720 pixels**. Display Scale changes the software workspace: smaller numbers enlarge text and controls; larger numbers fit more content. Open **Display Scale** at the bottom-right of the desktop, select **480–1080**, and release the slider to apply. **Save as default** retains a setting; **Reset to 900** restores the factory workspace. The desktop launcher and ordinary windows are repositioned to stay reachable when the workspace shrinks.

Use the top-right Wi-Fi control to choose your own network in nmtui. The Bluetooth control opens a terminal with pairing instructions; its interface is not a graphical Bluetooth settings page. Volume opens alsamixer. The desktop right-click menu opens the installed terminal, Dillo browser, Display Scale and Neofetch.

Run `neofetch` in a terminal for genuine Neofetch 7.1.0. The included software is built by Buildroot; this image does not have APT or pacman. Read the [Buildroot system notes](../Buildroot/README.md) before changing or rebuilding packages.

## Artifact and validation

| Artifact | Bytes | SHA-256 |
| --- | --- | --- |
| `Buildroot-2026.08.1-Openbox-HackberryPi-CM5-DisplayScale-Neofetch-20261115.img.xz` | `205496536` | `e76c077407c77cc37bb58f3dea15297e6c24b01eb724bfbed43e987cc807c6b4` |
| Expanded `.img` | `2420113408` | `5d715f536e83fb03702cd7275a2b324950f1a8cd2cac866813a6b4e19e44723b` |

The owner accepted the configured source card for publication. Saved Wi-Fi credentials, Bluetooth pairings, private home files, sessions, identities and diagnostic histories are excluded from the public copy; the factory pi account and default 900 workspace are retained. Fresh FAT/ext4 filesystem checks, preservation of public runtime payloads, factory privacy checks, and complete compressed-to-raw SHA-256 verification passed.

The freshly sanitized and repackaged release image has not received a separate physical flash/first-boot test. Physical screen/touch, USB keyboard, Wi-Fi association and Internet access, Bluetooth pairing, battery readings and audio on that release image remain part of the final-device test.

This release is a standalone complete disk image, not a PINN filesystem package. Read the [system notes](../Buildroot/README.md) for corresponding source material and kernel maintenance.
