#!/bin/sh
# Fresh PINN installs only: Btrfs subvolume backups are not advertised.
set -eu
umask 022

fail() { printf 'Omarchy PINN: %s\n' "$*" >&2; exit 1; }

choose_id() {
    case "$1" in
        PARTUUID=*) printf '%s\n' "$1" ;;
        '') printf '%s\n' "$2" ;;
        *) printf 'PARTUUID=%s\n' "$1" ;;
    esac
}

validate_id() {
    case "$1" in
        PARTUUID=?*|UUID=?*|LABEL=?*) ;;
        *) fail 'Invalid partition identifier' ;;
    esac
    case "$1" in *[!A-Za-z0-9_=.:+-]*) fail 'Unsafe partition identifier' ;; esac
}

validate_payload() {
    expected=$1; filename=$2; extra=${3:-}
    [ ${#expected} -eq 64 ] || fail 'Invalid payload SHA-256 length'
    case "$expected" in *[!0-9a-f]*) fail 'Invalid payload SHA-256' ;; esac
    [ -z "$extra" ] || fail 'Unexpected payload manifest field'
    case "$filename" in
        ''|.*|-*|*[!A-Za-z0-9._-]*) fail 'Unsafe payload filename' ;;
        *.tar.gz|*.tar.xz) ;;
        *) fail 'Unsupported payload archive' ;;
    esac
}

ensure_subvolume() {
    path=$1
    [ ! -L "$path" ] || fail 'Subvolume path must not be a symlink'
    if [ -e "$path" ]; then
        if btrfs subvolume show "$path" >/dev/null 2>&1; then
            return
        fi
        # An empty bootstrap directory can be replaced safely. Never flatten,
        # copy or erase a populated ordinary directory (including a backup).
        rmdir "$path" || fail 'Populated plain directory cannot become a Btrfs subvolume'
    fi
    btrfs subvolume create "$path"
    chmod 0755 "$path"
}

patch_paths() {
    boot=$1; root=$2; root_id=$3; boot_id=$4
    validate_id "$root_id"; validate_id "$boot_id"
    [ -f "$boot/cmdline.txt" ] || fail 'Native boot cmdline is missing'
    awk -v r="$root_id" '
      BEGIN {root=0;flags=0;fstype=0}
      {for(i=1;i<=NF;i++) {
         if($i ~ /^root=/) {$i="root=" r;root++}
         else if($i ~ /^rootflags=/) {$i="rootflags=subvol=@";flags++}
         else if($i ~ /^rootfstype=/) {$i="rootfstype=btrfs";fstype++}
       }
       if(!flags) {$0=$0 " rootflags=subvol=@";flags=1}
       if(!fstype) {$0=$0 " rootfstype=btrfs";fstype=1}
       print}
      END {if(root!=1 || flags!=1 || fstype!=1)exit 1}' \
      "$boot/cmdline.txt" > "$boot/cmdline.txt.pinn-new" || fail 'Unexpected native root command line'
    mv "$boot/cmdline.txt.pinn-new" "$boot/cmdline.txt"
    [ -f "$root/etc/fstab" ] || fail 'Root fstab is missing'
    awk -v r="$root_id" -v b="$boot_id" '
      BEGIN {OFS="\t";nr=0;nh=0;nl=0;np=0;nb=0}
      /^[[:space:]]*#/ || NF<2 {print;next}
      $2=="/" {$1=r;$3="btrfs";$4="noatime,compress=zstd:3,subvol=@";nr++}
      $2=="/home" {$1=r;$3="btrfs";$4="noatime,compress=zstd:3,subvol=@home";nh++}
      $2=="/var/log" {$1=r;$3="btrfs";$4="noatime,compress=zstd:3,subvol=@log";nl++}
      $2=="/var/cache/pacman/pkg" {$1=r;$3="btrfs";$4="noatime,compress=zstd:3,subvol=@pkg";np++}
      $2=="/boot/firmware" {$1=b;$3="vfat";nb++}
      {print}
      END {if(nr!=1 || nh!=1 || nl!=1 || np!=1 || nb!=1)exit 1}' \
      "$root/etc/fstab" > "$root/etc/fstab.pinn-new" || fail 'Unexpected Btrfs mount layout'
    mv "$root/etc/fstab.pinn-new" "$root/etc/fstab"
}

