#!/usr/bin/env bash
# Build every image Nubo OS ships, for ONE CPU architecture, and upload them.
# Run it once per architecture on a machine of that architecture (as root).
# The Drone pipeline "images" does this on the build VMs; it also works by hand.
#
# Usage: ci/build-all.sh VERSION ARCH [GROUP...]
#   VERSION  for example 0.8.0-beta5 (the release tag without the leading v)
#   ARCH     amd64 or arm64; must be this machine's architecture
#   GROUP    which to build; default is all of these:
#     iso-server   installer ISOs for server, virt, containers, edge
#     iso-desktop  the desktop installer ISO (amd64 only for now)
#     disks        VM disks of the four server flavours: qcow2, raw.xz, vmdk, ova,
#                  vhdx, vhd, vdi, gcp.tar.gz, and the Incus VM metadata
#     pi           Raspberry Pi images (arm64 only)
#     containers   OCI, WSL and Incus container images
#     netboot      PXE/iPXE files
# Environment: R2_ACCESS_KEY_ID, R2_SECRET_ACCESS_KEY, R2_ENDPOINT (upload).
#   NO_UPLOAD=1 keeps everything in out/ instead. DEBS_DIR uses packages you
#   already have instead of fetching them from the bucket.
# One failing group does not stop the others; the exit status says if any failed.
set -uo pipefail
cd "$(dirname "$0")/.."
ROOT="$PWD"
VERSION="${1:?version, for example 0.8.0-beta5}"; ARCH="${2:?amd64 or arm64}"; shift 2
GROUPS_WANTED=("$@"); [[ ${#GROUPS_WANTED[@]} -gt 0 ]] || GROUPS_WANTED=(iso-server iso-desktop disks pi containers netboot)
[[ "${ARCH}" == "$(dpkg --print-architecture)" ]] || { echo "This machine is $(dpkg --print-architecture); run the ${ARCH} build on a ${ARCH} machine." >&2; exit 1; }
[[ "$(id -u)" -eq 0 ]] || { echo "Run as root." >&2; exit 1; }
. images/lib.sh
if [[ -z "${NO_UPLOAD:-}" ]]; then . ci/rclone-env.sh; fi

OUT="${OUT:-${ROOT}/out/${VERSION}}"; WORKROOT="${WORKROOT:-/var/tmp/nubo-build}"
mkdir -p "${OUT}" "${WORKROOT}/src" "${WORKROOT}/debs"
FAILED=()

want() { local g; for g in "${GROUPS_WANTED[@]}"; do [[ "$g" == "$1" ]] && return 0; done; return 1; }

# ---- packages ---------------------------------------------------------------
DEBS="${DEBS_DIR:-${WORKROOT}/debs}"
if [[ -z "${DEBS_DIR:-}" ]]; then
  rm -rf "${DEBS}"; mkdir -p "${DEBS}"
  echo "==> Packages"
  if rclone lsf "r2:${R2_BUCKET}/_staging/v${VERSION}" >/dev/null 2>&1 && [[ -n "$(rclone lsf "r2:${R2_BUCKET}/_staging/v${VERSION}")" ]]; then
    rclone copy "r2:${R2_BUCKET}/_staging/v${VERSION}" "${DEBS}" --include '*.deb'
  else
    # Staging is cleared after a release is published; use what the beta channel carries.
    rclone copyto "r2:${R2_BUCKET}/suites/resolute-beta.list" "${WORKROOT}/beta.list"
    while read -r n; do
      rclone copyto "r2:${R2_BUCKET}/pool/main/n/nubo-os/${n}" "${DEBS}/${n}"
    done < <(grep -E "^nubo-.*_(all|${ARCH})\.deb\$" "${WORKROOT}/beta.list")
  fi
fi
compgen -G "${DEBS}/nubo-*.deb" >/dev/null || { echo "No Nubo packages found." >&2; exit 1; }
# The desktop and the server packages conflict; the desktop image gets only its own.
DESKTOP_DEBS="${WORKROOT}/debs-desktop"; rm -rf "${DESKTOP_DEBS}"; mkdir -p "${DESKTOP_DEBS}"
for f in "${DEBS}"/nubo-*.deb; do
  case "$(basename "$f")" in nubo-server*|nubo-edge*|nubo-podman*|nubo-incus*) ;; *) cp "$f" "${DESKTOP_DEBS}/" ;; esac
done

# ---- helpers ----------------------------------------------------------------
fetch_verified() {   # URL DEST SUMS_URL
  local url="$1" dest="$2" sums="$3"
  [[ -s "${dest}" ]] || curl -fL --retry 3 -o "${dest}" "${url}"
  local want have
  want="$(curl -fsL "${sums}" | awk -v f="$(basename "${url}")" '$2=="*"f || $2==f {print $1}')"
  have="$(sha256sum "${dest}" | cut -d' ' -f1)"
  [[ -n "${want}" && "${want}" == "${have}" ]] || { echo "checksum mismatch: $(basename "${url}")" >&2; return 1; }
}

# Checksum, torrent and upload for everything new in OUT, then free the space.
ship() {
  local f
  for f in "${OUT}"/nubo-os-*; do
    [[ -f "$f" ]] || continue
    case "$f" in *.sha256|*.torrent) continue ;; esac
    [[ -e "$f.sha256" ]] || (cd "${OUT}" && sha256sum "$(basename "$f")" >"$(basename "$f").sha256")
    [[ -e "$f.torrent" ]] || ci/make-torrent.sh "$f" "${VERSION}" || echo "torrent failed for $(basename "$f")" >&2
  done
  if [[ -z "${NO_UPLOAD:-}" ]]; then
    rclone copy "${OUT}" "r2:${R2_BUCKET}/dl/${VERSION}" --header-upload "Cache-Control: public, max-age=3600" --exclude '*.sha256' --exclude '*.torrent'
    rclone copy "${OUT}" "r2:${R2_BUCKET}/dl/${VERSION}" --header-upload "Cache-Control: public, max-age=300" --include '*.sha256' --include '*.torrent'
    rm -f "${OUT}"/nubo-os-*
  fi
}

