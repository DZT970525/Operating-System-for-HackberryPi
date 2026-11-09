# Omarchy: standalone installation with Raspberry Pi Imager

Use **Omarchy-Imager-Download-Tools-20261109.zip** to download and assemble the complete standalone image. Download the tool ZIP:

[Download helper ZIP](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/omarchy-imager-hackberrypi-2026-11-09/Omarchy-Imager-Download-Tools-20261109.zip)

The helper runs without administrator rights on Windows, macOS and Linux. Extract it to a normal computer folder with **about 11 GB free** for the first download and merge. The disk must support files larger than 4 GB. Use a **16 GB or larger SD card** for the resulting system.

1. Run the launcher in the extracted folder:
   - Windows: double-click `download-omarchy.cmd`.
   - macOS: open `download-omarchy.command`.
   - Linux: run `sh ./download-omarchy.sh` in that folder.
2. Wait for the download, per-part SHA-256 checks, merge and whole-compressed-image check to finish. The helper downloads **10 parts** and creates:

   ```
   Omarchy-4.5.0-HackberryPi-CM5-20261109.img.gz
   ```

3. Open [Raspberry Pi Imager](https://www.raspberrypi.com/software/), choose **Use custom**, and select the completed **`.img.gz` file directly**. You do not need to decompress it manually.
4. Select the intended SD card, confirm writing and let verification finish. Insert the card in HackberryPi CM5 and boot.
5. Log in with **pi / pi** and configure your own network, Agent accounts and subscriptions.

This is a complete standalone disk image. It is supplied through the helper, rather than as an Imager online JSON entry. The published `os_list_imager.json` catalog contains RPiOS and FydeOS. The helper writes the completed image file to the computer; Imager performs the SD-card write.

The compressed image is **4,935,054,616 bytes** and expands to **11,005,853,696 bytes**. The 10 parts consist of nine 500 MiB parts and a final 216,462,616-byte part. They reconstruct the exact sanitized standalone artifact that the owner successfully boot-tested; this download format does not change its system contents.

| Artifact | SHA-256 |
| --- | --- |
| Complete `.img.gz` | `e29204760a12f335c541c0dce4284519a68c434d1d659e0af895f2b8a8ab6c93` |
| Extracted `.img` | `d2c8c5b45b4cb16ae9d246cfda26f0ae1c569395f3448932f2bb96aecf3c12d2` |

The [PINN package](../Omarchy/README.md) remains available separately, with its existing Btrfs requirements and pending physical PINN/multiboot tests.

Helper preview: small offline POSIX tests passed. The Windows and macOS launchers received static review but have not been run on those operating systems. A full public-network download/resume test remains to be completed.

