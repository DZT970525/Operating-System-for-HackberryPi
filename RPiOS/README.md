# RPiOS — Raspberry Pi OS for HackberryPi

This **2026-11-17 v2** release replaces the earlier RPiOS download with the owner's tested, updated **64-bit Raspberry Pi OS Bookworm / labwc** system. The shipping kernel is now **6.12.115+rpt-rpi-2712**. Battery percentage continued working after the owner updated the kernel, and the CM5 power-key menu was physically tested. The publication copy is rebuilt in fresh filesystems after removing private data; its separate fresh-flash test remains pending.

## Included

- Native **720×720** screen and touch, with a **900×900** default equivalent workspace.
- English **Display Scale** desktop app for manual **480–1080** scaling; touchscreen desktop pinch zoom remains disabled.
- Native Wi-Fi, Bluetooth, audio and MAX17048 battery support.
- **`hackberrypi-battery-dkms` 1.2+hbpi2**, matching kernel headers and the signed battery update source.
- Short press and release of the CM5 power button opens **Shutdown options**, including **Shutdown** and **Reboot**. Repeated presses keep one menu. **Ctrl+Alt+Delete** opens the same menu.
- **Clash Verge 2.5.8** in the application menu, with its protected service/core installed. It has **no desktop shortcut**. No subscription, node credentials, proxy profile or node-selection cache is included. Automatic application launch, system proxy and TUN are off until configured by the new user.
- Default account **`pi`**, password **`pi`**, both lowercase. Configure your own network/accounts and change the password after first login.

## Raspberry Pi Imager

