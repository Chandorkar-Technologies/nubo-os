---
title: Set up rootless Podman
description: Run nubo-podman-init, keep your containers running after logout with linger, and check subuid and subgid ranges.
sidebar:
  order: 90
---

**Applies to:** Containers

Rootless Podman needs three things: the right packages, a range of subordinate user and group IDs for your user, and, if you want services to run after you log out, "linger". The Containers flavour installs the packages. This page sets up the rest and shows how to check it.

## Before you begin

- A Nubo OS Server with the Containers flavour (`sudo apt install nubo-podman` on any Nubo OS Server).
- A normal user account. Do not use `root` or a user that was never logged in.
- `sudo` rights.

## Steps

### 1. Run `nubo-podman-init`

Run it as your own user. Do not run it as root.

```bash
nubo-podman-init
```

The script (`/usr/bin/nubo-podman-init`) does two things for your user:

1. `loginctl enable-linger USER`: tells systemd to keep your user's service manager running when you are not logged in.
2. `systemctl --user enable --now podman.socket`: starts the Podman API socket and enables it for future logins.

It then prints the socket path and a test command:

```text
Podman socket: /run/user/1000/podman/podman.sock
Try: podman run --rm docker.io/library/hello-world
```

If you run it with `sudo` from your user account, it uses the name in `SUDO_USER`. Running it as root itself (not through `sudo`) stops with "Run as your own user (or with sudo)."

### 2. Check subuid and subgid

A rootless container needs a block of IDs to map the container's users to. They are listed in `/etc/subuid` and `/etc/subgid`:

```bash
grep "^$USER:" /etc/subuid /etc/subgid
```

Each file should show a line such as `youruser:100000:65536`: the user name, the first ID, and how many IDs. Accounts created in the usual way on Ubuntu get a range automatically. If a line is missing, add a range that does not overlap with any other:

```bash
sudo usermod --add-subuids 200000-265535 --add-subgids 200000-265535 "$USER"
podman system migrate
```

Choose numbers that are not already used by other lines in the files. `podman system migrate` makes Podman pick up the new range.

### 3. Check the user mapping

```bash
podman unshare cat /proc/self/uid_map
```

The output has a line that maps 0 to your own user ID and a second line that maps 1 onwards to your subuid range.

### 4. Run a test container

```bash
podman run --rm docker.io/library/hello-world
```

## Verify

```bash
loginctl show-user "$USER" --property=Linger
systemctl --user is-active podman.socket
podman info --format '{{.Host.Security.Rootless}}'
```

The first command prints `Linger=yes`. The second prints `active`. The third prints `true`.

You can also check the socket from a script or a tool that speaks the Docker API:

```bash
curl --unix-socket /run/user/$(id -u)/podman/podman.sock http://d/_ping
```

It answers `OK`.

## Troubleshooting

**`nubo-podman-init`: "Run as your own user (or with sudo)."** Cause: you are root. Fix: log in as your normal user.

**`Failed to connect to bus` when running `systemctl --user`.** Cause: you used `su` or `sudo -i` from another account, so your session has no user runtime directory. Fix: log in with SSH as the user, or use `sudo -iu USER` with `XDG_RUNTIME_DIR=/run/user/$(id -u)` set.

**`cannot find newuidmap` or `there might not be enough IDs available`.** Cause: `uidmap` is missing, or the subuid range is empty. Fix: `sudo apt install uidmap`, and check `/etc/subuid` and `/etc/subgid` as above.

**Containers stop when you log out.** Cause: linger is off. Fix: `sudo loginctl enable-linger "$USER"`, and re-check with the Verify commands.

**Short names such as `nginx` ask which registry to use.** Cause: Podman's short-name mode asks when it cannot decide. Fix: use the full name, for example `docker.io/library/nginx`. Nubo sets Docker Hub as the registry to search in `/etc/containers/registries.conf.d/50-nubo.conf`.

## See also

- [Containers with Podman](/server/flavours/containers-podman/)
- [Run your first container](/server/flavours/containers-first-container/)
- [Run a container as a service with Quadlet](/server/flavours/containers-quadlet-services/)
- [Rootless Podman in the Podman documentation](https://github.com/containers/podman/blob/main/docs/tutorials/rootless_tutorial.md)
