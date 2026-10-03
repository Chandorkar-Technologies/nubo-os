---
title: Run a container as a service with Quadlet
description: Describe a container in a .container file and let systemd start it at boot, as your user or as root.
sidebar:
  order: 110
---

**Applies to:** Containers

Quadlet lets you describe a container in a small file, and Podman turns the file into a systemd service. The service starts at boot, restarts when it fails, and is managed with `systemctl`. Quadlet is part of Podman; Nubo does not change it. This page shows the Nubo-relevant steps: where to put the file, how to keep it running without a login, and how to check it.

## Before you begin

- A Nubo OS Server with the Containers flavour and [rootless Podman set up](/server/flavours/containers-rootless-setup/), including linger. Without linger, a rootless service stops when you log out and does not start at boot.
- You have run the image once by hand, so you know its options ([first container](/server/flavours/containers-first-container/)).

## Where the file goes

| Mode | Directory | Manage with |
|---|---|---|
| Rootless (your user) | `~/.config/containers/systemd/` | `systemctl --user` |
| Root (system-wide) | `/etc/containers/systemd/` | `sudo systemctl` |

The file name becomes the service name: `web.container` produces `web.service`.

## Steps (rootless)

### 1. Create the file

```bash
mkdir -p ~/.config/containers/systemd
```

```ini title="~/.config/containers/systemd/web.container"
[Unit]
Description=Web server in a container

[Container]
Image=docker.io/library/nginx:stable
PublishPort=8080:80
Volume=%h/web-content:/usr/share/nginx/html:ro,Z

[Service]
Restart=always

[Install]
WantedBy=default.target
```

The sections:

- `[Container]` is Quadlet's own section. `Image` is the image (use a full name). `PublishPort` is the same as `-p`. `Volume` is the same as `-v`. `%h` expands to your home directory. The `Z` option relabels the files for SELinux and is harmless on systems without it.
- `[Service]` and `[Install]` are ordinary systemd sections. `WantedBy=default.target` starts the service when your user's service manager starts, which linger makes happen at boot.

Create the content to serve:

```bash
mkdir -p ~/web-content
echo 'Hello from Quadlet' > ~/web-content/index.html
```

### 2. Load and start it

```bash
systemctl --user daemon-reload
systemctl --user start web.service
```

You do not run `enable` on a Quadlet service. The `[Install]` section in the `.container` file is read by Quadlet's generator, which makes the service start at boot. If you try `systemctl --user enable web.service` it says the unit is generated, which is expected.

### 3. Open the port if needed

```bash
sudo ufw allow 8080/tcp
```

## Steps (root)

For a system-wide service, put the same file in `/etc/containers/systemd/web.container`. Use `WantedBy=multi-user.target` in `[Install]`, and manage it with `sudo systemctl daemon-reload` and `sudo systemctl start web.service`. Use root only if you need it; the rootless form is the default for Nubo OS.

## Verify

```bash
systemctl --user status web.service
podman ps
curl http://localhost:8080
```

The status shows `active (running)`, `podman ps` lists the container (Quadlet names it `systemd-web`), and `curl` prints "Hello from Quadlet". To test the boot behaviour, reboot, do not log in, and check from another machine that port 8080 answers.

To see what Quadlet generated from your file:

```bash
systemctl --user cat web.service
```

This prints the generated unit, so you can see how each line in your `.container` file became a `podman run` option.

## Troubleshooting

**`Unit web.service not found`.** Cause: the file is in the wrong directory, has the wrong extension, or you did not run `daemon-reload`. Fix: check the path from the table, and run `systemctl --user daemon-reload`.

**The service fails with `status=1`.** Cause: for example a typo in the image name or a port already in use. Fix: `journalctl --user -u web.service -e`.

**It starts when you log in but not at boot.** Cause: linger is off. Fix: `sudo loginctl enable-linger "$USER"`.

**Permission denied reading the volume.** Cause: user ID mapping. Files owned by your user appear as root inside a rootless container; a service running as another user inside will not own them. Fix: use `:ro` for content, or `podman unshare chown` to give the files to the container user's mapped ID.

**Image pulled at every start is slow, or fails offline.** Cause: Quadlet pulls when the image is missing. Fix: pull it first with `podman pull`, or add `Pull=never` once it is local (check the Podman documentation for your Podman version).

## See also

- [Containers with Podman](/server/flavours/containers-podman/)
- [Compose files with Podman](/server/flavours/containers-compose/)
- [Quadlet reference: podman-systemd.unit](https://docs.podman.io/en/latest/markdown/podman-systemd.unit.5.html)
