---
title: "Other platforms"
description: "Windows, macOS, Android, iPhone and iPad, and the web: what each needs and where it stands."
sidebar:
  order: 20
---

Nubo Office is meant for every platform. Only Linux is being built today. The rest are planned in this order, and each needs its own build machine and packaging.

| Platform | Package | Build needs | Status |
|---|---|---|---|
| Linux | Flatpak | Linux, Qt 6 WebEngine | Pipeline written, first build tested |
| Web | Browser, signed in with Nubo Email | Collabora Online server | Planned, replaces the document editor at `office.nubo.email` |
| Windows 11 | MSIX or installer, Intel and AMD, and Arm | Windows with Visual Studio 2026, WSL, Git Bash | Planned. A code-signing certificate is needed |
| macOS | Disk image, Apple silicon and Intel | A Mac with Homebrew, Node 20 and Xcode tools | Planned |
| Android | App | Linux with the Android NDK | Planned |
| iPhone and iPad | App | A Mac with Xcode, an Apple Developer membership, a real device | Planned |

:::note
Windows and macOS builds are signed so the system does not warn when you install them. That needs a code-signing certificate for Windows and an Apple Developer ID for macOS. Early builds may show a warning until those exist.
:::

The detail behind this table, including what we found in the source for each platform, is in [Platforms and build requirements](/office/collabora/platforms/).
