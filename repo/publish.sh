#!/usr/bin/env bash
# Build the signed apt archive from .deb files and upload it to Cloudflare R2.
# Usage: publish.sh DEBS_DIR
# Needs: reprepro, gpg (key imported), rclone configured with remote "nubo-r2".
# Env:   R2_BUCKET (default nubo-os), SKIP_UPLOAD=1 to only build locally.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
DEBS="$(readlink -f "${1:?directory with .deb files}")"
OUT="${OUT:-${HERE}/out}"
BUCKET="${R2_BUCKET:-nubo-os}"

mkdir -p "${OUT}"
rm -rf "${OUT}/conf"; cp -r "${HERE}/conf" "${OUT}/conf"
for deb in "${DEBS}"/*.deb; do
  reprepro -b "${OUT}" includedeb resolute "${deb}"
done
# Plain static files from here on: dists/ and pool/ are all apt needs.
rm -rf "${OUT}/db" "${OUT}/conf"
cp "${HERE}/nubo-archive-keyring.asc" "${OUT}/nubo-archive-keyring.asc" 2>/dev/null || true
[[ -n "${SKIP_UPLOAD:-}" ]] && { echo "Archive built in ${OUT}"; exit 0; }
rclone sync "${OUT}" "nubo-r2:${BUCKET}/apt" --fast-list --checksum
echo "Published to os.nubosuite.tech/apt"
