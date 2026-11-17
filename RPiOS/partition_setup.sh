#!/bin/sh
#supports_backup in PINN
# PINN owns partition allocation; this adapter never changes a partition table.
set -eu
umask 022
OLD_RELEASE='https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/rpios-hackberrypi-2026-11-09'
NEW_RELEASE='https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/rpios-battery-dkms-hackberrypi-2026-11-17'
DELTA_SHA256='cbd50d9dcf58a374a8409f38c9bf0ff82dafd83d58a873ae096b22c2bd006a9d'
DELETIONS_SHA256='e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855'
FRESH_MARKER='HackberryPi RPiOS battery DKMS fresh-install bootstrap v1'

fail() { printf 'RPiOS PINN: %s\n' "$*" >&2; exit 1; }

# Never traverse a guest symlink into the installer's own filesystem.
inside_path() (
    target_root=$1; relative=$2
    [ -d "$target_root" ] && [ ! -L "$target_root" ] || fail 'Invalid target root'
    case "$relative" in ''|/*|*/|*[!A-Za-z0-9._/+:@%={}-]*) fail 'Unsafe relative path' ;; esac
    case "/$relative/" in *'/../'*|*'/./'*|*'//'*) fail 'Non-canonical relative path' ;; esac
    parent="$target_root"
    remainder=$relative
    while [ "${remainder#*/}" != "$remainder" ]; do
        component=${remainder%%/*}; remainder=${remainder#*/}
        parent="$parent/$component"
        [ ! -L "$parent" ] || fail 'A target parent is a symlink'
        [ ! -e "$parent" ] || [ -d "$parent" ] || fail 'A target parent is not a directory'
    done
    printf '%s/%s\n' "$target_root" "$relative"
)

safe_unlink() {
    unlink_path=$(inside_path "$1" "$2")
    [ ! -d "$unlink_path" ] || [ -L "$unlink_path" ] || fail 'Refusing to unlink an unexpected directory'
    rm -f -- "$unlink_path"
}

ensure_target_dir() {
    directory_path=$(inside_path "$1" "$2")
    [ ! -L "$directory_path" ] || fail 'A target directory is a symlink'
    [ ! -e "$directory_path" ] || [ -d "$directory_path" ] || fail 'A target directory is not a directory'
    mkdir -p -- "$directory_path"
}

require_fresh_target() {
    target=$1
    marker=$(inside_path "$target" pinn-battery-fresh-install)
    [ -f "$marker" ] && [ ! -L "$marker" ] || fail 'Fresh bootstrap marker is missing'
    [ "$(cat "$marker")" = "$FRESH_MARKER" ] || fail 'Unexpected fresh bootstrap marker'
    for child in "$target"/* "$target"/.[!.]* "$target"/..?*; do
        [ -e "$child" ] || [ -L "$child" ] || continue
        case "${child##*/}" in
            pinn-payloads.sha256|pinn-battery-deletions.tsv|pinn-battery-fresh-install)
                [ -f "$child" ] && [ ! -L "$child" ] || fail 'Invalid bootstrap file' ;;
            lost+found) [ -d "$child" ] && [ ! -L "$child" ] || fail 'Invalid filesystem directory' ;;
            *) fail 'Refusing to apply a fresh image over existing target files' ;;
        esac
    done
}

apply_fresh_deletions() {
    target=$1; deletion_file=$2; deletion_hash=$3
    [ ! -e "$target/usr/local/share/hackberrypi-pinn/rpios-payloads-installed" ] || fail 'Deletion delta is not a repair operation'
    marker=$(inside_path "$target" pinn-battery-fresh-install)
    [ -f "$marker" ] && [ ! -L "$marker" ] && [ "$(cat "$marker")" = "$FRESH_MARKER" ] || fail 'No fresh-install authorization'
    [ -f "$deletion_file" ] && [ ! -L "$deletion_file" ] || fail 'Deletion manifest is missing'
    printf '%s  %s\n' "$deletion_hash" "$deletion_file" | sha256sum -c - >/dev/null
    tab=$(printf '\t')
    while IFS="$tab" read -r kind relative extra || [ -n "$kind$relative$extra" ]; do
        [ -n "$kind$relative$extra" ] || continue
        [ -z "$extra" ] || fail 'Unexpected deletion manifest field'
        path=$(inside_path "$target" "$relative")
        case "$kind" in
            file|symlink|fifo|character|block)
                if [ -e "$path" ] || [ -L "$path" ]; then
                    [ ! -d "$path" ] || [ -L "$path" ] || fail 'Deletion would remove an unexpected directory'
                    rm -f -- "$path"
                fi ;;
            directory)
                if [ -e "$path" ] || [ -L "$path" ]; then
                    [ -d "$path" ] && [ ! -L "$path" ] || fail 'Deletion expected a plain directory'
                    rmdir -- "$path" || fail 'Deletion directory contains unexpected files'
                fi ;;
            *) fail 'Unsupported deletion record' ;;
        esac
    done < "$deletion_file"
}

