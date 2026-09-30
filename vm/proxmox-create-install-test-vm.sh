#!/usr/bin/env bash
# Create an empty VM on the Proxmox host that boots the Nubo OS installer
# image, to test installing the way a customer would.
# Run on the Proxmox host as root.
# Usage: proxmox-create-install-test-vm.sh [ISO_FILE_NAME]
#
# Refuses to touch an existing VM: destroy it yourself first for a rerun.

set -euo pipefail

ISO_NAME="${1:-nubo-os-1-amd64.iso}"
VMID="${VMID:-302}"
NAME="${NAME:-nubo-os-install-test}"
CORES="${CORES:-4}"
MEMORY_MB="${MEMORY_MB:-8192}"
DISK_GB="${DISK_GB:-32}"
BRIDGE="${BRIDGE:-vmbr1}"
STORAGE="${STORAGE:-local-lvm}"
ISO_STORAGE="${ISO_STORAGE:-local}"

if [[ -e "/etc/pve/qemu-server/${VMID}.conf" || -e "/etc/pve/lxc/${VMID}.conf" ]]; then
  echo "Guest ${VMID} already exists; refusing to overwrite." >&2
  exit 1
fi
if [[ ! -f "/var/lib/vz/template/iso/${ISO_NAME}" ]]; then
  echo "ISO not found: /var/lib/vz/template/iso/${ISO_NAME}" >&2
  exit 1
fi

qm create "${VMID}" \
  --name "${NAME}" \
  --ostype l26 \
  --machine q35 \
  --bios ovmf \
  --cpu host --sockets 1 --cores "${CORES}" \
  --memory "${MEMORY_MB}" --balloon 0 \
  --scsihw virtio-scsi-single \
  --net0 "virtio,bridge=${BRIDGE}" \
  --vga virtio \
  --agent enabled=1 \
  --onboot 0 \
  --description "Nubo OS installer test. Private network only. Safe to destroy."

qm set "${VMID}" --efidisk0 "${STORAGE}:0,efitype=4m,pre-enrolled-keys=1"
qm set "${VMID}" --scsi0 "${STORAGE}:${DISK_GB},discard=on,ssd=1,iothread=1"
qm set "${VMID}" --ide2 "${ISO_STORAGE}:iso/${ISO_NAME},media=cdrom"
qm set "${VMID}" --boot "order=scsi0;ide2"

qm start "${VMID}"
echo "VM ${VMID} started from ${ISO_NAME}"
