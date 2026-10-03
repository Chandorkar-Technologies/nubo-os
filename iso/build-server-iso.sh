#!/usr/bin/env bash
# Build the Nubo OS Server installer image from Ubuntu's live-server image.
# The server image needs no unpacking: the boot menu is renamed, the installer
# is pointed at an answer file, and the Nubo packages ride along on the media.
#
# Usage: [FLAVOUR=server|virt|containers|edge] build-server-iso.sh UBUNTU_SERVER_ISO NUBO_DEBS_DIR OUTPUT_ISO
#   server      Nubo OS Server: the base system (default)
#   virt        Nubo OS Server, Virtualization: adds Incus and QEMU
#   containers  Nubo OS Server, Containers: adds Podman
#   edge        Nubo OS Edge: the smallest, for Raspberry Pi and old hardware
# Needs xorriso. Runs as a normal user. Works for amd64 and arm64 images.
set -euo pipefail

SRC_ISO="$(readlink -f "${1:?Ubuntu live-server ISO required}")"
DEBS="$(readlink -f "${2:?directory with nubo .deb files required}")"
OUT="$(readlink -f "${3:?output ISO path required}")"
WORK="${WORK:-$(mktemp -d)}"
HERE="$(cd "$(dirname "$0")" && pwd)"
ARCH="${ARCH:-$(dpkg --print-architecture)}"
FLAVOUR="${FLAVOUR:-server}"
case "${FLAVOUR}" in
  server)     PKGS="nubo-archive nubo-base nubo-server-core nubo-server-base"; TITLE="Nubo OS Server"; LABEL="Server" ;;
  virt)       PKGS="nubo-archive nubo-base nubo-server-core nubo-server-base nubo-incus"; TITLE="Nubo OS Server (Virtualization)"; LABEL="Virtualization" ;;
  containers) PKGS="nubo-archive nubo-base nubo-server-core nubo-server-base nubo-podman"; TITLE="Nubo OS Server (Containers)"; LABEL="Containers" ;;
  edge)       PKGS="nubo-archive nubo-base nubo-server-core nubo-edge"; TITLE="Nubo OS Edge"; LABEL="Edge" ;;
  *) echo "FLAVOUR must be server, virt, containers or edge" >&2; exit 1 ;;
esac

command -v xorriso >/dev/null || { echo "Missing tool: xorriso" >&2; exit 1; }
STAGE="${WORK}/stage"; rm -rf "${STAGE}"; mkdir -p "${STAGE}/boot/grub" "${STAGE}/.disk" "${STAGE}/nubo/pool" "${STAGE}/server"

# Only what a server needs; the desktop packages conflict with it.
# Only the base. Incus (containers and VMs) is added later with: apt install nubo-incus
for p in ${PKGS}; do
  f="$(ls "${DEBS}/${p}_"*.deb 2>/dev/null | head -n1 || true)"
  [[ -n "${f}" ]] && cp "${f}" "${STAGE}/nubo/pool/"
done
for p in ${PKGS}; do ls "${STAGE}/nubo/pool/${p}_"*.deb >/dev/null 2>&1 || { echo "${p} .deb not found in ${DEBS}" >&2; exit 1; }; done

echo "==> Branding the media"
for cfg in grub.cfg loopback.cfg; do
  xorriso -osirrox on -indev "${SRC_ISO}" -extract "/boot/grub/${cfg}" "${WORK}/${cfg}" 2>/dev/null || continue
  chmod u+w "${WORK}/${cfg}"
  # New names, the answer file, and a quiet console.
  # In GRUB a bare ";" ends the command, so it is escaped for the kernel line.
  args='autoinstall ds=nocloud\;s=/cdrom/server/ loglevel=3 systemd.show_status=false'
  while IFS= read -r line; do
    line="${line//Try or Install Ubuntu Server/Install ${TITLE}}"
    line="${line//Ubuntu Server/${TITLE}}"
    [[ "${line}" == *' ---'* ]] && line="${line/ ---/ ${args} ---}"
    printf '%s\n' "${line}"
  done <"${WORK}/${cfg}" >"${STAGE}/boot/grub/${cfg}"
