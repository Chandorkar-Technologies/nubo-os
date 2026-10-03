---
title: Welcome to Nubo OS
description: What Nubo OS is, which editions exist, and where to begin.
sidebar:
  order: 1
---

Nubo OS 1 "Flow" is an operating system from Chandorkar Technologies. It is based on Ubuntu 26.04 LTS and comes in two forms: a desktop for everyday computers, and a server for machines that run services. You can download it for free.

Underneath, Nubo OS is Ubuntu. Nubo adds its own look, a handful of apps and helpers, and a package archive, all delivered as ordinary packages on top of Ubuntu's. Because the base is unchanged, Ubuntu's security updates keep arriving, and software built for Ubuntu 26.04 generally works.

:::caution[Beta]
Nubo OS 1 is in beta. The packages at the time of writing are version 0.8.0~beta4. Pages in these docs mark features that are not built yet as **Planned**, and features that are built but not yet tested on real hardware as untested.
:::

## The editions

| Edition | For | Where to start |
|---|---|---|
| Desktop | Laptops, desktops, and virtual machines you sit in front of | [Desktop docs](/desktop/) |
| Server | A general-purpose server with sensible security defaults | [Server docs](/server/) |
| Virtualization | A server that runs virtual machines and system containers (Incus) | [Server docs](/server/) |
| Containers | A server for rootless Podman containers | [Server docs](/server/) |
| Edge | The smallest server: the core plus automatic security updates | [Server docs](/server/) |

The desktop is GNOME 50 with the Nubo glass theme, a notification centre, desktop widgets, a launcher, and a curated set of apps. Both the desktop and the server are built for 64-bit Intel and AMD processors (amd64) and for 64-bit Arm processors (arm64).

## Where to begin

If you want to try the desktop without changing your computer, start with [Try Nubo OS from a USB stick](/desktop/get-started/try-from-usb/). If you are ready to install, read [Install Nubo OS on a PC](/desktop/get-started/install-on-a-pc/). If you would rather experiment inside a virtual machine, read [Install Nubo OS in a virtual machine](/desktop/get-started/install-in-a-vm/).

After you install, [Your first login](/desktop/get-started/first-login/) and [A tour of your first day](/desktop/get-started/first-day-tour/) show you around.

## About this section

These pages give you the background you need before or beside the how-to guides:

- [What is different from Ubuntu](/start/what-is-different-from-ubuntu/) explains exactly what Nubo changes and what it leaves alone.
- [System requirements](/start/system-requirements/) lists what is confirmed and what is not yet confirmed.
- [Support and lifecycle](/start/support-and-lifecycle/) explains how long Nubo OS 1 is supported and how update channels work.
- [Getting help](/start/getting-help/) lists where to ask questions and report problems.
- [Frequently asked questions](/start/faq/) answers the questions people ask first.
- [Glossary](/start/glossary/) defines the terms used across the documentation.

## Where else to look

- [Desktop](/desktop/) for using and troubleshooting the desktop.
- [Server](/server/) for the server editions.
- [Updates](/updates/) for the package archive, update channels and Nubo Cumulus.
- [Reference](/reference/) for exact values, package lists and commands.
- [Developers](/developers/) for building Nubo OS from source.
