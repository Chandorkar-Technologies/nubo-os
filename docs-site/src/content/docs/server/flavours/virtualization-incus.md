---
title: Virtualization with Incus
description: What the Virtualization flavour of Nubo OS Server contains, and how Incus fits into it.
sidebar:
  order: 40
---

**Applies to:** Virtualization

The Virtualization flavour turns a Nubo OS Server into a host for system containers and virtual machines. It uses [Incus](https://linuxcontainers.org/incus/docs/main/), a manager for both. Nubo adds a first-run command that sets up a network bridge and a storage pool so that you can launch an instance right away.

## What is in the flavour

The package is `nubo-incus`. It depends on `nubo-server-base`, so you get everything in the [Server flavour](/server/flavours/server/) as well, plus:

| Package | Purpose |
|---|---|
| `incus` | The container and virtual machine manager. |
| `zfsutils-linux` | ZFS tools, so that you can create ZFS storage pools. |
| `bridge-utils` | Classic bridge tools. |
| QEMU (recommended) | `qemu-system-x86` on amd64 or `qemu-system-arm` on arm64. Needed for virtual machines, not for containers. |

The Virtualization server ISO also installs `qemu-utils` and the QEMU system package and firmware for your CPU during installation (`ovmf` on amd64, `qemu-efi-aarch64` on arm64). If you install the flavour with `apt` instead, QEMU comes along as a recommended package.

Nubo also ships two files for Incus:

- `/usr/bin/nubo-incus-init`, the setup command.
- `/usr/share/nubo/incus-preseed.yaml`, the configuration that command applies.

## What `nubo-incus-init` does

Run `sudo nubo-incus-init` once. It:

1. Applies the preseed with `incus admin init --preseed`. This creates the bridge `nubobr0`, the storage pool `default` (the `dir` driver), and a `default` profile that attaches each instance to `nubobr0` and puts its root disk on the `default` pool.
2. Adds the user who ran `sudo` to the `incus-admin` group. You must log out and in again for the group to take effect.

It does not launch any instance, import any image, or open the firewall. Details of the network and storage are on [Incus networks and storage](/server/flavours/virtualization-networks-and-storage/).

## Containers and virtual machines

Incus runs two kinds of instance:

- **System containers** share the host kernel. They start fast and use little memory. They behave like a small Linux system.
- **Virtual machines** run their own kernel under QEMU and KVM. They are better separated and can run other operating systems.

[Containers or virtual machines](/server/flavours/virtualization-containers-vs-vms/) helps you choose.

## Requirements and limits

- Virtual machines need hardware virtualization (KVM). On a machine that is itself a virtual machine, nested virtualization must be on. Check for `/dev/kvm`.
- The `dir` storage driver is the simplest one and has fewer features than ZFS (for example no copy-on-write snapshots; check the Incus storage documentation for the details). For heavier use, create a ZFS pool as shown on the [networks and storage](/server/flavours/virtualization-networks-and-storage/) page.
- Incus has its own firewall interaction with `ufw`. Nubo's firewall is closed except SSH, which can block traffic from instances. See the troubleshooting section of the quick start.
- Not yet tested on hardware: the whole Virtualization flavour has been built, but Nubo has not yet tested it on real hardware.

## Where Incus's own documentation fits

Nubo does not change Incus. For commands, image servers, clustering, projects, backups and the API, use the [Incus documentation](https://linuxcontainers.org/incus/docs/main/). These pages cover only the Nubo-specific parts.

## Next steps

- [Virtualization quick start](/server/flavours/virtualization-quick-start/)
- [Incus networks and storage](/server/flavours/virtualization-networks-and-storage/)
- [Add or change a flavour](/server/flavours/switch-flavour/)
