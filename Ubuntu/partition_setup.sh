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
release_base='https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/ubuntu-factory-2026-10-24'
cleanup() { umount "$root_dir" 2>/dev/null || true; rmdir "$root_dir" 2>/dev/null || true; }
trap cleanup EXIT HUP INT TERM
mount "$part2" "$root_dir"

# A PINN backup contains the complete installed root. Do not redownload payloads
# or erase customer identity when restoring such a backup.
if [ "${restore:-false}" != true ] || [ ! -f "$root_dir/usr/lib/chatgpt/ChatGPT" ] || [ ! -f "$root_dir/opt/google/chrome/chrome" ] || [ ! -d "$root_dir/var/lib/snapd/snaps" ]; then
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
6345341549529af3b84fecae6e14d734bb6aa8d71d64e030779555f16029bbb3 hbu_usr_bin.tar.gz
78ed0794c76c7d88b601cc0d82e945cb490c5cdcd103eadef9cafb6ef75197d6 hbu_usr_lib_arch.tar.gz
3f390dbb5249b1cb548c329eb2fb3e4efec6a124bcb638f0c7cef1a68b6f61ab hbu_usr_lib_other.tar.gz
04bcfbabfac6bc5d5c7e425d3c5567a1a780a3141a866ff7dfecf43c039a1736 hbu_usr_share.tar.gz
ec95245f1ffbca50dcde0a4c07f4327412cb1dd9b836ca74a41f3925433954b5 hbu_apps.tar.gz
83fbe503e65224e9378f38a28e34f8bb1160567e016d5942e18c12da77c7ecfd hbu_snapd.tar.gz
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
printf '%s\n' 'Ubuntu HackberryPi PINN package installed' > "$root_dir/usr/local/share/hackberrypi-pinn/payloads-installed"
sync