run() {   # NAME COMMAND...
  local name="$1"; shift
  echo; echo "################ ${name} ($(date -u +%H:%M:%S))"
  # Not "if ( ... )": that would switch off "set -e" inside the group.
  ( set -e; "$@" ); local rc=$?
  if [[ ${rc} -eq 0 ]]; then ship; else echo "!!! ${name} FAILED" >&2; FAILED+=("${name}"); rm -f "${OUT}"/nubo-os-*; fi
}

# ---- groups -----------------------------------------------------------------
iso_server() {
  local base="${WORKROOT}/src/live-server-${ARCH}.iso" flavour
  fetch_verified "$(liveserver_url "${ARCH}")" "${base}" "$(dirname "$(liveserver_url "${ARCH}")")/SHA256SUMS"
  for flavour in ${SERVER_FLAVOURS}; do
    echo "--> ${flavour}"
    ARCH="${ARCH}" FLAVOUR="${flavour}" WORK="$(mktemp -d)" iso/build-server-iso.sh "${base}" "${DEBS}" "${OUT}/nubo-os-${flavour}-${VERSION}-${ARCH}.iso"
  done
}

iso_desktop() {
  [[ "${ARCH}" == amd64 ]] || { echo "No Ubuntu desktop image for ${ARCH} is wired in yet; skipped."; return 0; }
  local iso=ubuntu-26.04.1-desktop-amd64.iso base="${CUMULUS}/cumulus-releases/26.04"
  fetch_verified "${base}/${iso}" "${WORKROOT}/src/${iso}" "${base}/SHA256SUMS"
  ARCH=amd64 WORK="${WORKROOT}/iso-desktop" iso/build-iso.sh "${WORKROOT}/src/${iso}" "${DESKTOP_DEBS}" "${OUT}/nubo-os-desktop-${VERSION}-amd64.iso"
}

disks() {
  local flavour
  for flavour in ${SERVER_FLAVOURS}; do
    echo "--> ${flavour}"
    VERSION="${VERSION}" FLAVOUR="${flavour}" images/build-cloud.sh "${DEBS}" "${OUT}" "${ARCH}"
    images/make-incus-vm.sh "${OUT}" "${flavour}" "${VERSION}" "${ARCH}"
    # Pack the qcow2 smaller for download; the disk is mostly empty space.
    qemu-img convert -c -O qcow2 "${OUT}/nubo-os-${flavour}-${VERSION}-${ARCH}.qcow2" "${WORKROOT}/c.qcow2" \
      && mv "${WORKROOT}/c.qcow2" "${OUT}/nubo-os-${flavour}-${VERSION}-${ARCH}.qcow2"
    # One flavour at a time keeps the build machine's disk use bounded.
    ship
  done
}

pi() {
  [[ "${ARCH}" == arm64 ]] || { echo "Raspberry Pi images are arm64; skipped."; return 0; }
  local flavour
  for flavour in server edge; do
    VERSION="${VERSION}" FLAVOUR="${flavour}" images/build-pi.sh "${DEBS}" "${OUT}"
    ship
  done
}

containers() { VERSION="${VERSION}" images/build-containers.sh "${DEBS}" "${OUT}" "${ARCH}"; }

netboot() {
  local base="${WORKROOT}/src/live-server-${ARCH}.iso" flavour
  fetch_verified "$(liveserver_url "${ARCH}")" "${base}" "$(dirname "$(liveserver_url "${ARCH}")")/SHA256SUMS"
  # Boot files are the same for every flavour; ship one set per architecture.
  images/make-netboot.sh "${base}" "${OUT}" server "${VERSION}" "${ARCH}"
}

want iso-server  && run iso-server  iso_server
want iso-desktop && run iso-desktop iso_desktop
want disks       && run disks       disks
want pi          && run pi          pi
want containers  && run containers  containers
want netboot     && run netboot     netboot

echo
if [[ ${#FAILED[@]} -gt 0 ]]; then echo "FAILED groups: ${FAILED[*]}" >&2; exit 1; fi
echo "All groups built for ${ARCH}."
