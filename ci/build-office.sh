#!/usr/bin/env bash
# Build Nubo Office (Collabora's code under Nubo names) as a Flatpak and publish
# it to our own Flatpak repository at archive.nubosuite.tech/flatpak.
#
# Usage: ci/build-office.sh UPSTREAM_TAG NUBO_VERSION
#   UPSTREAM_TAG  Collabora's release tag, for example coda-26.04.3.3-1
#   NUBO_VERSION  what we call it, for example 26.04.3.3-nubo1
# Run as an ordinary user with sudo on an amd64 build machine (see ci/setup-build-vm.sh).
# Not as root: flatpak-builder run by root cannot set file owners while unpacking archives
# inside its sandbox ("Can't set user=1000 ... Invalid argument"), and the build stops. Takes hours: the
# engine is LibreOffice-sized. Reuses work in WORK between runs (ccache, downloads).
# Environment: R2_ACCESS_KEY_ID, R2_SECRET_ACCESS_KEY, R2_ENDPOINT; GPG_KEY_ID of a
# secret key in the keyring (signs the repository); NO_UPLOAD=1 keeps the repo local.
#
# Not run end to end yet: the first run needs watching.
set -euo pipefail
cd "$(dirname "$0")/.."
ROOT="$PWD"
TAG="${1:?upstream tag, for example coda-26.04.3.3-1}"
VER="${2:?our version, for example 26.04.3.3-nubo1}"
WORK="${WORK:-/var/tmp/nubo-office}"
SRC="${WORK}/src"
REPO="${WORK}/repo"
APP_ID=tech.nubosuite.Office
mkdir -p "${WORK}"
export TMPDIR="${WORK}/tmp"; mkdir -p "${TMPDIR}"

echo "==> Source ${TAG}"
rm -rf "${SRC}"
git clone --depth 1 --branch "${TAG}" https://github.com/CollaboraOnline/online.mirror "${SRC}"

echo "==> Applying the Nubo names"
python3 office/rebrand.py "${SRC}" --version "${VER}" | tail -4
if grep -rIl "Collabora Online Development Edition" "${SRC}/browser/src" "${SRC}/qt" >/dev/null 2>&1; then
  echo "A Collabora product name is left in the interface; refusing to build." >&2
  python3 office/rebrand.py "${SRC}" --report | tail -20 >&2
  exit 1
fi

echo "==> Flatpak runtimes"
FP=(flatpak); [[ "$(id -u)" -ne 0 ]] && FP=(sudo flatpak)
"${FP[@]}" remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
for ref in org.kde.Sdk//6.10 org.kde.Platform//6.10 org.freedesktop.Sdk.Extension.node20//25.08 \
           io.qt.qtwebengine.BaseApp//6.10 io.qt.qtwebengine.BaseApp.Debug//6.10; do
  flatpak info "${ref%%//*}//${ref##*//}" >/dev/null 2>&1 || "${FP[@]}" install -y --noninteractive flathub "${ref}"
done

echo "==> Building ${APP_ID} (the long step)"
SIGN=(); [[ -n "${GPG_KEY_ID:-}" ]] && SIGN=(--gpg-sign="${GPG_KEY_ID}")
# --disable-rofiles-fuse: an ordinary user cannot mount the helper on this machine, and it is only a speed-up.
(cd "${SRC}" && flatpak-builder --force-clean --ccache --disable-rofiles-fuse --repo="${REPO}" "${SIGN[@]}" \
  --default-branch=stable "${WORK}/build" "qt/flatpak/${APP_ID}.json")
flatpak build-update-repo "${SIGN[@]}" --generate-static-deltas --prune "${REPO}"

echo "==> Repository description"
cat >"${REPO}/nubo.flatpakrepo" <<REPOFILE
[Flatpak Repo]
Title=Nubo OS
Url=https://archive.nubosuite.tech/flatpak/
Homepage=https://os.nubosuite.tech
Comment=Apps built by Nubo OS
$( [[ -n "${GPG_KEY_ID:-}" ]] && echo "GPGKey=$(gpg --export "${GPG_KEY_ID}" | base64 -w0)" )
REPOFILE

echo "==> A single downloadable bundle"
ARCH_FP="$(uname -m)"          # x86_64 or aarch64
BUNDLE_DIR="${WORK}/bundle"; rm -rf "${BUNDLE_DIR}"; mkdir -p "${BUNDLE_DIR}"
BUNDLE="nubo-office-${VER}-${ARCH_FP}.flatpak"
flatpak build-bundle "${REPO}" "${BUNDLE_DIR}/${BUNDLE}" "${APP_ID}" stable
(cd "${BUNDLE_DIR}" && sha256sum "${BUNDLE}" > "${BUNDLE}.sha256")
DL_BASE=https://archive.nubosuite.tech/dl/office ci/make-torrent.sh "${BUNDLE_DIR}/${BUNDLE}" "${VER}" || echo "no torrent made" >&2
python3 ci/make-office-manifest.py "${BUNDLE_DIR}" "${BUNDLE}" "${VER}" "${ARCH_FP}"

if [[ -z "${NO_UPLOAD:-}" ]]; then
  . ci/rclone-env.sh
  echo "==> Uploading to r2:${R2_BUCKET}/flatpak"
  rclone sync "${REPO}" "r2:${R2_BUCKET}/flatpak" --fast-list --transfers 16 \
    --header-upload "Cache-Control: public, max-age=300"
  rclone copy "${BUNDLE_DIR}" "r2:${R2_BUCKET}/dl/office/${VER}" --exclude 'latest-*.json' \
    --header-upload "Cache-Control: public, max-age=3600"
  # The website reads this to show the download.
  rclone copyto "${BUNDLE_DIR}/latest-${ARCH_FP}.json" "r2:${R2_BUCKET}/dl/office/latest-${ARCH_FP}.json" \
    --header-upload "Cache-Control: public, max-age=60"
  echo "Add it with: flatpak remote-add --if-not-exists nubo https://archive.nubosuite.tech/flatpak/nubo.flatpakrepo"
  echo "Download: https://archive.nubosuite.tech/dl/office/${VER}/${BUNDLE}"
fi
