---
title: Autoinstall and cloud-init
description: How the Nubo OS Server installer uses an answer file, how to make an unattended variant, and how cloud-init configures cloud and VM images.
sidebar:
  order: 20
---

**Applies to:** Server, Virtualization, Containers, Edge

The Nubo OS Server installer is Ubuntu Server's text installer (Subiquity). It can read an answer file, called an autoinstall file, which fills in the answers to its questions. Nubo's server ISOs carry such a file. It sets Nubo's choices (where packages come from, which packages to install) and leaves the personal questions, such as language, disk and user, for you.

Images for clouds, virtual machines and the Raspberry Pi do not use the installer. They start from a ready-made disk image, and first-boot setup is done by cloud-init. That is the second half of this section.

## In this section

- [How Nubo uses autoinstall](/server/autoinstall/how-nubo-uses-autoinstall/): an explanation of `iso/server-user-data`, key by key, and how each flavour differs.
- [Answer file reference](/server/autoinstall/answer-file-reference/): a table of every key the Nubo answer file sets.
- [A fully unattended install](/server/autoinstall/unattended-install-example/): change the answer file so that the installer asks nothing. Untested.
- [Validate and troubleshoot](/server/autoinstall/validate-and-troubleshoot/): check an answer file and read the installer's logs.
- [cloud-init on Nubo images](/server/autoinstall/cloud-init/): first-boot configuration for cloud and VM images.

## How the pieces relate

```text
Server ISO (installer)               Cloud / VM / Pi image
  server/user-data                     already installed disk image
  (autoinstall, read by Subiquity)     first boot: cloud-init
  late-commands install Nubo packages  Nubo packages added when the image is built
```

For the images themselves, see [Server images](/server/images/). For flavours, see [Choose a flavour](/server/flavours/).

## Further reading

Autoinstall is Canonical's feature, and its keys are defined by Subiquity. Nubo documents only what it sets. For the full list, see the [autoinstall reference](https://canonical-subiquity.readthedocs-hosted.com/en/latest/reference/autoinstall-reference.html) in the Subiquity documentation.
