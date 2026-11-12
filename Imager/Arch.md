# Arch Linux ARM: standalone installation with Raspberry Pi Imager

**Arch Linux ARM Xfce for HackberryPi**, with the native 720 × 720 CM5 display, touchscreen, MAX17048 battery integration, English Display Scale app and original Neofetch 7.1.0.

## Online download in Imager

1. Open [Raspberry Pi Imager](https://www.raspberrypi.com/software/) and choose **App Options → Content Repository → Edit**.
2. Select **Use custom URL** and enter:

   ```
   https://raw.githubusercontent.com/DZT970525/Operating-System-for-HackberryPi/main/os_list_imager.json
   ```

3. Choose **Apply & Restart**.
4. Select **HackberryPi CM5**, then **Arch Linux ARM Xfce for HackberryPi**.
5. Select the intended **16 GB or larger SD card**. Continue writing and verification; Imager downloads and decompresses the complete image automatically.

Writing erases the selected card. Insert the finished card in HackberryPi CM5 and boot. This catalog uses the image's existing account and defaults; configure Wi-Fi and other personal settings in the running system.

## Download first, then Use custom

1. [Download `ArchLinux-ARM-Xfce-HackberryPi-CM5-DisplayScale-Neofetch-20261112.img.xz`](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/archlinux-displayscale-hackberrypi-2026-11-12/ArchLinux-ARM-Xfce-HackberryPi-CM5-DisplayScale-Neofetch-20261112.img.xz).
2. In Imager select **Use custom** and choose the `.img.xz` file directly. Manual decompression and merging are not needed.
3. Select your SD card, confirm writing and let verification finish.

## First start

Log in with **pi / pi**, both lowercase. The login page shows **Default Password: pi**. Use `sudo` for administrator commands and change the factory password. Connect your own Wi-Fi and Bluetooth devices.

Machine identity and SSH host keys are fresh for each installation. First-start preparation initializes the package trust database; allow it to finish before running package updates. Standalone root expansion: **passed in a disposable two-partition loop test, including identity refusal, online ext4 growth and deferred-refresh resume; physical first boot remains untested**.

## Display Scale and Neofetch

The default workspace is **900 × 900**. Double-click **Display Scale** on the desktop, drag the slider and release to apply. **Save as default** remembers a selection; **Reset to 900** restores the default.

The physical panel remains **720 × 720 pixels**. Smaller workspace values enlarge text and controls; larger values fit more content. The range **480–1080** controls software scaling. No desktop pinch-to-zoom service is installed.

Automatic screensaver, blanking, DPMS, idle dimming and idle suspend are disabled on AC and battery. Manual screen locking and password authentication remain available.

Open a terminal and run:

```sh
neofetch
```

The installed `neofetch` package is genuine upstream Neofetch 7.1.0.

## Artifact and validation

| Artifact | Bytes | SHA-256 |
| --- | --- | --- |
| `ArchLinux-ARM-Xfce-HackberryPi-CM5-DisplayScale-Neofetch-20261112.img.xz` | `1156947144` | `89f459f4b0f68db1f0530a20bf660888435252a1ad5fa27cf51247760ed0ea21` |
| Expanded `.img` | `5421137920` | `ede076ba6997c538ea23b6a118dc51588d9d6e90e2eeacd54c55ea99db120506` |

Release: [archlinux-displayscale-hackberrypi-2026-11-12](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/tag/archlinux-displayscale-hackberrypi-2026-11-12). `SHA256SUMS`, `factory-status.json` and the local verification report `image-verification.json` accompany the image.

The owner accepted the configured source card for publication; physical boot of that source was not independently confirmed during preparation. Factory privacy audit: **passed: fresh filesystems, private state excluded before capture, factory account and residual audit verified**. Complete compressed/expanded verification: **passed: native filesystem/offline checks and complete compressed-to-raw SHA-256 round-trip**. Standalone growth checks: **passed in a disposable two-partition loop test, including identity refusal, online ext4 growth and deferred-refresh resume; physical first boot remains untested**.

The final sanitized image has **not** received a separate physical flash/first-boot test. Separate physical AC/battery idle-display and manual-lock testing also remains pending. Offline and loop checks do not replace those tests.

Read the [Arch Linux ARM system notes](../Arch/README.md) for kernel maintenance and sources. Arch is standalone only in this release; it is not added to the PINN catalog.
