---
title: Containers with Podman
description: What the Containers flavour of Nubo OS Server contains and how Podman is set up on it.
sidebar:
  order: 80
---

**Applies to:** Containers

The Containers flavour makes a Nubo OS Server ready to run application containers with [Podman](https://podman.io/). Podman runs containers without a central daemon and without root, and it uses the same image format as Docker.

## What is in the flavour

The package is `nubo-podman`. It depends on `nubo-server-base`, so everything in the [Server flavour](/server/flavours/server/) comes with it, plus:

| Package | Purpose |
|---|---|
| `podman` | Runs containers and pods. |
| `buildah` | Builds images. See [Build container images](/server/flavours/containers-build-images/). |
| `skopeo` | Inspects and copies images between registries and storage. |
| `uidmap` | Provides `newuidmap` and `newgidmap`, which rootless containers need. |
| `passt` | Provides the networking that rootless containers use (`pasta`). |
| `podman-compose` (recommended) | Runs Compose files. Only recommended, so it can be left out. See [Compose files with Podman](/server/flavours/containers-compose/). |

Nubo adds two files:

- `/usr/bin/nubo-podman-init`: starts the Podman API socket for your user and keeps your user's services running after you log out.
- `/etc/containers/registries.conf.d/50-nubo.conf`: sets `unqualified-search-registries = ["docker.io"]`, so that a short image name such as `nginx` is looked up on Docker Hub.

## Rootless by default

You use Podman as your normal user, not as root. The containers run under your user ID, and the "root" inside a container is mapped to a range of unprivileged IDs on the host. A process that escapes a rootless container lands as an unprivileged user. [Set up rootless Podman](/server/flavours/containers-rootless-setup/) explains the pieces.

You can still use `sudo podman ...` to run containers as root. Root containers and rootless containers keep their images and containers separately.

## Ways to run a container

| You want to | Use |
|---|---|
| Try something once | `podman run` ([first container](/server/flavours/containers-first-container/)) |
| Keep a service running and start it at boot | A Quadlet file ([Quadlet services](/server/flavours/containers-quadlet-services/)) |
| Start several containers from a Compose file | `podman-compose` ([Compose](/server/flavours/containers-compose/)) |
| Make your own image | `podman build` or `buildah` ([Build images](/server/flavours/containers-build-images/)) |

## Firewall

The server firewall is closed except for SSH. A container that publishes a port, for example `-p 8080:80`, is reachable from outside only if you also allow that port, for example with `sudo ufw allow 8080/tcp`. Whether rootless published ports bypass or obey `ufw` has not been tested on Nubo OS; check with a second machine before you rely on it.

## Docker compatibility

Podman accepts most Docker command line options, and the Podman API socket speaks the Docker API closely enough for many tools. `nubo-podman-init` starts that socket at `/run/user/UID/podman/podman.sock`. Nubo does not install Docker.

## Limits

- Ports below 1024 are not available to rootless containers by default. Use a higher port, or change the host setting `net.ipv4.ip_unprivileged_port_start` if you accept the consequences.
- Not yet tested on hardware: the Containers flavour has been built, but Nubo has not yet tested it on real hardware.

## Next steps

- [Set up rootless Podman](/server/flavours/containers-rootless-setup/)
- [Run your first container](/server/flavours/containers-first-container/)
- [Podman documentation](https://docs.podman.io/)
