---
title: Getting help
description: Where to read, ask and report problems, and what to include so someone can help you.
sidebar:
  order: 40
---

**Applies to:** Desktop, Server

You have four places to look for help, from fastest to slowest.

## 1. These documentation pages

- Something broke on the desktop? Start at [Troubleshooting](/desktop/troubleshooting/), which is organized by symptom.
- Not sure what a term means? See the [Glossary](/start/glossary/).
- A common question? See the [Frequently asked questions](/start/faq/).
- For anything that behaves as on Ubuntu 26.04, Ubuntu's documentation is accurate for Nubo OS too: [Ubuntu Desktop](https://ubuntu.com/desktop/docs) and [Ubuntu Server](https://ubuntu.com/server/docs).

## 2. Email support

Write to **support@nubo.email**. Include:

1. What you were trying to do.
2. What you expected, and what happened instead. Exact error text helps.
3. Which edition and version you use (see below).
4. Whether it happens on real hardware or in a virtual machine, and which one.
5. The log bundle from [Collect logs for support](/desktop/troubleshooting/collect-logs-for-support/), if the problem is on the desktop.

## 3. GitHub issues

The code is public at <https://github.com/Chandorkar-Technologies/nubo-os>. If you found a bug in how Nubo builds or packages something, open an issue there. Search the existing issues first. Do not post passwords, keys or private data in an issue.

## 4. Security reports

If you think you found a security problem, do not open a public issue. Email **security@nubosuite.tech**.

## Find your version

On the desktop, open Settings and then About. The screen shows the operating system name, which reads "Nubo OS 1", the hardware model, processor and memory. <!-- verify label -->

From a terminal:

```bash
cat /usr/lib/os-release
dpkg -l | grep '^ii  nubo-'
nubo-channel
```

The first command shows the system name. The second lists the Nubo packages and their versions. The third prints `stable` or `beta`.

## Before you ask

A few checks solve many problems:

1. Restart the computer. Several Nubo helpers start with the session.
2. Check your network. Several first-boot jobs, such as app downloads, wait for it and retry on the next boot.
3. Run `sudo apt update && sudo apt upgrade` and restart. You may be on a fixed version.
4. Try the matching page under [Troubleshooting](/desktop/troubleshooting/).

## Verify

You know you have enough detail for support when someone who has never seen your machine could repeat your steps and see the same result.

## Troubleshooting

- **No reply from support@nubo.email.** Check your spam folder, and resend with the log bundle attached. Nubo OS is in beta, so replies may take time.
- **The log bundle is too large to email.** Describe the problem first and say that you can share the bundle another way.

## See also

- [Support and lifecycle](/start/support-and-lifecycle/)
- [Collect logs for support](/desktop/troubleshooting/collect-logs-for-support/)
