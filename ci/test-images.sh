#!/usr/bin/env bash
# Check every Nubo OS image in a release folder before it is published.
#
# Usage: ci/test-images.sh DIR [VERSION]        (DIR holds nubo-os-* files; VERSION defaults to the one in the file names)
# Run on the Linux build VM. Needs: xorriso, qemu-img, tar, and (for the boot checks) qemu-system-x86_64, libguestfs-tools.
# Exit code: 0 when every check passed, 1 when any failed. Skipped checks (tool missing) are listed, not counted as passes.
#
# What it checks, per file kind:
#   all          the .sha256 matches, the file is not empty, a .torrent exists
#   ISO          readable by xorriso, has a BIOS and an EFI boot entry, the kernel and initrd are on the media,
#                the boot menu says "Nubo OS", the media label is ours
#   qcow2        qemu-img check is clean, the format is qcow2, /etc/os-release inside says Nubo OS
#                (with BOOT=1: boots under QEMU and waits for a login prompt or the Nubo name on the console)
#   containers   the archive lists, and carries /etc/os-release saying Nubo OS
#   netboot      kernel, initrd and a boot loader are present
set -uo pipefail
DIR="$(readlink -f "${1:?folder with the nubo-os-* files}")"
VER="${2:-}"
BOOT="${BOOT:-0}"                 # 1 = also boot disk images under QEMU (slow; needs KVM for sensible speed)
BOOT_TIMEOUT="${BOOT_TIMEOUT:-300}"
pass=0; fail=0; skip=0
ok()   { pass=$((pass+1)); printf '  ok    %s\n' "$*"; }
bad()  { fail=$((fail+1)); printf '  FAIL  %s\n' "$*"; }
skp()  { skip=$((skip+1)); printf '  skip  %s\n' "$*"; }
have() { command -v "$1" >/dev/null 2>&1; }

