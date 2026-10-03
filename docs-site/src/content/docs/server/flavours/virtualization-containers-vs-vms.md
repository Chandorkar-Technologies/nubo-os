---
title: Containers or virtual machines
description: How Incus system containers and virtual machines differ, and how to choose between them on a Nubo OS Server.
sidebar:
  order: 70
---

**Applies to:** Virtualization

Incus on the Virtualization flavour can start two kinds of instance from the same command, and the difference is in what they share with the host. This page explains the difference so you can choose. It has no steps; the commands are in the [quick start](/server/flavours/virtualization-quick-start/).

## What each one is

A **system container** is a set of processes that the host kernel runs in isolation, with its own file system, users and network. It looks like a small machine, with its own init system and services, but it uses the host's kernel. You create one with `incus launch IMAGE NAME`.

A **virtual machine** is a complete computer simulated by QEMU, using the CPU's virtualization features through KVM. It has its own kernel, its own firmware and its own virtual hardware. You create one with `incus launch IMAGE NAME --vm`.

```text
Container                      Virtual machine

 app  app                       app  app
  |    |                         |    |
 guest user space               guest user space
  |                              |
  +--- host kernel ---+          guest kernel
                                  |
                              QEMU / KVM
                                  |
                              host kernel
```

## How they compare

| Question | System container | Virtual machine |
|---|---|---|
| Kernel | The host's | Its own |
| Operating system inside | Linux only, and compatible with the host kernel | Any that runs on the virtual hardware, subject to the image |
| Isolation | Process-level. Separated by kernel features and, if you use them, AppArmor and user namespaces | Hardware-level virtualization. A separate kernel stands between the guest and the host |
| Start time | Seconds | Longer, because a whole system boots |
| Memory use | Lower | Higher, because the guest kernel and QEMU need memory |
| Needs `/dev/kvm` | No | Yes |
| Needs QEMU | No | Yes |
| Kernel modules and kernel settings | Cannot load its own kernel modules; limited sysctl | Free to do both inside the guest |

The table says nothing about speed in numbers, because Nubo has not measured these on its flavours.

## Choosing

Use a **container** when:

- you want a Linux system for a service, a test, or a build, and the host's kernel is fine;
- you want to run many small instances on one machine;
- the machine has no virtualization support.

Use a **virtual machine** when:

- the workload needs its own kernel version, kernel modules, or a non-Linux operating system;
- you want the strongest separation between the workload and the host, for example for software you do not trust;
- you need to test boot, disk or firmware behaviour.

When in doubt, start with a container. Moving to a virtual machine later is a matter of creating a new instance and moving the data.

## Containers here and containers with Podman

Incus system containers and Podman application containers are different things. An Incus container holds a whole Linux system that you manage like a server. A Podman container holds one application, built from an image, and is meant to be replaced rather than updated. If you want to run an application from a registry image, use the [Containers flavour](/server/flavours/containers-podman/). You can have both on one machine; see [Add or change a flavour](/server/flavours/switch-flavour/).

## See also

- [Virtualization with Incus](/server/flavours/virtualization-incus/)
- [Incus documentation: instances](https://linuxcontainers.org/incus/docs/main/explanation/instances/)
