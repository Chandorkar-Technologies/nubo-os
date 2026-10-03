---
title: AppArmor
description: What AppArmor does on Nubo OS Server, how to see which profiles are loaded, and how to investigate a denial.
sidebar:
  order: 30
---

**Applies to:** Server, Virtualization, Containers, Edge

AppArmor is a Linux security module that confines programs to a list of files, capabilities and network actions, described in a **profile**. If a confined program is compromised, the profile limits what the attacker can reach. Ubuntu enables it by default. On Nubo OS Server, `nubo-server-core` depends on the `apparmor` package, so it is present on every edition.

## What Nubo configures

Nubo adds no AppArmor profiles and does not change Ubuntu's. The profiles on a Nubo OS Server are the ones that Ubuntu's packages ship (for example for the container tools on the Containers edition, if their packages include a profile). Nubo only makes sure AppArmor is installed. Behavior is Ubuntu 26.04 LTS's.

## Explanation: modes

A profile can be in one of two modes:

| Mode | Behavior |
|---|---|
| enforce | Actions outside the profile are blocked and logged. |
| complain | Actions outside the profile are only logged. Used to build or test a profile. |

Programs without a profile are unconfined: AppArmor does nothing for them.

## Before you begin

- Logged in as a user with `sudo`.
- For changing modes you need the `apparmor-utils` package, which is not installed by default: `sudo apt install apparmor-utils`.

## Steps

### See the state

```bash
sudo aa-status
```

The output shows whether the module is loaded, how many profiles are in enforce and complain mode, and which running processes are confined.

```bash
systemctl is-active apparmor
cat /sys/module/apparmor/parameters/enabled
```

The first prints `active`, the second prints `Y`.

### Look at the profile files

```bash
ls /etc/apparmor.d/
```

Each file is named after the program path with dots in place of slashes (for example `usr.sbin.example`).

### Find a denial

When AppArmor blocks something, it logs a message with `apparmor="DENIED"`:

```bash
sudo journalctl -k | grep 'apparmor="DENIED"'
```

The message names the profile, the operation (for example `open`), the file and the program.

### Switch a profile to complain mode while you investigate

```bash
sudo aa-complain /etc/apparmor.d/usr.sbin.example
```

Run your program, read the logged denials, then set the profile back:

```bash
sudo aa-enforce /etc/apparmor.d/usr.sbin.example
```

### Allow the access the program needs

Do not turn a profile off. Add a rule for the access that is legitimate. Local additions go in `/etc/apparmor.d/local/<profile-name>`, which package updates leave alone. For example:

```text title="/etc/apparmor.d/local/usr.sbin.example"
/srv/data/** rw,
```

Reload the profile after you edit it:

```bash
sudo apparmor_parser -r /etc/apparmor.d/usr.sbin.example
```

(`usr.sbin.example` is a placeholder name; replace it with a real profile from `aa-status`.)

## Verify

```bash
sudo aa-status | head -n 10
```

The first lines say `apparmor module is loaded.` and show the number of profiles loaded and in enforce mode. After you changed a profile, confirm its mode in the `aa-status` list.

## Troubleshooting

**A service fails with "permission denied" although file permissions are right.** AppArmor may be blocking it. Search for `apparmor="DENIED"` in the kernel log as above, then add a local rule.

**`aa-complain: command not found`.** Install `apparmor-utils`.

**`apparmor module is not loaded`.** The kernel did not enable AppArmor. This is unusual on Ubuntu's kernel. Check `cat /proc/cmdline` for `apparmor=0` or `security=` options, which would turn it off.

**A service from a package outside Ubuntu is not confined.** Programs without a profile are unconfined. Ubuntu's profile set does not cover everything. Writing a profile is a larger job; see Ubuntu's AppArmor documentation.

**You edited a profile in `/etc/apparmor.d/` and a package update asks what to do with the file.** Keep your changes in `/etc/apparmor.d/local/` instead, so you can accept the package's version.

## See also

- [What the defaults do](/server/security/what-the-defaults-do/)
- [Ubuntu Server: AppArmor](https://ubuntu.com/server/docs/how-to/security/apparmor/)
- [Security](/server/security/)