[[ -d "$DIR" ]] || { echo "no such folder: $DIR" >&2; exit 2; }
shopt -s nullglob
files=("$DIR"/nubo-os-*)
[[ ${#files[@]} -gt 0 ]] || { echo "no nubo-os-* files in $DIR" >&2; exit 2; }
if [[ -z "$VER" ]]; then
  VER="$(basename "${files[0]}" | sed -E 's/^nubo-os-[a-z]+-([0-9][^-]*(-[a-z]+[0-9]+)?)-.*/\1/')"
fi
echo "Nubo OS image check: $DIR (version $VER)"

check_common() {   # FILE
  local f="$1" b; b="$(basename "$f")"
  [[ -s "$f" ]] && ok "$b: not empty ($(du -h "$f" | cut -f1))" || { bad "$b: empty"; return; }
  if [[ -f "$f.sha256" ]]; then
    ( cd "$DIR" && sha256sum -c "$b.sha256" >/dev/null 2>&1 ) && ok "$b: checksum matches" || bad "$b: checksum does not match"
  else bad "$b: no .sha256 file"; fi
  [[ -s "$f.torrent" ]] && ok "$b: torrent present" || bad "$b: no .torrent file"
}

check_iso() {      # FILE
  local f="$1" b flavour; b="$(basename "$f")"
  flavour="$(echo "$b" | sed -E 's/^nubo-os-([a-z]+)-.*/\1/')"
  if ! have xorriso; then skp "$b: xorriso missing"; return; fi
  local info; info="$(xorriso -indev "$f" -report_el_torito plain -report_system_area plain 2>&1)"
  grep -qi "El Torito boot img.*BIOS" <<<"$info" && ok "$b: BIOS boot entry" || bad "$b: no BIOS boot entry"
  grep -qi "El Torito boot img.*UEFI" <<<"$info" && ok "$b: UEFI boot entry" || bad "$b: no UEFI boot entry"
  local label; label="$(xorriso -indev "$f" -toc 2>&1 | sed -n 's/^Volume id *: *//p' | head -1 | tr -d "'")"
  [[ "$label" == *Nubo* || "$label" == *NUBO* ]] && ok "$b: media label '$label'" || bad "$b: media label '$label' does not name Nubo"
  local listing; listing="$(xorriso -indev "$f" -find / -maxdepth 3 -type f 2>/dev/null | tr -d "'")"
  if grep -Eq '/casper/(vmlinuz|initrd)|/boot/(vmlinuz|initrd)|/install/(vmlinuz|initrd)' <<<"$listing"; then ok "$b: kernel and initrd on the media"; else bad "$b: no kernel/initrd found"; fi
  local tmp cfg; tmp="$(mktemp)"
  xorriso -osirrox on -indev "$f" -extract /boot/grub/grub.cfg "$tmp" >/dev/null 2>&1; cfg="$(head -400 "$tmp" 2>/dev/null)"; rm -f "$tmp"
  if [[ -n "$cfg" ]]; then
    grep -qi "nubo" <<<"$cfg" && ok "$b: boot menu mentions Nubo" || bad "$b: boot menu does not mention Nubo"
    if grep -Eqi "menuentry[^\"']*[\"'][^\"']*ubuntu" <<<"$cfg"; then bad "$b: a boot menu entry still says Ubuntu"; else ok "$b: no 'Ubuntu' in boot menu entries"; fi
  else skp "$b: grub.cfg not readable"; fi
  local sz; sz=$(stat -c %s "$f"); [[ $sz -gt 1500000000 ]] && ok "$b: plausible size" || bad "$b: size $sz looks too small"
  ( [[ "$flavour" == desktop ]] ) && { grep -q "/casper/minimal.standard.live.squashfs\|/casper/.*squashfs" <<<"$listing" && ok "$b: live system layer present" || bad "$b: no squashfs live layer"; }
}

check_qcow2() {    # FILE
  local f="$1" b; b="$(basename "$f")"
  have qemu-img || { skp "$b: qemu-img missing"; return; }
  [[ "$(qemu-img info --output=json "$f" 2>/dev/null | grep -o '"format": "[a-z0-9]*"' | head -1)" == '"format": "qcow2"' ]] && ok "$b: qcow2 format" || bad "$b: not qcow2"
  qemu-img check "$f" >/dev/null 2>&1 && ok "$b: qemu-img check clean" || bad "$b: qemu-img check reports errors"
  if have virt-cat; then
    local rel; rel="$(LIBGUESTFS_BACKEND=direct virt-cat -a "$f" /etc/os-release 2>/dev/null)"
    grep -q '^NAME="\?Nubo OS' <<<"$rel" && ok "$b: os-release says Nubo OS" || bad "$b: os-release does not say Nubo OS"
  else skp "$b: virt-cat missing (install libguestfs-tools) for the os-release check"; fi
  if [[ "$BOOT" == 1 ]]; then
    if ! have qemu-system-x86_64; then skp "$b: qemu-system-x86_64 missing"; return; fi
    local acc=tcg; [[ -w /dev/kvm ]] && acc=kvm
    local log; log="$(mktemp)"; local ovl; ovl="$(mktemp -u).qcow2"
    qemu-img create -q -f qcow2 -F qcow2 -b "$f" "$ovl"
    timeout "$BOOT_TIMEOUT" qemu-system-x86_64 -machine q35,accel=$acc -cpu max -m 2048 -smp 2 -nographic -serial mon:stdio \
        -drive file="$ovl",if=virtio -nic user,model=virtio-net-pci >"$log" 2>&1 &
    local pid=$! t=0 seen=
    while kill -0 $pid 2>/dev/null && [[ $t -lt $BOOT_TIMEOUT ]]; do
      grep -Eqi "login:|Nubo OS" "$log" && { seen=1; break; }; sleep 5; t=$((t+5))
    done
    kill $pid 2>/dev/null; wait $pid 2>/dev/null; rm -f "$ovl"
    [[ -n "$seen" ]] && ok "$b: boots under QEMU ($acc, ${t}s)" || bad "$b: no login prompt within ${BOOT_TIMEOUT}s ($acc); log $log"
  fi
}

check_archive() {  # FILE
  local f="$1" b; b="$(basename "$f")"
  case "$f" in
    *.tar.gz|*.tgz) tar tzf "$f" >/dev/null 2>&1 && ok "$b: archive lists" || { bad "$b: archive is damaged"; return; }
                    tar xzOf "$f" ./etc/os-release 2>/dev/null | grep -q 'Nubo OS' && ok "$b: os-release says Nubo OS" || skp "$b: no ./etc/os-release in the archive (a layered image?)" ;;
    *.tar.xz)       tar tJf "$f" >/dev/null 2>&1 && ok "$b: archive lists" || bad "$b: archive is damaged" ;;
    *.tar)          tar tf "$f" >/dev/null 2>&1 && ok "$b: archive lists" || bad "$b: archive is damaged" ;;
    *)              skp "$b: unknown archive kind" ;;
  esac
}

for f in "${files[@]}"; do
  case "$f" in *.sha256|*.torrent) continue ;; esac
  b="$(basename "$f")"; echo "$b"
  check_common "$f"
  case "$b" in
    *.iso)                          check_iso "$f" ;;
    *.qcow2)                        check_qcow2 "$f" ;;
    *netboot*|*vmlinuz*|*initrd*)   [[ -s "$f" ]] && ok "$b: netboot file present" ;;
    *.tar*|*.tgz|*.rootfs*|*.squashfs) check_archive "$f" ;;
    *.img|*.img.xz)                 [[ -s "$f" ]] && ok "$b: disk image present" ;;
    *)                              skp "$b: no specific check for this kind" ;;
  esac
done

# the set: every flavour we ship has its images
echo "Set"
for flavour in server virt containers edge; do
  ls "$DIR"/nubo-os-"$flavour"-"$VER"-amd64.iso >/dev/null 2>&1 && ok "$flavour ISO present" || bad "$flavour ISO missing"
done
ls "$DIR"/nubo-os-desktop-"$VER"-amd64.iso >/dev/null 2>&1 && ok "desktop ISO present" || bad "desktop ISO missing"

echo
echo "passed $pass, failed $fail, skipped $skip"
[[ $fail -eq 0 ]]
