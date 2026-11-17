#!/bin/bash
# Bootstrap only the signed HackberryPi battery APT source.
set -Eeuo pipefail
readonly base_url='https://raw.githubusercontent.com/DZT970525/Operating-System-for-HackberryPi/main/drivers/battery/apt'

fail() { printf 'Battery setup: %s\n' "$*" >&2; exit 1; }

check_hardware() {
    # The optional function argument is for isolated fixtures; main always uses /.
    python3 - "${1:-/}" <<'PY'
import os, shlex, sys
from pathlib import Path
root = Path(sys.argv[1])
values = {}
for line in (root / 'etc/os-release').read_text().splitlines():
    if '=' in line and not line.startswith('#'):
        key, value = line.split('=', 1)
        words = shlex.split(value)
        values[key] = words[0] if words else ''
if values.get('ID') not in ('debian', 'raspbian') or values.get('VERSION_CODENAME') != 'bookworm' or not (root / 'etc/rpi-issue').is_file():
    sys.exit('This installer requires Raspberry Pi OS Bookworm.')
trees = [root / 'sys/firmware/devicetree/base', root / 'proc/device-tree']
tree = next((p for p in trees if (p / 'model').is_file()), None)
if tree is None or not (tree / 'model').read_bytes().rstrip(b'\0').startswith(b'Raspberry Pi Compute Module 5'):
    sys.exit('This installer requires a running Raspberry Pi Compute Module 5.')
if b'raspberrypi,5-compute-module' not in (tree / 'compatible').read_bytes().split(b'\0'):
    sys.exit('The running CM5 device tree could not be confirmed.')
for directory, _, files in os.walk(tree, followlinks=False):
    if 'compatible' in files and b'hackberrypi,max17048-battery' in (Path(directory) / 'compatible').read_bytes().split(b'\0'):
        break
else:
    sys.exit('The HackberryPi MAX17048 battery overlay is missing. Use the HackberryPi CM5 system image first.')
PY
}

verify_file() {
    local actual
    actual=$(sha256sum -- "$1")
    [[ ${actual%% *} == "$2" ]] || fail "Checksum verification failed: ${1##*/}"
}

check_destination() {
    local source=$1 destination=$2
    if [[ -e $destination || -L $destination ]]; then
        [[ -f $destination && ! -L $destination ]] && cmp -s -- "$source" "$destination" ||
            fail "Existing configuration differs; review it before retrying: $destination"
    fi
}

install_config() {
    local staged
    staged=$(mktemp "${2}.XXXXXX")
    install -m 0644 -- "$1" "$staged"
    mv -fT -- "$staged" "$2"
}

main() {
    [[ $EUID == 0 ]] || fail 'Run this installer with sudo bash.'
    for program in python3 curl sha256sum dpkg mktemp install cmp mv apt-get flock; do
        command -v "$program" >/dev/null || fail "Required system tool is missing: $program"
    done
    [[ $(dpkg --print-architecture) == arm64 ]] || fail 'This installer requires the ARM64 system image.'
    check_hardware /
    local temporary file
    temporary=$(mktemp -d /tmp/hackberrypi-battery.XXXXXX)
    trap 'rm -rf -- "${temporary:-}"' EXIT
    for file in hackberrypi-battery.gpg hackberrypi-battery.list hackberrypi-battery.pref; do
        curl --proto '=https' --proto-redir '=https' --tlsv1.2 --fail --location --silent --show-error \
            --connect-timeout 15 --max-time 90 --retry 2 --retry-delay 2 --retry-max-time 180 \
            "$base_url/$file" --output "$temporary/$file"
    done
    verify_file "$temporary/hackberrypi-battery.gpg" '2d9bdc643a55b6945e6223f6fa1bffcb48140e0ab91d86364696c502a72d239a'
    verify_file "$temporary/hackberrypi-battery.list" '54a1c41367b8ba9164b9aa40ad5768a7ff0ccdbe70d11d4d522011a9646cd794'
    verify_file "$temporary/hackberrypi-battery.pref" '17897b126a7bdf4167a0ea2abe7e55ff3699c4fe06d1fec5e1d320738db0f9ad'
    exec 9>/run/lock/hackberrypi-battery-bootstrap.lock
    flock -x -w 30 9 || fail 'Another battery setup is still running.'
    # Preflight all destinations before changing any APT configuration.
    for file in /etc/apt/keyrings /etc/apt/sources.list.d /etc/apt/preferences.d; do
        [[ ! -L $file ]] || fail "APT configuration directory is a symbolic link: $file"
    done
    check_destination "$temporary/hackberrypi-battery.gpg" /etc/apt/keyrings/hackberrypi-battery.gpg
    check_destination "$temporary/hackberrypi-battery.list" /etc/apt/sources.list.d/hackberrypi-battery.list
    check_destination "$temporary/hackberrypi-battery.pref" /etc/apt/preferences.d/hackberrypi-battery
    install -d -m 0755 /etc/apt/keyrings /etc/apt/sources.list.d /etc/apt/preferences.d
    install_config "$temporary/hackberrypi-battery.gpg" /etc/apt/keyrings/hackberrypi-battery.gpg
    install_config "$temporary/hackberrypi-battery.pref" /etc/apt/preferences.d/hackberrypi-battery
    install_config "$temporary/hackberrypi-battery.list" /etc/apt/sources.list.d/hackberrypi-battery.list
    apt-get -o Acquire::Retries=2 -o Acquire::https::Timeout=30 -o Acquire::http::Timeout=30 update
    apt-get install -y --no-install-recommends hackberrypi-battery-dkms
    printf '\nBattery driver installed. Restart when convenient to check the battery indicator.\n'
    rm -rf -- "$temporary"
    trap - EXIT
}

main "$@"
