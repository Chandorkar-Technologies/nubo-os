#!/usr/bin/env bash
# Build Nubo Office for macOS (Apple silicon) on the build Mac, following macos/README.md in Collabora's source.
#
# Usage: ci/build-office-macos.sh [STAGE ...]
#   stages (default: all, in this order):
#     tools    Python helpers for the build
#     engine   the office engine (hours); safe to re-run, make resumes where it stopped
#     online   configure the app, build the web interface, put our brand pack in place
#     app      build the app with Xcode
#     dmg      package a .dmg
# Environment: WORK (default /Volumes/NuboBuild: an APFS volume with room for about 60 GB),
#              VER (default 26.04.3.3-nubo1), SIGN (a codesign identity; default "-" = ad hoc, for our own testing).
# The source is expected in $WORK/office (a checkout of Collabora's monorepo at the release tag).
set -euo pipefail
cd "$(dirname "$0")/.."
REPO="$PWD"
WORK="${WORK:-/Volumes/NuboBuild}"
SRC="${WORK}/office"
VER="${VER:-26.04.3.3-nubo1}"
SIGN="${SIGN:--}"
APP_NAME="Nubo Office"
APP_ID="tech.nubosuite.Office"
LOGS="${WORK}/logs"; mkdir -p "${LOGS}"
# The helper Python (lxml, polib) goes on PATH only for the later stages: in front of Homebrew's python it breaks meson in the engine build.
export PATH="/opt/homebrew/opt/node@22/bin:/opt/homebrew/bin:/opt/homebrew/opt/make/libexec/gnubin:${PATH}"
export CCACHE_DIR="${WORK}/ccache"; export CCACHE_MAXSIZE=15G
[[ -d "${SRC}/engine" ]] || { echo "No source in ${SRC}" >&2; exit 1; }
stages=("$@"); [[ ${#stages[@]} -eq 0 ]] && stages=(tools engine online app dmg)
has() { local s; for s in "${stages[@]}"; do [[ "$s" == "$1" ]] && return 0; done; return 1; }

if has tools; then
  echo "==> tools"
  [[ -x "${WORK}/venv/bin/python3" ]] || python3 -m venv "${WORK}/venv"
  "${WORK}/venv/bin/pip" install -q lxml polib dmgbuild
fi

if has engine; then
  echo "==> engine: names"
  python3 "${REPO}/office/rebrand.py" "${SRC}" --version "${VER}" --platform macos | tail -3
  echo "==> engine: configure and build (this takes hours)"
  cat > "${SRC}/engine/autogen.input" <<INPUT
PKG_CONFIG=/opt/homebrew/bin/pkg-config
GNUMAKE=gmake
--with-distro=CPMacOS-LOKit
--disable-mergelibs
--enable-ccache
--without-lang
--with-product-name=${APP_NAME}
--with-vendor=Nubo
INPUT
  ( cd "${SRC}/engine" && ./autogen.sh && make ) 2>&1 | tee -a "${LOGS}/engine.log"
  ls -d "${SRC}"/engine/instdir/*.app
fi

if has online; then
  export PATH="${WORK}/venv/bin:${PATH}"
  echo "==> online: configure"
  APPDIR="$(ls -d "${SRC}"/engine/instdir/*.app | head -1)"
  ( cd "${SRC}" && ./autogen.sh && ./configure --enable-macosapp --enable-experimental \
      --with-app-name="${APP_NAME}" --with-app-package-name="${APP_ID}" --with-vendor="Nubo" \
      --with-lo-path="${APPDIR#${SRC}/}" ) 2>&1 | tee -a "${LOGS}/online.log"
  echo "==> online: the web interface"
  ( cd "${SRC}" && make ) 2>&1 | tee -a "${LOGS}/online.log"
  echo "==> brand pack into the web interface"
  BRAND="${REPO}/office/brand"
  mkdir -p "${SRC}/browser/dist"
  cp -a "${BRAND}"/branding* "${BRAND}/images" "${SRC}/browser/dist/"
fi

if has app; then
  echo "==> app: Xcode"
  ( cd "${SRC}/macos/coda" && xcodebuild -project coda.xcodeproj -scheme coda -configuration Release \
      -derivedDataPath "${WORK}/xcode" CODE_SIGN_IDENTITY="${SIGN}" CODE_SIGNING_ALLOWED=YES build ) 2>&1 | tee -a "${LOGS}/xcode.log" | tail -30
  ls -d "${WORK}"/xcode/Build/Products/Release/*.app
fi

if has dmg; then
  echo "==> dmg"
  APP="$(ls -d "${WORK}"/xcode/Build/Products/Release/*.app | head -1)"
  mkdir -p "${WORK}/out"
  hdiutil create -volname "${APP_NAME}" -srcfolder "${APP}" -ov -format UDZO "${WORK}/out/nubo-office-${VER}-arm64.dmg"
  shasum -a 256 "${WORK}/out/nubo-office-${VER}-arm64.dmg" | tee "${WORK}/out/nubo-office-${VER}-arm64.dmg.sha256"
fi