done
# Names shown on the "type of installation" screen.
xorriso -osirrox on -indev "${SRC_ISO}" -extract /casper/install-sources.yaml "${WORK}/install-sources.yaml" 2>/dev/null
chmod u+w "${WORK}/install-sources.yaml"
mkdir -p "${STAGE}/casper"
sed -e 's/Ubuntu Server (minimized)/Nubo OS Server (minimal)/' -e 's/Ubuntu Server/Nubo OS Server/' \
  "${WORK}/install-sources.yaml" >"${STAGE}/casper/install-sources.yaml"

# The installer's own system (what you see while booting and in the installer's
# console) is Ubuntu's. A small extra layer on top of it carries the Nubo
# identity. Casper stacks every .squashfs in /casper and the last name sorts on top.
if command -v mksquashfs >/dev/null; then
  LAYER="${WORK}/layer"; rm -rf "${LAYER}"; mkdir -p "${LAYER}/usr/lib" "${LAYER}/etc"
  cp "${HERE}/../server/os-release" "${LAYER}/usr/lib/os-release"
  cp "${HERE}/../server/issue" "${LAYER}/etc/issue"
  cp "${HERE}/../server/issue.net" "${LAYER}/etc/issue.net"
  cp "${HERE}/../server/lsb-release" "${LAYER}/etc/lsb-release"
  mksquashfs "${LAYER}" "${STAGE}/casper/zz-nubo-identity.squashfs" -noappend -quiet -no-progress -all-root
else
  echo "mksquashfs not found: boot text will still say Ubuntu" >&2
fi
echo "${TITLE} 1 \"Flow\" - Release ${ARCH} ($(date -u +%Y%m%d))" >"${STAGE}/.disk/info"
cp "${HERE}/server-user-data" "${STAGE}/server/user-data"
# Extra steps per flavour, added after the Nubo packages are installed.
case "${FLAVOUR}" in
  virt)
    cat >>"${STAGE}/server/user-data" <<'EXTRA'
    - >-
      curtin in-target --target=/target -- sh -c
      'DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends
      qemu-utils $(case "$(dpkg --print-architecture)" in
      amd64) echo "qemu-system-x86 ovmf" ;; *) echo "qemu-system-arm qemu-efi-aarch64" ;; esac)'
EXTRA
    ;;
esac
cp "${HERE}/server-meta-data" "${STAGE}/server/meta-data"

echo "==> Updating checksums"
xorriso -osirrox on -indev "${SRC_ISO}" -extract /md5sum.txt "${WORK}/md5sum.orig" 2>/dev/null || : >"${WORK}/md5sum.orig"
chmod u+w "${WORK}/md5sum.orig"
changed="$(cd "${STAGE}" && find . -type f | sort)"
grep -v -F -f <(printf '%s\n' "${changed}") "${WORK}/md5sum.orig" >"${STAGE}/md5sum.txt" || true
(cd "${STAGE}" && printf '%s\n' "${changed}" | grep -v md5sum.txt | xargs -d '\n' md5sum 2>/dev/null || printf '%s\n' "${changed}" | grep -v md5sum.txt | tr '\n' '\0' | xargs -0 md5sum) >>"${STAGE}/md5sum.txt"

echo "==> Writing ${OUT}"
maps=()
while IFS= read -r file; do maps+=(-map "${STAGE}/${file#./}" "/${file#./}"); done < <(cd "${STAGE}" && find . -type f | sort)
rm -f "${OUT}"
xorriso -indev "${SRC_ISO}" -outdev "${OUT}" -boot_image any replay \
  -volid "Nubo OS ${LABEL} 1 ${ARCH}" "${maps[@]}" -commit
echo "Done: ${OUT}"
