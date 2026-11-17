# HackberryPi CM5 battery updates for Raspberry Pi OS

This small APT source supplies `hackberrypi-battery-dkms`, the MAX17048 battery driver used by the HackberryPi CM5 image. It repairs a missing battery after the original 6.6 kernel is replaced during a Raspberry Pi OS update. The package retains driver source under `/usr/src` and registers it with DKMS. Matching `linux-headers-rpi-2712` and `linux-headers-rpi-v8` packages stay installed as dependencies.

Normal kernel updates then rebuild and install the driver through Debian's kernel and header hooks. There is no need to download or flash an entire replacement image for a routine kernel update. A future kernel that changes the driver's source interfaces can still require a driver package update.

New reviewed driver package versions published to this source are offered by the usual **system update** (`sudo apt update` followed by `sudo apt upgrade`). Kernel and driver package updates are different: DKMS automatically adapts an installed source version to each compatible new kernel; a changed source version must first be published here. This does not execute an unreviewed upstream Git branch and does not enable unattended upgrades.

## Install once

For the ARM64 Raspberry Pi OS Bookworm HackberryPi CM5 image only. Keep the existing `hackberrypicm5` device-tree overlay. This source does not change display scaling, networking, or the desktop.

Download `hackberrypi-battery.gpg`, `hackberrypi-battery.list`, and `hackberrypi-battery.pref` from this directory. Before installing the key, confirm its fingerprint:

```sh
gpg --show-keys --with-fingerprint hackberrypi-battery.gpg
```

The complete fingerprint is:

```text
144B F022 65C6 30AE 270F 1E88 D2BC 5DB0 662C BD6E
```

Then run from the download directory:

```sh
sudo install -d -m 0755 /etc/apt/keyrings
sudo install -m 0644 hackberrypi-battery.gpg /etc/apt/keyrings/hackberrypi-battery.gpg
sudo install -m 0644 hackberrypi-battery.list /etc/apt/sources.list.d/hackberrypi-battery.list
sudo install -m 0644 hackberrypi-battery.pref /etc/apt/preferences.d/hackberrypi-battery
sudo apt update
sudo apt install hackberrypi-battery-dkms
sudo reboot
```

The repository key is scoped with `signed-by`; package preferences allow only `hackberrypi-battery-dkms` from this source. DKMS and compiler/header dependencies come from the system's existing official Debian/Raspberry Pi sources.

## Check after an update

```sh
dkms status -m hackberrypi-max17048
modinfo -k "$(uname -r)" hackberrypi-max17048
cat /sys/class/power_supply/battery/capacity
```

`apt update` alone refreshes package lists; it does not install a kernel. After a kernel update has been installed, restart before checking the running kernel's battery driver.

## Source and maintenance

The matching package source is in `hackberrypi-battery-package-source.tar.xz`; driver notices and copyright are retained. `build-repository.py` regenerates the flat APT index, SHA-256/SHA-512 package-list checksums, and OpenPGP signatures after a new package is reviewed and built. Upload the new `.deb`, both package lists, and all three release/signature files together in one commit so clients see a consistent source. Retain older versioned `.deb` files while existing indexes may be cached.

The private signing key is held separately by the maintainer and must never be uploaded, embedded in an image, or included in a source archive. To sign a new repository version:

```sh
python3 build-repository.py --package /path/to/new/hackberrypi-battery-dkms_VERSION_all.deb --output /path/to/apt-upload --gnupghome /path/to/private-signing
```

The public signing key is non-expiring so a static small repository does not break installed systems when no new version is needed. Release metadata records the signing date. Key compromise or rotation requires distributing a reviewed replacement key explicitly. The repository does not set a metadata expiry date; it relies on TLS, signed metadata, and package versions rather than claiming replay protection.

Official mechanism references: [Raspberry Pi kernel and matching headers](https://www.raspberrypi.com/documentation/computers/linux_kernel.html), [DKMS manual](https://manpages.debian.org/bookworm/dkms/dkms.8.en.html), [APT authentication](https://manpages.debian.org/bookworm/apt/apt-secure.8.en.html), and [APT package preferences](https://manpages.debian.org/bookworm/apt/apt_preferences.5.en.html).
