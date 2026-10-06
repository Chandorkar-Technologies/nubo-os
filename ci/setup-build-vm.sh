#!/usr/bin/env bash
# One-time setup of a Linux VM as a Nubo image builder and Drone exec runner.
# Do this once on an amd64 VM and once on an arm64 VM (ISOs and disks run
# the target's own programs, so each architecture builds on its own CPU).
#
# Usage (as root on Ubuntu 26.04):
#   DRONE_RPC_HOST=ci.hostingduty.com DRONE_RPC_SECRET=... ci/setup-build-vm.sh
# Needs about 150 GB of free disk space under /var/tmp and 8 GB of RAM.
#
# The runner runs pipeline commands as root on this machine. Use a machine that
# does nothing else, and keep the repository's write access to people you trust.
set -euo pipefail
[[ "$(id -u)" -eq 0 ]] || { echo "Run as root." >&2; exit 1; }
: "${DRONE_RPC_HOST:?}" "${DRONE_RPC_SECRET:?}"
ARCH="$(dpkg --print-architecture)"
export DEBIAN_FRONTEND=noninteractive

apt-get update -q
apt-get install -y -q ca-certificates curl git rsync xz-utils xorriso squashfs-tools \
  qemu-utils libguestfs-tools linux-image-generic buildah mktorrent rclone gnupg \
  python3 nodejs npm build-essential unzip jq cloud-guest-utils
# libguestfs needs a readable kernel to start its helper machine.
chmod 0644 /boot/vmlinuz-* 2>/dev/null || true

# Flutter's Linux build (the installer app) needs these.
apt-get install -y -q clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev libstdc++-14-dev libglu1-mesa unzip || true

url="https://github.com/drone-runners/drone-runner-exec/releases/latest/download/drone_runner_exec_linux_${ARCH}.tar.gz"
curl -fsSL "${url}" | tar -xz -C /usr/local/bin drone-runner-exec
chmod +x /usr/local/bin/drone-runner-exec

mkdir -p /etc/drone-runner-exec /var/tmp/nubo-build
cat >/etc/drone-runner-exec/config <<CONF
DRONE_RPC_PROTO=https
DRONE_RPC_HOST=${DRONE_RPC_HOST}
DRONE_RPC_SECRET=${DRONE_RPC_SECRET}
DRONE_RUNNER_NAME=nubo-builder-${ARCH}
DRONE_RUNNER_CAPACITY=1
DRONE_RUNNER_LABELS=nubo-builder:true
DRONE_PLATFORM_OS=linux
DRONE_PLATFORM_ARCH=${ARCH}
DRONE_LOG_FILE=/var/log/drone-runner-exec.log
CONF
chmod 0600 /etc/drone-runner-exec/config

cat >/etc/systemd/system/drone-runner-exec.service <<'UNIT'
[Unit]
Description=Drone exec runner (Nubo image builder)
After=network-online.target
Wants=network-online.target

[Service]
EnvironmentFile=/etc/drone-runner-exec/config
ExecStart=/usr/local/bin/drone-runner-exec daemon /etc/drone-runner-exec/config
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
UNIT
systemctl daemon-reload
systemctl enable --now drone-runner-exec
echo "Runner nubo-builder-${ARCH} is up. In Drone, check that it shows as connected."
echo "Also add these Drone secrets if they are missing: r2_access_key_id, r2_secret_access_key, r2_endpoint, nubo_gpg_private_key."
