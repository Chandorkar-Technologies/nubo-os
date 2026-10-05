#!/usr/bin/env bash
# Publish a desktop installer image that was built by hand (iso/build-iso.sh).
# Reads ci/desktop-iso-source: three lines, VERSION, URL, SHA256 of the image.
# Fetches the image, refuses it unless the checksum matches, uploads it to R2
# under iso/<version>/ (archive.nubosuite.tech/iso/<version>/).
set -euo pipefail
cd "$(dirname "$0")/.."
. ci/rclone-env.sh
{ read -r VER; read -r URL; read -r SUM; } < ci/desktop-iso-source
[[ -n "${VER}" && -n "${URL}" && "${SUM}" =~ ^[0-9a-f]{64}$ ]] || { echo "ci/desktop-iso-source needs VERSION, URL, SHA256" >&2; exit 1; }
NAME="nubo-os-desktop-${VER}-amd64.iso"
mkdir -p work
curl -fL --retry 3 -o "work/${NAME}" "${URL}"
have="$(sha256sum "work/${NAME}" | cut -d' ' -f1)"
[[ "${have}" == "${SUM}" ]] || { echo "checksum mismatch: got ${have}" >&2; exit 1; }
echo "${SUM}  ${NAME}" > "work/${NAME}.sha256"
rclone copy "work/${NAME}" "r2:${R2_BUCKET}/iso/${VER}" --header-upload "Cache-Control: public, max-age=3600"
rclone copy "work/${NAME}.sha256" "r2:${R2_BUCKET}/iso/${VER}" --header-upload "Cache-Control: public, max-age=300"
echo "Image is at https://archive.nubosuite.tech/iso/${VER}/${NAME}"
