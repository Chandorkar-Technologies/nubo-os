---
title: Build container images
description: Write a Containerfile, build it with Podman or Buildah, and move images around with Skopeo on a Nubo OS Server.
sidebar:
  order: 130
---

**Applies to:** Containers

The Containers flavour installs `buildah` and `skopeo` along with Podman. You can build your own images without Docker and without root. This page walks through a small build and then shows what Buildah and Skopeo add.

## Before you begin

- A Nubo OS Server with the Containers flavour and [rootless Podman set up](/server/flavours/containers-rootless-setup/).
- Access to a registry from which to pull the base image (Docker Hub works by default).

## Steps

### 1. Write a Containerfile

A Containerfile is the same format as a Dockerfile. Podman reads both names.

```bash
mkdir -p ~/hello-image && cd ~/hello-image
```

```dockerfile title="~/hello-image/Containerfile"
FROM docker.io/library/alpine:3
RUN apk add --no-cache curl
COPY greeting.txt /greeting.txt
CMD ["cat", "/greeting.txt"]
```

```bash
echo 'Hello from my own image' > greeting.txt
```

### 2. Build it

```bash
podman build -t localhost/hello:1 .
```

`-t` names the image. The `localhost/` prefix marks it as a local image, not one from a registry. Podman runs each step in a build container, as your user.

### 3. Run it

```bash
podman run --rm localhost/hello:1
```

It prints "Hello from my own image".

### 4. Buildah, when you want more control

`podman build` uses Buildah's code. The `buildah` command also lets you build without a Containerfile, step by step, which is useful in scripts:

```bash
ctr=$(buildah from docker.io/library/alpine:3)
buildah run "$ctr" -- apk add --no-cache curl
buildah copy "$ctr" greeting.txt /greeting.txt
buildah config --cmd 'cat /greeting.txt' "$ctr"
buildah commit "$ctr" localhost/hello:2
buildah rm "$ctr"
```

### 5. Skopeo, to inspect and copy

Skopeo works on images without pulling them first:

```bash
skopeo inspect docker://docker.io/library/alpine:3
skopeo copy docker://docker.io/library/alpine:3 dir:./alpine-copy
```

The first command prints the image's metadata. The second saves the image to a directory. Skopeo can also copy between registries, which needs credentials (`skopeo login`).

### 6. Push to a registry (optional)

```bash
podman login REGISTRY
podman tag localhost/hello:1 REGISTRY/NAME/hello:1
podman push REGISTRY/NAME/hello:1
```

Replace `REGISTRY` and `NAME` with your own. Nubo OS does not run a registry for you.

## Verify

```bash
podman images
podman run --rm localhost/hello:1
```

`podman images` lists `localhost/hello` with the tag `1`. The run prints your greeting.

## Troubleshooting

**`Error: creating build container: short-name`.** Cause: the `FROM` line has no registry. Fix: `FROM docker.io/library/alpine:3`.

**`newuidmap` errors or `potentially insufficient UIDs`.** Cause: rootless setup incomplete, or an image has files owned by IDs outside your subuid range. Fix: [Set up rootless Podman](/server/flavours/containers-rootless-setup/); check `/etc/subuid`.

**The build cannot download packages (`apk add` fails).** Cause: the build container has no network. Fix: check that the host has network; run `podman run --rm docker.io/library/alpine:3 ping -c1 1.1.1.1` as a test. Rootless networking uses `passt`, which `nubo-podman` installs.

**Out of disk space.** Cause: images and build layers in `~/.local/share/containers`. Fix: `podman system df`, then `podman system prune`. Prune removes unused data; read its prompt.

## See also

- [Containers with Podman](/server/flavours/containers-podman/)
- [Run a container as a service with Quadlet](/server/flavours/containers-quadlet-services/)
- [Buildah](https://buildah.io/) and [Skopeo](https://github.com/containers/skopeo) project pages
