# Operating Systems for HackberryPi

Customized ARM64 systems for **HackberryPi CM5**, published as PINN installation packages.

| System | Documentation | Default login |
| --- | --- | --- |
| Ubuntu 24.04.5 for HackberryPi | [Ubuntu](Ubuntu/README.md) | Create an account using native first-boot setup |
| Kali Linux 2026.3 for HackberryPi | [Kali](Kali/README.md) | Username `kali`, password `kali` — both lowercase; use `sudo` for administrator commands |

| Fyde OS for HackBerry Pi (FydeOS 23.0) | [FydeOS](FydeOS/README.md) | Native first-run setup with your own account and any required vendor license |

Change the Kali password after your first login. Saved user logins, Wi-Fi credentials and personal history are excluded from the published Kali package.

## PINN download source

Use a PINN build with CM5 and HackberryPi display support. Add this to the existing single line in `recovery.cmdline`:

```
alt_image_source=https://raw.githubusercontent.com/DZT970525/Operating-System-for-HackberryPi/main/os_list_v3.json
```

All three systems appear in **General**. The older `Ubuntu/os_list_v3.json` endpoint is also maintained as a combined feed for cards already using it. `repo_list.json` points to the combined catalog.

Packages and checksums are under [Releases](https://github.com/DZT970525/Operating-System-for-HackberryPi/releases). Read each system's installation notes before downloading. These releases contain PINN filesystem archives and supplemental application archives, rather than directly flashable raw images. Keep the network connected throughout online installation.

The customized Kali standalone card has been boot-tested by the owner. All three PINN packages remain previews until installation and multiboot have been tested through PINN on the device. Ubuntu needs at least 16.5 GiB and Kali at least 20.5 GiB, plus PINN and other systems. Fyde OS needs at least 12.2 GiB and supports SD installation only. Its four-partition PINN edition disables native whole-disk OTA and Powerwash; reset or upgrade by reinstalling through PINN.
