#!/usr/bin/env bash
# Copy this repository to the dev VM, build the packages there and install them.
# Packages are built inside the VM because the icon sources contain filenames
# that differ only by case, which macOS cannot hold.
# Usage: vm/sync-and-build.sh [--no-install]

set -euo pipefail

# Local settings (Proxmox host etc.) can live outside the repository.
[[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/nubo-os/env" ]] && . "${XDG_CONFIG_HOME:-$HOME/.config}/nubo-os/env"
PVE_HOST="${PVE_HOST:?set PVE_HOST to the Proxmox host, e.g. root@proxmox.example.net}"
VM_USER="${VM_USER:-nubo}"
VMID="${VMID:-301}"
# The desktop's network manager takes its address from DHCP, so ask the
# hypervisor where the VM currently is instead of assuming one.
VM_IP="${VM_IP:-$(ssh -o BatchMode=yes "${PVE_HOST}" "qm guest cmd ${VMID} network-get-interfaces" \
  | grep -o '"ip-address" : "10\.[0-9.]*"' | head -1 | cut -d'"' -f4)}"
if [[ -z "${VM_IP}" ]]; then
  echo "Could not find the VM address; is VM ${VMID} running?" >&2
  exit 1
fi
REMOTE_DIR="${REMOTE_DIR:-/home/${VM_USER}/nubo-os}"
INSTALL=1
[[ "${1:-}" == "--no-install" ]] && INSTALL=0

cd "$(dirname "$0")/.."

SSH=(ssh -o BatchMode=yes -o StrictHostKeyChecking=accept-new -J "${PVE_HOST}")

echo "==> Syncing sources"
rsync -az --delete \
  --exclude '.git/' --exclude '.DS_Store' --exclude '/build/' --exclude '/out/' \
  --exclude '/vendor/colloid-gtk/' --exclude '/vendor/colloid-icons/' \
  --exclude '/debian/.debhelper/' --exclude '/debian/nubo-*/' --exclude '/debian/files' \
  -e "${SSH[*]}" ./ "${VM_USER}@${VM_IP}:${REMOTE_DIR}/"

echo "==> Building in VM"
"${SSH[@]}" "${VM_USER}@${VM_IP}" "
  set -euo pipefail
  cd '${REMOTE_DIR}'
  vendor/fetch.sh
  sudo DEBIAN_FRONTEND=noninteractive apt-get build-dep -y ./ >/dev/null
  dpkg-buildpackage -us -uc -b 2>&1 | tail -25
  rm -rf out && mkdir -p out && mv ../nubo-*_*.deb out/
  rm -f ../nubo-os_*.buildinfo ../nubo-os_*.changes
  ls -lh out/
"

if [[ "${INSTALL}" -eq 1 ]]; then
  echo "==> Installing in VM"
  "${SSH[@]}" "${VM_USER}@${VM_IP}" "
    set -euo pipefail
    cd '${REMOTE_DIR}/out'
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --reinstall -o Dpkg::Options::=--force-confnew ./nubo-*.deb </dev/null 2>&1 | tail -15
  "
fi
