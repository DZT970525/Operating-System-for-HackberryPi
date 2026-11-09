#!/bin/sh
#supports_backup in PINN
# PINN owns partition allocation; this adapter never changes a partition table.
set -eu
umask 022

fail() { printf 'RPiOS PINN: %s\n' "$*" >&2; exit 1; }

choose_id() {
    case "$1" in
        PARTUUID=*) printf '%s\n' "$1" ;;
        '') printf '%s\n' "$2" ;;
        *) printf 'PARTUUID=%s\n' "$1" ;;
    esac
}

validate_id() {
    case "$1" in PARTUUID=?*|UUID=?*|LABEL=?*) ;; *) fail 'Invalid partition identifier' ;; esac
    case "$1" in *[!A-Za-z0-9_=.:+-]*) fail 'Unsafe partition identifier' ;; esac
}

validate_payload() {
    expected=$1; filename=$2; extra=${3:-}
    [ ${#expected} -eq 64 ] || fail 'Invalid payload SHA-256 length'
    case "$expected" in *[!0-9a-f]*) fail 'Invalid payload SHA-256' ;; esac
    [ -z "$extra" ] || fail 'Unexpected payload manifest field'
    case "$filename" in
        hbr_payload_[0-9][0-9].tar.gz) ;;
        *) fail 'Unsupported payload filename' ;;
    esac
}

patch_paths() {
    boot=$1; root=$2; root_id=$3; boot_id=$4
    validate_id "$root_id"; validate_id "$boot_id"
    [ -f "$boot/cmdline.txt" ] || fail 'Native boot cmdline is missing'
    awk -v r="$root_id" '
      BEGIN {roots=0;types=0;lines=0}
      NF {
        lines++; out=""
        for(i=1;i<=NF;i++) {
          if($i ~ /^root=/) {$i="root=" r; roots++}
          else if($i ~ /^rootfstype=/) {$i="rootfstype=ext4"; types++}
          else if($i=="init=/usr/lib/raspi-config/init_resize.sh") {continue}
          out=out (out=="" ? "" : " ") $i
        }
        if(!types) {out=out " rootfstype=ext4"; types=1}
        print out
      }
      END {if(lines!=1 || roots!=1 || types!=1)exit 1}' \
      "$boot/cmdline.txt" > "$boot/cmdline.txt.pinn-new" || fail 'Unexpected native root command line'
    [ -f "$root/etc/fstab" ] || fail 'Root fstab is missing'
    awk -v r="$root_id" -v b="$boot_id" '
      BEGIN {OFS="\t";nr=0;nb=0}
      /^[[:space:]]*#/ || NF<2 {print;next}
      $2=="/" {$1=r;$3="ext4";nr++}
      $2=="/boot/firmware" {$1=b;$3="vfat";nb++}
      {print}
      END {if(nr!=1 || nb!=1)exit 1}' \
      "$root/etc/fstab" > "$root/etc/fstab.pinn-new" || fail 'Unexpected ext4 mount layout'
    mv "$boot/cmdline.txt.pinn-new" "$boot/cmdline.txt"
    mv "$root/etc/fstab.pinn-new" "$root/etc/fstab"
}

