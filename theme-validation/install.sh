#!/usr/bin/env bash
# Nubo OS look validation.
# Run inside a fresh Ubuntu 26.04 desktop VM, as the normal user (not root).
# Installs Colloid (grey + black) as "Nubo", matching icons and a black cursor,
# then applies them. Undo with ./uninstall.sh.
#
# Build on Linux only: the icon repo has filenames that differ only by case,
# so a macOS checkout silently drops files.

set -euo pipefail

NAME="Nubo"
VARIANT="grey"
TWEAKS=(black rimless float)
WORK="${HOME}/.cache/nubo-theme-validation"

if [[ "$(id -u)" -eq 0 ]]; then
  echo "Run as your normal user; sudo is requested when needed." >&2
  exit 1
fi

echo "==> GNOME Shell: $(gnome-shell --version)"

echo "==> Installing build dependencies"
sudo apt-get update
sudo apt-get install -y git sassc gtk2-engines-murrine gnome-themes-extra \
  gnome-shell-extensions gnome-shell-extension-manager gnome-tweaks
# Cursor package is in universe; keep going if this release does not carry it.
sudo apt-get install -y bibata-cursor-theme || echo "!! bibata-cursor-theme not packaged here, skipping cursor"

mkdir -p "${WORK}"
cd "${WORK}"

clone_or_update() {
  local url="$1" dir="$2"
  if [[ -d "${dir}/.git" ]]; then
    git -C "${dir}" pull --ff-only
  else
    git clone --depth 1 "${url}" "${dir}"
  fi
}

echo "==> Fetching Colloid theme and icons"
clone_or_update https://github.com/vinceliuice/Colloid-gtk-theme.git gtk
clone_or_update https://github.com/vinceliuice/Colloid-icon-theme.git icons

echo "==> Building theme as ${NAME} (${VARIANT}, tweaks: ${TWEAKS[*]})"
(cd gtk && ./install.sh --name "${NAME}" --theme "${VARIANT}" --tweaks "${TWEAKS[@]}" --libadwaita)

echo "==> Building icons as ${NAME}"
(cd icons && ./install.sh --name "${NAME}" --theme "${VARIANT}")

THEME="${NAME}-Grey-Dark"

echo "==> Applying ${THEME}"
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-theme "${THEME}"
gsettings set org.gnome.desktop.interface icon-theme "${THEME}"
if [[ -d /usr/share/icons/Bibata-Modern-Classic ]]; then
  gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Classic'
fi

# The shell theme needs the User Themes extension, which only loads after a
# re-login when its package was installed in this same session.
USER_THEME_EXT='user-theme@gnome-shell-extensions.gcampax.github.com'
if gnome-extensions enable "${USER_THEME_EXT}" 2>/dev/null; then
  gsettings set org.gnome.shell.extensions.user-theme name "${THEME}"
  echo "==> Shell theme applied"
else
  echo "!! User Themes extension not loaded yet."
  echo "   Log out, log in, then run: ./apply-shell.sh"
fi

cat <<EOF

Done. Installed theme names:
  ${NAME}-Grey        ${NAME}-Grey-Light        ${NAME}-Grey-Dark

Glass (manual): open Extension Manager, install "Blur my Shell",
set blur to static, keep Applications blur OFF.

Then capture the screenshots listed in README.md.
EOF
