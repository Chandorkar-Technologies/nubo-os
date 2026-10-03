---
title: Administer a server
description: "Day-to-day administration of a Nubo OS Server: users, SSH, firewall, updates, time, networking, services, logs, disks, backups and monitoring."
sidebar:
  order: 1
---

**Applies to:** Server, Virtualization, Containers, Edge

Administering Nubo OS Server is administering Ubuntu Server 26.04 LTS. The pages in this section give the commands for the common jobs and point out where Nubo's defaults change what you see. For the generic Linux parts they link to [Ubuntu Server documentation](https://ubuntu.com/server/docs).

## Pages in this section

| Page | What it helps you do |
|---|---|
| [Users and sudo](/server/administer/users-and-sudo/) | Add and remove users, give administrator rights, lock accounts. |
| [SSH keys and hardening](/server/administer/ssh-keys-and-hardening/) | Install a key, turn off password login, and understand the settings Nubo ships. |
| [Firewall with ufw](/server/administer/firewall-ufw/) | See the default firewall and open a port safely. |
| [Updates and reboots](/server/administer/updates-and-reboots/) | Understand automatic updates and decide when to reboot. |
| [Time with chrony](/server/administer/time-with-chrony/) | Check time sync and add your own time servers. |
| [Networking with Netplan](/server/administer/networking-with-netplan/) | Set a static address or change the network configuration. |
| [Services with systemd](/server/administer/services-with-systemd/) | Start, stop, enable and write services. |
| [Logs with journald](/server/administer/logs-with-journald/) | Read logs and keep them from filling the disk. |
| [Disks and LVM](/server/administer/disks-and-lvm/) | Read the installer's layout and grow a volume. |
| [Backups](/server/administer/backups/) | Back up and restore with restic. |
| [Monitoring basics](/server/administer/monitoring-basics/) | Check the health of a server with built-in tools. |
| [Upgrading between releases](/server/administer/upgrading-between-releases/) | How releases arrive and what not to run. |

## What Nubo sets up for you

A fresh server already has:

- an administrator user (the one you made in the installer) with `sudo`;
- SSH that refuses root login, with password login still on;
- a firewall that allows only SSH;
- chrony, using Cloudflare NTS and `pool.ntp.org`;
- automatic installation of updates (all four editions include `unattended-upgrades`);
- fail2ban and needrestart on every edition except Edge.

The security consequences are collected in [Security](/server/security/).

## A suggested order for a new server

1. [Users and sudo](/server/administer/users-and-sudo/): check who can administer the machine.
2. [SSH keys and hardening](/server/administer/ssh-keys-and-hardening/): move to key-only login.
3. [Firewall with ufw](/server/administer/firewall-ufw/): open only the ports your services need.
4. [Backups](/server/administer/backups/): set up a backup before you store anything valuable.
5. [Updates and reboots](/server/administer/updates-and-reboots/): decide how you will handle restarts.
