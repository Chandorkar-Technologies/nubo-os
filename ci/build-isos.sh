#!/usr/bin/env bash
# Build every server installer image (4 flavours x amd64 and arm64) from the packages
# staged by the build step, and upload them to R2 under iso/ (archive.nubosuite.tech/iso/).
# The ISO builder only rearranges files; it runs nothing from the target system,
# so one amd64 machine builds both architectures.
set -euo pipefail
cd "$(dirname "$0")/.."
. ci/rclone-env.sh
TAG="${DRONE_TAG:?}"
VER="${TAG#v}"
BASE=https://archive.nubosuite.tech
declare -A SRC=(
  [amd64]="${BASE}/cumulus-releases/26.04/ubuntu-26.04-live-server-amd64.iso"
  [arm64]="${BASE}/cumulus-images/ubuntu/releases/26.04/release/ubuntu-26.04-live-server-arm64.iso"
)
mkdir -p debs work
rclone copy "r2:${R2_BUCKET}/_staging/${TAG}" debs --include '*.deb'
ls debs

for arch in amd64 arm64; do
  iso="work/base-${arch}.iso"
  echo "==> base image ${arch}"
  curl -fL --retry 3 -o "${iso}" "${SRC[$arch]}"
  # Checksum from Ubuntu's own list, fetched the same way.
  dir="$(dirname "${SRC[$arch]}")"
  want="$(curl -fsL "${dir}/SHA256SUMS" | awk -v f="$(basename "${SRC[$arch]}")" '$2=="*"f || $2==f {print $1}')"
  have="$(sha256sum "${iso}" | cut -d' ' -f1)"
  [[ -n "${want}" && "${want}" == "${have}" ]] || { echo "checksum mismatch for ${arch} base image" >&2; exit 1; }
  for flavour in server virt containers edge; do
    out="work/nubo-os-${flavour}-${VER}-${arch}.iso"
    echo "==> ${flavour} ${arch}"
    ARCH="${arch}" FLAVOUR="${flavour}" WORK="$(mktemp -d)" iso/build-server-iso.sh "${iso}" debs "${out}"
    (cd work && sha256sum "$(basename "${out}")" > "$(basename "${out}").sha256")
    rclone copy "${out}" "r2:${R2_BUCKET}/iso/${VER}" --header-upload "Cache-Control: public, max-age=3600"
    rclone copy "${out}.sha256" "r2:${R2_BUCKET}/iso/${VER}" --header-upload "Cache-Control: public, max-age=300"
    rm -f "${out}" "${out}.sha256"
  done
  rm -f "${iso}"
done
echo "Images are at ${BASE}/iso/${VER}/"
