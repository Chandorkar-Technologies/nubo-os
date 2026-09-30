#!/usr/bin/env bash
# Run inside the live session. Tries the installer with parts of the
# white-label configuration removed, one at a time, and reports which part
# lets it reach the language page. Each try restarts the installer service.
set -u
W=/usr/share/desktop-provision
LOG=/var/log/installer/ubuntu_bootstrap.log

try() {
  local label="$1"
  pkill -9 -f bin/ubuntu_bootstrap 2>/dev/null; pkill -9 -x launcher 2>/dev/null
  sleep 2
  systemctl --user reset-failed 2>/dev/null
  sudo truncate -s0 "$LOG"
  systemctl --user start --no-block ubuntu-desktop-installer
  sleep 40
  if sudo grep -q "Loaded 75 languages\|locale: Selected" "$LOG" 2>/dev/null && sudo grep -q "route\|Navigat\|pushing\|/locale" "$LOG" 2>/dev/null; then r=maybe; else r=stuck; fi
  if pgrep -f bin/ubuntu_bootstrap >/dev/null && sudo grep -q "keyboard\|refresh" "$LOG" 2>/dev/null; then r=OK; fi
  printf '%-28s %s  (last: %s)\n' "$label" "$r" "$(sudo tail -1 "$LOG" | cut -c25-90)"
}

sudo cp -a "$W" /tmp/wl-backup
try "full config"
sudo sed -i 's/^app-name:.*/app-name: Installer/' "$W/whitelabel.yaml"; try "no app-name"
sudo cp /tmp/wl-backup/whitelabel.yaml "$W/"; sudo sed -i '/^theme:/,/^pages:/{/^pages:/!d}' "$W/whitelabel.yaml"; try "no theme"
sudo cp /tmp/wl-backup/whitelabel.yaml "$W/"; sudo sed -i '/image/d' "$W/whitelabel.yaml"; try "no page images"
sudo cp /tmp/wl-backup/whitelabel.yaml "$W/"; sudo mv "$W/slides" /tmp/slides.off; try "no slides"
sudo mv /tmp/slides.off "$W/slides"
sudo rm -f "$W/whitelabel.yaml"; try "no whitelabel.yaml"
sudo cp -a /tmp/wl-backup/. "$W/"
