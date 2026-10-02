#!/usr/bin/env bash
# Build the Nubo OS Server installer image from Ubuntu's live-server image.
# The server image needs no unpacking: the boot menu is renamed, the installer
# is pointed at an answer file, and the Nubo packages ride along on the media.
#
# Usage: build-server-iso.sh UBUNTU_SERVER_ISO NUBO_DEBS_DIR OUTPUT_ISO
# Needs xorriso. Runs as a normal user. Works for amd64 and arm64 images.
set -euo pipefail

SRC_ISO="$(readlink -f "${1:?Ubuntu live-server ISO required}")"
DEBS="$(readlink -f "${2:?directory with nubo .deb files required}")"
OUT="$(readlink -f "${3:?output ISO path required}")"
WORK="${WORK:-$(mktemp -d)}"
HERE="$(cd "$(dirname "$0")" && pwd)"
ARCH="${ARCH:-$(dpkg --print-architecture)}"

command -v xorriso >/dev/null || { echo "Missing tool: xorriso" >&2; exit 1; }
STAGE="${WORK}/stage"; rm -rf "${STAGE}"; mkdir -p "${STAGE}/boot/grub" "${STAGE}/.disk" "${STAGE}/nubo/pool" "${STAGE}/server"

# Only what a server needs; the desktop packages conflict with it.
for p in nubo-archive nubo-server-base nubo-incus; do
  f="$(ls "${DEBS}/${p}_"*.deb 2>/dev/null | head -n1 || true)"
  [[ -n "${f}" ]] && cp "${f}" "${STAGE}/nubo/pool/"
done
ls "${STAGE}/nubo/pool" | grep -q nubo-server-base || { echo "nubo-server-base .deb not found in ${DEBS}" >&2; exit 1; }

echo "==> Branding the media"
for cfg in grub.cfg loopback.cfg; do
  xorriso -osirrox on -indev "${SRC_ISO}" -extract "/boot/grub/${cfg}" "${WORK}/${cfg}" 2>/dev/null || continue
  chmod u+w "${WORK}/${cfg}"
  # New names, the answer file, and a quiet console.
  sed -e 's/Try or Install Ubuntu Server/Install Nubo OS Server/' \
      -e 's/Ubuntu Server/Nubo OS Server/g' \
      -e 's# ---# autoinstall ds=nocloud\;s=/cdrom/server/ loglevel=3 systemd.show_status=false ---#' \
      "${WORK}/${cfg}" >"${STAGE}/boot/grub/${cfg}"
done
echo "Nubo OS Server 1 \"Flow\" - Release ${ARCH} ($(date -u +%Y%m%d))" >"${STAGE}/.disk/info"
cp "${HERE}/server-user-data" "${STAGE}/server/user-data"
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
  -volid "Nubo OS Server 1 ${ARCH}" "${maps[@]}" -commit
echo "Done: ${OUT}"
