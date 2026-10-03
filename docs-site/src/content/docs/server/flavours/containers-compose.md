---
title: Compose files with Podman
description: Install podman-compose on a Nubo OS Server, run a Compose file, and know where it differs from Docker Compose.
sidebar:
  order: 120
---

**Applies to:** Containers

Many projects ship a `compose.yaml` file that describes several containers together. On the Containers flavour you can run these files with `podman-compose`. It is not part of the required set: the package `nubo-podman` only recommends it, so a machine installed without recommended packages does not have it.

## Before you begin

- A Nubo OS Server with the Containers flavour and [rootless Podman set up](/server/flavours/containers-rootless-setup/).
- A `compose.yaml` file. The example below makes one.

## Steps

### 1. Install `podman-compose`

```bash
sudo apt install podman-compose
```

If `nubo-podman` was installed with recommended packages, it may already be there. Check with `podman-compose --version`.

### 2. Write a Compose file

```yaml title="compose.yaml"
services:
  web:
    image: docker.io/library/nginx:stable
    ports:
      - "8080:80"
    volumes:
      - ./html:/usr/share/nginx/html:ro
```

```bash
mkdir -p html
echo 'Hello from Compose' > html/index.html
```

Use full image names. `podman-compose` hands them to Podman, and a short name may trigger a registry question.

### 3. Start and stop

```bash
podman-compose up -d
podman-compose ps
podman-compose logs
podman-compose down
```

`up -d` creates the containers (and a network) and starts them in the background. `down` stops and removes them.

## Verify

```bash
podman-compose up -d
curl http://localhost:8080
podman-compose down
```

The `curl` command prints "Hello from Compose".

## What is different from Docker Compose

- `podman-compose` is a separate project (a Python script) that translates a Compose file into Podman commands. It is not the Docker tool, and it does not support every feature of the Compose specification. If a file uses a feature it does not know, it may warn or ignore it. Nubo has not tested a list of supported features.
- Recent Podman versions also have a `podman compose` command that calls an external Compose provider. Which provider it uses depends on what is installed; read `podman compose --help` on your machine.
- Rootless containers cannot publish ports below 1024 by default.
- Services start only while your user's service manager runs. For anything that should survive a reboot, prefer [Quadlet](/server/flavours/containers-quadlet-services/), which systemd manages. You can translate each Compose service into a Quadlet `.container` file by hand.
- Using the Docker API: `nubo-podman-init` starts the Podman socket at `/run/user/UID/podman/podman.sock`. Tools that read `DOCKER_HOST` can use it, for example `export DOCKER_HOST=unix:///run/user/$(id -u)/podman/podman.sock`. Whether the Docker Compose binary works against it on Nubo OS has not been tested, and Nubo does not install it.

## Troubleshooting

**`podman-compose: command not found`.** Cause: it is only a recommended package. Fix: `sudo apt install podman-compose`.

**`Error: short-name ... did not resolve`.** Cause: the image has no registry in its name. Fix: write `docker.io/library/...`.

**Port binding fails.** Cause: a port below 1024, or a port already in use. Fix: use a different host port, and check with `ss -ltn`.

**Volumes are empty or unreadable.** Cause: user ID mapping in rootless mode. Fix: use read-only mounts for content, and see the Quadlet page for `podman unshare chown`.

**The services stop after logout.** Cause: linger is off. Fix: `sudo loginctl enable-linger "$USER"`.

## See also

- [Containers with Podman](/server/flavours/containers-podman/)
- [Run a container as a service with Quadlet](/server/flavours/containers-quadlet-services/)
- [Compose specification](https://compose-spec.io/)
