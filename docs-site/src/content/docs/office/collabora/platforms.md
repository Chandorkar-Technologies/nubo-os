---
title: "Platforms and build requirements"
description: "What the source contains for Linux, web, Windows, macOS, Android and iOS, what each build needs, and the order we plan them."
sidebar:
  order: 50
---

**Applies to:** Developers

Checked in the source on 2026-10-07 (tag `coda-26.04.3.3-1`).

| Platform | In the source | Build needs | Status |
|---|---|---|---|
| Linux desktop | `qt/`, Flatpak and snap | Linux, Qt 6 WebEngine. The engine build takes hours | Pipeline written, first build tested |
| Web (any browser, phones too) | The Collabora Online server | Linux, the server build | To do. Replaces the editor at `office.nubo.email` |
| Windows desktop | `windows/coda/` Visual Studio project, MSIX packaging, own README | Windows with Visual Studio 2026, WSL, Git Bash (WinGet files in `windows/.config/`), x64 and Arm64 | Needed. Not started |
| macOS desktop | `macos/`, own README | A Mac with Homebrew, Node 20, Xcode tools | Not started |
| Android | `android/` | Linux with the Android NDK | Not started |
| iPhone and iPad | `ios/` | A Mac with Xcode, an Apple Developer membership, a real device (no simulator) | Not started, needs the paid account |
| WebAssembly | `wasm/` | | Immature upstream. Ignored |

## Order

1. Linux desktop, which proves the rebrand.
2. The web server.
3. Windows.
4. Android and macOS.
5. iOS, when there is an Apple developer account.

## What is shared and what is per platform

The names, logos, colours and welcome slides live in the web interface, so they apply everywhere. The app id, icons, installer and store listing are done once per platform.

## Windows

- A Windows machine with about 8 cores, 32 GB of RAM and 100 GB of disk.
- Signing the package needs a code-signing certificate, which costs money and can take days to issue. Without it, Windows warns when installing.
- The Microsoft Store needs a verified publisher name.
- A Windows machine on the Proxmox host is available. Setup is to do.

## Before any store listing

Run the trademark search for the five names, and ask Collabora to confirm the credit wording.

## See also

- [Other platforms](/office/install/other-platforms/)
- [Pipeline for Nubo Office](/office/collabora/pipeline/)
