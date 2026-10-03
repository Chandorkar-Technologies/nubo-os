---
title: Run your first container
description: A tutorial that takes you from hello-world to a web server in a rootless Podman container on Nubo OS Server.
sidebar:
  order: 100
---

**Applies to:** Containers

In this tutorial you run a test container, start a web server in the background, reach it from your own machine, look at its logs, and remove it. You use Podman as your normal user.

## Before you begin

- A Nubo OS Server with the Containers flavour, with [rootless Podman set up](/server/flavours/containers-rootless-setup/).
- Internet access to Docker Hub.
- If you will open the web server from another machine: `sudo` rights to change the firewall.

## Step 1: run hello-world

```bash
podman run --rm docker.io/library/hello-world
```

Podman downloads the image, runs it, prints a short message, and, because of `--rm`, deletes the container when it ends. If you see the message, Podman works. The image stays in your local storage.

```bash
podman images
```

## Step 2: start a web server

```bash
podman run -d --name web -p 8080:80 docker.io/library/nginx
```

What the options mean:

| Option | Meaning |
|---|---|
| `-d` | Run in the background. |
| `--name web` | Name the container, so you can refer to it. |
| `-p 8080:80` | Publish port 80 of the container on port 8080 of the host. |

Port 8080 is above 1024, so a rootless container may use it.

## Step 3: reach it

On the server:

```bash
curl -I http://localhost:8080
```

The first line of the answer should be `HTTP/1.1 200 OK`. To reach it from another machine, allow the port in the firewall, which is closed to everything but SSH:

```bash
sudo ufw allow 8080/tcp
```

Then open `http://SERVER-ADDRESS:8080` in a browser.

## Step 4: look inside

```bash
podman ps
podman logs web
podman exec -it web sh
```

`podman ps` lists running containers. `podman logs` shows what nginx printed, including your request. `podman exec -it web sh` opens a shell inside the container; leave with `exit`.

## Step 5: stop and remove

```bash
podman stop web
podman rm web
sudo ufw delete allow 8080/tcp
```

Remove the firewall rule only if you added it in step 3.

## Verify

```bash
podman ps -a
```

The list should no longer contain `web`. `podman images` still shows the images that you downloaded. Remove them with `podman rmi docker.io/library/nginx docker.io/library/hello-world`.

## Troubleshooting

**`Error: ... requesting bind port 80: permission denied`.** Cause: a rootless container cannot publish a port below 1024. Fix: use a port such as 8080, as in the steps.

**`short-name resolution` prompt or error.** Cause: you wrote an image name without a registry. Fix: write the whole name, `docker.io/library/nginx`. On Nubo OS, Docker Hub is the configured search registry.

**`curl: (7) Failed to connect` on localhost.** Cause: the container is not running. Fix: `podman ps -a` and `podman logs web`.

**Works on the server but not from another machine.** Cause: the firewall. Fix: `sudo ufw allow 8080/tcp`. Not yet tested: whether `ufw` governs rootless published ports on Nubo OS is not confirmed; if it still fails, check `sudo ufw status` and the network between the two machines.

**Error mentioning `newuidmap` or subuid.** Cause: rootless setup is incomplete. Fix: see [Set up rootless Podman](/server/flavours/containers-rootless-setup/).

## What you built

You ran a container, published a port, used logs and a shell, and removed it. The same options work in Quadlet files, which is how you keep a container running as a service.

## Next steps

- [Run a container as a service with Quadlet](/server/flavours/containers-quadlet-services/)
- [Build container images](/server/flavours/containers-build-images/)
- [Podman documentation](https://docs.podman.io/)
