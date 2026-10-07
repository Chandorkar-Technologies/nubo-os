---
title: "Source and build"
description: "Where Collabora's code is, and the steps to build the engine and the Linux desktop app."
sidebar:
  order: 20
---

**Applies to:** Developers

## The code

Everything lives in one monorepo. The former Collabora Office core is the `engine/` folder.

- Read-only mirror: https://github.com/CollaboraOnline/online.mirror
- Home repository (Gerrit): `https://gerrit.collaboraoffice.com/online`
- We build the release the Flathub app uses. For example the tag `coda-26.04.3.3-1`.

```bash
git clone --depth 1 --branch coda-26.04.3.3-1 https://github.com/CollaboraOnline/online.mirror collabora
```

The clone is about 2.3 GB.

## What the monorepo holds

| Folder | Holds |
|---|---|
| `engine/` | The office engine (LibreOffice-based) |
| `browser/` | The web interface: TypeScript, CSS, HTML. All four apps share it |
| `qt/` | The Linux desktop app: Qt 6 WebEngine around the web interface |
| `wsd/`, `kit/`, `common/` | The server and the document process |
| `windows/coda/`, `macos/`, `android/`, `ios/` | The other platforms |
| `wasm/` | WebAssembly experiment, not used |

## Build the Linux desktop app

These steps follow `qt/README.md` in the checkout.

1. Install the dependencies (Ubuntu 26.04):

   ```bash
   sudo apt install -y autoconf automake build-essential cmake fontconfig git \
     libcap-dev libcppunit-dev libpam0g-dev libpng-dev libssl-dev libtool libzstd-dev \
     npm pkg-config python3-lxml python3-polib qt6-base-dev qt6-tools-dev \
     qt6-tools-dev-tools qt6-webengine-dev qt6-websockets-dev ccache
   ```

   The engine also needs the LibreOffice build tools (gperf, flex, bison, nasm and the usual development libraries). A compiler with full C++20 support (GCC 13 or newer) is required.

2. Build the engine, with our product name and vendor:

   ```bash
   cd engine
   ./autogen.sh --with-distro=CPLinux-LOKit --without-package-format --with-system-nss \
       --with-product-name="Nubo Office" --with-vendor="Nubo" --enable-ccache
   make -j8
   ```

3. Apply the rebrand (see [the rebrand script](/office/collabora/rebrand-script/)), then build the app from the top of the checkout:

   ```bash
   python3 office/rebrand.py . --version 26.04.3.3-nubo1
   ./autogen.sh
   ./configure --enable-qtapp --with-app-branding=$PWD/qt/brand-nubo --enable-silent-rules
   make -j8
   ```

   This gives `qt/coda-qt`.

## How long it takes

On a VM with 8 cores and 22 GB of RAM, the engine build ran for about four hours: roughly 9,750 compile steps out of 14,900 build steps in all. The app and the web interface took a few minutes on top. Later builds are much faster with `ccache`.

## Verify

```bash
grep -E "PRODUCTNAME|OOO_VENDOR" engine/config_host.mk
```

The product is `Nubo Office` and the vendor is `Nubo`. Running `qt/coda-qt` shows the start screen under the Nubo name.

## Troubleshooting

- **The compile fails in the web interface.** Run the rebrand script only once per checkout state, or use a fresh checkout. The script is safe to run twice, but a half-applied manual edit can break the TypeScript build.
- **The window says "Collabora Office".** The rebrand script was not run before the app build, or a `.tsx` file was skipped. Run it again and rebuild.
- **The first run in a virtual machine shows a blank window.** Use software rendering: `QT_QPA_PLATFORM=xcb QTWEBENGINE_CHROMIUM_FLAGS="--no-sandbox --disable-gpu"`.

## See also

- [Pipeline for Nubo Office](/office/collabora/pipeline/)
- [First build results](/office/collabora/first-build/)
