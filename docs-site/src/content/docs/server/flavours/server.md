---
title: Server
description: What the base Nubo OS Server flavour installs, how it is set up out of the box, and where to go next.
sidebar:
  order: 20
---

**Applies to:** Server, Virtualization, Containers

The Server flavour is the base of Nubo OS Server. The other two full flavours, Virtualization and Containers, are this flavour plus a group of packages. Edge uses the same core but leaves out some of the extras. Everything on this page therefore also holds for Virtualization and Containers.

Nubo OS Server 1 "Flow" is based on Ubuntu 26.04 LTS. Software that behaves as it does on Ubuntu is not repeated in these docs. For general topics, such as networking or storage, use the [Ubuntu Server documentation](https://ubuntu.com/server/docs).

## What you get

The Server flavour is the package `nubo-server-base`. It depends on `nubo-server-core` and adds a few tools.

### The core (`nubo-server-core`)

| Part | What it does |
|---|---|
| Identity | The system calls itself "Nubo OS Server 1" (`/usr/lib/os-release`, `/etc/issue`, `/etc/issue.net`, `/etc/lsb-release`). Ubuntu's original files are kept beside them with a `.ubuntu` suffix. The boot menu entry reads "Nubo OS". |
| Message of the day | Shows the docs address and the support address. Ubuntu news, help text and Pro adverts are switched off. |
| SSH | `openssh-server` with `PermitRootLogin no`, `MaxAuthTries 4`, `LoginGraceTime 30` and `X11Forwarding no`, set in `/etc/ssh/sshd_config.d/90-nubo-sshd.conf`. Password login stays on until you install an SSH key, so a new machine is never locked out. |
| Firewall | `ufw`, closed to incoming traffic except SSH. The package runs `/usr/libexec/nubo/nubo-server-firewall` once, on first install. |
| Time | `chrony`, with time servers from `nubo-base` (time.cloudflare.com with NTS, and pool.ntp.org). |
| AppArmor | Installed as a dependency. |
| Kernel hardening | Network settings in `/usr/lib/sysctl.d/90-nubo-server.conf`, among them reverse-path filtering, no ICMP redirects, SYN cookies, and restricted kernel pointers and `dmesg`. |
| Package archive | `nubo-archive` and `nubo-base` come with it: the Nubo package archive, Nubo Cumulus for Ubuntu's packages, and no crash reports or news sent to Canonical. |

### What the Server flavour adds (`nubo-server-base`)

| Package | Purpose |
|---|---|
| `unattended-upgrades` | Installs security updates automatically. See [update settings](/updates/). |
| `fail2ban` | Blocks addresses that fail to log in repeatedly. |
| `needrestart` | Tells you which services need a restart after an update. |
| `curl`, `ca-certificates`, `htop`, `less`, `vim-tiny` | Everyday tools. |

## Automatic updates

Nubo OS Server installs updates from three sources without asking: Ubuntu's security pocket, Ubuntu's updates pocket, and the Nubo archive. The configuration file is `/etc/apt/apt.conf.d/52-nubo-unattended.conf`. The server never reboots by itself (`Automatic-Reboot "false"`). When an update needs a reboot, you choose when to do it.

## Conflicts

`nubo-server-core` cannot be installed together with `nubo-branding` (the desktop), `snapd`, `landscape-common`, `lxd-installer`, `ubuntu-pro-client` or `ubuntu-advantage-tools`. Installing the server packages on a machine that has these removes them. This is why there are no snaps on a Nubo OS Server.

## Check what is installed

```bash
dpkg -l nubo-server-core nubo-server-base nubo-base nubo-archive
cat /usr/lib/os-release
sudo ufw status verbose
```

`ufw status` should show a default of "deny (incoming)" and a rule that allows OpenSSH.

## Next steps

- Install the Server flavour: [/server/](/server/) has the install guides.
- Add Incus or Podman: [Add or change a flavour](/server/flavours/switch-flavour/).
- Automate the install: [Autoinstall](/server/autoinstall/).
- Compare flavours: [Choose a flavour](/server/flavours/).
