---
title: Security
description: What Nubo OS Server configures for security, how its protections work, and what the machine contacts on the internet.
sidebar:
  order: 1
---

**Applies to:** Server, Virtualization, Containers, Edge

This section describes the security-relevant choices Nubo makes on a server, so that you know exactly what the machine does without being told. It does not claim that the system is unbreakable. It lists settings, files and reasons. You can check every statement against the files on your own machine.

## Pages in this section

| Page | What it covers |
|---|---|
| [What the defaults do](/server/security/what-the-defaults-do/) | A reference table of every file and setting from `nubo-server-core`, `nubo-server-base`, `nubo-edge`, `nubo-base` and `nubo-archive`, with the reason for each. |
| [fail2ban](/server/security/fail2ban/) | Brute-force protection on the Server, Virtualization and Containers editions. |
| [AppArmor](/server/security/apparmor/) | Mandatory access control profiles that confine programs. |
| [Disk encryption](/server/security/disk-encryption/) | LUKS encryption chosen in the installer, passphrases, recovery and caveats. |
| [What contacts the internet](/server/security/what-contacts-the-internet/) | Every outside address the system uses, what is switched off, and what remains. |

## The approach in short

1. **Closed by default.** Incoming connections are blocked except SSH ([Firewall with ufw](/server/administer/firewall-ufw/)).
2. **No root over SSH**, and a short list of limits for login attempts ([SSH keys and hardening](/server/administer/ssh-keys-and-hardening/)).
3. **Updates install themselves**, but reboots are yours to choose ([Updates and reboots](/server/administer/updates-and-reboots/)).
4. **Fewer outside contacts.** Package downloads, time and the network check go to Nubo or to neutral services. Crash reports, login news and Ubuntu Pro adverts are switched off.
5. **Ubuntu's security work stays intact.** Nubo does not replace the kernel, the boot loader, the package signatures or the AppArmor policy. Ubuntu's packages keep Ubuntu's signatures.

## What Nubo does not do

- It does not claim certifications or compliance. Nubo OS Server has none to claim.
- It does not enforce key-only SSH login. It leaves password login on until you install a key and turn it off yourself.
- It does not add its own AppArmor profiles or fail2ban jails. Those come from Ubuntu's packages.
- It does not encrypt the disk unless you choose that in the installer.

## Reporting a security problem

Send it to security@nubosuite.tech. For general questions use support@nubo.email.

## See also

- [Ubuntu Security documentation](https://documentation.ubuntu.com/security/)
- [Administer](/server/administer/)