payload_hash() {
    case "$1" in
        hbr_payload_01.tar.gz) printf '%s\n' d31135219ea0634878664581d467fec1fc42cfd66fb741e720c8d37ce1dcb7e1 ;;
        hbr_payload_02.tar.gz) printf '%s\n' de66ed7b989d7063be91aa3903e0de108a17490a08ef534a80c40115d6994e8a ;;
        hbr_payload_03.tar.gz) printf '%s\n' f8f24cb1a3b6fbeeba2e9e8bfdb9323e15a760bfec26d8af44489e20e7f9ae1c ;;
        hbr_payload_04.tar.gz) printf '%s\n' eae43eb2e221349638af940cdcc0481e8351da6fe8049e3955631c7b38c0c0ed ;;
        hbr_payload_05.tar.gz) printf '%s\n' "$DELTA_SHA256" ;;
        *) fail 'Unsupported payload name' ;;
    esac
}

payload_url() {
    case "$1" in
        hbr_payload_0[1-4].tar.gz) printf '%s/%s\n' "$OLD_RELEASE" "$1" ;;
        hbr_payload_05.tar.gz) printf '%s/%s\n' "$NEW_RELEASE" "$1" ;;
        *) fail 'Unsupported payload URL' ;;
    esac
}

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
        hbr_payload_0[1-5].tar.gz) ;;
        *) fail 'Unsupported payload filename' ;;
    esac
}

