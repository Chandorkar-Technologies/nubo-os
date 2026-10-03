#!/usr/bin/env bash
# Nubo OS Server cloud/VM image from Ubuntu's cloud image.
# Usage: build-cloud.sh DEBS_DIR OUT_DIR [amd64|arm64]
# Output: nubo-os-server-ARCH.qcow2 (+ .vhd, .vmdk for Hyper-V and VMware)
# Needs root, qemu-utils, libguestfs-tools.
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
ARCH="${3:-$(dpkg --print-architecture)}"
SUITE=resolute
BASE="https://archive.nubosuite.tech/cumulus-cloud/${SUITE}/current/${SUITE}-server-cloudimg-${ARCH}.img"
mkdir -p "${OUT}"; IMG="${OUT}/nubo-os-${FLAVOUR}-${ARCH}.qcow2"
curl -fL -o "${IMG}" "${BASE}"
qemu-img resize "${IMG}" 10G
virt-customize -a "${IMG}" \
  --copy-in "${DEBS}":/var/tmp \
  --copy-in "$(dirname "$0")/../ci/use-cumulus.sh":/var/tmp \
  --run-command 'sh /var/tmp/use-cumulus.sh' \
  --run-command "apt-get update -q && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends ${DEBLIST}" \
  --run-command '/usr/libexec/nubo/nubo-server-firewall || true' \
  --run-command 'rm -rf /var/tmp/debs' \
  --truncate /etc/machine-id
qemu-img convert -O vpc -o subformat=dynamic "${IMG}" "${OUT}/nubo-os-${FLAVOUR}-${ARCH}.vhd"
qemu-img convert -O vmdk "${IMG}" "${OUT}/nubo-os-${FLAVOUR}-${ARCH}.vmdk"
ls -lh "${OUT}"
