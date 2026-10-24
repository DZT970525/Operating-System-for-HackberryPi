# Ubuntu for HackberryPi

Ubuntu 24.04.5 LTS ARM64 factory-state backup for HackberryPi. Retains device-specific DPI display and boot configuration; not a generic PC installer.

## Included

- Google Chrome as default browser.
- ChatGPT and Chrome pinned to the left Dock, with desktop shortcuts.
- Touchscreen Dock reveal/dismiss gestures and a five-second hide delay.
- Matrix digital-rain screensaver, defaulting to ten minutes.
- Ubuntu native first-boot setup: language, keyboard, network, timezone, device name, account and password.
- English, German, French and Spanish language packs.

Seller accounts, application logins, saved Wi-Fi connections and old SSH host keys were cleared. Pinyin and Clash Verge were removed. Customizations apply to new customer accounts.

## Backup and restore

Download every image part and checksum from the same Release. Parts are a single gzip stream split to fit GitHub's asset limits, not individually bootable images.

Uncompressed size: 31,914,983,424 bytes. Use a destination card at least this large.

Join parts in numeric order and decompress on Linux/macOS:

```sh
cat ubuntu-hackberrypi-factory-2026-10-24.img.gz.part* | gzip -dc > ubuntu-hackberrypi-factory.img
```

Verify SHA-256 checksums, then write the resulting `.img` with Raspberry Pi Imager or another raw-image writer. Writing erases the destination card.

## Validation

Filesystem and fresh-account configuration checks passed. A physical test of the prepared factory first-boot UI is still pending. Create distribution images before completing first-boot setup; creating an account consumes factory state.

This repository is initially private for backup.
