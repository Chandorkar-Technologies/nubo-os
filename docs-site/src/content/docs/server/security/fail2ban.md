---
title: fail2ban
description: What fail2ban does on Nubo OS Server, how to check that it protects SSH, how to unban an address and how to tune it.
sidebar:
  order: 20
---

**Applies to:** Server, Virtualization, Containers (not Edge)

fail2ban reads logs and, when an address fails to log in too many times, blocks that address in the firewall for a while. It makes password guessing against SSH slow and expensive. The package `nubo-server-base` installs `fail2ban`, so it is on the Server, Virtualization and Containers editions. The Edge edition does not include it.

## What Nubo configures

Nothing. Nubo ships no fail2ban jail files and no changes to its configuration. You get the behavior of the Ubuntu `fail2ban` package, which, as far as we know, enables a jail for SSH on installation. Confirm that on your machine with the first step below. <!-- verify: sshd jail enabled by default on 26.04 -->

The settings Nubo does ship that matter alongside it: SSH allows 4 attempts per connection (`MaxAuthTries 4`) and 30 seconds to log in (`LoginGraceTime 30`), and ufw can rate-limit SSH. See [SSH keys and hardening](/server/administer/ssh-keys-and-hardening/) and [Firewall with ufw](/server/administer/firewall-ufw/).

:::tip
fail2ban is a second line of defense. The strongest protection for SSH is to turn off password login and use keys. See [SSH keys and hardening](/server/administer/ssh-keys-and-hardening/).
:::

## Before you begin

- Logged in as a user with `sudo`.
- A Server, Virtualization or Containers edition (fail2ban installed). On Edge, install it with `sudo apt install fail2ban`.
- Your own public IP address, if you plan to add it to the ignore list.

## Steps

### 1. Check that fail2ban runs and watches SSH

```bash
systemctl is-active fail2ban
sudo fail2ban-client status
sudo fail2ban-client status sshd
```

```text
Status
|- Number of jail:	1
`- Jail list:	sshd
```

The second command lists the active jails; you should see `sshd`. The third shows the number of failed attempts and the addresses currently banned.

### 2. See the effective settings of the jail

```bash
sudo fail2ban-client get sshd bantime
sudo fail2ban-client get sshd findtime
sudo fail2ban-client get sshd maxretry
```

fail2ban's built-in defaults are a ban of 10 minutes (`bantime`), counted over a window of 10 minutes (`findtime`) after 5 failures (`maxretry`), unless the packaged files change them. The commands show the real values. <!-- verify: package defaults on 26.04 -->

### 3. Tune it with a local file

Never edit `/etc/fail2ban/jail.conf`; package updates replace it. Create `jail.local` or a file in `jail.d/`:

```ini title="/etc/fail2ban/jail.d/90-local.conf"
[DEFAULT]
# Never ban these addresses: your own office or home address, and localhost.
ignoreip = 127.0.0.1/8 ::1 203.0.113.10

[sshd]
enabled  = true
maxretry = 4
findtime = 10m
bantime  = 1h
```

`203.0.113.10` is a documentation example address; replace it with yours. Then reload:

```bash
sudo fail2ban-client reload
```

### 4. Unban an address

If you ban yourself by mistake:

```bash
sudo fail2ban-client set sshd unbanip 203.0.113.55
```

Do this from the console or from a different address.

### 5. Ban an address by hand

```bash
sudo fail2ban-client set sshd banip 198.51.100.7
```

### 6. See what happened

```bash
sudo journalctl -u fail2ban -n 50 --no-pager
sudo fail2ban-client status sshd
```

## Verify

Test from a second machine that is not in your ignore list. Make `maxretry` failed attempts with a wrong password, then check on the server:

```bash
sudo fail2ban-client status sshd
```

`Currently banned` rises to 1 and the address is listed. Unban the test address afterwards (step 4). If you only use SSH keys, you will not see failures from yourself; ban lists then show automated scanners.

## Troubleshooting

**`fail2ban-client: command not found`.** fail2ban is not installed (Edge edition). Install it.

**`Failed to access socket path`.** The service is not running. Check `systemctl status fail2ban` and `journalctl -u fail2ban`.

**The `sshd` jail is not listed.** Add the `[sshd]` section with `enabled = true` as in step 3 and reload.

**Bans do not stop connections.** fail2ban acts through the firewall. Check that its actions loaded without errors in `journalctl -u fail2ban`, and see `sudo fail2ban-client get sshd actions`. The kernel firewall rules it creates are separate from the ufw rule list, so `ufw status` does not show them.

**You banned yourself.** Use step 4 from the console. Add your address to `ignoreip`.

**SSH moved to another port.** The jail watches the SSH log, not the port number, but if you set `port = ...` in the jail it must match.

## See also

- [SSH keys and hardening](/server/administer/ssh-keys-and-hardening/)
- [Firewall with ufw](/server/administer/firewall-ufw/)
- [fail2ban documentation](https://github.com/fail2ban/fail2ban/wiki)
