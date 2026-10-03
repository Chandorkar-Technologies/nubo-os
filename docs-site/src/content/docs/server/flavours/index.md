---
title: Choose a flavour
description: Compare the four Nubo OS Server flavours (Server, Virtualization, Containers and Edge) and pick the one that fits your machine.
sidebar:
  order: 10
---

**Applies to:** Server, Virtualization, Containers, Edge

Nubo OS Server comes in four flavours. They share one base, and each flavour is a package that adds to it. You pick a flavour when you download the installer, but the choice is not permanent: on an installed machine you can add another flavour with `apt`. See [Add or change a flavour](/server/flavours/switch-flavour/).

All four flavours include the same core: the Nubo identity ("Nubo OS Server 1"), SSH without root login, a firewall closed except for SSH, time sync with chrony, AppArmor, and kernel network hardening. The flavours differ in what sits on top of that core.

## Comparison

| | Server | Virtualization | Containers | Edge |
|---|---|---|---|---|
| Package | `nubo-server-base` | `nubo-incus` | `nubo-podman` | `nubo-edge` |
| Installer media label | Server | Virtualization | Containers | Edge |
| Built on | `nubo-server-core` | Server | Server | `nubo-server-core` |
| Automatic security updates | Yes (`unattended-upgrades`) | Yes | Yes | Yes |
| Brute-force protection (`fail2ban`) | Yes | Yes | Yes | No |
| Restart check after updates (`needrestart`) | Yes | Yes | Yes | No |
| Everyday tools (`curl`, `htop`, `less`, `vim-tiny`) | Yes | Yes | Yes | No |
| Adds | Nothing extra | Incus, ZFS tools, `bridge-utils`; QEMU is recommended | Podman, Buildah, Skopeo, `uidmap`, `passt`; `podman-compose` is recommended | Nothing extra |
| First-run command | none | `nubo-incus-init` | `nubo-podman-init` | none |
| Disk and memory footprint | not measured yet | not measured yet | not measured yet | not measured yet |
| Typical use | General purpose server, web and mail, a base to build on | Hosting system containers and virtual machines | Running application containers | Raspberry Pi, old hardware, appliances |

The footprint row is empty on purpose. Nubo has not measured it, and these docs do not publish numbers that nobody has measured.

## How the packages stack

```text
nubo-edge ----------------------+
                                +--> nubo-server-core (identity, SSH, firewall, chrony, hardening)
nubo-server-base --+------------+
                   |
        +----------+----------+
        |                     |
   nubo-incus            nubo-podman
```

`nubo-server-core` is the shared base. `nubo-server-base` and `nubo-edge` both depend on it. `nubo-incus` and `nubo-podman` both depend on `nubo-server-base`.

## Which one should I choose?

- Choose **Server** if you want a normal, hardened Linux server and will install your own services. It is also the right start if you are not sure yet: you can add Incus or Podman later.
- Choose **Virtualization** if the machine will host virtual machines or system containers. See [Virtualization with Incus](/server/flavours/virtualization-incus/).
- Choose **Containers** if you run applications as OCI containers (images from Docker Hub and other registries). See [Containers with Podman](/server/flavours/containers-podman/).
- Choose **Edge** if the machine is small, runs unattended, and you want the least on it. See [Edge](/server/flavours/edge/).

:::note
The desktop and the server are separate. `nubo-server-core` conflicts with `nubo-branding`, so a machine is either a Nubo OS desktop or a Nubo OS Server. For the desktop, see [/desktop/](/desktop/).
:::

## In this section

- [Server](/server/flavours/server/): the base flavour and what it contains.
- [Add or change a flavour](/server/flavours/switch-flavour/): move an installed machine between flavours with `apt`.
- [Virtualization with Incus](/server/flavours/virtualization-incus/): overview of the Virtualization flavour.
- [Virtualization quick start](/server/flavours/virtualization-quick-start/): set up Incus and launch a container and a virtual machine.
- [Incus networks and storage](/server/flavours/virtualization-networks-and-storage/): the preseed, the `nubobr0` bridge, the `default` pool, and how to change them.
- [Containers or virtual machines](/server/flavours/virtualization-containers-vs-vms/): how to choose between them.
- [Containers with Podman](/server/flavours/containers-podman/): overview of the Containers flavour.
- [Set up rootless Podman](/server/flavours/containers-rootless-setup/): `nubo-podman-init`, linger, and subuid and subgid.
- [Run your first container](/server/flavours/containers-first-container/): a tutorial from `hello-world` to a web server.
- [Run a container as a service with Quadlet](/server/flavours/containers-quadlet-services/): start containers with systemd.
- [Compose files with Podman](/server/flavours/containers-compose/): `podman-compose` and its limits.
- [Build container images](/server/flavours/containers-build-images/): Containerfiles, Buildah and Skopeo.
- [Edge](/server/flavours/edge/): overview of the Edge flavour.
- [Prepare and provision an Edge device](/server/flavours/edge-prepare-and-provision/): images and cloud-init.
- [Update and recover an Edge device](/server/flavours/edge-update-and-recover/): what exists today, and what is planned.
