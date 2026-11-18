# PINN Multiboot Installer for HackberryPi

The **2026-11-18** image is an empty PINN installer for **HackberryPi CM5**. No operating system is preinstalled. It contains no saved Wi-Fi credentials, application accounts or owner installation history.

## Write a new card

1. Open [Raspberry Pi Imager](https://www.raspberrypi.com/software/) with the [HackberryPi online catalog](https://raw.githubusercontent.com/DZT970525/Operating-System-for-HackberryPi/main/os_list_imager.json), then choose **PINN Multiboot Installer for HackberryPi**.
2. Alternatively [download `HackberryPi-PINN-12OS-CM5-20261118.img.xz`](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/pinn-multiboot-hackberrypi-2026-11-16/HackberryPi-PINN-12OS-CM5-20261118.img.xz) (108.0 MiB), verify [`PINN-RUNTIME-SHA256SUMS-20261118`](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/pinn-multiboot-hackberrypi-2026-11-16/PINN-RUNTIME-SHA256SUMS-20261118), and select the file through **Use custom**. Imager accepts `.img.xz` directly.
3. Choose the intended SD card, write it and wait for verification. Writing replaces that card's contents. Skip optional operating-system account customization; connect the network in PINN after boot.
4. Boot HackberryPi CM5. The twelve system choices/icons appear before Wi-Fi. Connect Wi-Fi, check the systems that fit the card and choose **Install**. Keep power and networking connected.
5. Select an installed system in the startup menu. Hold **Shift** at startup to enter PINN management.

The expanded installer is **516 MiB** with one fresh RECOVERY partition. PINN creates its settings on first initialization and allocates the selected systems later. A **32 GB card holds a suitable subset**, not all twelve systems. Eleven entries download additional verified data during **Install**; their separate **Download** action is not a complete offline installer.

## Included fixes

- Compact **48×48** startup icons with whole-row touch and keyboard selection.
- Installer script compatibility and the corrected DietPi `/boot/firmware` recipe.
- Resilient small-metadata downloads and visible post-install download, verification and extraction progress.
- DHCP-provided DNS, bounded root-only debug logs, matched CM5 screen/touch, USB OTG Host, Wi-Fi and battery support.

PINN uses the physical **720×720** panel. Installed systems keep their own Display Scale defaults, commonly a **900×900** logical workspace.

## Existing multiboot cards

Writing this factory image replaces a card's existing systems. Keep a backup before changing an existing multiboot card. Updating only `catalog/os_list_v3.json` changes OS recipes; it does not replace an older installer runtime with these new fixes.

## Verification and source

The owner accepted the current runtime and compact startup menu on the device. RPiOS and Arch completed installation in the tested session, and DietPi's corrected post-install stage passed on its assigned partitions after repair. The empty image has independent partition/filesystem/privacy and full compression checks. Fresh-card installation of all twelve choices or every combination is not claimed; the release remains a multiboot preview.

Read the [full installation notes](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/pinn-multiboot-hackberrypi-2026-11-16/PINN-Installation-20261118.txt), [verification report](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/pinn-multiboot-hackberrypi-2026-11-16/PINN-RUNTIME-VERIFICATION-20261118.json) and [source/support bundle](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/pinn-multiboot-hackberrypi-2026-11-16/HackberryPi-PINN-Runtime-Support-20261118.tar.xz). Older dated installers remain archived on the [PINN release page](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/tag/pinn-multiboot-hackberrypi-2026-11-16).
