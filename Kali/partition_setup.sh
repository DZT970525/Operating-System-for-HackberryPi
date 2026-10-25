#!/bin/sh
#supports_backup in PINN
set -eu

choose_id() {
    case "$1" in PARTUUID=*) printf '%s\n' "$1";; '') printf '%s\n' "$2";; *) printf 'PARTUUID=%s\n' "$1";; esac
}

patch_paths() {
    boot=$1; root=$2; root_id=$3; boot_id=$4
    grep -q 'root=' "$boot/cmdline.txt"
    sed "s@root=[^ ][^ ]*@root=$root_id@g" "$boot/cmdline.txt" > "$boot/cmdline.txt.pinn-new"
    mv "$boot/cmdline.txt.pinn-new" "$boot/cmdline.txt"
    awk -v r="$root_id" -v b="$boot_id" 'BEGIN {OFS="\t";nr=0;nb=0}
      /^[[:space:]]*#/ || NF<2 {print;next}
      $2=="/" {$1=r;nr=1}
      $2=="/boot/firmware" {$1=b;nb=1}
      {print}
      END {if(!nr)print r,"/","ext4","defaults",0,1; if(!nb)print b,"/boot/firmware","vfat","defaults",0,2}' \
      "$root/etc/fstab" > "$root/etc/fstab.pinn-new"
    mv "$root/etc/fstab.pinn-new" "$root/etc/fstab"
}

# The test harness sources the functions without mounting or downloading anything.
if [ "${HB_PINN_TEST:-0}" = 1 ]; then return 0; fi

for argument in "$@"; do
    case "$argument" in
      part1=*) part1=${argument#part1=};; part2=*) part2=${argument#part2=};;
      id1=*) id1=${argument#id1=};; id2=*) id2=${argument#id2=};;
    esac
done
: "${part2:?PINN root partition missing}"
: "${id1:?PINN boot identifier missing}"
: "${id2:?PINN root identifier missing}"
boot_id=$(choose_id "${partuuid1:-}" "$id1")
root_id=$(choose_id "${partuuid2:-}" "$id2")
boot_dir=$(pwd)
root_dir=$(mktemp -d /tmp/hackberrypi-root.XXXXXX)
package_dir=$(dirname "$0")
release_base='https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/kali-hackberrypi-2026-10-25'
cleanup() { umount "$root_dir" 2>/dev/null || true; rmdir "$root_dir" 2>/dev/null || true; }
trap cleanup EXIT HUP INT TERM
mount "$part2" "$root_dir"

# A PINN backup contains the complete installed root. Do not redownload payloads
# or erase customer identity when restoring such a backup.
if [ "${restore:-false}" != true ] || [ ! -f "$root_dir/usr/local/share/hackberrypi-pinn/payloads-installed" ]; then
    mkdir -p "$root_dir/var/tmp"
    while read -r expected filename; do
        [ -n "$filename" ] || continue
        echo "HackberryPi: installing $filename"
        temporary="$root_dir/var/tmp/.pinn-$filename"
        if [ -f "$package_dir/$filename" ]; then
            cp "$package_dir/$filename" "$temporary"
        else
            wget --retry-connrefused --read-timeout=120 --tries=5 -O "$temporary" "$release_base/$filename"
        fi
        printf '%s  %s\n' "$expected" "$temporary" | sha256sum -c -
        bsdtar -xpf "$temporary" -C "$root_dir"
        rm -f "$temporary"
    done <<'PAYLOADS'
bbf17d8a65b10b9bd7c3fe3f5dee2d1bf0df8ae313962e97b8ee1e1cab955112 hbk_bin.tar.gz
6ebb08dc26999570992d08acee07311a81d598638a9942c12fe7ddc6ef1b59bc hbk_chatgpt.tar.gz
26338ca73d6fb895eadaac873235be4d9c7fa16b71c6b26fe03b93f552812d1b hbk_firmware.tar.gz
406f2e0e31e3b5551f0df7a8632c84e207d9a44786e48c12fccafd62885677e3 hbk_lib_arch.tar.gz
1c34bf6467e9462e7253080620cac3b19c843add0fefd9a39ffe248ae8035cbe hbk_lib_other.tar.gz
ded0c6cb9a3938acb1698c1b4f2aca9711867504bc2f525493bf07d2ebeb6c59 hbk_network_support.tar.gz
d56c3175fa8e020eda559dc7c2aad30073872235be4a57252a7167f2983b1065 hbk_python.tar.gz
9e0b3504df3c716c17324304309cb06fb1bd1f4c645b627c051353b090654fcc hbk_share.tar.gz
PAYLOADS
fi

patch_paths "$boot_dir" "$root_dir" "$root_id" "$boot_id"
if [ "${restore:-false}" != true ]; then
    : > "$root_dir/etc/machine-id"
    chmod 444 "$root_dir/etc/machine-id"
    mkdir -p "$root_dir/var/lib/dbus"
    rm -f "$root_dir/var/lib/dbus/machine-id"
    ln -s /etc/machine-id "$root_dir/var/lib/dbus/machine-id"
    rm -f "$root_dir"/etc/ssh/ssh_host_* "$root_dir/var/lib/systemd/random-seed"
fi
mkdir -p "$root_dir/usr/local/share/hackberrypi-pinn"
printf '%s\n' 'Kali HackberryPi PINN package installed' > "$root_dir/usr/local/share/hackberrypi-pinn/payloads-installed"
sync
