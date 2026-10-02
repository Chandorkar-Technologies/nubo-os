#!/usr/bin/env bash
# Raspberry Pi 4/5 image: Ubuntu's preinstalled arm64 Pi image with the Nubo
# server packages added. Desktop variant follows once the server image is proven.
# Usage: build-pi.sh DEBS_DIR OUT_DIR   (needs root, qemu-utils, libguestfs-tools, xz-utils)
set -euo pipefail
DEBS="$(readlink -f "${1:?debs dir}")"; OUT="$(readlink -f "${2:?out dir}")"
URL="https://cdimage.ubuntu.com/releases/resolute/release/ubuntu-26.04-preinstalled-server-arm64+raspi.img.xz"
mkdir -p "${OUT}"; IMG="${OUT}/nubo-os-server-raspi.img"
curl -fL "${URL}" | xz -d >"${IMG}"
virt-customize -a "${IMG}" \
  --copy-in "${DEBS}":/var/tmp \
  --run-command 'apt-get install -y /var/tmp/debs/nubo-archive_*.deb /var/tmp/debs/nubo-server-base_*.deb || true' \
  --run-command 'rm -rf /var/tmp/debs'
xz -T0 -f "${IMG}"
ls -lh "${OUT}"
