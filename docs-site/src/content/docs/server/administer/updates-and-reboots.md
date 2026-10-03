---
title: Updates and reboots
description: How automatic updates work on Nubo OS Server, how to check them, and how to handle restarts and kernel updates.
sidebar:
  order: 40
---

**Applies to:** Server, Virtualization, Containers, Edge

Nubo OS Server installs updates by itself and never reboots by itself. This page explains what that means, how to check it, and how to decide when to restart.

## How automatic updates are set up

The package `nubo-archive` ships `/etc/apt/apt.conf.d/52-nubo-unattended.conf`. Its content:

```text title="/etc/apt/apt.conf.d/52-nubo-unattended.conf"
// Nubo OS Server: install security updates automatically, reboot only on request.
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
Unattended-Upgrade::Automatic-Reboot "false";
Unattended-Upgrade::Origins-Pattern {
        "origin=Ubuntu,codename=${distro_codename}-security";
        "origin=Ubuntu,codename=${distro_codename}-updates";
        "origin=Nubo,codename=${distro_codename}";
};
```

| Line | Meaning |
|---|---|
| `Update-Package-Lists "1"` | Refresh the package lists once a day. |
| `Unattended-Upgrade "1"` | Run `unattended-upgrade` once a day. |
| `Automatic-Reboot "false"` | Never reboot automatically, even when an update asks for it. |
| `origin=Ubuntu,codename=...-security` | Install Ubuntu security updates. |
| `origin=Ubuntu,codename=...-updates` | Also install Ubuntu's general updates (bug fixes). |
| `origin=Nubo,codename=...` | Install updates to Nubo's own packages from the Nubo archive. |

On the Server, Virtualization, Containers and Edge editions the program that does the work, `unattended-upgrades`, is installed. This file is in `nubo-archive`, which is also on the desktop, so check the package on your edition before you rely on it (see Verify below). The settings in this file add to Ubuntu's own `50unattended-upgrades` file; they do not replace it.

Updates to Ubuntu's packages come through Nubo Cumulus, with Ubuntu's servers as a fallback. The packages are unchanged and keep Ubuntu's signatures. Nubo's channels are explained in [Updates](/updates/): `stable` is the default; `sudo nubo-channel beta` switches to earlier builds and `sudo nubo-channel stable` switches back.

## Before you begin

- Logged in as a user with `sudo`.

## Steps

### Check that automatic updates ran

```bash
systemctl list-timers 'apt-daily*'
ls -l /var/log/unattended-upgrades/
sudo tail -n 30 /var/log/unattended-upgrades/unattended-upgrades.log
```

### Rehearse an unattended run

This shows what would be installed, without installing:

```bash
sudo unattended-upgrade --dry-run --debug
```

### Install updates by hand

```bash
sudo apt update
sudo apt full-upgrade
```

### Find out if a reboot is needed

```bash
test -f /var/run/reboot-required && cat /var/run/reboot-required
test -f /var/run/reboot-required.pkgs && cat /var/run/reboot-required.pkgs
```

If the first file exists, a package (usually the kernel or libc) wants a restart. `reboot-required.pkgs` lists which package.

### Find services that need a restart (not on Edge)

`needrestart` is part of the Server, Virtualization and Containers editions. It runs after `apt` and checks whether running programs use files that were replaced.

```bash
sudo needrestart -r l
```

`-r l` lists what needs a restart without doing it. To make `apt` restart services automatically instead of asking, create a drop-in:

```perl title="/etc/needrestart/conf.d/90-auto.conf"
$nrconf{restart} = 'a';
```

Use `'a'` only if a brief service restart after each update is acceptable.

### Reboot

Pick a quiet time and make sure services start on their own at boot (`systemctl is-enabled name`). Then:

```bash
sudo reboot
```

After the machine returns, check which kernel runs and that nothing failed:

```bash
uname -r
systemctl --failed
```

### Let the server reboot itself at a set time (optional)

If you accept that, say so in a drop-in that loads after Nubo's file:

```text title="/etc/apt/apt.conf.d/60-reboot.conf"
Unattended-Upgrade::Automatic-Reboot "true";
Unattended-Upgrade::Automatic-Reboot-Time "04:00";
```

Do not turn this on for a machine with an encrypted disk that waits for a passphrase at boot (see [Disk encryption](/server/security/disk-encryption/)); it would stay off until someone types the passphrase.

## Verify

```bash
apt-config dump | grep -E 'Unattended-Upgrade::(Automatic-Reboot|Origins-Pattern)|Periodic'
dpkg -l unattended-upgrades | tail -n 1
```

You should see `Automatic-Reboot "false"` (or `"true"` if you changed it), the three origins, and a line starting with `ii` for the package. If `dpkg` reports no such package, `unattended-upgrades` is missing on this machine; install it with `sudo apt install unattended-upgrades`.

## Troubleshooting

**Updates never install.** Check `systemctl status unattended-upgrades` and `systemctl list-timers 'apt-daily*'`. Read the log in `/var/log/unattended-upgrades/`. A held-back package, a full disk or a locked dpkg (another `apt` is running) are the usual causes.

**`apt update` fails with a signature or connection error.** Check that the machine can reach https://archive.nubosuite.tech and has the correct time (`chronyc tracking`); a clock that is far off breaks signature checks. See [What contacts the internet](/server/security/what-contacts-the-internet/).

**A kernel update installed but `uname -r` shows the old kernel.** You have not rebooted yet. This is expected: reboot when it suits you.

**Packages are "kept back".** Use `sudo apt full-upgrade`, which can add or remove packages to resolve dependencies. Ubuntu may also stage some updates gradually (phased updates), which keeps a package back for a few days. Wait, or see Ubuntu's documentation on phased updates.

**You want to pause automatic updates.** Disable the timers for a while: `sudo systemctl disable --now apt-daily-upgrade.timer`. Remember to enable them again.

## See also

- [Updates](/updates/)
- [Upgrading between releases](/server/administer/upgrading-between-releases/)
- [Ubuntu: automatic updates](https://ubuntu.com/server/docs/how-to/software/automatic-updates/)
