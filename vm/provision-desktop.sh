#!/usr/bin/env bash
# Turn the fresh cloud-image VM into an Ubuntu Desktop development machine.
# Run inside the VM as root:  sudo bash provision-desktop.sh
#
# Development VM only: enables automatic login and disables screen locking so
# screenshots can be taken unattended. Never ship these settings.

set -euo pipefail
export DEBIAN_FRONTEND=noninteractive

DEV_USER="${DEV_USER:-nubo}"

echo "==> Waiting for first-boot setup to finish"
cloud-init status --wait >/dev/null 2>&1 || true

echo "==> Installing desktop"
apt-get update
apt-get install -y ubuntu-desktop-minimal qemu-guest-agent

echo "==> Installing theme build tools"
apt-get install -y git sassc gtk2-engines-murrine gnome-themes-extra \
  gnome-shell-extensions gnome-tweaks imagemagick librsvg2-bin \
  build-essential debhelper devscripts
# In universe; not fatal if this release does not carry them.
apt-get install -y bibata-cursor-theme || echo "!! bibata-cursor-theme unavailable"
apt-get install -y gnome-shell-extension-blur-my-shell || echo "!! blur-my-shell not packaged"

echo "==> Automatic login for ${DEV_USER} (dev VM only)"
install -d /etc/gdm3
cat >/etc/gdm3/custom.conf <<EOF
[daemon]
AutomaticLoginEnable=true
AutomaticLogin=${DEV_USER}

[security]

[xdmcp]

[chooser]

[debug]
EOF

echo "==> No welcome wizard, no screen lock, no blanking (dev VM only)"
apt-get purge -y gnome-initial-setup || true
install -d /etc/dconf/profile /etc/dconf/db/local.d
cat >/etc/dconf/profile/user <<'EOF'
user-db:user
system-db:local
EOF
cat >/etc/dconf/db/local.d/00-nubo-dev-vm <<'EOF'
[org/gnome/desktop/session]
idle-delay=uint32 0

[org/gnome/desktop/screensaver]
lock-enabled=false

[org/gnome/settings-daemon/plugins/power]
sleep-inactive-ac-type='nothing'
EOF
dconf update

echo "==> Graphical boot screen"
# Cloud images boot in text mode on a serial console. Real desktops boot
# quietly with a splash, so match that here or the boot screen never shows.
cat >/etc/default/grub.d/99-nubo-dev-splash.cfg <<'GRUBEOF'
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"
GRUB_TERMINAL=gfxterm
GRUBEOF
update-grub

systemctl enable qemu-guest-agent >/dev/null 2>&1 || true
systemctl set-default graphical.target

echo "==> Versions"
gnome-shell --version
. /etc/os-release && echo "${PRETTY_NAME}"

echo "==> Done. Reboot to enter the desktop."
