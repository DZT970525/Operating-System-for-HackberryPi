# PINN Multiboot Installer for HackberryPi

The **2026-11-21 v2** release makes **Add OS gray until the network is ready** and adds the **base64** tool required by Omarchy's embedded installation script. Use **20261121-v2** for a new **HackberryPi CM5** card, or apply the file-only runtime update to an existing prepared edition below. The previous fresh-card Install fix, native **Recovery Mode** button, restored RPiOS icon and twelve-system payload catalog are retained.

## Write a new card

1. Open [Raspberry Pi Imager](https://www.raspberrypi.com/software/) with the [HackberryPi online catalog](https://raw.githubusercontent.com/DZT970525/Operating-System-for-HackberryPi/main/os_list_imager.json), then choose **PINN Multiboot Installer for HackberryPi**.
2. Alternatively [download `HackberryPi-PINN-12OS-CM5-20261121-v2.img.xz`](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/pinn-multiboot-hackberrypi-2026-11-16/HackberryPi-PINN-12OS-CM5-20261121-v2.img.xz), verify [`PINN-RUNTIME-SHA256SUMS-20261121-v2`](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/pinn-multiboot-hackberrypi-2026-11-16/PINN-RUNTIME-SHA256SUMS-20261121-v2), and select the file through **Use custom**. Imager accepts `.img.xz` directly.
3. Choose the intended SD card, write it and wait for verification. Writing replaces that card's contents. Skip optional operating-system account customization; connect the network in PINN after boot.
4. Boot HackberryPi CM5. All twelve choices and icons appear before Wi-Fi. Connect Wi-Fi, select the systems that fit the card and choose **Install**. Keep power and networking connected.
5. Select an installed system in the startup menu. Select **Recovery Mode**, or hold **Shift** at startup, to enter PINN management.

No OS is preinstalled. The image contains no saved Wi-Fi credentials, application account, private key or owner installation history. It expands to **516 MiB**, with one fresh **512 MiB RECOVERY** partition; PINN creates settings on first initialization and allocates selected systems later. A **32 GB card holds a suitable subset**, not all twelve systems. Eleven entries download additional verified data during **Install**; their separate **Download** action is not a complete offline installer.

## Update an existing multiboot card

For the prepared **HackberryPi CM5 PINN 20261118, 20261120 or 20261121** edition, download [`HackberryPi-PINN-Runtime-Update-20261121-v2.zip`](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/pinn-multiboot-hackberrypi-2026-11-16/HackberryPi-PINN-Runtime-Update-20261121-v2.zip), verify the dated checksums and follow **`UPGRADE.txt`** inside it.

1. Shut down the device and back up the card, including its original `pinn.rfs`.
2. Connect the card to a computer. Replace **only `pinn.rfs` in the root of the RECOVERY partition** with `pinn.rfs` from the ZIP.
3. Keep the partition layout, installed OS partitions, SETTINGS, `cmdline.txt`, `config.txt`, catalog and every other file. Wait for writing to finish, safely eject and boot the device.

**Do not flash the empty `.img.xz` to upgrade an installed card.** That replaces its systems and data. Updating only `catalog/os_list_v3.json` changes recipes and does not install the new runtime.

If an earlier Omarchy attempt failed with **`base64: command not found`**, update PINN before retrying Omarchy. The runtime ZIP does not finish incomplete systems, restore their payloads, change installed-OS metadata or reclaim partitions. Use **Add OS** when suitable free space is available to preserve existing systems. If failed space remains allocated but is not listed for system management, keep the card and obtain layout-specific recovery.

## Recovery Mode and system management

The startup menu's **Recovery Mode** button uses the same native gray style as its adjacent controls, with hover and pressed feedback. Missing boot-menu icons can use the local catalog cache, including RPiOS.

In Recovery Mode, **Add OS** installs one new online catalog choice at a time into supported free space at the end of the card. Follow the space review, confirmation and explicit **Restart PINN / Resume Add OS** prompts. Existing systems remain allocated; Add OS does not resize them. Automatically checked installed rows are ignored when selecting a new OS. Use **Add OS** to preserve the installed systems; the ordinary **Install** action repartitions.

**Add OS is gray while the network is not ready** and automatically recovers after connection or reconnection. A pending installation remains manageable offline through **Manage Add OS**: **Cancel Add** is available, while continuing installation requires the network.

**Delete OS** removes the selected installed system after confirmation. It does not enlarge the remaining systems. Follow the required restart before continuing. Add/Delete accepts the supported prepared CM5 SD-card layout and rejects unsupported layouts or unsafe states. Keep a backup before changing an existing card.

The refresh also improves payload retries, download/extraction progress, status layout, optional license terms and RPiOS Add completion. Prior installer-script, metadata-download, DNS and bounded diagnostic-log fixes remain included, along with CM5 screen/touch, Wi-Fi, USB OTG Host and battery support. PINN uses the physical **720×720** panel; installed systems retain their own Display Scale defaults, commonly **900×900**.

## Verification and source

The **20261121-v2 Add OS network gate passed 9 ARM32 Qt4 UI tests and 109 checks** using the production GUI library and native selection logic, including real private-interface connect/drop/reconnect, direct activation, offline pending cancellation and existing storage guards. The **base64 compatibility tool passed 62 actual ARM32 BusyBox checks**, including exact decoding of Omarchy's embedded script, malformed input and pipeline failures; runtime command dependencies were checked. These tests did not perform a physical boot or install an OS payload. **A separate physical v2 fresh-flash and complete Omarchy reinstallation test remains pending.**

The retained fresh-card helper fix previously passed 33 ARM32 tests. Earlier owner sessions accepted the native Recovery Mode button and restored RPiOS icon, completed RPiOS Add while retaining three prior systems, completed RPiOS and Arch installation, and checked DietPi's repaired post-install stage. The new dated report separately records image partition, filesystem, privacy and compression checks. Fresh-card installation of all twelve systems, every combination and every Add/Delete layout is not claimed; this remains a **multiboot preview**.

Read the [full installation notes](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/pinn-multiboot-hackberrypi-2026-11-16/PINN-Installation-20261121-v2.txt), [verification report](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/pinn-multiboot-hackberrypi-2026-11-16/PINN-RUNTIME-VERIFICATION-20261121-v2.json) and [source/support bundle](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/pinn-multiboot-hackberrypi-2026-11-16/HackberryPi-PINN-Runtime-Support-20261121-v2.tar.xz). Existing OS payload URLs, payload checksums and adapter sources remain unchanged. Older dated installers remain archived on the [PINN release page](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/tag/pinn-multiboot-hackberrypi-2026-11-16); choose **20261121-v2** for a new card.

