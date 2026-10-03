---
title: Users and sudo
description: Add and remove users, give or take away administrator rights with sudo, and lock accounts on a Nubo OS Server.
sidebar:
  order: 10
---

**Applies to:** Server, Virtualization, Containers, Edge

User management on Nubo OS Server is the same as on Ubuntu Server. Nubo does not change the user tools, the `sudo` rules or the password policy. This page gives the commands you will use most, and what the installer sets up. For deeper topics (LDAP, Kerberos, SSSD) see [Ubuntu's user management guide](https://ubuntu.com/server/docs/how-to/security/user-management/).

## What the installer created

The user you entered on the installer's Profile screen is the first administrator:

- It belongs to the `sudo` group, so it can run commands as root with `sudo`.
- The root account has no password, so nobody can log in as root with a password. Root login over SSH is also refused by Nubo's SSH setting (see [SSH keys and hardening](/server/administer/ssh-keys-and-hardening/)).

## Before you begin

- Logged in as a user who can use `sudo`.

## Steps

### Add a user

```bash
sudo adduser alice
```

`adduser` asks for a password and some optional details, then creates the home directory. To create a user who logs in only with an SSH key, you can still set a password; you can lock it afterwards (see below).

### Give a user administrator rights

Add the user to the `sudo` group:

```bash
sudo usermod -aG sudo alice
```

The `-a` flag matters: without it, `usermod -G` replaces the user's groups instead of adding one. The user must log out and in again for the new group to apply.

### Take administrator rights away

```bash
sudo deluser alice sudo
```

### See what a user may do

```bash
sudo -l -U alice
```

### Allow one command without a password

Put a rule in its own file, using `visudo` so a syntax error cannot lock you out. The file name must not contain a dot or end in `~`.

```bash
sudo visudo -f /etc/sudoers.d/90-backup
```

```text title="/etc/sudoers.d/90-backup"
backup ALL=(root) NOPASSWD: /usr/bin/restic
```

Keep rules narrow. A password-less rule for a shell or editor is the same as password-less root.

### Lock or unlock an account

Locking disables password login. SSH key login can still work unless you also expire the account.

```bash
sudo passwd -l alice      # lock the password
sudo passwd -u alice      # unlock it
sudo chage -E 0 alice     # expire the account: blocks all logins
sudo chage -E -1 alice    # remove the expiry
```

### Remove a user

```bash
sudo deluser alice                   # keeps the home directory
sudo deluser --remove-home alice     # deletes the home directory too
```

Before you delete a user, check for running processes (`ps -u alice`) and files owned by that user elsewhere (`sudo find / -xdev -user alice`).

### Change a password

```bash
passwd                # your own
sudo passwd alice     # someone else's
```

## Verify

```bash
id alice
getent group sudo
```

`id` lists the groups the user belongs to. `getent group sudo` lists the members of `sudo`.

To test `sudo` without changing anything, log in as the user and run:

```bash
sudo -v
```

It asks for the user's password and prints nothing if the user may use `sudo`.

## Troubleshooting

**`alice is not in the sudoers file. This incident will be reported.`** The user is not in the `sudo` group, or has not logged in again since being added. Add the user and have them log out and in.

**You edited `/etc/sudoers` and now `sudo` fails.** Always edit with `visudo`. If you are locked out, boot to recovery mode or use the console as root from a rescue system and fix the file. This is why drop-in files under `/etc/sudoers.d/` are safer.

**`adduser: The user alice already exists.`** Choose another name, or use `usermod` to change the existing user.

**A deleted user's files still show a number as the owner.** The files are owned by an old user ID. Find them with `sudo find / -xdev -nouser` and reassign them with `chown`.

## See also

- [SSH keys and hardening](/server/administer/ssh-keys-and-hardening/)
- [Ubuntu: user management](https://ubuntu.com/server/docs/how-to/security/user-management/)
