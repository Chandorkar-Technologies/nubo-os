#!/usr/bin/env bash
# Raspberry Pi 4/5 image: Ubuntu's preinstalled arm64 Pi image with the Nubo
# server packages added. Desktop variant follows once the server image is proven.
# Usage: build-pi.sh DEBS_DIR OUT_DIR   (needs root, qemu-utils, libguestfs-tools, xz-utils)
set -euo pipefail
FLAVOUR="${FLAVOUR:-server}"
case "${FLAVOUR}" in
  server)     PKGS="nubo-archive nubo-base nubo-server-core nubo-server-base" ;;
  virt)       PKGS="nubo-archive nubo-base nubo-server-core nubo-server-base nubo-incus" ;;
  containers) PKGS="nubo-archive nubo-base nubo-server-core nubo-server-base nubo-podman" ;;
  edge)       PKGS="nubo-archive nubo-base nubo-server-core nubo-edge" ;;
  *) echo "FLAVOUR must be server, virt, containers or edge" >&2; exit 1 ;;
esac
DEBLIST=""; for p in ${PKGS}; do DEBLIST="${DEBLIST} /var/tmp/debs/${p}_*.deb"; done
DEBS="$(readlink -f "${1:?debs dir}")"; OUT="$(readlink -f "${2:?out dir}")"
URL="https://archive.nubosuite.tech/cumulus-images/releases/resolute/release/ubuntu-26.04-preinstalled-server-arm64+raspi.img.xz"
mkdir -p "${OUT}"; IMG="${OUT}/nubo-os-${FLAVOUR}-raspi.img"
curl -fL "${URL}" | xz -d >"${IMG}"
virt-customize -a "${IMG}" \
  --copy-in "${DEBS}":/var/tmp \
  --copy-in "$(dirname "$0")/../ci/use-cumulus.sh":/var/tmp \
  --run-command 'sh /var/tmp/use-cumulus.sh' \
  --run-command "apt-get update -q && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends ${DEBLIST}" \
  --run-command 'rm -rf /var/tmp/debs'
xz -T0 -f "${IMG}"
ls -lh "${OUT}"
