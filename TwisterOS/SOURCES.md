# Sources and notices for Twister OS 3.1 on HackberryPi

[Release and source assets](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/tag/twisteros-displayscale-hackberrypi-2026-11-16)

## HackberryPi integration

The [integration source archive](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/twisteros-displayscale-hackberrypi-2026-11-16/TwisterOS-HackberryPi-Integration-Source-20261116.tar.xz) includes the native screen/touch overlay description and compiled overlay, MAX17048 driver/DKMS files and native-kernel build helper, Display Scale application, default 900 configuration, X11 touch/font/no-idle settings, native network/Bluetooth/audio control configuration, matching initramfs integration, theme templates, the complete ThemeTwister adaptation, and final factory startup helpers. The accepted native RP1 DPI output configuration is retained; final runtime files override matching earlier deployment templates in the canonical payload. File manifests identify the exact sources.

The ThemeTwister source retains **grayduck's 3.1.0-rpi author/version header**. The original shell source recovered from the installed stock executable, modified source and patch are supplied together. Fifteen theme choices now explicitly set the actual **DPI-1** wallpaper for four workspaces. The modification flushes Xfconf and logs out normally instead of force-killing all of the user's processes. Other native theme actions are retained.

CNflysky's MAX17048 source retains its author notice and **GPL** declaration. The module is built for the native **6.12.25+rpt-rpi-v8** kernel with matching headers; other kernels need their own corresponding build. Upstream Neofetch retains **MIT**. The supplied upstream reference source and native Debian package inventory distinguish upstream 7.1.0 from installed package 7.1.0-4.

## Exact native kernel

The unchanged native Raspberry Pi/Debian kernel source package is **`linux 1:6.12.25-1+rpt1`**. The v8 flavour uses **4 KiB pages**; this release keeps Twister's `kernel8.img` selection rather than substituting `kernel_2712.img`.

Matching source assets:

- [linux_6.12.25.orig.tar.xz](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/twisteros-displayscale-hackberrypi-2026-11-16/linux_6.12.25.orig.tar.xz)
- [linux_6.12.25-1+rpt1.debian.tar.xz](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/twisteros-displayscale-hackberrypi-2026-11-16/linux_6.12.25-1%2Brpt1.debian.tar.xz)
- [linux_6.12.25-1+rpt1.dsc](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/twisteros-displayscale-hackberrypi-2026-11-16/linux_6.12.25-1%2Brpt1.dsc)

The native binary/source version is recorded by the authenticated Raspberry Pi package metadata. The historical descriptor is separately signed by Serge Schneider, fingerprint **`480203C910DA290C44F704D6A41C82885484A525`**; its archive checksums are verified against the downloaded sources. Current repository `Sources` metadata contains a newer kernel and is not misrepresented as authenticating this historical source version. The included provenance files record the two verification paths.

Build using the source package's included Debian/Raspberry Pi packaging instructions and matching v8 configuration. Retain the package's copyright, kernel `COPYING`, per-file SPDX identifiers and documented exceptions. The [Raspberry Pi kernel project](https://github.com/raspberrypi/linux) and [packaging repository](https://github.com/RPi-Distro/linux-packaging) remain the upstream maintenance sources.

## Base and native package sources

The [source-notices archive](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/twisteros-displayscale-hackberrypi-2026-11-16/TwisterOS-HackberryPi-Source-Notices-20261116.tar.xz) contains original-image provenance, final native package Source/version records, package copyrights and component license texts. Native notices remain under `/usr/share/doc` in the image. Obtain the exact native package source revisions from their documented Debian/Raspberry Pi source repositories; these inventories are not a claim that every upstream package's full source is copied into this archive.

Original system: [Twister OS 3.1.0 downloads](https://twisteros.com/downloads/) and [Pi Labs credits](https://twisteros.com/credits/). Theme assets, vendor firmware, fonts, application binaries and names retain their original owners' terms. No whole-image relicensing or upstream endorsement is claimed. Read [PUBLICATION-NOTICES.txt](PUBLICATION-NOTICES.txt).
