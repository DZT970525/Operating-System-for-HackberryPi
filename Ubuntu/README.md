# Ubuntu for HackberryPi — PINN

Ubuntu 24.04.5 LTS ARM64 for HackberryPi CM5, prepared for PINN multi-boot installation. Device-specific DPI boot configuration is retained.

**Status: packaging/upload in progress; not ready to install yet.**

## Included

Chrome as default browser; ChatGPT and Chrome Dock/desktop shortcuts; touchscreen Dock gestures; five-second Dock hide delay; Matrix screensaver after ten minutes; Ubuntu native customer first-boot setup; English, German, French and Spanish language packs. Seller accounts and logins were cleared. Pinyin and Clash Verge were removed.

## PINN online installation

After the release and metadata are complete and publicly accessible, append this to PINN recovery.cmdline (keep it on one line):

```text
alt_image_source=https://raw.githubusercontent.com/DZT970525/Operating-System-for-HackberryPi/main/Ubuntu/os_list_v3.json
```

PINN reads JSON metadata, not this GitHub HTML page. The package uses boot/root partition tarballs and a partition_setup.sh script that maps the real partitions assigned by PINN. Larger application payloads are fetched and checksum-verified by that script to stay within GitHub per-file limits.

For offline installation, download every metadata file and every payload archive from the same Release into one OS folder under a USB drive os directory. PINN standard download of only the main tarballs is not sufficient for this package.

## Compatibility and validation

Use a PINN build with CM5 and the required display support. Filesystem and fresh-account configuration tests passed. A real PINN install, first boot and multi-OS switch test on HackberryPi remain pending; this is a preview package.

The repository is initially private. Anonymous PINN downloads will not work until the repository and release assets are public.
