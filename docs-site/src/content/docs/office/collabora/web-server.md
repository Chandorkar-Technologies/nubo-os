---
title: "The web editor"
description: "The plan to replace the document editor at office.nubo.email with the Nubo build of Collabora Online."
sidebar:
  order: 70
---

**Applies to:** Developers, administrators

:::caution[Planned]
Nothing in this page is switched on yet.
:::

## Today

`office.nubo.email` runs ONLYOFFICE. Nubo Email's web mail (Bulwark) opens documents there.

## Why change

- ONLYOFFICE's free edition keeps its own branding and attribution. White-labelling it needs a paid licence. I could not confirm their current terms, so check them before relying on this.
- Collabora Online's code is MPLv2 and can be rebranded when built from source, which is what we do for the desktop apps.
- One engine for desktop and web means a document opens and looks the same on both.

## What it takes

1. Build Collabora Online (the server, `wsd`, `kit` and the web interface) from the same source tag as the desktop app, with our rebrand and brand pack.
2. Package it for the Nubo server (a package or a container image).
3. Run it as the document server behind `office.nubo.email`, with WOPI between it and Nubo Email.
4. Move documents over and test that existing files open and save the same.
5. Switch Nubo Email to the new editor and retire ONLYOFFICE.

The web interface gets the same names, colours and welcome slides, because it is the same code.

## Shared editing

Several people editing one document at once is a feature of the Collabora Online server. It starts to work for Nubo users when this switch is done.

## See also

- [Accounts and files](/office/account/sign-in-and-files/)
- [Platforms and build requirements](/office/collabora/platforms/)
