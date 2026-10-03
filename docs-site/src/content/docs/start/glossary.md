---
title: Glossary
description: Plain definitions of the terms used across the Nubo OS documentation.
sidebar:
  order: 60
---

Terms are in alphabetical order.

**Activities overview.** The full-screen view that shows open windows, a search box and the app grid. In Nubo OS, clicking the Nubo logo at the left of the top bar opens it.

**amd64.** The 64-bit Intel and AMD processor architecture. Nubo OS builds for it.

**apt.** The command-line tool that installs, updates and removes packages on Ubuntu and Nubo OS.

**arm64.** The 64-bit Arm processor architecture, used by Apple silicon Macs, Raspberry Pi 4 and 5, and many servers. Nubo OS builds for it.

**Archive.** A server that stores packages for `apt`. Nubo's archive is at `archive.nubosuite.tech`. Ubuntu has its own archive.

**authd.** An Ubuntu service that lets the login screen accept sign-ins from an outside identity provider. Nubo account sign-in uses it.

**authd-oidc.** The broker that connects authd to an OpenID Connect provider. It is distributed as a snap, which is why `snapd` stays on the desktop.

**Autoinstall.** Ubuntu's way of giving the installer a file of answers. Nubo's file keeps every screen interactive and adds a last step that installs the Nubo packages. See [What the installer does](/desktop/get-started/what-the-installer-does/).

**Beta channel.** The `resolute-beta` suite of the Nubo archive, with early packages. See *Channel*.

**Beta.** The state of Nubo OS 1 at the time of writing.

**Channel.** A stream of package updates. Nubo has `stable` (suite `resolute`) and `beta` (suite `resolute-beta`). Change it with `sudo nubo-channel`.

**Collabora Office.** The office suite that replaces LibreOffice in Nubo OS. It comes from Flathub.

**Cumulus (Nubo Cumulus).** A cache of Ubuntu's archive and images, run by Nubo as a Cloudflare Worker. Ubuntu's packages pass through it unchanged and still carry Ubuntu's signatures.

**dconf.** GNOME's settings database. Nubo's defaults are written into it.

**Dock.** The bar of app icons at the bottom of the screen. Nubo's dock floats and is centred.

**Edge (edition).** The smallest Nubo OS Server: the core and automatic security updates.

**Extension (GNOME Shell extension).** A small add-on that changes the GNOME Shell. Nubo uses extensions for the top bar logo, the notification centre, the widgets, the blur and others.

**Flatpak.** A way to install apps with their own libraries, used here with Flathub.

**Flathub.** The main catalog of Flatpak apps. Nubo OS installs several apps from it on first boot.

**Flavour.** A variant of Nubo OS Server: server, virt, containers or edge in the build scripts. The docs call them editions.

**Flow.** The name of Nubo OS release 1.

**GNOME.** The desktop environment Nubo OS builds on. Release 1 uses GNOME 50.

**GNOME Shell.** The part of GNOME that draws the top bar, overview and notifications.

**GSConnect.** A GNOME Shell extension that links your phone to your desktop. Nubo ships it with scrcpy.

**Incus.** A manager for system containers and virtual machines, used by the Virtualization edition.

**ISO.** A disk image file. You write an ISO to a USB stick to install or try Nubo OS.

**Live session.** Running the desktop from the USB stick without installing, to try it out.

**Nubo Account.** A sign-in managed by Nubo SSO at `mail.nubo.email`, offered at the login screen as early access.

**nubo-channel.** The command that shows or switches the update channel.

**nubo-get.** The helper that downloads a popular app from Flathub and opens it when you click its grey icon.

**Nubo Search.** The launcher opened with <kbd>Super</kbd>+<kbd>Space</kbd>, based on Vicinae.

**Package.** A bundle of files and instructions that `apt` installs. Nubo's are named `nubo-...`.

**Placeholder (grey icon).** A launcher for a popular app that is not installed. Clicking it downloads the app.

**Podman.** A tool for running containers without a background daemon, used by the Containers edition.

**Resolute.** The code name of Ubuntu 26.04 LTS. It is also the stable suite name in the Nubo archive.

**Secure Boot.** A firmware feature that only starts signed boot loaders. The Nubo OS desktop image keeps Ubuntu's signed ones.

**Snap.** Ubuntu's package format, run by `snapd`.

**Stable channel.** The default Nubo channel, suite `resolute`.

**Suite.** The name of a release stream inside an apt archive.

**Super key.** The key with the Windows logo on most keyboards, or the Command key on a Mac keyboard.

**Top bar.** The strip across the top of the screen with the Nubo logo, the clock and the status icons.

**Widget.** A draggable card on the desktop showing the clock and weather, system usage or a calendar.