patch_paths() {
    boot=$1; root=$2; root_id=$3; boot_id=$4
    validate_id "$root_id"; validate_id "$boot_id"
    [ -f "$boot/cmdline.txt" ] || fail 'Native boot cmdline is missing'
    [ ! -L "$boot/cmdline.txt" ] || fail 'Native cmdline must not be a symlink'
    inside_path "$root" etc/fstab >/dev/null
    [ ! -L "$root/etc/fstab" ] || fail 'Native fstab must not be a symlink'
    [ ! -e "$boot/cmdline.txt.pinn-new" ] && [ ! -L "$boot/cmdline.txt.pinn-new" ] || fail 'Staged cmdline already exists'
    [ ! -e "$root/etc/fstab.pinn-new" ] && [ ! -L "$root/etc/fstab.pinn-new" ] || fail 'Staged fstab already exists'
    awk -v r="$root_id" '
      BEGIN {roots=0;types=0;minors=0;lines=0}
      NF {
        lines++; out=""
        for(i=1;i<=NF;i++) {
          if($i ~ /^root=/) {$i="root=" r; roots++}
          else if($i ~ /^rootfstype=/) {$i="rootfstype=ext4"; types++}
          else if($i ~ /^mmcblk.perdev_minors=/) {$i="mmcblk.perdev_minors=64"; minors++}
          else if($i=="init=/usr/lib/raspi-config/init_resize.sh") {continue}
          out=out (out=="" ? "" : " ") $i
        }
        if(!types) {out=out " rootfstype=ext4"; types=1}
        if(!minors) {out=out " mmcblk.perdev_minors=64"; minors=1}
        print out
      }
      END {if(lines!=1 || roots!=1 || types!=1 || minors!=1)exit 1}' \
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
    for relative in etc/systemd/system/multi-user.target.wants/hackberrypi-image-grow.service \
                    etc/systemd/system/hackberrypi-image-grow.service usr/local/sbin/hackberrypi-image-grow \
                    etc/hackberrypi/image-first-boot etc/init.d/resize2fs_once; do
        safe_unlink "$root" "$relative"
    done
    for cache in "$root"/usr/local/sbin/__pycache__/hackberrypi-image-grow.*.pyc; do
        [ ! -e "$cache" ] && [ ! -L "$cache" ] || safe_unlink "$root" "${cache#"$root/"}"
    done
    for link in "$root"/etc/rc[0-6S].d/*resize2fs_once; do
        [ ! -L "$link" ] || safe_unlink "$root" "${link#"$root/"}"
    done
}

install_identity_firstboot() {
    root=$1
    inside_path "$root" usr/local/sbin/hackberrypi-rpios-firstboot >/dev/null
    inside_path "$root" etc/systemd/system/hackberrypi-rpios-firstboot.service >/dev/null
    # Keep the sanitized distribution's separate, identity-only helper intact.
    [ -x "$root/usr/local/sbin/hackberrypi-rpios-firstboot" ] \
        && [ -f "$root/etc/systemd/system/hackberrypi-rpios-firstboot.service" ] \
        || fail 'RPiOS identity initialization helper is missing'
    ensure_target_dir "$root" etc/hackberrypi
    ensure_target_dir "$root" etc/systemd/system/multi-user.target.wants
    safe_unlink "$root" etc/systemd/system/multi-user.target.wants/hackberrypi-rpios-firstboot.service
    ln -s ../hackberrypi-rpios-firstboot.service \
        "$root/etc/systemd/system/multi-user.target.wants/hackberrypi-rpios-firstboot.service"
    printf '%s\n' 'Initialize a new device identity on first boot.' > "$root/etc/hackberrypi/rpios-identity-first-boot"
    safe_unlink "$root" etc/machine-id
    : > "$root/etc/machine-id"
    chmod 0444 "$root/etc/machine-id"
    ensure_target_dir "$root" var/lib/dbus
    safe_unlink "$root" var/lib/dbus/machine-id
    ln -s /etc/machine-id "$root/var/lib/dbus/machine-id"
    for key in "$root"/etc/ssh/ssh_host_*; do
        [ ! -e "$key" ] && [ ! -L "$key" ] || safe_unlink "$root" "${key#"$root/"}"
    done
    safe_unlink "$root" var/lib/systemd/random-seed
    safe_unlink "$root" var/lib/systemd/credential.secret
}

install_payloads() {
    root=$1; package=$2
    manifest="$root/pinn-payloads.sha256"
    [ -s "$manifest" ] || fail 'PINN bootstrap payload manifest is missing'
    count=0
    while read -r expected filename extra || [ -n "$expected$filename$extra" ]; do
        [ -n "$expected" ] || continue
        case "$expected" in \#*) continue ;; esac
        validate_payload "$expected" "$filename" "$extra"
        count=$((count+1))
        [ "$count" -le 5 ] && [ "$filename" = "$(printf 'hbr_payload_%02d.tar.gz' "$count")" ] || fail 'Payload order/count differs'
        [ "$expected" = "$(payload_hash "$filename")" ] || fail 'Payload hash differs from the pinned release'
        temporary="$root/.pinn-download-$filename"
        [ ! -L "$temporary" ] || fail 'Download destination is a symlink'
        printf 'RPiOS PINN: installing %s\n' "$filename"
        if [ -f "$package/$filename" ] && [ ! -L "$package/$filename" ]; then
            cp "$package/$filename" "$temporary"
        else
            wget --retry-connrefused --read-timeout=120 --tries=5 \
                -O "$temporary" "$(payload_url "$filename")"
        fi
        printf '%s  %s\n' "$expected" "$temporary" | sha256sum -c -
        if [ "$filename" = hbr_payload_05.tar.gz ]; then
            apply_fresh_deletions "$root" "$root/pinn-battery-deletions.tsv" "$DELETIONS_SHA256"
        fi
        bsdtar --numeric-owner -xpf "$temporary" -C "$root"
        rm -f "$temporary"
        temporary=''
    done < "$manifest"
    [ "$count" -eq 5 ] || fail 'Payload manifest did not contain all five archives'
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
    ensure_target_dir "$root" usr/local/share/hackberrypi-pinn
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
: "${part1:?PINN boot partition missing}"
: "${id1:?PINN boot identifier missing}"
: "${id2:?PINN root identifier missing}"
boot_id=$(choose_id "${partuuid1:-}" "$id1")
root_id=$(choose_id "${partuuid2:-}" "$id2")
validate_id "$boot_id"; validate_id "$root_id"
part1=$(readlink -f "$part1"); part2=$(readlink -f "$part2")
[ -b "$part1" ] && [ -b "$part2" ] && [ "$part1" != "$part2" ] || fail 'Two allocated block partitions are required'
name1=${part1##*/}; name2=${part2##*/}
sys1=$(readlink -f "/sys/class/block/$name1"); sys2=$(readlink -f "/sys/class/block/$name2")
[ -f "$sys1/partition" ] && [ -f "$sys2/partition" ] || fail 'Whole disks are not installation targets'
[ "${sys1%/*}" = "${sys2%/*}" ] || fail 'Assigned boot/root are on different disks'
[ "$(cat "$sys1/partition")" -ge 6 ] && [ "$(cat "$sys2/partition")" -ge 6 ] || fail 'PINN logical partitions must be at least 6'
boot_dir=$(pwd)
root_dir=$(mktemp -d /tmp/hackberrypi-rpios-root.XXXXXX)
package_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
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
    require_fresh_target "$root_dir"
    install_payloads "$root_dir" "$package_dir"
fi
finalize_installation "$boot_dir" "$root_dir" "$root_id" "$boot_id" "$restoring"
sync
printf '%s\n' 'RPiOS PINN installation complete'
