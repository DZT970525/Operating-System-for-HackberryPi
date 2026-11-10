# Kali Linux 2026.3 for HackberryPi

ARM64 Kali Rolling for **HackberryPi CM5**, with GNOME/Wayland, 720×720 DPI display and touchscreen configuration, ChatGPT, and MAX17048 battery support. Battery percentage is enabled and the top-panel System Monitor indicators are disabled by default.

Based on the official Raspberry Pi Imager Kali 2026.2 ARM64 image, then upgraded to Kali Rolling 2026.3. The owner successfully boot-tested this customized standalone system. **The PINN package is a preview: a complete installation and multiboot test through PINN is still required.** Other Raspberry Pi models are not supported by this hardware-specific package.

## Default login

| Item | Value |
| --- | --- |
| Username | `kali` |
| Password | `kali` |
| Administrator commands | `sudo`, using the same password |

Both username and password are **lowercase**. Change the password after your first login with `passwd`. Root login is locked. This package excludes saved application logins, Wi-Fi passwords, user history and original machine keys. Each installation generates new machine identity and SSH host keys. The tested source card is not modified by publishing.

## Install with Raspberry Pi Imager

For a complete standalone SD card with default **900 × 900** scaling, follow the [Kali Raspberry Pi Imager instructions](../Imager/Kali.md). Use a **32 GB or larger SD card**.

## Display Scale

After sign-in, the default desktop workspace is **900 × 900**. Double-click **Display Scale** on the desktop to open the English app. Drag its slider from **480 × 480** to **1080 × 1080**, then release to apply. Use **Save as default** to keep a chosen size for later logins.

The physical screen remains **720 × 720**. These values describe software scaling: a smaller workspace enlarges text and controls; a larger workspace fits more content. Nearby values can snap by one or two pixels to a supported scale. Native Wayland touch scrolling and the existing battery support are retained. No desktop pinch-to-zoom service is installed.

The login screen displays **Default Password: kali** below the password field. This is a factory-password hint; it does not change authentication.

## Install through PINN

Use a PINN build supporting **CM5 and the HackberryPi display**. Add the following to the existing single line in `recovery.cmdline`:

```
alt_image_source=https://raw.githubusercontent.com/DZT970525/Operating-System-for-HackberryPi/main/os_list_v3.json
```

Select **Kali Linux 2026.3 for HackberryPi** in **General**. Allow at least **20.5 GiB** for Kali, in addition to PINN and other operating systems. More space is recommended for updates and tools. Existing cards using this repository's Ubuntu feed will also receive the Kali entry.

Keep the network connected. PINN first downloads the boot and base-root archives. `partition_setup.sh` then downloads eight original supplemental archives and the final Display Scale overlay, verifies their SHA-256 checksums and assembles the installed system. Each asset stays below GitHub's 2 GiB limit. The script rewrites the kernel command line and `/etc/fstab` with PINN's actual partition identifiers. Stock automatic partition resizing is disabled to protect the multiboot layout.

The `hbk_*.tar.gz` files are **PINN filesystem archives**. They are separate from the complete standalone disk image supplied for [Raspberry Pi Imager](../Imager/Kali.md). The final `hbk_display_scale.tar.gz` overlay adds Display Scale v1.1, default 900 × 900 scaling and the login password hint after the original base payloads are installed. PINN keeps its own partition identifiers and multiboot layout; standalone automatic disk expansion is not installed by this overlay.

## Offline installation and checksums

Download the **ten original `hbk_*.tar.gz` files** and `marketing.tar` from the [original Kali release](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/tag/kali-hackberrypi-2026-10-25), plus **`hbk_display_scale.tar.gz`** from the [Display Scale release](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/tag/kali-displayscale-hackberrypi-2026-11-10). Download the current `SHA256SUMS`, `partition_setup.sh` and metadata from this folder. Put them together in a PINN OS directory such as `os/Kali_HackberryPi/` on a supported USB drive. Run `sha256sum -c SHA256SUMS` from that directory before installation. PINN's ordinary two-tarball download/export alone does not include the nine supplemental archives.

A PINN backup created after a successful installation contains the complete assembled root. Its restore path keeps the installed user's data and identity.

## Notes

Touch scrolling depends on application support. GNOME/Wayland and the Firefox/ChatGPT launch settings favor native touch input. No automatic screen blanking or idle suspend is enabled, to keep the DPI panel driven while powered. This package includes the same display, touch and battery configuration tested by the owner; it does not add the Ubuntu-specific Dock or Matrix screensaver.
