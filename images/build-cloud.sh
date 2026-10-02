#!/usr/bin/env bash
# Nubo OS Server cloud/VM image from Ubuntu's cloud image.
# Usage: build-cloud.sh DEBS_DIR OUT_DIR [amd64|arm64]
# Output: nubo-os-server-ARCH.qcow2 (+ .vhd, .vmdk for Hyper-V and VMware)
# Needs root, qemu-utils, libguestfs-tools.
set -euo pipefail
DEBS="$(readlink -f "${1:?debs dir}")"; OUT="$(readlink -f "${2:?out dir}")"
ARCH="${3:-$(dpkg --print-architecture)}"
SUITE=resolute
BASE="https://archive.nubosuite.tech/cumulus-cloud/${SUITE}/current/${SUITE}-server-cloudimg-${ARCH}.img"
mkdir -p "${OUT}"; IMG="${OUT}/nubo-os-server-${ARCH}.qcow2"
curl -fL -o "${IMG}" "${BASE}"
qemu-img resize "${IMG}" 10G
virt-customize -a "${IMG}" \
  --copy-in "${DEBS}":/var/tmp \
  --copy-in "$(dirname "$0")/../ci/use-cumulus.sh":/var/tmp \
  --run-command 'sh /var/tmp/use-cumulus.sh' \
  --run-command 'apt-get update && apt-get install -y /var/tmp/debs/nubo-archive_*.deb /var/tmp/debs/nubo-server-base_*.deb /var/tmp/debs/nubo-branding_*.deb || true' \
  --run-command '/usr/libexec/nubo/nubo-server-firewall || true' \
  --run-command 'rm -rf /var/tmp/debs' \
  --truncate /etc/machine-id
qemu-img convert -O vpc -o subformat=dynamic "${IMG}" "${OUT}/nubo-os-server-${ARCH}.vhd"
qemu-img convert -O vmdk "${IMG}" "${OUT}/nubo-os-server-${ARCH}.vmdk"
ls -lh "${OUT}"
