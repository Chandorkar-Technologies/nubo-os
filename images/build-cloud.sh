#!/usr/bin/env bash
# Nubo OS Server virtual-machine disks from Ubuntu's cloud image.
# Usage: VERSION=0.8.0-beta5 [FLAVOUR=server] build-cloud.sh DEBS_DIR OUT_DIR [amd64|arm64]
# Output: nubo-os-FLAVOUR-VERSION-ARCH.{qcow2,raw.xz,vmdk,ova,vhdx,vhd,vdi,gcp.tar.gz}
# Runs natively: the image's own programs run while the packages install, so an
# arm64 disk needs an arm64 machine. Needs root, qemu-utils, libguestfs-tools.
#
# These are cloud images: no password and no SSH key are set. Give the machine a
# login with cloud-init (a "seed" disk or the platform's user data); see
# the docs page "Run Nubo OS in a virtual machine".
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
. "${HERE}/lib.sh"
FLAVOUR="${FLAVOUR:-server}"
VERSION="${VERSION:?VERSION required, for example 0.8.0-beta5}"
PKGS="$(flavour_packages "${FLAVOUR}")"
DEBLIST=""; for p in ${PKGS}; do DEBLIST="${DEBLIST} /var/tmp/debs/${p}_*.deb"; done
DEBS="$(readlink -f "${1:?debs dir}")"; OUT="$(readlink -f "${2:?out dir}")"
ARCH="${3:-$(dpkg --print-architecture)}"
[[ "${ARCH}" == "$(dpkg --print-architecture)" ]] || { echo "Build ${ARCH} disks on a ${ARCH} machine." >&2; exit 1; }
mkdir -p "${OUT}"
N="nubo-os-${FLAVOUR}-${VERSION}-${ARCH}"
IMG="${OUT}/${N}.qcow2"
curl -fL --retry 3 -o "${IMG}" "$(cloudimg_url "${ARCH}")"
qemu-img resize "${IMG}" 10G
virt-customize -a "${IMG}" \
  --copy-in "${DEBS}":/var/tmp \
  --copy-in "${HERE}/../ci/use-cumulus.sh":/var/tmp \
  --run-command 'sh /var/tmp/use-cumulus.sh' \
  --run-command "apt-get update -q && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends ${DEBLIST}" \
  --run-command '/usr/libexec/nubo/nubo-server-firewall || true' \
  --run-command 'cloud-init clean --logs || true' \
  --run-command 'rm -rf /var/tmp/debs /var/tmp/use-cumulus.sh' \
  --truncate /etc/machine-id
"${HERE}/convert.sh" "${IMG}" "${OUT}" "${FLAVOUR}" "${VERSION}" "${ARCH}"
