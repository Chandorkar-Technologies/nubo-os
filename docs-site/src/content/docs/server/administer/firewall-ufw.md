---
title: Firewall with ufw
description: See what the default Nubo OS Server firewall does, open and close ports with ufw, and avoid resetting your rules by accident.
sidebar:
  order: 30
---

**Applies to:** Server, Virtualization, Containers, Edge

A new Nubo OS Server has a firewall that blocks all incoming connections except SSH. It uses `ufw` (Uncomplicated Firewall), Ubuntu's standard front end for the kernel firewall. This page explains what Nubo set up and shows how to open a port for a service you run.

## What Nubo sets up

`nubo-server-core` depends on `ufw`. When the package is installed for the first time, its post-install script runs a helper, `/usr/libexec/nubo/nubo-server-firewall`. The helper is a short shell script:

```sh title="/usr/libexec/nubo/nubo-server-firewall"
ufw --force reset >/dev/null
ufw default deny incoming
ufw default allow outgoing
ufw allow OpenSSH
ufw --force enable
```

In plain words: it clears all existing rules, blocks all incoming connections, allows all outgoing connections, allows SSH, and turns the firewall on (also at every boot).

:::caution
The helper starts with `ufw --force reset`, which **deletes every rule you have added**. The package runs it only on first install, not on upgrades. Do not run it by hand on a server whose rules you want to keep.
:::

`OpenSSH` is an application profile that the `openssh-server` package installs; it stands for port 22 over TCP.

## Before you begin

- Logged in as a user with `sudo`.
- If you work over SSH, you know that the `OpenSSH` rule stays in place. Never remove it unless you have console access.

## Steps

### Look at the rules

```bash
sudo ufw status verbose
sudo ufw status numbered
```

### Open a port

Open a port for a web server (HTTP and HTTPS):

```bash
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
```

If the package of your service installs a ufw profile, you can use its name instead. List the profiles with `sudo ufw app list`.

### Open a port only for one network or address

For a database that only your office network may reach (the address range is an example):

```bash
sudo ufw allow from 192.168.1.0/24 to any port 5432 proto tcp
```

### Slow down repeated SSH connections

```bash
sudo ufw limit OpenSSH
```

`limit` still allows SSH but refuses an address that makes six or more connections within 30 seconds. This replaces the plain `allow` rule for `OpenSSH`. It complements fail2ban; see [fail2ban](/server/security/fail2ban/).

### Close a port

Show the rules with numbers, then delete by number (the numbers change after each deletion, so list again):

```bash
sudo ufw status numbered
sudo ufw delete 3
```

Or delete by the same description you used to create the rule:

```bash
sudo ufw delete allow 80/tcp
```

### Turn logging up or down

```bash
sudo ufw logging medium
```

Firewall messages go to the system log. Read them with `sudo journalctl -k | grep UFW`.

## Verify

```bash
sudo ufw status verbose
```

Your new rule appears in the list. To test from another machine, try to connect to the port:

```bash
nc -vz your-server 443
```

`succeeded` means the firewall let the connection through. If nothing is listening on the port yet, you see `Connection refused`, which still means the firewall is open (a blocked port times out instead). To see what is listening on the server itself:

```bash
sudo ss -tlnp
```

## Virtualization and Containers editions

:::caution
Not yet tested. The default deny rule applies to the bridge that Incus creates (`nubobr0`) and to the networks that containers use. It can stop virtual machines and containers on the bridge from getting an address or DNS from the host. If instances on `nubobr0` cannot reach the network, an Incus-documented fix is to allow traffic on the bridge: `sudo ufw allow in on nubobr0` and `sudo ufw route allow in on nubobr0`. Check Incus's firewall documentation before you use it. For Podman containers published with `-p`, ports are opened by Podman's own rules. Test them from another machine.
:::

## Troubleshooting

**You cannot reach a service from another machine.** Check, in this order: the service is running (`systemctl status name`), it listens on the right address (`sudo ss -tlnp`), the ufw rule exists (`sudo ufw status`), and no other firewall (a cloud security group, a router) blocks the port.

**You locked yourself out of SSH.** Use the console and run `sudo ufw allow OpenSSH`.

**ufw says `Status: inactive`.** Enable it with `sudo ufw enable`. Confirm that `OpenSSH` is in the list first if you are on SSH, or you will cut your own session off.

**Rules for IPv6 are missing.** IPv6 handling is controlled by `IPV6=yes` in `/etc/default/ufw`, which is the Ubuntu default. After you change it, run `sudo ufw disable && sudo ufw enable`.

## See also

- [What the defaults do](/server/security/what-the-defaults-do/)
- [SSH keys and hardening](/server/administer/ssh-keys-and-hardening/)
- [Ubuntu Server: firewalls](https://ubuntu.com/server/docs/how-to/security/firewalls/)
