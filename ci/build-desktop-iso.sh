#!/usr/bin/env bash
# Build the Nubo OS Desktop installer image (amd64) and upload it to R2 under
# iso/<version>/ (archive.nubosuite.tech/iso/<version>/).
# Packages come from the beta channel already published in the bucket, so this
# can run any time after a release, not only in the release build itself.
# Needs a privileged container: the image builder mounts and chroots.
# Usage: build-desktop-iso.sh VERSION   (for example 0.8.0-beta11)
set -euo pipefail
cd "$(dirname "$0")/.."
. ci/rclone-env.sh
VER="${1:?version, for example 0.8.0-beta11}"
BASE=https://archive.nubosuite.tech/cumulus-releases/26.04
ISO=ubuntu-26.04.1-desktop-amd64.iso
mkdir -p debs work out

echo "==> Nubo packages the beta channel carries"
# The image label is the release tag; the package version is whatever
# debian/changelog said when the packages were built, so take the channel's list.
rclone copy "r2:${R2_BUCKET}/suites/resolute-beta.list" work
mapfile -t names < <(grep -E '^nubo-.*_(all|amd64)\.deb$' work/resolute-beta.list \
  | grep -v -E '^nubo-(server|edge|podman|incus)')
for n in "${names[@]}"; do
  rclone copyto "r2:${R2_BUCKET}/pool/main/n/nubo-os/${n}" "debs/${n}"
done
ls debs
compgen -G "debs/nubo-*.deb" >/dev/null || { echo "no nubo packages in the beta channel" >&2; exit 1; }

echo "==> Ubuntu Desktop base image"
curl -fL --retry 3 -o "work/${ISO}" "${BASE}/${ISO}"
want="$(curl -fsL "${BASE}/SHA256SUMS" | awk -v f="${ISO}" '$2=="*"f || $2==f {print $1}')"
have="$(sha256sum "work/${ISO}" | cut -d' ' -f1)"
[[ -n "${want}" && "${want}" == "${have}" ]] || { echo "checksum mismatch for the base image" >&2; exit 1; }

OUT="out/nubo-os-desktop-${VER}-amd64.iso"
ARCH=amd64 WORK=/var/tmp/nubo-iso iso/build-iso.sh "work/${ISO}" debs "${OUT}"
# Ubuntu's own image is no longer needed; free the space before uploading.
rm -f "work/${ISO}"
(cd out && sha256sum "$(basename "${OUT}")" > "$(basename "${OUT}").sha256")

rclone copy "${OUT}" "r2:${R2_BUCKET}/iso/${VER}" --header-upload "Cache-Control: public, max-age=3600"
rclone copy "${OUT}.sha256" "r2:${R2_BUCKET}/iso/${VER}" --header-upload "Cache-Control: public, max-age=300"
echo "Image is at https://archive.nubosuite.tech/iso/${VER}/$(basename "${OUT}")"
cat "${OUT}.sha256"
