#!/bin/sh
#supports_backup in PINN
# Draft for a complete, sanitized Manjaro root payload extracted by PINN.
# PINN owns partition allocation. This adapter never writes a partition table.
set -eu
umask 022

fail() { printf 'Manjaro PINN: %s\n' "$*" >&2; exit 1; }

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

patch_paths() {
    boot=$1; root=$2; root_id=$3; boot_id=$4
    validate_id "$root_id"; validate_id "$boot_id"
    [ -f "$boot/cmdline.txt" ] && [ ! -L "$boot/cmdline.txt" ] || fail 'Native cmdline missing or symlinked'
    [ -f "$root/etc/fstab" ] && [ ! -L "$root/etc/fstab" ] || fail 'Native fstab missing or symlinked'
    [ ! -e "$boot/cmdline.txt.pinn-new" ] && [ ! -L "$boot/cmdline.txt.pinn-new" ] || fail 'Unexpected staged cmdline'
    [ ! -e "$root/etc/fstab.pinn-new" ] && [ ! -L "$root/etc/fstab.pinn-new" ] || fail 'Unexpected staged fstab'
    awk -v r="$root_id" '
      BEGIN {roots=0;types=0;lines=0}
      NF {
        lines++; out=""
        for(i=1;i<=NF;i++) {
          if($i ~ /^root=/) {$i="root=" r; roots++}
          else if($i ~ /^rootfstype=/) {$i="rootfstype=ext4"; types++}
          else if($i ~ /^init=.*(resize|grow)/) {exit 1}
          out=out (out=="" ? "" : " ") $i
        }
        if(!types) {out=out " rootfstype=ext4"; types=1}
        print out
      }
      END {if(lines!=1 || roots!=1 || types!=1)exit 1}' \
      "$boot/cmdline.txt" > "$boot/cmdline.txt.pinn-new" || fail 'Unexpected native root command line'
    awk -v r="$root_id" -v b="$boot_id" '
      BEGIN {OFS="\t";nr=0;nb=0}
      /^[[:space:]]*#/ || NF<2 {print;next}
      $2=="/" {$1=r;$3="ext4";nr++}
      $2=="/boot" {$1=b;$3="vfat";nb++}
      {print}
      END {if(nr!=1 || nb!=1)exit 1}' \
      "$root/etc/fstab" > "$root/etc/fstab.pinn-new" || fail 'Unexpected Manjaro mount layout'
    mv "$boot/cmdline.txt.pinn-new" "$boot/cmdline.txt"
    mv "$root/etc/fstab.pinn-new" "$root/etc/fstab"
}

disable_standalone_growth() {
    root=$1
    rm -f "$root/etc/systemd/system/multi-user.target.wants/hackberrypi-manjaro-image-grow.service"
    rm -f "$root/etc/systemd/system/hackberrypi-manjaro-image-grow.service"
    rm -f "$root/usr/local/sbin/hackberrypi-manjaro-image-grow"
    rm -f "$root"/usr/local/sbin/__pycache__/hackberrypi-manjaro-image-grow.*.pyc
    rm -f "$root/etc/hackberrypi/manjaro-image-first-boot"
    rm -f "$root/etc/hackberrypi/manjaro-image-growth-state.json"
    rm -f "$root/etc/hackberrypi/image-layout.json"
    # Preserve /etc/hackberrypi/provisioned and the vendor resize.service guard.
    # This adapter never invokes the OEM keyring-generation script.
}

finalize_installation() {
    boot=$1; root=$2; root_id=$3; boot_id=$4
    [ -f "$root/etc/hackberrypi/provisioned" ] || fail 'OEM provisioning completion marker missing'
    [ -f "$root/etc/systemd/system/resize.service.d/90-hackberrypi-complete.conf" ] \
      && grep -qx 'ConditionPathExists=!/etc/hackberrypi/provisioned' \
         "$root/etc/systemd/system/resize.service.d/90-hackberrypi-complete.conf" \
      || fail 'OEM resize suppression is missing'
    [ -f "$root/usr/local/lib/hackberrypi/display_control.py" ] || fail 'Manjaro display payload missing'
    patch_paths "$boot" "$root" "$root_id" "$boot_id"
    disable_standalone_growth "$root"
    mkdir -p "$root/usr/local/share/hackberrypi-pinn"
    printf '%s\n' 'Manjaro HackberryPi PINN root installed; PINN owns all partition sizes.' \
      > "$root/usr/local/share/hackberrypi-pinn/manjaro-installed"
    # Sanitized root payload already carries an identity-only first-boot helper.
    # Preserve it unchanged, especially on backup/restore; never erase live keys here.
}

# Unit tests source functions only; no mount or network operations are performed.
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
    /dev/*) [ -b "$part2" ] || fail 'Assigned root is not a block partition' ;;
    PARTUUID=?*|UUID=?*|LABEL=?*) validate_id "$part2" ;;
    *) fail 'Invalid assigned root' ;;
esac
boot_dir=$(pwd)
root_dir=$(mktemp -d /tmp/hackberrypi-manjaro-root.XXXXXX)
mounted=false
cleanup() {
    if [ "$mounted" = true ]; then umount "$root_dir" || true; fi
    rmdir "$root_dir" 2>/dev/null || true
}
trap cleanup EXIT HUP INT TERM
mount "$part2" "$root_dir"
mounted=true
finalize_installation "$boot_dir" "$root_dir" "$root_id" "$boot_id"
sync
printf '%s\n' 'Manjaro PINN installation complete'
