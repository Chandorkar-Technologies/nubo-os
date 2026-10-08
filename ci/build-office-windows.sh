#!/usr/bin/env bash
# Build Nubo Office for Windows (x64). Run from Git Bash on the Windows build PC, following windows/coda/README.md
# in Collabora's source.
#
# Usage: ci/build-office-windows.sh [configure|make|all]      (default: all; "make" resumes an interrupted build)
#
# One-time setup of the PC (see docs/office/windows-build.md for the details we used):
#   - Visual Studio 2026 Community with the components in windows/.config/2026.vsconfig
#   - tools in H:\co\bin (make 4.2.1 msvc, jom, pkgconf) and Strawberry Perl Portable in H:\co\spp (with Font::TTF)
#   - WSL2 with an Ubuntu 24.04 distro that is the DEFAULT distro (the scripts call plain wsl.exe), with the packages from
#     user_steps.winget and Node.js 22 (Node 20 crashes esbuild's WebAssembly)
#   - Developer Mode on, git core.autocrlf=false
#   - the source (coda-<release> tag) in H:\co\collabora-office with the Nubo rebrand applied (office/rebrand.py, --platform windows)
# Paths must not contain spaces.
set -e
ROOT="${ROOT:-/h/co}"
export MSYS=winsymlinks:nativestrict
# Windows Perl writes CRLF line endings by default. The build generates gperf tables with Perl, and gperf rejects CRLF
# ("junk after declaration"), which breaks libabw, libfreehand and libvisio. Unix line endings fix it.
export PERLIO=perlio
export PATH="${ROOT}/bin:${ROOT}/spp/c/bin:${ROOT}/spp/perl/bin:$PATH"
mkdir -p "${ROOT}/logs" "${ROOT}/co-externaltar" "${ROOT}/build"
cd "${ROOT}/build"
step="${1:-all}"

if [[ "$step" == configure || "$step" == all ]]; then
  cat > autogen.input <<'INPUT'
--with-distro=CODAWindows
--host=x86_64-pc-cygwin
--with-visual-studio=2026
--with-strawberry-perl-portable=H:\co\spp
--with-external-tar=H:\co\co-externaltar
--with-product-name=Nubo Office
--with-vendor=Nubo
INPUT
  echo "== autogen $(date)" | tee -a "${ROOT}/logs/build.log"
  "${ROOT}/collabora-office/windows/coda/build/autogen.sh" 2>&1 | tee -a "${ROOT}/logs/build.log"
fi
if [[ "$step" == make || "$step" == all ]]; then
  echo "== make $(date)" | tee -a "${ROOT}/logs/build.log"
  make CONFIG=Release 2>&1 | tee -a "${ROOT}/logs/build.log"
  echo "== finished $(date)" | tee -a "${ROOT}/logs/build.log"
fi
