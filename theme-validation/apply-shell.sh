#!/usr/bin/env bash
# Second step after re-login: enable User Themes and apply the Nubo shell theme.
set -euo pipefail

THEME="${1:-Nubo-Grey-Dark}"

gnome-extensions enable 'user-theme@gnome-shell-extensions.gcampax.github.com'
gsettings set org.gnome.shell.extensions.user-theme name "${THEME}"
echo "Shell theme set to ${THEME}"
