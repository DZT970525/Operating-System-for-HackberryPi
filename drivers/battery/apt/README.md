# HackberryPi CM5 battery driver

If this battery update source is already configured, install or update the driver with:

```sh
sudo apt install hackberrypi-battery-dkms
```

For another device that has **never configured this source**, run this once:

```sh
curl -fsSL https://raw.githubusercontent.com/DZT970525/Operating-System-for-HackberryPi/main/drivers/battery/apt/install.sh | sudo bash
```

This installs the signed update source and driver on the **ARM64 Raspberry Pi OS Bookworm image for HackberryPi CM5**. The running device must already have the HackberryPi MAX17048 battery overlay. It does not add hardware support to an unrelated Raspberry Pi or another operating system. Restart after installation when convenient; the installer does not restart automatically.

The original image stored the battery driver only for its 6.6 kernel, so replacing that kernel could remove the battery indicator. This package keeps the driver source under `/usr/src`, registers it with DKMS, and retains matching kernel header dependencies. Normal kernel upgrades then rebuild the battery driver automatically. Reviewed driver package updates are included in the usual `sudo apt update` and `sudo apt upgrade`, without downloading a new full system image. Future incompatible kernel interfaces can still require a driver source update.

The installer checks the device before downloading anything, validates the fixed public key and source settings, and uses APT's signed package indexes. The key is limited with `signed-by`; package preferences allow only `hackberrypi-battery-dkms` from this source. Dependencies come from the system's existing Debian/Raspberry Pi sources. Existing same-name APT settings with different contents are left for manual review.

## Check the driver

```sh
dkms status -m hackberrypi-max17048
modinfo -k "$(uname -r)" hackberrypi-max17048
cat /sys/class/power_supply/battery/capacity
```

## Source and signing

`hackberrypi-battery-package-source.tar.xz` contains the matching source, build files, packaging scripts, and retained notices. `build-repository.py` regenerates package indexes and signatures for a reviewed new package version. Upload its generated indexes, release signatures, and package together; keep previously published versioned `.deb` files available for cached clients.

Public key fingerprint:

```text
144B F022 65C6 30AE 270F 1E88 D2BC 5DB0 662C BD6E
```

The maintainer's private signing key stays separate and is never uploaded or included in an image. To publish a reviewed package:

```sh
python3 build-repository.py --package /path/to/hackberrypi-battery-dkms_VERSION_all.deb --output /path/to/apt-upload --gnupghome /path/to/private-signing
```

This small static repository uses a non-expiring signing key and does not set metadata expiry; key rotation requires an explicit reviewed replacement. It does not execute an upstream Git branch or enable unattended upgrades.

Mechanism references: [Raspberry Pi kernel and headers](https://www.raspberrypi.com/documentation/computers/linux_kernel.html), [DKMS](https://manpages.debian.org/bookworm/dkms/dkms.8.en.html), [APT authentication](https://manpages.debian.org/bookworm/apt/apt-secure.8.en.html).
