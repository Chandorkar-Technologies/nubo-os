---
title: Add or change a flavour
description: Move an installed Nubo OS Server between the Server, Virtualization, Containers and Edge flavours with apt.
sidebar:
  order: 30
---

**Applies to:** Server, Virtualization, Containers, Edge

A flavour is a package. That means you can change it on a running machine with `apt`, without reinstalling. This page shows how, and which combinations are safe.

## Before you begin

- A Nubo OS Server that you can log in to with `sudo`.
- Network access to the Nubo archive and Ubuntu's archive (through Nubo Cumulus).
- Run `sudo apt update` first.

The four packages and what they depend on, from `debian/control`:

| Package | Depends on |
|---|---|
| `nubo-server-core` | `nubo-archive`, `nubo-base`, `openssh-server`, `ufw`, `chrony`, `apparmor` |
| `nubo-server-base` (Server) | `nubo-server-core`, `unattended-upgrades`, `fail2ban`, `needrestart`, `curl`, `ca-certificates`, `htop`, `less`, `vim-tiny` |
| `nubo-edge` (Edge) | `nubo-server-core`, `unattended-upgrades` |
| `nubo-podman` (Containers) | `nubo-server-base`, `podman`, `buildah`, `skopeo`, `uidmap`, `passt`; recommends `podman-compose` |
| `nubo-incus` (Virtualization) | `nubo-server-base`, `incus`, `zfsutils-linux`, `bridge-utils`; recommends QEMU |

## Steps

### Add Containers

```bash
sudo apt update
sudo apt install nubo-podman
nubo-podman-init
```

### Add Virtualization

```bash
sudo apt update
sudo apt install nubo-incus
sudo nubo-incus-init
```

Because QEMU is only recommended, `apt` installs it by default. If you turn off recommended packages (`--no-install-recommends`), also install `qemu-system-x86` (amd64) or `qemu-system-arm` (arm64) so that virtual machines work. Containers do not need QEMU.

### Go from Edge to Server

```bash
sudo apt install nubo-server-base
```

This adds `fail2ban`, `needrestart` and the everyday tools to the Edge system. Nothing from Edge is removed.

### Go from Server to Edge

Both `nubo-server-base` and `nubo-edge` sit on `nubo-server-core`, so they do not conflict. Installing `nubo-edge` on a Server machine changes nothing visible, because Server already includes everything Edge has. To get a smaller system you must remove the extras:

```bash
sudo apt install nubo-edge
sudo apt remove nubo-server-base
sudo apt autoremove --dry-run
```

Read the `--dry-run` list before you run `autoremove` for real. The packages that Server pulled in (`fail2ban`, `needrestart`, `htop` and so on) become removable once `nubo-server-base` is gone. Packages you installed yourself and still need must be marked as manually installed first (`sudo apt-mark manual PACKAGE`).

:::caution
`nubo-podman` and `nubo-incus` depend on `nubo-server-base`. Removing `nubo-server-base` also removes `nubo-podman` or `nubo-incus`. Your containers and virtual machines stay on disk, but the tools stop being managed by a flavour package. Remove Podman or Incus data deliberately and separately.
:::

### What is safe and what conflicts

| Change | Result |
|---|---|
| Install `nubo-podman` and `nubo-incus` together | Allowed. Neither package conflicts with the other. Running both on one machine is possible. Not yet tested. |
| Install `nubo-edge` and `nubo-server-base` together | Allowed. No conflict between them. |
| Install any server package on a Nubo OS desktop | Not possible: `nubo-server-core` conflicts with `nubo-branding`. |
| Install `nubo-desktop` on a server | Not possible for the same reason. |
| Install `snapd` or `ubuntu-pro-client` on a server | These conflict with `nubo-server-core`. Apt cannot keep both, so it will refuse or propose a removal. Read the plan apt shows before you accept. |

## Verify

```bash
apt policy nubo-podman nubo-incus nubo-edge nubo-server-base
```

An installed package shows a version after "Installed:". Check that the flavour's command exists:

```bash
command -v nubo-podman-init nubo-incus-init
```

## Troubleshooting

**apt wants to remove `nubo-server-core`.** Cause: you asked it to install something that conflicts, for example `snapd`. Fix: answer no, and do not install the conflicting package.

**`nubo-incus-init` says "Run with sudo."** Cause: the Incus setup needs root. Fix: run `sudo nubo-incus-init`. `nubo-podman-init` is the opposite: run it as your own user.

**Virtual machines do not start after adding `nubo-incus`.** Cause: QEMU was not installed (recommended packages were off). Fix: install `qemu-system-x86` or `qemu-system-arm`.

**Unsure which flavour a machine is.** Run `apt policy` as above, or `dpkg -l | grep nubo-`.

## See also

- [Choose a flavour](/server/flavours/)
- [Virtualization quick start](/server/flavours/virtualization-quick-start/)
- [Set up rootless Podman](/server/flavours/containers-rootless-setup/)
