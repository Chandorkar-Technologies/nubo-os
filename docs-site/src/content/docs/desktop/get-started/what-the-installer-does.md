---
title: What the installer does
description: How the Nubo OS installer image is built, what its answer file does, and how Nubo Cumulus and the Nubo packages fit in.
sidebar:
  order: 80
---

**Applies to:** Desktop

This page explains how the Nubo OS desktop installer works. You do not need it to install. Read it if you want to know what is added to Ubuntu's installer and why.

## Built on Ubuntu's image

The Nubo OS desktop image is built from the official Ubuntu Desktop image rather than from scratch (`iso/build-iso.sh`). The builder changes only a few things:

- The Nubo packages and everything they need are carried on the media, in `/nubo/pool`.
- The installer installs them as its last step.
- The live "try it" session has them installed already.
- The boot menu, volume name and install choices say Nubo OS. The volume name reads "Nubo OS 1" followed by the CPU type.
- The installer's name and look change: its illustrations, slides and colors are Nubo's. The installer app is rebuilt from the same upstream sources with the product name changed.

Everything else is Ubuntu's, including the boot loader and kernel. That is why Secure Boot keeps working.

## The answer file

Ubuntu's installer can read an *autoinstall* file from the root of the install media. Nubo's is `iso/autoinstall.yaml`. It does three things.

### 1. Every screen stays interactive

```yaml
autoinstall:
  version: 1
  interactive-sections:
    - "*"
```

The `*` means every section is still asked. Nubo does not decide your language, disk or user for you.

### 2. Ubuntu's packages come through Nubo Cumulus

The file points the installer's package mirror at Nubo Cumulus: `https://archive.nubosuite.tech/cumulus` for amd64 and `https://archive.nubosuite.tech/cumulus-arm` for arm64. The security source points there too. Cumulus is a cache of Ubuntu's archive. Packages pass through unchanged and keep Ubuntu's signatures.

If Cumulus cannot be reached, the installer falls back to the packages on the media (`fallback: offline-install`). Other settings in the file turn off the installer self-update (`refresh-installer: update: false`) and the location guess for mirror selection (`geoip: false`).

### 3. The late step installs the Nubo packages

The last thing the installer does is run four commands in the new system:

1. Create a temporary folder `/var/tmp/nubo` in the new system.
2. Copy `/cdrom/nubo/pool/*.deb` into it.
3. Install them with `apt-get install`, non-interactively, keeping the Nubo versions of configuration files (`--force-confnew`).
4. Remove the temporary folder.

Doing this at the end, rather than inside the system images, works the same for every language and install type and survives Ubuntu re-cutting its images.

## What happens at the first boot

The installed system is then Nubo OS. On its first boot, two services complete the setup: `nubo-first-boot` (cleanup and Flathub apps) and `nubo-account-setup` (sign-in connector). See [Your first login](/desktop/get-started/first-login/).

## Where the packages come from afterward

The package `nubo-archive`, installed in the late step, adds Nubo's apt source and signing key, and replaces Ubuntu's source file so Ubuntu's packages are fetched through Cumulus, with Ubuntu's own servers as a fallback. Ubuntu's original file is kept as `/etc/apt/sources.list.d/ubuntu.sources.ubuntu`. You can opt out of Cumulus by creating `/etc/nubo/no-cumulus` and reinstalling `nubo-archive`.

From then on, updates come from the Nubo archive and, through it, from Ubuntu. See [Updates](/updates/).

## What is not changed

- The partitioning screens, the time zone screen (which still uses a Canonical location service) and the account screens are Ubuntu's.
- The installed boot loader name stays Ubuntu, for Secure Boot.

## See also

- [Install Nubo OS on a PC](/desktop/get-started/install-on-a-pc/)
- [Updates](/updates/)
- [Developers](/developers/) for how to build the image
