---
title: Known issues
description: What is untested, unfinished or not built yet in Nubo OS 1 "Flow", stated plainly.
sidebar:
  order: 80
---

This page is a plain list of what does not work yet, what is untested and what is only planned. It is read from the repository, including the notes the developers wrote for themselves. Nubo OS 0.8.0 is a beta. If you find something that is not listed, write to support@nubo.email.

## Not built yet (Planned)

:::caution[Planned]
These are not part of Nubo OS today. Do not rely on them.
:::

- Nubo Drive (file storage and sync).
- Nubo Backup.
- A migration app for moving from another system.
- Nubo Pro (a paid or extended-support offering).
- A Nubo Store with its own cloud login, which would restore your apps on a new machine. Today the Nubo Store is GNOME Software, renamed, with Flatpak support, and installs come from Flathub.
- Translations. Nubo's own texts are in English only.
- Benchmarks. No speed or battery figures are published because none have been measured on real hardware.
- A supported way to run a private mirror of the archive. See [Build a private mirror](/updates/build-a-private-mirror/).
- Release upgrades to a later Nubo OS release. `do-release-upgrade` is switched off and no replacement exists yet.

## Untested or early access

### Installation images

- **Desktop installer image.** The script exists (`iso/build-iso.sh`) and an image was built with it earlier, but the release system does not build it yet. The notes in the repository say it needs a new run, and the arm64 desktop image is untested.
- **Server installer images.** The release system builds all four editions for amd64 and arm64. An image was built and inspected on arm64. They have not been tested on real hardware. The four-edition split (Server, Virtualization, Containers, Edge) is marked "not yet tested" in the repository history.
- **Cloud and virtual machine images** (`.qcow2`, `.vhd`, `.vmdk`) and the **Raspberry Pi image**: the scripts exist and are marked untested.

### Accounts

- **Nubo account sign-in at the login screen** is early access. It has not been approved from start to finish with a real account. It needs a network connection at first boot and tries again at each boot until it succeeds. The first account to sign in owns the machine.
- **The "Nubo" provider in GNOME Online Accounts** is a preview. A successful sign-in against the real mail server has not been tested, because no real credentials were available. It has been tested against a test server, and a wrong password against the real server gives a clean error. The paths for calendar, contacts and files were taken from a description of the server and are untested. It supports one password only: an account with two-factor authentication needs an app password. Its texts are not translated. It was built and tested only against GNOME Online Accounts 3.58 on arm64. The patched Settings that put Nubo first in the list are not installed by default, so Nubo appears at the bottom of the provider list.

### Desktop

- **Light mode.** Modern apps follow the light and dark setting. Dark mode for modern apps is libadwaita's own dark grey, not pure black.
- **Terminal colors.** In the live session, the terminal still uses Ubuntu's purple palette in some profiles.
- **Boot menu.** One boot-menu entry still reads "Ubuntu". It is hidden on a normal start.
- **First-boot apps need a network.** Firefox, LocalSend, Newelle, Collabora Office, Shortwave, Spotify (x86 only) and VLC come from Flathub on the first boot that has a network connection. Without one, the step is retried at the next boot. An app that does not exist for your processor is skipped.
- **Nubo Search for arm64** is released separately from the other packages, so on arm64 it may lag behind.
- **Weather widget.** The location is found automatically by default. Where the location comes from was not checked.

### Servers

- **Firewall.** The first install sets up a firewall that is closed except for SSH. How it behaves together with the Incus bridge `nubobr0` was not checked.
- **Edition tests.** Virtualization, Containers and Edge have not been tested on a running machine from a Nubo image.

### Build and release

- **arm64 builds in the release system.** The release pipeline builds the amd64 packages. The arm64 build waits for an arm64 build machine; until one exists, arm64 packages are uploaded by hand and stay in the archive.
- **Tag and package versions.** The number in a release tag and the version in the packages do not always match. See [Release versions and support](/updates/release-versions-and-support/).
- **Final 0.8.0.** The `0.8.0` tag exists, but the package changelog still ends at `0.8.0~beta3`. Check your installed version before assuming you have the final release.

## Behavior that surprises people

- **snapd stays on the desktop.** The Nubo account sign-in service is distributed as a snap, so `snapd` and contact with the snap store remain on the desktop. The server editions do not install `snapd`. The fix is to package the sign-in service as a regular package.
- **`lsb_release` still says Ubuntu.** Renaming it has to be done together with the automatic update origin patterns, otherwise security updates stop. It is not done. Other identity files say Nubo OS.
- **The installer asks Ubuntu's geolocation service for your time zone** (desktop installer). Not yet patched.
- **Opting out of Nubo Cumulus.** The documented method (create `/etc/nubo/no-cumulus` and reinstall `nubo-archive`) does not put Ubuntu's source file back on a machine that already switched. See [Use Ubuntu's servers directly](/updates/use-ubuntus-servers-directly/) for the steps that do.
- **Running `nubo-server-firewall` again deletes your own firewall rules.**
- **Password login over SSH stays on** until you install an SSH key, so a new machine is never locked out. Turn it off yourself after you install a key.
- **Automatic reboots are off.** Updates that need a restart wait for you.
- **The archive key expires on 1 October 2031.**
- **`nubo-archive` package description** mentions `os.nubosuite.tech`; the archive address is `archive.nubosuite.tech`.

## Reporting a problem

Write to support@nubo.email. For a security problem, write to security@nubosuite.tech. The source code is at https://github.com/Chandorkar-Technologies/nubo-os.

## See also

- [Release notes](/reference/release-notes/)
- [Editions comparison](/reference/editions-comparison/)
- [Privacy and network endpoints](/updates/privacy-and-network-endpoints/)
