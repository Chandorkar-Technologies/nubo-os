#!/usr/bin/env bash
# Revert the VM to stock Ubuntu look and remove the Nubo test themes.
set -euo pipefail

WORK="${HOME}/.cache/nubo-theme-validation"

gsettings reset org.gnome.desktop.interface gtk-theme
gsettings reset org.gnome.desktop.interface icon-theme
gsettings reset org.gnome.desktop.interface cursor-theme
gsettings reset org.gnome.desktop.interface color-scheme
gsettings reset org.gnome.shell.extensions.user-theme name 2>/dev/null || true

if [[ -d "${WORK}/gtk" ]]; then
  (cd "${WORK}/gtk" && ./install.sh --name Nubo --remove) || true
fi
if [[ -d "${WORK}/icons" ]]; then
  (cd "${WORK}/icons" && ./install.sh --name Nubo --remove) || true
fi

# The --libadwaita flag wrote overrides here; remove them so GTK4 apps reset.
rm -rf "${HOME}/.config/gtk-4.0/gtk.css" "${HOME}/.config/gtk-4.0/gtk-dark.css" \
  "${HOME}/.config/gtk-4.0/assets"

echo "Reverted. Log out and back in to finish."
