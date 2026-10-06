#!/usr/bin/env bash
# Raspberry Pi 4/5 image: Ubuntu's preinstalled arm64 Pi image with the Nubo
# server packages added. Desktop variant follows once the server image is proven.
# Usage: VERSION=0.8.0-beta12 [FLAVOUR=server|edge|...] build-pi.sh DEBS_DIR OUT_DIR
# Output: nubo-os-FLAVOUR-VERSION-arm64-raspi.img.xz
# Run on an arm64 machine as root. Needs qemu-utils, libguestfs-tools, xz-utils.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
. "${HERE}/lib.sh"
FLAVOUR="${FLAVOUR:-server}"
VERSION="${VERSION:?VERSION required}"
PKGS="$(flavour_packages "${FLAVOUR}")"
DEBLIST=""; for p in ${PKGS}; do DEBLIST="${DEBLIST} /var/tmp/debs/${p}_*.deb"; done
DEBS="$(readlink -f "${1:?debs dir}")"; OUT="$(readlink -f "${2:?out dir}")"
[[ "$(dpkg --print-architecture)" == arm64 ]] || { echo "Build Raspberry Pi images on an arm64 machine." >&2; exit 1; }
URL="${CUMULUS}/cumulus-images/releases/resolute/release/ubuntu-26.04-preinstalled-server-arm64+raspi.img.xz"
mkdir -p "${OUT}"; IMG="${OUT}/nubo-os-${FLAVOUR}-${VERSION}-arm64-raspi.img"
curl -fL --retry 3 "${URL}" | xz -d >"${IMG}"
virt-customize -a "${IMG}" \
  --copy-in "${DEBS}":/var/tmp \
  --copy-in "${HERE}/../ci/use-cumulus.sh":/var/tmp \
  --run-command 'sh /var/tmp/use-cumulus.sh' \
  --run-command "apt-get update -q && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends ${DEBLIST}" \
  --run-command 'rm -rf /var/tmp/debs /var/tmp/use-cumulus.sh'
xz -T0 -f "${IMG}"
ls -lh "${IMG}.xz"
