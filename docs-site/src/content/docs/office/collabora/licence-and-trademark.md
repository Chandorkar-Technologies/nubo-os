---
title: "Licence and trademark rules"
description: "What the Collabora licence and trademark policy allow us to do with their code, and what we remove, keep and credit."
sidebar:
  order: 10
---

This page records what we read and what we do about it. It is not legal advice. We plan to ask `trademark@collaboraoffice.com` to confirm our About wording before release.

## What we read

- Collabora Online MPLv2 terms: https://www.collaboraonline.com/terms/collabora-online-mplv2/
- Collabora trademark policy: https://www.collaboraonline.com/trademark-policy/
- Collabora Online SDK theming page: https://sdk.collaboraonline.com/docs/theming.html
- LibreOffice branding notes for the `--with-branding` and `--with-vendor` build options.
- The documents in the source tree: `qt/README.md`, `macos/README.md`, `windows/coda/README.md`, `android/README.md`, `ios/README.md`.

## What the licence lets us do

1. **Use the code.** Collabora Online and the Collabora Office engine are mostly under the Mozilla Public License 2.0. Building from source, changing and distributing it is allowed.
2. **Build our own binaries.** Collabora's own executables carry extra conditions, and their free CODE builds are described as unsuitable for production use in a company without contributing. We avoid that by building from source ourselves.
3. **Offer the source.** If we distribute modified source files, we offer them under MPLv2. The script and brand pack are in the Nubo OS repository (`office/`), and the unmodified base is Collabora's tagged release.

## What we must remove

- **All uses of Collabora's marks in a modified build.** The marks are Collabora, Collabora Office, Collabora Online, CODE and the Collabora Productivity logo. The policy says: remove all trademark uses of the Marks from the version of the software you are modifying.
- **Their brand pack.** Collabora's Flatpak downloads a separate pack of logos, images and a welcome slideshow marked "All Rights Reserved". We cannot use it, and we do not copy from it. [Our own pack](/office/collabora/brand-pack/) replaces it.
- **Anything that implies endorsement.** Our wording must not suggest more of a link to Collabora than there is.

## What we must keep

- Copyright and licence notices, including "Copyright the Collabora Online contributors" in the file headers, `COPYING*`, `THIRDPARTYLICENSES` and `CODA-THIRDPARTYLICENSES.html`.
- The "License Information" link in the About window.
- A credit for the technology base.

## The credit line

The About window and the welcome text say: **Built on Collabora Online and LibreOffice technology.** The trademark policy lets us name the marks to say what a product is built on. It does not prescribe wording, which is why we ask Collabora to confirm it.

## LibreOffice's name

The name "LibreOffice" may be used only for substantially unmodified software, per The Document Foundation. Nubo Office does not call itself LibreOffice. A count of the engine's compiled library still shows about 85 internal "LibreOffice" strings (file-format and configuration names), which users do not see.

## Names we chose

Nubo Office, Nubo Write, Nubo Cells, Nubo Present and Nubo Draw. A trademark search at the registers is still to do before any store listing.

## See also

- [The rebrand script](/office/collabora/rebrand-script/)
- [Brand and licence rules](/developers/brand-and-licence-rules/) for Nubo OS itself