install_identity_firstboot() {
    root=$1
    [ -d "$root/etc/hackberrypi" ] || fail 'HackberryPi configuration missing'
    [ -d "$root/usr/local/sbin" ] || fail 'HackberryPi helper directory missing'
    # The tested standalone image grows partition 2. PINN owns allocation and
    # may install this root on any logical partition; never run that helper.
    rm -f "$root/usr/local/sbin/hackberrypi-image-grow"
    rm -f "$root"/usr/local/sbin/__pycache__/hackberrypi-image-grow.*.pyc
    cat > "$root/usr/local/sbin/hackberrypi-image-firstboot" <<'FIRSTBOOT'
#!/bin/bash
set -euo pipefail
test -f /etc/hackberrypi/image-first-boot || exit 0
if [[ ! -f /etc/hackberrypi/image-keyring-ready ]]; then
    install -d -m 0700 /etc/pacman.d/gnupg
    pacman-key --init
    pacman-key --populate archlinux archlinuxarm omarchy
    ssh-keygen -A
    touch /etc/hackberrypi/image-keyring-ready
fi
# No partition resize here: PINN has already allocated the filesystem.
rm -f /etc/hackberrypi/image-first-boot
FIRSTBOOT
    chmod 0755 "$root/usr/local/sbin/hackberrypi-image-firstboot"
    cat > "$root/etc/systemd/system/hackberrypi-image-grow.service" <<'UNIT'
[Unit]
Description=Initialize a fresh HackberryPi Omarchy PINN device identity
After=local-fs.target
Before=display-manager.service
ConditionPathExists=/etc/hackberrypi/image-first-boot

[Service]
Type=oneshot
ExecStart=/usr/local/sbin/hackberrypi-image-firstboot
TimeoutStartSec=300

[Install]
WantedBy=multi-user.target
UNIT
    mkdir -p "$root/etc/systemd/system/multi-user.target.wants"
    ln -sfn ../hackberrypi-image-grow.service "$root/etc/systemd/system/multi-user.target.wants/hackberrypi-image-grow.service"
    printf '%s\n' 'Initialize identity once; partition sizing belongs to PINN.' > "$root/etc/hackberrypi/image-first-boot"
    rm -f "$root/etc/hackberrypi/image-keyring-ready"
    rm -f "$root/etc/machine-id"
    : > "$root/etc/machine-id"
    chmod 0444 "$root/etc/machine-id"
    mkdir -p "$root/var/lib/dbus"
    rm -f "$root/var/lib/dbus/machine-id"
    ln -s /etc/machine-id "$root/var/lib/dbus/machine-id"
    rm -f "$root"/etc/ssh/ssh_host_*
    rm -f "$root/var/lib/systemd/random-seed" "$root/var/lib/systemd/credential.secret"
    rm -rf "$root/etc/pacman.d/gnupg"
}

# Tests source these functions without touching a block device or network.
if [ "${HB_PINN_TEST:-0}" = 1 ]; then return 0; fi

# PINN's plain tar backups cannot recreate subvolume identity. Fail before
# mounting anything instead of risking an unbootable or erased user restore.
[ "${restore:-false}" != true ] || fail 'PINN backup restore is not supported by this edition'

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
boot_dir=$(pwd)
root_dir=$(mktemp -d /tmp/hackberrypi-omarchy-root.XXXXXX)
package_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
release_base='https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/omarchy-hackberrypi-2026-11-09'
temporary=''
mounted=false
cleanup() {
    [ -z "$temporary" ] || rm -f "$temporary"
    if [ "$mounted" = true ]; then umount "$root_dir" || true; fi
    rmdir "$root_dir" 2>/dev/null || true
}
trap cleanup EXIT HUP INT TERM
command -v btrfs >/dev/null || fail 'This PINN build does not include Btrfs tools'
command -v bsdtar >/dev/null || fail 'This PINN build does not include bsdtar'
mount -o subvolid=5,compress=zstd:3 "$part2" "$root_dir"
mounted=true
btrfs filesystem show "$root_dir" >/dev/null || fail 'Assigned root is not a Btrfs filesystem'
manifest="$root_dir/pinn-payloads.sha256"
[ -s "$manifest" ] || fail 'PINN bootstrap payload manifest is missing'
for volume in @ @home @log @pkg; do ensure_subvolume "$root_dir/$volume"; done

count=0
while read -r expected filename extra || [ -n "$expected$filename$extra" ]; do
    [ -n "$expected" ] || continue
    case "$expected" in \#*) continue ;; esac
    validate_payload "$expected" "$filename" "$extra"
    temporary="$root_dir/.pinn-download-$filename"
    printf 'Omarchy PINN: installing %s\n' "$filename"
    if [ -f "$package_dir/$filename" ]; then
        cp "$package_dir/$filename" "$temporary"
    else
        wget --retry-connrefused --read-timeout=120 --tries=5 -O "$temporary" "$release_base/$filename"
    fi
    printf '%s  %s\n' "$expected" "$temporary" | sha256sum -c -
    bsdtar --numeric-owner -xpf "$temporary" -C "$root_dir"
    rm -f "$temporary"
    temporary=''
    count=$((count+1))
done < "$manifest"
[ "$count" -gt 0 ] || fail 'Payload manifest contained no archives'
for volume in @ @home @log @pkg; do
    btrfs subvolume show "$root_dir/$volume" >/dev/null || fail 'A required subvolume is missing'
done
patch_paths "$boot_dir" "$root_dir/@" "$root_id" "$boot_id"
install_identity_firstboot "$root_dir/@"
mkdir -p "$root_dir/@/usr/local/share/hackberrypi-pinn"
printf '%s\n' 'Omarchy HackberryPi PINN payloads installed' > "$root_dir/@/usr/local/share/hackberrypi-pinn/payloads-installed"
sync
printf '%s\n' 'Omarchy PINN installation complete'
