#!/usr/bin/env bash
# Container-style images: OCI (Docker, Podman, Kubernetes), WSL and Incus/LXC.
# They carry the Nubo base only (archive, update settings, no crash reports):
# a container needs no firewall, SSH server or boot loader.
# Usage: VERSION=0.8.0-beta5 build-containers.sh DEBS_DIR OUT_DIR [amd64|arm64]
# Output: nubo-os-base-VERSION-ARCH.{oci.tar,wsl,incus-container.tar.xz,incus-container.squashfs}
# Optional: OCI_REPO=ghcr.io/owner/nubo-os with REGISTRY_USER and REGISTRY_PASSWORD
#   also pushes the image to that registry as :VERSION (and :latest on a final release).
# Run natively as root. Needs buildah, squashfs-tools, xz-utils.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
. "${HERE}/lib.sh"
VERSION="${VERSION:?VERSION required}"
DEBS="$(readlink -f "${1:?debs dir}")"; OUT="$(readlink -f "${2:?out dir}")"
ARCH="${3:-$(dpkg --print-architecture)}"
[[ "${ARCH}" == "$(dpkg --print-architecture)" ]] || { echo "Build ${ARCH} container images on a ${ARCH} machine." >&2; exit 1; }
N="nubo-os-base-${VERSION}-${ARCH}"
mkdir -p "${OUT}"

ctr="$(buildah from --arch "${ARCH}" docker.io/library/ubuntu:26.04)"
trap 'buildah rm "${ctr}" >/dev/null 2>&1 || true' EXIT
mkdir -p /tmp/nubo-ctr-debs && rm -f /tmp/nubo-ctr-debs/*
for p in $(flavour_packages base); do cp "${DEBS}/${p}_"*.deb /tmp/nubo-ctr-debs/; done
buildah copy "${ctr}" /tmp/nubo-ctr-debs /var/tmp/debs
buildah copy "${ctr}" "${HERE}/../ci/use-cumulus.sh" /var/tmp/use-cumulus.sh
buildah run "${ctr}" -- sh -c '
  set -e
  export DEBIAN_FRONTEND=noninteractive
  apt-get update -q && apt-get install -y -q --no-install-recommends ca-certificates
  sh /var/tmp/use-cumulus.sh
  apt-get update -q
  apt-get install -y -q --no-install-recommends /var/tmp/debs/*.deb
  rm -rf /var/tmp/debs /var/tmp/use-cumulus.sh /var/lib/apt/lists/*'
buildah config --label org.opencontainers.image.title="Nubo OS" \
  --label org.opencontainers.image.version="${VERSION}" \
  --label org.opencontainers.image.source="https://github.com/Chandorkar-Technologies/nubo-os" \
  --label org.opencontainers.image.licenses="GPL-3.0-or-later" \
  --cmd /bin/bash "${ctr}"
img="nubo-os:${VERSION}-${ARCH}"
buildah commit --format oci "${ctr}" "${img}" >/dev/null
buildah push "${img}" "oci-archive:${OUT}/${N}.oci.tar:nubo-os:${VERSION}"
if [[ -n "${OCI_REPO:-}" ]]; then
  creds=(); [[ -n "${REGISTRY_USER:-}" ]] && creds=(--creds "${REGISTRY_USER}:${REGISTRY_PASSWORD:?}")
  buildah push "${creds[@]}" "${img}" "docker://${OCI_REPO}:${VERSION}-${ARCH}"
fi

# Root file system for WSL and Incus.
mnt="$(buildah mount "${ctr}")"
mkdir -p "${mnt}/etc"
tar -C "${mnt}" -czf "${OUT}/${N}.wsl" .
mksquashfs "${mnt}" "${OUT}/${N}.incus-container.squashfs" -comp xz -noappend -quiet -no-progress
buildah umount "${ctr}" >/dev/null

meta="$(mktemp -d)"
case "${ARCH}" in amd64) incus_arch=x86_64 ;; arm64) incus_arch=aarch64 ;; esac
cat >"${meta}/metadata.yaml" <<YAML
architecture: ${incus_arch}
creation_date: $(date -u +%s)
properties:
  description: Nubo OS ${VERSION}
  os: nubo
  release: "${VERSION}"
  variant: default
  architecture: ${incus_arch}
YAML
tar -C "${meta}" -cJf "${OUT}/${N}.incus-container.tar.xz" metadata.yaml
rm -rf "${meta}" /tmp/nubo-ctr-debs
ls -lh "${OUT}/${N}".*
