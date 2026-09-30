#!/usr/bin/env bash
# Create the Nubo OS development VM on a Proxmox host.
# Run on the Proxmox host as root:  bash proxmox-create-dev-vm.sh
#
# The VM sits on the private NAT bridge only (no public IP). It starts from the
# official Ubuntu cloud image; the desktop is added afterwards by
# provision-desktop.sh, which gives the same package set as a Desktop install
# without a 6 GB ISO or an interactive installer.
#
# Refuses to touch an existing VM: destroy it yourself first if you want a rebuild.

set -euo pipefail

VMID="${VMID:-301}"
NAME="${NAME:-nubo-os-dev}"
CORES="${CORES:-4}"
MEMORY_MB="${MEMORY_MB:-8192}"
DISK_GB="${DISK_GB:-48}"
BRIDGE="${BRIDGE:-vmbr1}"
IP_CIDR="${IP_CIDR:-10.0.0.31/24}"   # on the private NAT bridge
GATEWAY="${GATEWAY:-10.0.0.1}"
DNS="${DNS:-1.1.1.1}"
STORAGE="${STORAGE:-local-lvm}"
CI_USER="${CI_USER:-nubo}"
SSH_KEYS_FILE="${SSH_KEYS_FILE:-/root/nubo-os-dev.authorized_keys}"
CRED_FILE="${CRED_FILE:-/root/nubo-os-dev.cred}"

RELEASE="26.04"
IMG_NAME="ubuntu-${RELEASE}-server-cloudimg-amd64.img"
IMG_BASE="https://cloud-images.ubuntu.com/releases/${RELEASE}/release"
IMG_DIR="/var/lib/vz/template/iso"
IMG_PATH="${IMG_DIR}/${IMG_NAME}"

if [[ -e "/etc/pve/qemu-server/${VMID}.conf" || -e "/etc/pve/lxc/${VMID}.conf" ]]; then
  echo "Guest ${VMID} already exists; refusing to overwrite." >&2
  exit 1
fi
if [[ ! -s "${SSH_KEYS_FILE}" ]]; then
  echo "Missing ${SSH_KEYS_FILE} (public keys allowed to log in to the VM)." >&2
  exit 1
fi
if ping -c1 -W1 "${IP_CIDR%/*}" >/dev/null 2>&1; then
  echo "${IP_CIDR%/*} already answers on the network; pick another IP_CIDR." >&2
  exit 1
fi

echo "==> Fetching cloud image"
mkdir -p "${IMG_DIR}"
expected="$(curl -fsSL "${IMG_BASE}/SHA256SUMS" | awk -v f="*${IMG_NAME}" '$2 == f {print $1}')"
if [[ -z "${expected}" ]]; then
  echo "Could not find ${IMG_NAME} in upstream SHA256SUMS." >&2
  exit 1
fi
if [[ ! -f "${IMG_PATH}" ]] || [[ "$(sha256sum "${IMG_PATH}" | cut -d' ' -f1)" != "${expected}" ]]; then
  curl -fL --retry 3 -o "${IMG_PATH}.part" "${IMG_BASE}/${IMG_NAME}"
  actual="$(sha256sum "${IMG_PATH}.part" | cut -d' ' -f1)"
  if [[ "${actual}" != "${expected}" ]]; then
    rm -f "${IMG_PATH}.part"
    echo "Checksum mismatch for ${IMG_NAME}." >&2
    exit 1
  fi
  mv "${IMG_PATH}.part" "${IMG_PATH}"
fi
echo "    checksum OK"

echo "==> Creating VM ${VMID} (${NAME})"
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
  --description "Nubo OS development VM. Private network only."

qm set "${VMID}" --efidisk0 "${STORAGE}:0,efitype=4m,pre-enrolled-keys=1"
qm set "${VMID}" --scsi0 "${STORAGE}:0,import-from=${IMG_PATH},discard=on,ssd=1,iothread=1"
qm disk resize "${VMID}" scsi0 "${DISK_GB}G"
qm set "${VMID}" --boot order=scsi0

echo "==> Configuring first-boot settings"
umask 077
# openssl, not `tr </dev/urandom | head`: that pipe dies of SIGPIPE under pipefail.
password="$(openssl rand -hex 16)"
printf 'vm=%s\nuser=%s\npassword=%s\nip=%s\n' "${VMID}" "${CI_USER}" "${password}" "${IP_CIDR%/*}" >"${CRED_FILE}"

qm set "${VMID}" --ide2 "${STORAGE}:cloudinit"
qm set "${VMID}" \
  --ciuser "${CI_USER}" \
  --cipassword "${password}" \
  --sshkeys "${SSH_KEYS_FILE}" \
  --ipconfig0 "ip=${IP_CIDR},gw=${GATEWAY}" \
  --nameserver "${DNS}" \
  --ciupgrade 0
unset password

echo "==> Starting VM"
qm start "${VMID}"

cat <<EOF

VM ${VMID} started.
  address : ${IP_CIDR%/*} (private, reach it through this host)
  user    : ${CI_USER}
  password: stored in ${CRED_FILE} (root-only)
EOF
