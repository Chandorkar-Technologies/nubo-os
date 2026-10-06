#!/usr/bin/env bash
# Incus virtual-machine image: the metadata file that goes with a qcow2 disk.
# Import: incus image import NAME.incus-vm.tar.xz NAME.qcow2 --alias nubo-os
# Usage: make-incus-vm.sh OUT_DIR FLAVOUR VERSION ARCH
set -euo pipefail
OUT="$(readlink -f "${1:?out dir}")"; FLAVOUR="${2:?}"; VER="${3:?}"; ARCH="${4:?}"
case "${ARCH}" in amd64) a=x86_64 ;; arm64) a=aarch64 ;; esac
meta="$(mktemp -d)"; trap 'rm -rf "${meta}"' EXIT
cat >"${meta}/metadata.yaml" <<YAML
architecture: ${a}
creation_date: $(date -u +%s)
properties:
  description: Nubo OS ${FLAVOUR} ${VER}
  os: nubo
  release: "${VER}"
  variant: cloud
  architecture: ${a}
YAML
tar -C "${meta}" -cJf "${OUT}/nubo-os-${FLAVOUR}-${VER}-${ARCH}.incus-vm.tar.xz" metadata.yaml
