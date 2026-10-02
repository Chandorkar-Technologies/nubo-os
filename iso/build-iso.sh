#!/usr/bin/env bash
# Build the Nubo OS installer image from the official Ubuntu Desktop image.
#
# What changes compared with the Ubuntu image:
#   - the Nubo packages and everything they need are carried on the media
#   - the installer installs them as its last step (see autoinstall.yaml)
#   - the live "try it" session has them installed already
#   - boot menu, volume name and install choices say Nubo OS
# Everything else is byte-for-byte Ubuntu's, including the boot loader.
#
# Run as root on Linux. Needs network access for dependency download.
# Usage: build-iso.sh UBUNTU_ISO NUBO_DEBS_DIR OUTPUT_ISO

set -euo pipefail

SRC_ISO="$(readlink -f "${1:?Ubuntu ISO required}")"
DEBS="$(readlink -f "${2:?directory with nubo .deb files required}")"
OUT="$(readlink -f "${3:?output ISO path required}")"
WORK="${WORK:-/var/tmp/nubo-iso}"
HERE="$(cd "$(dirname "$0")" && pwd)"

ARCH="${ARCH:-$(dpkg --print-architecture)}"
VOLUME_ID="Nubo OS 1 ${ARCH}"
LIVE_LAYER="minimal.standard.live"

if [[ "$(id -u)" -ne 0 ]]; then
  echo "Run as root." >&2
  exit 1
fi
for tool in xorriso unsquashfs mksquashfs; do
  command -v "${tool}" >/dev/null || { echo "Missing tool: ${tool}" >&2; exit 1; }
done
if ! compgen -G "${DEBS}/nubo-*.deb" >/dev/null; then
  echo "No nubo-*.deb files in ${DEBS}." >&2
  exit 1
fi

