---
title: Frequently asked questions
description: Short, honest answers to the questions people ask first about Nubo OS.
sidebar:
  order: 50
---

Answers here come from the Nubo OS repository. Where something is not built or not confirmed, the answer says so.

## The basics

### Is Nubo OS Ubuntu?

It is based on Ubuntu 26.04 LTS. The kernel, boot loader, and nearly all packages are Ubuntu's, unchanged. Nubo adds its own look, apps, helpers and a package archive. See [What is different from Ubuntu](/start/what-is-different-from-ubuntu/). "Ubuntu" is a trademark of Canonical, and Nubo OS is not a Canonical product.

### Who makes it?

Chandorkar Technologies. The code is public at <https://github.com/Chandorkar-Technologies/nubo-os>.

### Is it free?

Yes. The download is free. Licenses are in the repository (`LICENSE` for the code and `LICENSE.brand` for the Nubo brand files).

### Which version is current?

Nubo OS 1 "Flow", currently in beta (packages at version 0.8.0~beta4 as of 3 October 2026).

### How long is it supported?

The base has five years of security updates, to April 2031. See [Support and lifecycle](/start/support-and-lifecycle/).

### Is it ready for my main computer?

It is a beta. Try it first from a USB stick or a virtual machine, keep backups, and read the notes marked **Planned** or "untested" in these docs.

## Installing

### Can I try it without installing?

Yes. Boot the USB stick and choose the live session. The live session already has the Nubo packages installed. See [Try Nubo OS from a USB stick](/desktop/get-started/try-from-usb/).

### Can I dual boot with Windows?

The installer is Ubuntu's installer, so the usual dual-boot approach applies. Nubo adds a few cautions. See [Dual boot with Windows](/desktop/get-started/dual-boot-with-windows/).

### Does Secure Boot work?

Yes on the desktop image. The boot loader and kernel are Ubuntu's signed ones.

### Does the installer need the internet?

No, but it helps. Ubuntu's packages come through Nubo Cumulus. If Cumulus cannot be reached, the installer falls back to the packages on the install media. Several first-boot jobs, like downloading apps from Flathub, need a network and retry on the next boot.

### Does it run on ARM?

The Nubo packages build for amd64 and arm64, and Nubo Search ships for both. The arm64 desktop image has not been tested on real hardware. Server images for both CPUs are built for every release.

### Can I run it in a virtual machine?

Yes. See [Install Nubo OS in a virtual machine](/desktop/get-started/install-in-a-vm/).

## Software

### What about snaps?

Ubuntu uses snaps for some apps. On Nubo OS the first-boot cleanup removes Ubuntu's store snaps, the Firefox snap and the Thunderbird snap, and installs Firefox from Flathub. Snapd stays on the desktop for now, because the Nubo account sign-in broker (`authd-oidc`) is distributed as a snap. On servers, snapd is not installed.

### Why Flatpak and Flathub?

Flathub has a large catalog, apps are updated by their publishers, and Nubo does not have to redistribute proprietary binaries in the image. Popular apps appear as grey placeholders in the launcher; clicking one downloads it from Flathub and opens it.

### Which apps come installed?

Geary for mail, plus GNOME's Files, Calendar, Settings and others. On first boot, if you have a network, these arrive from Flathub: Firefox, LocalSend, Newelle, Collabora Office, Shortwave, Spotify (x86 only) and VLC. LibreOffice is removed in favor of Collabora Office.

### Can I still use apt?

Yes. Nubo packages are ordinary `.deb` files and `apt` works as on Ubuntu.

### Can I install Ubuntu's PPAs and vendor repositories?

The system still reports `ID=ubuntu`, `VERSION_ID=26.04` and `VERSION_CODENAME=resolute`, so installers that check for Ubuntu keep working. Nubo has not tested individual vendors.

### Is there a Nubo app store?

:::caution[Planned]
A Nubo Store with its own cloud login is planned and not built. Today, apps come from Flathub through the grey launchers and GNOME Software.
:::

## Privacy and network

### What does Nubo OS send out?

Nubo OS removes several Ubuntu contacts: crash reporting, message-of-the-day news, Ubuntu Pro services and the release-upgrade check are off. The connectivity check goes to Nubo and time comes from `time.cloudflare.com` (NTS) and `pool.ntp.org`. Package downloads go through Nubo Cumulus, which is operated by Nubo on Cloudflare, with Ubuntu as a fallback. Some contacts with Canonical remain, for example the snap store on the desktop. The repository lists them in `docs/ubuntu-endpoints.md`.

### Can I avoid Nubo Cumulus?

Yes. Create `/etc/nubo/no-cumulus` and reinstall `nubo-archive`. Your machine then uses Ubuntu's servers directly. Ubuntu's signatures are never changed by Cumulus.

### Does Nubo OS collect telemetry?

Nubo Search is configured with system-info telemetry off. Nubo has not published any other telemetry. If you find a contact that is not documented, email support@nubo.email.

## Desktop

### Does it use Wayland?

Nubo OS uses Ubuntu 26.04's GNOME 50 session and does not change the session type. For what the session supports, see Ubuntu's release notes.

### Why is the top bar different?

At the left, the Nubo logo with the text "Nubo OS 1" opens the Activities overview directly. There is no drop-down.

### What is the keyboard shortcut for search?

<kbd>Super</kbd>+<kbd>Space</kbd> opens Nubo Search. Switching keyboard layouts moved to <kbd>Alt</kbd>+<kbd>Shift</kbd>.

### Why are some icons grey?

They are placeholders for popular apps that are not installed. Click one to download the app from Flathub.

### Can I use a light theme?

Yes. The default is dark, and the theme follows the system light and dark switch ("Dark Style" in the quick settings menu). <!-- verify label -->

### Can I change widgets?

The desktop widgets are draggable cards. Their positions are saved in `~/.config/nubo/widgets.json`. See [Widgets not showing](/desktop/troubleshooting/widgets-not-showing/).

### Can I sign in with a Nubo account?

Early access. The login screen can offer a "Nubo Account" sign-in using a code approved from a phone, after the first boot with a network. It has not yet been approved end to end with a real account. <!-- verify label -->

### Is my language supported?

Nubo has no translations of its own yet; this is planned. The system languages of Ubuntu are available.

## Servers

### Is there a server edition?

Yes: Server, Virtualization (Incus), Containers (Podman) and Edge. See [Server](/server/).

## See also

- [Glossary](/start/glossary/)
- [Getting help](/start/getting-help/)
