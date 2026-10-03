---
title: Networking with Netplan
description: Read the network configuration the installer wrote, set a static address safely with netplan try, and check the result.
sidebar:
  order: 60
---

**Applies to:** Server, Virtualization, Containers, Edge

Nubo OS Server configures its network the way Ubuntu Server does: with Netplan. You describe the network in YAML files under `/etc/netplan/`, and Netplan turns that into configuration for the network service that runs on the machine. Nubo does not change this. This page covers the commands and one common task, setting a fixed address. For the full syntax, see the [Netplan documentation](https://netplan.readthedocs.io/).

## How it fits together

- The installer's Network screen writes a Netplan file for the interfaces you configured. Look in `/etc/netplan/` to see its name; the content depends on what you chose. <!-- verify: file name written by the installer -->
- `netplan apply` generates the configuration for the network back end (systemd-networkd on a server) and applies it.
- `/etc/netplan/*.yaml` files are merged in alphabetical order; a later file overrides an earlier one.

:::note
`nubo-base` installs a NetworkManager setting that points the connectivity check at Nubo (`/etc/NetworkManager/conf.d/20-connectivity-ubuntu.conf`, address https://archive.nubosuite.tech/check). It has an effect only on machines that run NetworkManager, which a typical Nubo OS Server does not.
:::

## Before you begin

- Logged in as a user with `sudo`.
- If you work over SSH, console access to the machine in case the new network settings do not work. `netplan try` (below) protects you from most mistakes, but console access is the safety net.
- The values you want: address and prefix length (for example `192.168.1.50/24`), gateway, and DNS servers.

## Steps

### Look at what is there

```bash
ip -br address
ip route
ls -l /etc/netplan/
sudo netplan get
resolvectl status
```

`ip -br address` lists interfaces and addresses in short form. `sudo netplan get` prints the merged Netplan configuration.

### Set a static address

1. Note your interface name from `ip -br link`. The names below (`enp0s1`) are examples; yours may differ.
2. Copy the existing file so you can go back:

   ```bash
   mkdir -p ~/netplan-backup && sudo cp /etc/netplan/*.yaml ~/netplan-backup/
   ```

3. Edit the file the installer wrote (use its real name), or create a file that sorts after it:

   ```yaml title="/etc/netplan/60-static.yaml"
   network:
     version: 2
     ethernets:
       enp0s1:
         dhcp4: false
         addresses:
           - 192.168.1.50/24
         routes:
           - to: default
             via: 192.168.1.1
         nameservers:
           addresses: [192.168.1.1, 9.9.9.9]
   ```

   If the installer's file already configures `enp0s1` with `dhcp4: true`, edit that file instead of adding a second one; otherwise the two files merge and you get both settings.

4. Netplan files must not be readable by everyone:

   ```bash
   sudo chmod 600 /etc/netplan/60-static.yaml
   ```

5. Try the change with an automatic rollback:

   ```bash
   sudo netplan try
   ```

   If the new settings work, press <kbd>Enter</kbd> to keep them within the timeout (120 seconds by default). If you lose your session or press nothing, Netplan restores the old settings.

6. After you keep the change, nothing more is needed: it is applied. To apply a change without the rollback, use `sudo netplan apply`.

## Verify

```bash
ip -br address
ip route
resolvectl status
ping -c 3 archive.nubosuite.tech
```

The interface shows your address, `ip route` shows `default via 192.168.1.1`, `resolvectl status` lists your DNS servers, and the ping gets replies. Finally, reboot and check that the address stays (`sudo reboot`, then `ip -br address`).

## Troubleshooting

**`netplan try` or `apply` reports `Invalid YAML` or an indentation error.** YAML uses spaces, never tabs, and indentation matters. Check each line against the example.

**`Permissions for /etc/netplan/... are too open`.** Run `sudo chmod 600` on the file.

**The interface has two addresses.** Two Netplan files configure the same interface. Run `sudo netplan get` to see the merged result and remove the duplicate.

**There is no connectivity after `netplan apply`.** Use the console: restore the backup (`sudo cp ~/netplan-backup/*.yaml /etc/netplan/`) and run `sudo netplan apply`.

**Name resolution fails but pinging an address works.** Check `resolvectl status` for a DNS server on the link, and `resolvectl query archive.nubosuite.tech`.

**The Virtualization edition's bridge.** `nubo-incus-init` creates a bridge called `nubobr0` through Incus. It is managed by Incus, not by Netplan. Do not add it to your Netplan files.

## See also

- [First boot checklist](/server/install/first-boot-checklist/)
- [Firewall with ufw](/server/administer/firewall-ufw/)
- [Ubuntu Server: networking](https://ubuntu.com/server/docs/explanation/networking/about-netplan/)
