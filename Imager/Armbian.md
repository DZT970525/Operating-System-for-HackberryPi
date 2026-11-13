# Armbian: standalone installation with Raspberry Pi Imager

**Armbian Xfce for HackberryPi** uses the official Armbian 26.8.1 Debian 13 Trixie ARM64 base, with Xfce/X11 fully installed and the coherent native Armbian 26.8.3 kernel, device-tree and header bundle (**6.18.44-current-bcm2711**).

## Online download in Imager

1. Open [Raspberry Pi Imager](https://www.raspberrypi.com/software/) and choose **App Options → Content Repository → Edit**.
2. Select **Use custom URL** and enter:

   ```
   https://raw.githubusercontent.com/DZT970525/Operating-System-for-HackberryPi/main/os_list_imager.json
   ```

3. Choose **Apply & Restart**.
4. Select **HackberryPi CM5 → Armbian Xfce for HackberryPi**.
5. Select the intended **16 GB or larger SD card** and continue writing and verification. Imager downloads and decompresses the complete image automatically.

Writing replaces the selected card. Keep the image's factory account and prepared integration; configure Wi-Fi in the running desktop rather than using Imager OS customization.

## Download first, then Use custom

1. [Download `Armbian-26.8.1-Xfce-HackberryPi-CM5-DisplayScale-Neofetch-20261113.img.xz`](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/armbian-displayscale-hackberrypi-2026-11-13/Armbian-26.8.1-Xfce-HackberryPi-CM5-DisplayScale-Neofetch-20261113.img.xz).
2. Choose **Use custom** in Imager and select the `.img.xz` directly. Merging and manual decompression are not needed.
3. Choose your SD card, confirm writing, and let writing and verification finish before booting.

## First start

Log in as **pi** with password **pi**, both lowercase. The login screen displays **Default Password: pi**. Change the password after first login and use `sudo` for administrator commands.

First-start preparation expands the root filesystem and creates fresh machine and SSH identities. The desktop is already installed; it does not need to download Xfce before use. Connect your own Wi-Fi from the top-right panel and pair devices through its Bluetooth control. The same panel includes volume and battery controls. USB 2.0 Host mode supports external peripherals.

Saved private Wi-Fi connections, Bluetooth pairings, account sessions, keyrings and personal histories are excluded from the public copy.

## Display Scale and Neofetch

The physical panel stays **720 × 720 pixels**. Display Scale changes the software workspace: smaller numbers enlarge text and controls; larger numbers fit more content. Double-click **Display Scale** on the desktop, choose **480–1080**, and use **Save as default** to retain a setting. **Reset to 900** restores the factory workspace. No global desktop pinch-to-zoom service is included.

Automatic screen-idle transitions are disabled on AC and battery, with manual locking retained. Run `neofetch` in a terminal for original Neofetch 7.1.0 system information. Debian identification in tools is expected because this Armbian build uses Debian 13.

## Artifact and validation

| Artifact | Bytes | SHA-256 |
| --- | --- | --- |
| `Armbian-26.8.1-Xfce-HackberryPi-CM5-DisplayScale-Neofetch-20261113.img.xz` | `641406348` | `6620fd62e16a4e9b97f59cf786f324b6360f1f637602b9bb35cbae60724a595d` |
| Expanded `.img` | `4601151488` | `5e798c068776fed175e51326fae76714822ba444bdeb14d7390e6072ed10fc07` |

The owner accepted the configured source card for publication. Factory privacy audit: **passed: fresh filesystems, private state excluded and factory account retained**. Native filesystem and offline integration audit: **passed: native filesystem, startup, display and network integration checks**. Complete compressed-to-raw verification: **passed: complete XZ integrity and compressed-to-raw SHA-256 round-trip**. Standalone root expansion: **passed using the shipped helper in an isolated two-partition loop test; physical first boot remains pending**.

The rebuilt sanitized release image has not received a separate physical flash/first-boot test. Actual Wi-Fi association, Bluetooth pairing, audio playback, screen/touch behavior and AC/battery idle/manual-lock behavior require that final-image device test.

Read the [Armbian system notes](../Armbian/README.md) for sources and kernel maintenance. This release is a standalone image; it is not a PINN filesystem package.