Choose RPiOS in the [Imager online catalog](https://raw.githubusercontent.com/DZT970525/Operating-System-for-HackberryPi/main/os_list_imager.json), or download the complete [RPiOS-HackberryPi-CM5-20261117-v2.img.xz](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/rpios-clash-power-hackberrypi-2026-11-17/RPiOS-HackberryPi-CM5-20261117-v2.img.xz) (1.64 GiB) and select **Use custom** in [Raspberry Pi Imager](https://www.raspberrypi.com/software/). Use a **16 GB or larger** SD card. Write and verify it, then boot HackberryPi CM5. The `.img.xz` is one complete image; manual decompression or merging is unnecessary.

Use the supplied `pi` account and skip Imager's optional OS customization. At first boot, the standalone edition grows only its own root partition and initializes a new machine/SSH identity. Writing an image replaces the selected card.

## Battery and power menu

The driver source and DKMS registration are retained, so ordinary later kernel/header updates rebuild and install the battery module. The signed update source is already configured:

```sh
sudo apt install hackberrypi-battery-dkms
```

Existing installations can apply the [one-command battery retrofit](../drivers/battery/apt/README.md) without reflashing. A future incompatible kernel interface can still require a reviewed driver update.

The former desktop power binding called an obsolete helper removed during package updates. This edition binds the key to the installed native `pishutdown` menu through a small single-instance launcher. No kernel or device-tree change is required for the menu fix.

## Clash Verge

Open **Clash Verge** from the application menu and import your own subscription or local profile. Choose your node and enable the desired proxy mode. This public image includes no usable personal proxy subscription and does not turn on a proxy automatically. The application remains available without placing an icon on the wallpaper desktop.

## PINN multiboot

Download the [fresh 2026-11-21 PINN installer](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/pinn-multiboot-hackberrypi-2026-11-16/HackberryPi-PINN-12OS-CM5-20261121.img.xz), or select **PINN Multiboot Installer for HackberryPi** in the [Imager online catalog](https://raw.githubusercontent.com/DZT970525/Operating-System-for-HackberryPi/main/os_list_imager.json). For a downloaded file, use Imager **Use custom** and select the `.img.xz` directly. This image contains **only PINN, with no systems installed and no saved private data**. Connect Wi-Fi, select the systems that fit and choose **Install**. Read the [PINN installation notes](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/pinn-multiboot-hackberrypi-2026-11-16/PINN-Installation-20261121.txt), the [Imager guide](../Imager/PINN.md) and `PINN-RUNTIME-SHA256SUMS-20261121`. The refresh includes the native gray **Recovery Mode** button with hover/pressed feedback, the restored RPiOS startup icon, Add OS, installed-system management and installation fixes. The existing twelve-system catalog and OS payloads remain unchanged. Older dated assets remain archived; choose **20261121** for a new card.

The **20261120 empty installer could keep Install gray on a newly initialized card** because it misidentified the fresh setup. **20261121 fixes this fresh-card detection** while retaining the checks that protect existing installations and pending operations. Use **20261121** for new cards. An already-written 20261120 card can receive the file-only update below. The fix passed native helper and Qt application checks; a separate physical fresh-flash and installation test of the 20261121 image is pending.

For an existing prepared **HackberryPi CM5 PINN 20261118 or 20261120** card, use the [file-only runtime update ZIP](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/pinn-multiboot-hackberrypi-2026-11-16/HackberryPi-PINN-Runtime-Update-20261121.zip) and its **`UPGRADE.txt`**. Back up the card, shut it down and replace **only `pinn.rfs` in the RECOVERY partition's root**. Preserve SETTINGS, all installed systems, the partition layout and every other file. **Do not flash the empty installer image to upgrade an existing card:** image writing replaces its systems and data.

The fresh RPiOS recipe uses a new boot archive and **5 full root payloads** from this same release. It does not depend on the older RPiOS payloads or layer a small driver delta over them. Allocate at least **8.5 GiB**, plus PINN and the other selected systems. The adapter verifies every archive, writes only PINN's allocated logical partitions, substitutes their assigned partition identifiers, and disables standalone whole-card expansion. Backup/restore preserves the installed user's identity and state. CM5 SD installation is supported; USB boot/root is not advertised.

For a new card, use the fresh 20261121 PINN installer above. For runtime fixes on a compatible existing card, use the file-only ZIP above. Catalog-only replacement below updates recipes but does not add the new runtime fixes to an older installer. To preserve an existing multiboot card, first back up `catalog/os_list_v3.json`, `repo_list.json` and `catalog/repo_list.json` on its RECOVERY boot partition. Download the [current combined catalog](https://raw.githubusercontent.com/DZT970525/Operating-System-for-HackberryPi/main/os_list_v3.json) and save it as **`catalog/os_list_v3.json`**, replacing that cached JSON. The earlier and v2 RPiOS editions have the same 2026-11-17 date; PINN can retain the first cached recipe when dates are equal, so the cache replacement is required. Then update **both selector files** to this identical content, keeping the existing system partitions and `cmdline.txt`:

```json
{
  "repo_list": [
    {"name": "HackberryPi cached catalog", "url": "/tmp/hackberrypi-catalog/os_list_v3.json"},
    {"name": "HackberryPi online updates", "url": "https://raw.githubusercontent.com/DZT970525/Operating-System-for-HackberryPi/main/os_list_v3.json"}
  ]
}
```

Connect Wi-Fi to fetch the new recipe. The FAT root selector takes priority over command-line source settings, so changing `alt_image_source` alone is insufficient for an old local-only selector. The repository's public selector is HTTPS-only; the prepared installer additionally has its local cache.

For manual offline preparation, download every item in [archives.json](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/rpios-clash-power-hackberrypi-2026-11-17/archives.json) with its supplied hash. PINN's two ordinary boot/root tarballs omit supplemental root payloads. The [adapter and custom integration source](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/rpios-clash-power-hackberrypi-2026-11-17/RPiOS-HackberryPi-PINN-Source-20261117-v2.tar.xz) accompanies this exact full-payload recipe. Software assembly checked **169,353 paths** and **391 hardlink groups**; any bounded extraction metadata differences are listed in `PINN-ASSEMBLY-VERIFICATION.json`.

## Privacy, source and verification

The publication copy excludes saved Wi-Fi passwords, network connections, Bluetooth pairings, browser data, application logins, Clash subscriptions/profiles/runtime state, histories, personal files, old recovery fragments, original machine/SSH identities and private DKMS signing keys. It is copied into newly formatted filesystems so deleted personal data and old journal/free blocks are not carried into the release.

Custom adapter, power-menu, display integration and battery package sources are included in the source attachment. The [signed battery source package](https://raw.githubusercontent.com/DZT970525/Operating-System-for-HackberryPi/main/drivers/battery/apt/hackberrypi-battery-package-source.tar.xz), [Clash Verge upstream](https://github.com/clash-verge-rev/clash-verge-rev) and Debian/Raspberry Pi source repositories provide the corresponding upstream source references. Installed original notices are retained under `/usr/share/doc`. Read `factory-status.json`, `SHA256SUMS` and `PINN-ASSEMBLY-VERIFICATION.json` for measured facts.

| Check | Result |
| --- | --- |
| Configured source card: desktop, kernel update and battery percentage | Owner reported passed |
| Configured source card: physical CM5 power-key menu | Owner reported passed |
| Sanitized standalone image: file contents, metadata, filesystems and full compressed stream | Passed |
| Native PINN packages: full assembly and partition/identity fixtures | Passed |
| Sanitized standalone image: separate fresh-flash boot | Pending |
| RPiOS online PINN installation and current startup menu | Completed/accepted in the owner test session; fresh-card combinations still require testing |




