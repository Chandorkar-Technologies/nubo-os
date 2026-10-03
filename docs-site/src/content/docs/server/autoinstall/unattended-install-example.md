---
title: A fully unattended install
description: Change the Nubo answer file so that the server installer asks no questions, and build an ISO with it.
sidebar:
  order: 30
---

**Applies to:** Server, Virtualization, Containers, Edge

Nubo's own answer file leaves six screens interactive. This guide shows what you change to make an installer that asks nothing, builds a machine with a user, a key and a disk layout that you chose, and reboots.

:::caution
This procedure has not been tested. It is based on Nubo's answer file and on Subiquity's documented keys. Test it in a virtual machine before you point it at real hardware. An unattended install can erase the disk without asking.
:::

## Before you begin

- A Linux build machine with `xorriso`, and the Nubo `.deb` files for your flavour. See [Build your own image](/server/images/build-your-own-image/).
- Ubuntu's live-server ISO for your CPU (26.04).
- A copy of the repository.
- A password hash, if you want a password: `mkpasswd -m sha-512` (from the `whois` package), or no password and an SSH key only.
- A test virtual machine.

## Steps

### 1. Copy the answer file

```bash
cp iso/server-user-data iso/my-user-data
```

### 2. Remove the interactive sections

Delete the whole `interactive-sections:` list. Everything that was listed (locale, keyboard, network, storage, identity, ssh) now needs an answer.

### 3. Add the answers

Add these keys under `autoinstall:`, next to `version: 1`. Names and values are examples; change them.

```yaml
  locale: en_US.UTF-8
  keyboard:
    layout: us
  timezone: UTC
  identity:
    hostname: nubo-server
    username: admin
    password: "$6$REPLACE_WITH_YOUR_HASH"
  ssh:
    install-server: true
    authorized-keys:
      - ssh-ed25519 AAAA... you@example
    allow-pw: false
  storage:
    layout:
      name: lvm
  shutdown: reboot
```

What they do:

| Key | Purpose |
|---|---|
| `identity` | The first user. The password must be a hash, not plain text. |
| `ssh.install-server` | Installs and enables the SSH server. Nubo's own core already depends on `openssh-server`. |
| `ssh.authorized-keys` | Public keys for the first user. |
| `ssh.allow-pw: false` | No password login. Nubo's core keeps password login on until a key is installed, so set this only when you have a key in the file. |
| `storage.layout.name` | A built-in layout: `lvm` or `direct` (see the Subiquity reference). It uses the whole disk it chooses, which can be the wrong one on a machine with several disks. Use an explicit `storage` configuration there. |
| `network` | Not set here: with no answer Subiquity configures DHCP on the interfaces it finds. For fixed addresses, add a Netplan `network:` section. |
| `shutdown` | `reboot` restarts after install; `poweroff` shuts down. |

Do not set `interactive-sections` at all. Leave `refresh-installer`, `snaps`, `source`, `apt` and `late-commands` as they are, so that packages still come through Nubo Cumulus and the Nubo packages are installed.

:::danger
A password hash and an SSH key in the file end up on the ISO, readable by anyone who has the ISO. Use a hash of a throw-away password and change it after the first login, or use an SSH key only.
:::

### 4. Build the ISO with your file

`iso/build-server-iso.sh` copies `iso/server-user-data` to the media. The simplest way is to replace that file in your working copy, not in your commit:

```bash
cp iso/server-user-data iso/server-user-data.orig
cp iso/my-user-data iso/server-user-data
FLAVOUR=server iso/build-server-iso.sh UBUNTU_SERVER_ISO NUBO_DEBS_DIR nubo-unattended.iso
cp iso/server-user-data.orig iso/server-user-data
```

### 5. Boot it in a VM

Start a virtual machine with a blank disk and the ISO, and watch the console. The installer should run through without a question and then reboot. Remove the ISO from the VM before the reboot so that the machine does not start the installer again.

## Verify

After the reboot:

```bash
ssh admin@ADDRESS
cat /etc/os-release | head -2
dpkg -l nubo-server-core nubo-server-base
sudo ufw status
```

You should log in with your key, see "Nubo OS Server", and have the Nubo packages installed.

## Troubleshooting

**The installer still asks a question.** Cause: a section was left without an answer, or `interactive-sections` is still present. Fix: compare with the table above; check the installer log (see [Validate and troubleshoot](/server/autoinstall/validate-and-troubleshoot/)).

**The installer stops with an error on the storage step.** Cause: the layout does not fit the disk, or there is more than one disk. Fix: set an explicit `storage` configuration; see the Subiquity documentation.

**It installs again after the reboot.** Cause: the ISO is still attached. Fix: detach the ISO, or set the VM to boot from disk first.

**Cannot log in.** Cause: the hash is wrong (for example with the `$` characters mangled by the shell), or the key is wrong. Fix: put the hash in single quotes when creating it; check the key.

**Machine wiped the wrong disk.** Cause: the layout picked a disk you did not intend. Fix: define the disk explicitly. This is why you test in a VM first.

## See also

- [How Nubo uses autoinstall](/server/autoinstall/how-nubo-uses-autoinstall/)
- [Answer file reference](/server/autoinstall/answer-file-reference/)
- [Subiquity autoinstall reference](https://canonical-subiquity.readthedocs-hosted.com/en/latest/reference/autoinstall-reference.html)
