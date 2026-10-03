---
title: Validate and troubleshoot
description: Check an answer file and an installer ISO before you use them, and find out why an installation stopped or did not behave as expected.
sidebar:
  order: 40
---

**Applies to:** Server, Virtualization, Containers, Edge

Use this guide when you have changed the answer file or built your own ISO, and when an install does not go the way you expect. It covers checks before the install, testing, and the places where the installer writes its logs.

## Before you begin

- The ISO you built, or the answer file you edited.
- A virtual machine for tests (any hypervisor that boots an ISO).
- For the file checks: `xorriso` and Python 3 with PyYAML (`python3-yaml`).

## Steps

### 1. Check the YAML

A wrong indent is the most common mistake. Parse the file:

```bash
python3 -c 'import sys, yaml; yaml.safe_load(open(sys.argv[1])); print("YAML ok")' iso/server-user-data
```

The file must also keep the first line `#cloud-config`:

```bash
head -1 iso/server-user-data
```

For a check of the key names and values against Subiquity's schema, follow the [autoinstall validation guide](https://canonical-subiquity.readthedocs-hosted.com/en/latest/howto/autoinstall-validation.html) from Subiquity. Use the version of the installer that matches Ubuntu 26.04.

### 2. Look at what is on the ISO

Read the answer file straight from the image to confirm that your edit, and the flavour's extra command, are in the media:

```bash
xorriso -osirrox on -indev nubo.iso -extract /server/user-data /tmp/user-data-on-iso
cat /tmp/user-data-on-iso
```

List the packages that will be installed:

```bash
xorriso -indev nubo.iso -ls /nubo/pool/
```

Check the kernel line in the boot menu:

```bash
xorriso -osirrox on -indev nubo.iso -extract /boot/grub/grub.cfg /tmp/grub.cfg
grep -n autoinstall /tmp/grub.cfg
```

You should see `autoinstall ds=nocloud\;s=/cdrom/server/` on the kernel lines.

### 3. Check the download

The CI publishes a `.sha256` file next to each ISO at `https://archive.nubosuite.tech/iso/VERSION/`. Compare:

```bash
sha256sum -c nubo-os-server-VERSION-amd64.iso.sha256
```

### 4. Test in a virtual machine

Boot the ISO with a blank disk and at least a few GiB of memory. Watch the console. With Nubo's file, the installer asks for language, keyboard, network, disk, user and SSH, and does the rest.

### 5. Read the logs

On the installer's console, switch to a shell, or after the install look on the new system. The Subiquity logs are under `/var/log/installer/` (in the live environment) and are copied to the installed system:

```bash
ls /var/log/installer/
less /var/log/installer/subiquity-server-debug.log
```

The late commands are run by curtin. Search the logs for the Nubo package install:

```bash
grep -rn "nubo" /var/log/installer/ | head -40
```

The answer the installer actually used is saved in `/var/log/installer/autoinstall-user-data`.

## Verify

On the installed system:

```bash
dpkg -l | grep nubo-
cat /etc/apt/sources.list.d/ubuntu.sources
```

You should see the Nubo packages for your flavour installed (`nubo-server-core` and the flavour package) and apt sources pointing at `archive.nubosuite.tech`.

## Troubleshooting

**The installer shows "Continue with autoinstall?" or asks to wipe the disk.** Cause: the `autoinstall` kernel argument is missing, for example because you booted from an entry that your edit missed. Fix: check `grub.cfg` and `loopback.cfg` (step 2).

**The installer ignores the file and shows all screens.** Cause: the file was not found. Fix: the NoCloud source needs both `user-data` and `meta-data` in `/server/` on the media; check them with `xorriso -indev nubo.iso -ls /server/`.

**An error about the file's format at the start of the install.** Cause: invalid YAML or an unknown key. Fix: step 1, and the Subiquity validation guide.

**The install stops at the "late commands" step.** Cause: a package could not be installed, for example because of a missing dependency, or no network for the dependencies from the archive. Fix: see `/var/log/installer/` for the apt output. The Nubo packages must all be on the media (`/nubo/pool/`); the build script refuses to build when one is missing.

**The installed system has Ubuntu's name, not Nubo's.** Cause: the Nubo packages were not installed. Fix: `dpkg -l nubo-server-core`; if missing, check the late-commands log.

**Packages come from Ubuntu's servers, not Nubo Cumulus.** Cause: the mirror keys were changed, or Cumulus is opted out. Fix: check `apt.mirror-selection` in the answer file; check whether `/etc/nubo/no-cumulus` exists on the machine.

**Network problems during install.** Cause: the installer uses the network answers you gave. Fix: re-check the network screen, and the network check at `https://archive.nubosuite.tech/check` from another machine.

## See also

- [How Nubo uses autoinstall](/server/autoinstall/how-nubo-uses-autoinstall/)
- [Answer file reference](/server/autoinstall/answer-file-reference/)
- [Build your own image](/server/images/build-your-own-image/)
