#!/usr/bin/env bash
# Network boot (PXE/iPXE) files from a server installer ISO: kernel, initrd and
# an iPXE script. Host the ISO next to them and boot with its URL.
# Usage: make-netboot.sh SERVER_ISO OUT_DIR FLAVOUR VERSION ARCH
# Needs xorriso.
set -euo pipefail
ISO="$(readlink -f "${1:?iso}")"; OUT="$(readlink -f "${2:?out dir}")"
FLAVOUR="${3:?}"; VER="${4:?}"; ARCH="${5:?}"
N="nubo-os-${FLAVOUR}-${VER}-${ARCH}"
w="$(mktemp -d)"; trap 'rm -rf "${w}"' EXIT
mkdir -p "${w}/${N}-netboot"
xorriso -osirrox on -indev "${ISO}" -extract /casper/vmlinuz "${w}/${N}-netboot/vmlinuz" \
  -extract /casper/initrd "${w}/${N}-netboot/initrd" 2>/dev/null
cat >"${w}/${N}-netboot/nubo.ipxe" <<IPXE
#!ipxe
# Put ${N}.iso on a web server and change ISO_URL to its address.
set ISO_URL http://your-server.example/${N}.iso
set base \${boot-url}
kernel \${base}vmlinuz ip=dhcp url=\${ISO_URL} --- quiet
initrd \${base}initrd
boot
IPXE
tar -C "${w}" -cJf "${OUT}/${N}.netboot.tar.xz" "${N}-netboot"