disable_standalone_growth() {
    root=$1
    # The standalone distribution may grow its own final root partition.
    # A PINN root can be partition 6, 7, or any assigned logical partition.
    rm -f "$root/etc/systemd/system/multi-user.target.wants/hackberrypi-image-grow.service"
    rm -f "$root/etc/systemd/system/hackberrypi-image-grow.service"
    rm -f "$root/usr/local/sbin/hackberrypi-image-grow"
    rm -f "$root"/usr/local/sbin/__pycache__/hackberrypi-image-grow.*.pyc
    rm -f "$root/etc/hackberrypi/image-first-boot"
    rm -f "$root/etc/init.d/resize2fs_once"
    for link in "$root"/etc/rc[0-6S].d/*resize2fs_once; do
        [ ! -L "$link" ] || rm -f "$link"
    done
}

install_identity_firstboot() {
    root=$1
    # Keep the sanitized distribution's separate, identity-only helper intact.
    [ -x "$root/usr/local/sbin/hackberrypi-rpios-firstboot" ] \
        && [ -f "$root/etc/systemd/system/hackberrypi-rpios-firstboot.service" ] \
        || fail 'RPiOS identity initialization helper is missing'
    mkdir -p "$root/etc/hackberrypi" "$root/etc/systemd/system/multi-user.target.wants"
    ln -sfn ../hackberrypi-rpios-firstboot.service \
        "$root/etc/systemd/system/multi-user.target.wants/hackberrypi-rpios-firstboot.service"
    printf '%s\n' 'Initialize a new device identity on first boot.' > "$root/etc/hackberrypi/rpios-identity-first-boot"
    rm -f "$root/etc/machine-id"
    : > "$root/etc/machine-id"
    chmod 0444 "$root/etc/machine-id"
    mkdir -p "$root/var/lib/dbus"
    rm -f "$root/var/lib/dbus/machine-id"
    ln -s /etc/machine-id "$root/var/lib/dbus/machine-id"
    rm -f "$root"/etc/ssh/ssh_host_*
    rm -f "$root/var/lib/systemd/random-seed" "$root/var/lib/systemd/credential.secret"
}

install_payloads() {
    root=$1; package=$2; release=$3
    manifest="$root/pinn-payloads.sha256"
    [ -s "$manifest" ] || fail 'PINN bootstrap payload manifest is missing'
    count=0
    while read -r expected filename extra || [ -n "$expected$filename$extra" ]; do
        [ -n "$expected" ] || continue
        case "$expected" in \#*) continue ;; esac
        validate_payload "$expected" "$filename" "$extra"
        temporary="$root/.pinn-download-$filename"
        printf 'RPiOS PINN: installing %s\n' "$filename"
        if [ -f "$package/$filename" ]; then
            cp "$package/$filename" "$temporary"
        else
            wget --retry-connrefused --read-timeout=120 --tries=5 \
                -O "$temporary" "$release/$filename"
        fi
        printf '%s  %s\n' "$expected" "$temporary" | sha256sum -c -
        bsdtar --numeric-owner -xpf "$temporary" -C "$root"
        rm -f "$temporary"
        temporary=''
        count=$((count+1))
    done < "$manifest"
    [ "$count" -gt 0 ] || fail 'Payload manifest contained no archives'
    [ -f "$root/etc/os-release" ] && [ -x "$root/usr/bin/python3" ] \
        && [ -f "$root/usr/local/lib/hackberrypi/display_control.py" ] \
        || fail 'The assembled Raspberry Pi OS payload is incomplete'
}

finalize_installation() {
    boot=$1; root=$2; root_id=$3; boot_id=$4; restoring=$5
    if [ "$restoring" = true ]; then
        # An ext4 PINN backup contains the assembled root and customer state.
        [ -f "$root/usr/local/share/hackberrypi-pinn/rpios-payloads-installed" ] \
            && [ -f "$root/usr/local/lib/hackberrypi/display_control.py" ] \
            || fail 'The backup is not an assembled RPiOS PINN installation'
        patch_paths "$boot" "$root" "$root_id" "$boot_id"
        disable_standalone_growth "$root"
        return
    fi
    patch_paths "$boot" "$root" "$root_id" "$boot_id"
    disable_standalone_growth "$root"
    install_identity_firstboot "$root"
    mkdir -p "$root/usr/local/share/hackberrypi-pinn"
    printf '%s\n' 'RPiOS HackberryPi PINN payloads installed' \
        > "$root/usr/local/share/hackberrypi-pinn/rpios-payloads-installed"
}

# Tests source these functions without touching a block device or network.
if [ "${HB_PINN_TEST:-0}" = 1 ]; then return 0; fi

for argument in "$@"; do
    case "$argument" in
        part1=*) part1=${argument#part1=} ;; part2=*) part2=${argument#part2=} ;;
        id1=*) id1=${argument#id1=} ;; id2=*) id2=${argument#id2=} ;;
        partuuid1=*) partuuid1=${argument#partuuid1=} ;;
        partuuid2=*) partuuid2=${argument#partuuid2=} ;;
    esac
done
: "${part2:?PINN root partition missing}"
: "${id1:?PINN boot identifier missing}"
: "${id2:?PINN root identifier missing}"
boot_id=$(choose_id "${partuuid1:-}" "$id1")
root_id=$(choose_id "${partuuid2:-}" "$id2")
validate_id "$boot_id"; validate_id "$root_id"
case "$part2" in
    /dev/*) [ -b "$part2" ] || fail 'Assigned root is not a block device' ;;
    PARTUUID=?*|UUID=?*|LABEL=?*) validate_id "$part2" ;;
    *) fail 'Invalid assigned root device' ;;
esac
boot_dir=$(pwd)
root_dir=$(mktemp -d /tmp/hackberrypi-rpios-root.XXXXXX)
package_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
release_base='https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/rpios-hackberrypi-2026-11-09'
temporary=''
mounted=false
cleanup() {
    [ -z "$temporary" ] || rm -f "$temporary"
    if [ "$mounted" = true ]; then umount "$root_dir" || true; fi
    rmdir "$root_dir" 2>/dev/null || true
}
trap cleanup EXIT HUP INT TERM
command -v bsdtar >/dev/null || fail 'This PINN build does not include bsdtar'
mount "$part2" "$root_dir"
mounted=true

restoring=${restore:-false}
# Re-running partition setup on an installed root is a repair, even if the
# caller omitted restore=true. Never reset an existing customer's identity.
if [ -f "$root_dir/usr/local/share/hackberrypi-pinn/rpios-payloads-installed" ]; then
    restoring=true
fi
if [ "$restoring" != true ]; then
    install_payloads "$root_dir" "$package_dir" "$release_base"
fi
finalize_installation "$boot_dir" "$root_dir" "$root_id" "$boot_id" "$restoring"
sync
printf '%s\n' 'RPiOS PINN installation complete'
