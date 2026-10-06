# Shared by the image scripts.
# Artifact names: nubo-os-<flavour>-<version>-<arch>.<extension>
#   flavour: desktop server virt containers edge base
#   version: for example 0.8.0-beta5

# Packages each server flavour installs.
flavour_packages() {
  case "$1" in
    server)     echo "nubo-archive nubo-base nubo-server-core nubo-server-base" ;;
    virt)       echo "nubo-archive nubo-base nubo-server-core nubo-server-base nubo-incus" ;;
    containers) echo "nubo-archive nubo-base nubo-server-core nubo-server-base nubo-podman" ;;
    edge)       echo "nubo-archive nubo-base nubo-server-core nubo-edge" ;;
    base)       echo "nubo-archive nubo-base" ;;
    *) echo "unknown flavour: $1" >&2; return 1 ;;
  esac
}

SERVER_FLAVOURS="server virt containers edge"

# Ubuntu's own sources, fetched through Nubo Cumulus.
CUMULUS=https://archive.nubosuite.tech
cloudimg_url()  { echo "${CUMULUS}/cumulus-cloud/resolute/current/resolute-server-cloudimg-$1.img"; }
liveserver_url() {
  case "$1" in
    amd64) echo "${CUMULUS}/cumulus-releases/26.04/ubuntu-26.04-live-server-amd64.iso" ;;
    arm64) echo "${CUMULUS}/cumulus-images/ubuntu/releases/26.04/release/ubuntu-26.04-live-server-arm64.iso" ;;
  esac
}