MOUNTS=()
mount_push() {
  mount "$@"
  MOUNTS+=("${!#}")
}
cleanup() {
  local i
  for ((i = ${#MOUNTS[@]} - 1; i >= 0; i--)); do
    umount -l "${MOUNTS[i]}" 2>/dev/null || true
  done
}
trap cleanup EXIT

# Make a root directory usable as a chroot, without letting package scripts
# start services or rebuild boot files that the media never uses.
enter_prepare() {
  local root="$1"
  mount_push --bind /dev "${root}/dev"
  mount_push --bind /dev/pts "${root}/dev/pts"
  mount_push -t proc proc "${root}/proc"
  mount_push -t sysfs sysfs "${root}/sys"
  mount_push --bind /etc/resolv.conf "${root}/etc/resolv.conf"
  # The images list the install media as a package source; without it
  # mounted, refreshing the package lists fails outright.
  mkdir -p "${root}/cdrom"
  mount_push --bind "${WORK}/mnt/iso" "${root}/cdrom"
  printf '#!/bin/sh\nexit 101\n' >"${root}/usr/sbin/policy-rc.d"
  chmod +x "${root}/usr/sbin/policy-rc.d"
  local stub
  for stub in update-initramfs update-grub; do
    [[ -e "${root}/usr/sbin/${stub}" ]] && mount_push --bind /bin/true "${root}/usr/sbin/${stub}"
  done
}
enter_finish() {
  local root="$1" stub
  for stub in update-grub update-initramfs; do
    umount "${root}/usr/sbin/${stub}" 2>/dev/null || true
  done
  rm -f "${root}/usr/sbin/policy-rc.d"
  # Tools run inside may leave sub-mounts under /sys or /dev; take those down too.
  local m
  for m in cdrom etc/resolv.conf sys proc dev/pts dev; do
    umount -R "${root}/${m}" 2>/dev/null || umount -l "${root}/${m}" 2>/dev/null || true
  done
}

echo "==> Preparing ${WORK}"
rm -rf "${WORK}"
mkdir -p "${WORK}"/{mnt/iso,mnt/minimal,mnt/standard,deps-upper,deps-work,deps-root,live,live-work,live-root,stage/casper,stage/nubo/pool}

mount_push -o loop,ro "${SRC_ISO}" "${WORK}/mnt/iso"
mount_push -o loop,ro "${WORK}/mnt/iso/casper/minimal.squashfs" "${WORK}/mnt/minimal"
mount_push -o loop,ro "${WORK}/mnt/iso/casper/minimal.standard.squashfs" "${WORK}/mnt/standard"

echo "==> Collecting packages the Nubo packages depend on"
# Resolved against the smallest install, so the set covers every install type.
mount_push -t overlay overlay \
  -o "lowerdir=${WORK}/mnt/minimal,upperdir=${WORK}/deps-upper,workdir=${WORK}/deps-work" \
  "${WORK}/deps-root"
enter_prepare "${WORK}/deps-root"
# Firefox comes from Mozilla's repository on Nubo OS; make it visible here so
# its package and dependencies land on the media too.
install -D -m 0644 "${HERE}/../data/apt/mozilla.sources" "${WORK}/deps-root/etc/apt/sources.list.d/mozilla.sources"
install -D -m 0644 "${HERE}/../data/apt/mozilla.pref" "${WORK}/deps-root/etc/apt/preferences.d/mozilla.pref"
install -D -m 0644 "${HERE}/../data/apt/packages.mozilla.org.asc" "${WORK}/deps-root/etc/apt/keyrings/packages.mozilla.org.asc"
mkdir -p "${WORK}/deps-root/var/tmp/nubo"
cp "${DEBS}"/nubo-*.deb "${WORK}/deps-root/var/tmp/nubo/"
chroot "${WORK}/deps-root" sh -c '
  set -e
  export DEBIAN_FRONTEND=noninteractive
  apt-get update -q >/dev/null
  apt-get install -y -q --download-only /var/tmp/nubo/*.deb >/dev/null
'
cp "${DEBS}"/nubo-*.deb "${WORK}/stage/nubo/pool/"
find "${WORK}/deps-root/var/cache/apt/archives" -maxdepth 1 -name '*.deb' \
  -exec cp {} "${WORK}/stage/nubo/pool/" \;
enter_finish "${WORK}/deps-root"
umount "${WORK}/deps-root"
echo "    $(find "${WORK}/stage/nubo/pool" -name '*.deb' | wc -l) packages on media"

echo "==> Installing Nubo into the live session"
unsquashfs -q -f -d "${WORK}/live" "${WORK}/mnt/iso/casper/${LIVE_LAYER}.squashfs"
mount_push -t overlay overlay \
  -o "lowerdir=${WORK}/mnt/standard:${WORK}/mnt/minimal,upperdir=${WORK}/live,workdir=${WORK}/live-work" \
  "${WORK}/live-root"
enter_prepare "${WORK}/live-root"
mkdir -p "${WORK}/live-root/var/tmp/nubo"
cp "${WORK}"/stage/nubo/pool/*.deb "${WORK}/live-root/var/tmp/nubo/"
if ! chroot "${WORK}/live-root" sh -c '
  set -e
  export DEBIAN_FRONTEND=noninteractive
  apt-get update -q >/dev/null
  apt-get install -y -q -o Dpkg::Options::=--force-confnew /var/tmp/nubo/*.deb
  rm -rf /var/tmp/nubo
' >"${WORK}/live-apt.log" 2>&1; then
  echo "Package installation in the live session failed; last lines:" >&2
  grep -v -E '^(Selecting|Preparing|Unpacking|\(Reading|Get:)' "${WORK}/live-apt.log" | tail -40 >&2
  exit 1
fi
chroot "${WORK}/live-root" dpkg-query -W --showformat='${Package} ${Version}\n' \
  >"${WORK}/stage/casper/${LIVE_LAYER}.manifest"

echo "==> Rebuilding the media boot files with the Nubo boot screen"
# The boot screen shown while the media starts lives in the initramfs on the
# media, not in the system images. Rebuild it from the live session, where
# the Nubo boot screen is now installed.
# The live layer deletes the system's own initramfs (the media carries it as
# /casper/initrd instead), so one is created fresh for the kernel present.
umount "${WORK}/live-root/usr/sbin/update-initramfs" 2>/dev/null || true
kver="$(ls "${WORK}/live-root/lib/modules" | sort -V | tail -1)"
chroot "${WORK}/live-root" update-initramfs -c -k "${kver}" >/dev/null
initrd="${WORK}/live-root/boot/initrd.img-${kver}"
cp "${initrd}" "${WORK}/stage/casper/initrd"
# At boot the initramfs only accepts a medium that carries its own UUID, and a
# freshly built initramfs has a new one; write it onto the media as well.
rm -rf "${WORK}/initrd-unpacked"
unmkinitramfs "${initrd}" "${WORK}/initrd-unpacked"
uuid_file="$(find "${WORK}/initrd-unpacked" -path '*conf/uuid.conf' | head -1)"
[[ -n "${uuid_file}" ]] || { echo "Rebuilt initramfs has no UUID file." >&2; exit 1; }
mkdir -p "${WORK}/stage/.disk"
for marker in "${WORK}"/mnt/iso/.disk/casper-uuid-*; do
  cp "${uuid_file}" "${WORK}/stage/.disk/$(basename "${marker}")"
done
echo "    media UUID: $(cat "${uuid_file}")"
echo "    initrd for ${kver}: $(du -h "${initrd}" | cut -f1) (media had $(du -h "${WORK}/mnt/iso/casper/initrd" | cut -f1))"
if ! lsinitramfs "${WORK}/stage/casper/initrd" | grep -q 'scripts/casper$'; then
  echo "Rebuilt initramfs lacks the live-boot scripts; refusing to continue." >&2
  exit 1
fi
# Keep the live layer as it was: the media carries the file, the layer need not.
rm -f "${WORK}/live/boot/initrd.img-${kver}" "${WORK}"/live/boot/initrd.img-*.dpkg-bak
rm -rf "${WORK}/live/var/lib/initramfs-tools"
enter_finish "${WORK}/live-root"
umount "${WORK}/live-root"

if [[ -n "${INSTALLER_SNAP:-}" ]]; then
  echo "==> Replacing the installer app with the Nubo build"
  # The live session has this snap installed already, so swapping the file
  # underneath is enough; the seed copy is replaced for consistency.
  for target in "${WORK}"/live/var/lib/snapd/snaps/ubuntu-desktop-bootstrap_*.snap \
                "${WORK}"/live/var/lib/snapd/seed/snaps/ubuntu-desktop-bootstrap_*.snap; do
    [[ -e "${target}" ]] || continue
    cp "${INSTALLER_SNAP}" "${target}"
    echo "    $(basename "${target}")"
  done
fi

echo "==> Packing the live session layer"
compression="$(unsquashfs -s "${WORK}/mnt/iso/casper/${LIVE_LAYER}.squashfs" \
  | sed -n 's/^Compression \([a-z0-9]*\).*/\1/p')"
mksquashfs "${WORK}/live" "${WORK}/stage/casper/${LIVE_LAYER}.squashfs" \
  -noappend -quiet -no-progress -comp "${compression:-xz}"
du -sx --block-size=1 "${WORK}/live" | cut -f1 >"${WORK}/stage/casper/${LIVE_LAYER}.size"

echo "==> Branding the media"
mkdir -p "${WORK}/stage/boot/grub" "${WORK}/stage/.disk"
for cfg in grub.cfg loopback.cfg; do
  # Besides the new names: keep the console free of the boot log. "quiet splash"
  # alone still lets systemd print its status lines whenever the splash screen
  # does not take over (for example in some virtual machines).
  sed -e 's/Try or Install Ubuntu/Try or Install Nubo OS/' \
      -e 's/"Ubuntu (safe graphics)"/"Nubo OS (safe graphics)"/' \
      -e 's/ quiet splash/ quiet splash loglevel=3 systemd.show_status=false rd.systemd.show_status=false vt.global_cursor_default=0/' \
      "${WORK}/mnt/iso/boot/grub/${cfg}" >"${WORK}/stage/boot/grub/${cfg}"
done
# Shown by the installer as the product name. The quoted codename is
# required: the installer takes the text before the first quote and crashes
# on a line without one.
echo "Nubo OS 1 \"Flow\" - Release ${ARCH} ($(date -u +%Y%m%d))" >"${WORK}/stage/.disk/info"
sed -e 's/Ubuntu Desktop (minimized)/Nubo OS Desktop (minimal)/' \
    -e 's/Ubuntu Desktop/Nubo OS Desktop/' \
    "${WORK}/mnt/iso/casper/install-sources.yaml" >"${WORK}/stage/casper/install-sources.yaml"
cp "${HERE}/autoinstall.yaml" "${WORK}/stage/autoinstall.yaml"

echo "==> Updating checksums"
# Entries for replaced files are dropped, then every staged file is added.
changed="$(cd "${WORK}/stage" && find . -type f ! -name md5sum.txt | sort)"
grep -v -F -f <(printf '%s\n' "${changed}") "${WORK}/mnt/iso/md5sum.txt" \
  >"${WORK}/stage/md5sum.txt" || true
(cd "${WORK}/stage" && printf '%s\n' "${changed}" | xargs -d '\n' md5sum) \
  >>"${WORK}/stage/md5sum.txt"

echo "==> Writing ${OUT}"
maps=()
while IFS= read -r file; do
  maps+=(-map "${WORK}/stage/${file#./}" "/${file#./}")
done < <(cd "${WORK}/stage" && find . -type f | sort)

rm -f "${OUT}"
xorriso -indev "${SRC_ISO}" -outdev "${OUT}" \
  -boot_image any replay \
  -volid "${VOLUME_ID}" \
  "${maps[@]}" \
  -commit 2>&1 | grep -v -E '^xorriso : UPDATE|^$' | tail -5

sha256sum "${OUT}" | sed "s|${OUT}|$(basename "${OUT}")|" >"${OUT}.sha256"
ls -lh "${OUT}"
echo "==> Done"
