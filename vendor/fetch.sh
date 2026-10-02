#!/usr/bin/env bash
# Fetch pinned upstream sources into vendor/. Run before building packages;
# the package build itself never touches the network.
# To take an upstream update: change the pin below, rebuild, re-test.

set -euo pipefail
cd "$(dirname "$0")"

fetch_git() {
  local name="$1" url="$2" commit="$3"
  if [[ -d "${name}/.git" ]] && [[ "$(git -C "${name}" rev-parse HEAD)" == "${commit}" ]]; then
    echo "${name}: already at ${commit:0:12}"
    return
  fi
  rm -rf "${name}"
  git init -q "${name}"
  git -C "${name}" remote add origin "${url}"
  git -C "${name}" fetch -q --depth 1 origin "${commit}"
  git -C "${name}" checkout -q FETCH_HEAD
  echo "${name}: fetched ${commit:0:12}"
}

fetch_file() {
  local name="$1" url="$2" sha256="$3"
  if [[ -f "${name}" ]] && [[ "$(sha256sum "${name}" | cut -d' ' -f1)" == "${sha256}" ]]; then
    echo "${name}: already present"
    return
  fi
  curl -fsSL --retry 3 -o "${name}.part" "${url}"
  if [[ "$(sha256sum "${name}.part" | cut -d' ' -f1)" != "${sha256}" ]]; then
    rm -f "${name}.part"
    echo "${name}: checksum mismatch" >&2
    exit 1
  fi
  mv "${name}.part" "${name}"
  echo "${name}: fetched"
}

# Application and shell theme. GPL-3.0.
fetch_git colloid-gtk https://github.com/vinceliuice/Colloid-gtk-theme.git \
  fe11342f37f124f1b29d44cf33e9a06053f4bba2

# Glass effect, release 73 (supports GNOME 46 to 51, blurs menus too). GPL-3.0.
fetch_file blur-my-shell.zip \
  "https://github.com/aunetx/blur-my-shell/releases/download/v73/blur-my-shell%40aunetx.shell-extension.zip" \
  237a59e04b3cffd3fb86aa3cd18b32f929c61e2af8dcc781379364a59d53b129

# App grid layout (rows, columns, icon size), release 9. MIT.
fetch_file app-grid-tuner.zip \
  "https://extensions.gnome.org/download-extension/app-grid-tuner%40m-lab.shell-extension.zip?version_tag=74585" \
  1f22a99698cb626c975d11c5941a413d069ec0614ecaf993042aa1804faa3f67

# Desktop clock and weather widget, release 8 (supports GNOME 46 to 50). GPL-3.0+.
fetch_file glass-widgets.zip \
  "https://extensions.gnome.org/download-extension/glass-widgets%40peter-njoro.github.io.shell-extension.zip?version_tag=74968" \
  ba0ceef0b730fc1e9b439d591d2a9a10170a578a4cc5dc6066cb69d59bde853e

# Launcher behind Nubo Search, release 0.29.1 as an AppImage (it carries its own
# Qt and C++ runtime; the plain tarball needs a newer C++ library than Ubuntu
# 26.04 ships). GPL-3.0.
fetch_file vicinae.AppImage \
  "https://github.com/vicinaehq/vicinae/releases/download/v0.29.1/Vicinae-x86_64.AppImage" \
  44906f2290f0934572f1977de8aa529c3b67d104025a489b32f226fe3b0f3dd9
