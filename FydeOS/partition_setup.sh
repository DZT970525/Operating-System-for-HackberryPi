#!/bin/sh
#supports_backup in PINN
# FydeOS four-partition preview; no raw GPT writes.
set -eu
choose_id() { case "$1" in PARTUUID=*) printf '%s\n' "$1";; '') printf '%s\n' "$2";; *) printf 'PARTUUID=%s\n' "$1";; esac; }
part_number() {
 case "$1" in /dev/mmcblk*p[0-9]*|/dev/sd*[0-9]*|/dev/nvme*n*p[0-9]*) n=${1##*[!0-9]};; *) echo 'PINN must supply a real partition path' >&2; return 1;; esac
 case "$n" in ''|0|*[!0-9]*) return 1;; esac
 printf '%s\n' "$n"
}
patch_root() {
 root=$1;boot=$2;root_id=$3;boot_id=$4;bn=$5;rn=$6;sn=$7;on=$8
 sed "s@root=[^ ][^ ]*@root=$root_id@g;s@rootfstype=[^ ][^ ]*@rootfstype=ext4@g" "$boot/cmdline.txt" > "$boot/cmdline.txt.pinn-new"
 mv "$boot/cmdline.txt.pinn-new" "$boot/cmdline.txt"
 # Both dictionaries are consumed by the native C++ startup program.
 j="$root/usr/sbin/partition_vars.json"
 for pair in "STATE:$sn" "ROOT_A:$rn" "OEM:$on" "EFI_SYSTEM:$bn" 'ROOT_B:0' 'ROOT_C:0' 'KERN_A:0' 'KERN_B:0' 'KERN_C:0' 'RWFW:0' 'RESERVED:0'; do
  key=${pair%:*};val=${pair#*:}
  sed "s/\"PARTITION_NUM_$key\"[[:space:]]*:[[:space:]]*\"[0-9][0-9]*\"/\"PARTITION_NUM_$key\": \"$val\"/g" "$j" > "$j.new";cat "$j.new" > "$j";rm -f "$j.new"
  if [ -f "$root/usr/sbin/write_gpt.sh" ]; then
   sed "s/PARTITION_NUM_$key=\"[0-9][0-9]*\"/PARTITION_NUM_$key=\"$val\"/g" "$root/usr/sbin/write_gpt.sh" > "$root/usr/sbin/write_gpt.sh.new";cat "$root/usr/sbin/write_gpt.sh.new" > "$root/usr/sbin/write_gpt.sh";rm -f "$root/usr/sbin/write_gpt.sh.new"
  fi
 done
 sed 's/"FS_FORMAT_ROOT_A"[[:space:]]*:[[:space:]]*"ext2"/"FS_FORMAT_ROOT_A": "ext4"/g' "$j" > "$j.new"
 cat "$j.new" > "$j";rm -f "$j.new"
 sed 's/FS_FORMAT_ROOT_A="ext2"/FS_FORMAT_ROOT_A="ext4"/g' "$root/usr/sbin/write_gpt.sh" > "$root/usr/sbin/write_gpt.sh.new"
 cat "$root/usr/sbin/write_gpt.sh.new" > "$root/usr/sbin/write_gpt.sh";rm -f "$root/usr/sbin/write_gpt.sh.new"
 printf '%s\t/\text4\tro\t0 0\n' "$root_id" > "$root/etc/fstab"
 printf '%s\t/mnt/boot\tvfat\tnoauto,ro\t0 0\n' "$boot_id" >> "$root/etc/fstab"
 mkdir -p "$root/usr/share/hackberry-pinn/original-jobs"
 for job in auto-expand-partition boot-update-firmware os_install_service fwupdtool-update fydeos-scripts-updater; do
  file="$root/etc/init/$job.conf"
  if [ -f "$file" ] && [ ! -f "$root/usr/share/hackberry-pinn/original-jobs/$job.conf" ]; then cp "$file" "$root/usr/share/hackberry-pinn/original-jobs/$job.conf"; fi
  printf '%s\n' 'description "Disabled for PINN multiboot disk protection"' manual task 'exec /bin/false' > "$file"
 done
 # Prevent native whole-disk powerwash/installer paths from touching other OSes.
 for rel in sbin/clobber-state usr/sbin/clobber usr/sbin/chromeos-install usr/sbin/expand-partition.sh usr/sbin/update_kernel.sh usr/sbin/update_dtb.sh; do
  file="$root/$rel"
  if [ -f "$file" ] && [ ! -f "$file.pinn-disabled" ]; then mv "$file" "$file.pinn-disabled"; fi
  printf '%s\n' '#!/bin/sh' 'rm -f /mnt/stateful_partition/factory_install_reset 2>/dev/null || true' 'echo "This operation is disabled in the PINN edition. Reinstall this OS through PINN." >&2' 'exit 1' > "$file";chmod 755 "$file"
 done
 # Keep the genuine update-engine D-Bus API for the first-run wizard, but
 # direct its default checks to a loopback endpoint which never offers updates.
 mkdir -p "$root/usr/share/hackberry-pinn"
 cat > "$root/usr/share/hackberry-pinn/no-update-server.py" <<'PINN_PY'
#!/usr/bin/python3.11
"""Loopback-only no-update endpoint for the PINN edition's OOBE check."""
from http.server import BaseHTTPRequestHandler, HTTPServer
from xml.etree import ElementTree as ET
class Handler(BaseHTTPRequestHandler):
 def do_POST(self):
  try:
   size=int(self.headers.get('Content-Length','0'))
   if not 0<size<=1048576:raise ValueError('size')
   request=ET.fromstring(self.rfile.read(size));response=ET.Element('response',{'protocol':'3.0','server':'pinn-no-update'})
   for app in request.iter():
    if app.tag.rsplit('}',1)[-1]=='app' and app.get('appid'):
     a=ET.SubElement(response,'app',{'appid':app.get('appid'),'status':'ok'});ET.SubElement(a,'updatecheck',{'status':'noupdate'});ET.SubElement(a,'ping',{'status':'ok'})
   data=ET.tostring(response,encoding='utf-8',xml_declaration=True);self.send_response(200);self.send_header('Content-Type','text/xml');self.send_header('Content-Length',str(len(data)));self.end_headers();self.wfile.write(data)
  except (ValueError,ET.ParseError):self.send_error(400)
 def log_message(self,*args):pass
if __name__=='__main__':HTTPServer(('127.0.0.1',18097),Handler).serve_forever()
PINN_PY
 cat > "$root/etc/init/hackberry-pinn-update-server.conf" <<'PINN_JOB'
description "PINN local no-update responder"
start on starting system-services
stop on stopping system-services
respawn
respawn limit 3 60
exec /usr/bin/python3.11 /usr/share/hackberry-pinn/no-update-server.py
PINN_JOB
 cat > "$root/etc/init/update-engine.override" <<'PINN_WAIT'
pre-start script
 start hackberry-pinn-update-server >/dev/null 2>&1 || true
 attempts=0
 while ! /usr/bin/python3.11 -c 'import socket; s=socket.create_connection(("127.0.0.1",18097),1); s.close()' >/dev/null 2>&1; do
  attempts=$((attempts+1))
  [ "$attempts" -lt 15 ] || exit 1
  sleep 1
 done
end script
PINN_WAIT
 sed 's@^CHROMEOS_AUSERVER=.*@CHROMEOS_AUSERVER=http://127.0.0.1:18097/service/update2@' "$root/etc/lsb-release" > "$root/etc/lsb-release.new"
 cat "$root/etc/lsb-release.new" > "$root/etc/lsb-release";rm -f "$root/etc/lsb-release.new"
}
if [ "${HB_PINN_TEST:-0}" = 1 ]; then return 0; fi
for arg in "$@"; do
 case "$arg" in part1=*) part1=${arg#part1=};;part2=*) part2=${arg#part2=};;part3=*) part3=${arg#part3=};;part4=*) part4=${arg#part4=};;id1=*) id1=${arg#id1=};;id2=*) id2=${arg#id2=};; esac
done
: "${part1:?}" "${part2:?}" "${part3:?}" "${part4:?}" "${id1:?}" "${id2:?}"
bn=$(part_number "$part1");rn=$(part_number "$part2");sn=$(part_number "$part3");on=$(part_number "$part4")
[ "$bn" != "$rn" ] && [ "$rn" != "$sn" ] && [ "$sn" != "$on" ] && [ "$bn" != "$sn" ] && [ "$bn" != "$on" ] && [ "$rn" != "$on" ]
boot=$(pwd);root=$(mktemp -d /tmp/hackberry-fyde-root.XXXXXX)
cleanup() { umount "$root" 2>/dev/null || true;rmdir "$root" 2>/dev/null || true; }
trap cleanup EXIT HUP INT TERM
mount "$part2" "$root"
base='https://github.com/DZT970525/Operating-System-for-HackberryPi/releases/download/fydeos-factory-pinn-2026-10-26'
package_dir=$(dirname "$0")
if [ "${restore:-false}" != true ] || [ ! -f "$root/usr/share/hackberry-pinn/payloads-installed" ]; then
 mkdir -p "$root/var/tmp"
 while read -r expected name; do
  [ -n "$name" ] || continue
  tmp="$root/var/tmp/.pinn-$name"
  echo "Fyde OS: installing $name"
  if [ -f "$package_dir/$name" ]; then cp "$package_dir/$name" "$tmp";else wget --no-verbose --retry-connrefused --read-timeout=120 --tries=5 -O "$tmp" "$base/$name";fi
  printf '%s  %s\n' "$expected" "$tmp" | sha256sum -c -
  bsdtar -xpf "$tmp" -C "$root";rm -f "$tmp"
 done <<'PAYLOADS'
b137df815a05f62db8be19cffe2dc8cb3abc443b62f444f3143ecc5460acd076 hbf_apps.tar.gz
99f609b811556f8b18c53c902abb5a5a3ac030c515be3c546071e3a91758b5c3 hbf_runtime.tar.gz
e30cd601fba6a11ee3b2c65442827d311dbc2ccb661def98118e7a7a0e5be867 hbf_share.tar.gz
PAYLOADS
fi
patch_root "$root" "$boot" "$(choose_id "${partuuid2:-}" "$id2")" "$(choose_id "${partuuid1:-}" "$id1")" "$bn" "$rn" "$sn" "$on"
mkdir -p "$root/usr/share/hackberry-pinn"
printf '%s\n' 'Fyde OS PINN payloads installed' > "$root/usr/share/hackberry-pinn/payloads-installed"
sync
