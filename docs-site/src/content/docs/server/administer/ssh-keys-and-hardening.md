---
title: SSH keys and hardening
description: Install an SSH key, switch to key-only login, and understand every setting in Nubo's SSH configuration file.
sidebar:
  order: 20
---

**Applies to:** Server, Virtualization, Containers, Edge

Every Nubo OS Server includes OpenSSH, with a small configuration file that refuses root login and tightens a few limits. It leaves password login on, so a fresh machine is never locked out. This page explains the file, then shows how to install a key and turn password login off. The result is a server that only accepts logins from people who hold a key.

:::note
Turning off password login is a recommendation, not something Nubo enforces. The package does not turn it off for you, because it cannot know whether you have a key installed.
:::

## What Nubo ships

The package `nubo-server-core` installs one file:

```text title="/etc/ssh/sshd_config.d/90-nubo-sshd.conf"
# Nubo OS Server: no root login over SSH. Password login stays on until an
# SSH key is installed, so a fresh machine is never locked out.
PermitRootLogin no
MaxAuthTries 4
LoginGraceTime 30
X11Forwarding no
```

OpenSSH reads every `*.conf` file in `/etc/ssh/sshd_config.d/` before the main file. For most settings the **first** value it sees wins, and files are read in alphabetical order. That matters when you add your own file, as you will below.

| Line | Meaning | Ubuntu's default |
|---|---|---|
| `PermitRootLogin no` | Nobody can log in as `root` over SSH, with a password or a key. Administer through your own user and `sudo`. | `prohibit-password` (key only) |
| `MaxAuthTries 4` | After 4 failed authentication attempts on one connection, the server drops it. This slows down password guessing on a single connection. | 6 |
| `LoginGraceTime 30` | A client has 30 seconds to finish logging in before the server closes the connection. This frees up connection slots from idle or hostile clients sooner. | 120 seconds |
| `X11Forwarding no` | Graphical programs cannot be forwarded to your desktop over SSH. A server has no use for it, and forwarding adds attack surface. | `yes` in Ubuntu's main file |

The "Ubuntu's default" column is OpenSSH's and Ubuntu's standard behavior; if you need to confirm it on your machine, see `/etc/ssh/sshd_config` and `man sshd_config`. <!-- verify label: defaults as shipped in Ubuntu 26.04 -->

`passwordauthentication` is not in Nubo's file, so the system default applies, which is **yes**. fail2ban (on every edition except Edge) adds a layer against password guessing; see [fail2ban](/server/security/fail2ban/).

## Before you begin

- A working login to the server, on the console or over SSH, as a user with `sudo`.
- A second terminal window. You will test the key in it before you close your first session. This is how you avoid locking yourself out.
- A computer you log in from (the client) with an SSH client. macOS, Linux and current Windows all include `ssh`.

## Steps

### 1. Create a key on your client

Run this on your own computer, not on the server:

```bash
ssh-keygen -t ed25519 -C "alice@laptop"
```

Accept the default file location and **choose a passphrase**. This creates a private key (`~/.ssh/id_ed25519`, which never leaves your computer) and a public key (`~/.ssh/id_ed25519.pub`).

### 2. Copy the public key to the server

From the client:

```bash
ssh-copy-id alice@192.168.64.5
```

Use your user name and the server's address. The command appends the public key to `~/.ssh/authorized_keys` on the server and sets safe permissions. It asks for your password one last time.

If `ssh-copy-id` is not available, paste the contents of `id_ed25519.pub` into `~/.ssh/authorized_keys` on the server, then run `chmod 700 ~/.ssh` and `chmod 600 ~/.ssh/authorized_keys`.

### 3. Test the key in a new terminal

```bash
ssh alice@192.168.64.5
```

You should be asked for the key's passphrase, not the account password. **Keep your first session open.**

### 4. Turn off password login

On the server, create a drop-in file whose name sorts **before** `90-nubo-sshd.conf` and before any file the cloud tooling adds (such as `50-cloud-init.conf`), so that your value is read first:

```bash
sudo tee /etc/ssh/sshd_config.d/10-keys-only.conf >/dev/null <<'EOF'
PasswordAuthentication no
KbdInteractiveAuthentication no
EOF
```

Setting `KbdInteractiveAuthentication no` closes the other route to a password prompt.

### 5. Check the configuration and reload

```bash
sudo sshd -t
sudo systemctl reload ssh
```

`sshd -t` prints nothing if the configuration is valid. Do not reload if it prints an error.

### 6. Test from a third terminal

```bash
ssh alice@192.168.64.5
```

Then prove that passwords are refused:

```bash
ssh -o PubkeyAuthentication=no alice@192.168.64.5
```

## Verify

On the server:

```bash
sudo sshd -T | grep -E 'permitrootlogin|passwordauthentication|kbdinteractiveauthentication|maxauthtries|logingracetime|x11forwarding'
```

```text
permitrootlogin no
passwordauthentication no
kbdinteractiveauthentication no
maxauthtries 4
logingracetime 30
x11forwarding no
```

The second test in step 6 should end with `Permission denied (publickey)`.

## Troubleshooting

**You cannot log in after turning off passwords.** Use the console of the machine or your hypervisor. Delete `/etc/ssh/sshd_config.d/10-keys-only.conf`, run `sudo systemctl reload ssh`, and check that your public key is in `~/.ssh/authorized_keys` with the right permissions (directory `700`, file `600`, owned by your user).

**`sshd -T` still shows `passwordauthentication yes`.** Another file sets it earlier. List the files with `ls /etc/ssh/sshd_config.d/` and give yours a lower number. Find the setting with `sudo grep -ri passwordauthentication /etc/ssh/`.

**`Permission denied (publickey)` with the right key.** The server may not be reading the right file. Run `ssh -v alice@host` to see which keys your client offers, and check `~/.ssh/authorized_keys` on the server for the exact public key.

**`Too many authentication failures`.** Your client offers many keys and the server's `MaxAuthTries 4` stops after four. Name the key: `ssh -i ~/.ssh/id_ed25519 -o IdentitiesOnly=yes alice@host`.

**`ssh: Connection refused`.** SSH is not running or the firewall blocks it. Check `systemctl status ssh` and [Firewall with ufw](/server/administer/firewall-ufw/).

## See also

- [fail2ban](/server/security/fail2ban/)
- [Users and sudo](/server/administer/users-and-sudo/)
- [What the defaults do](/server/security/what-the-defaults-do/)
- [OpenSSH on Ubuntu Server](https://ubuntu.com/server/docs/how-to/security/openssh-server/)
