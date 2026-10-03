---
title: Brand and licence rules
description: What the Nubo OS licences allow you to reuse, which files are protected by trademark, and how to name the base system correctly.
sidebar:
  order: 130
---

Nubo OS has two kinds of licence in one repository: free software for the code, and a trademark restriction on the Nubo name and mark. This page summarizes both so you know what you can copy, change and ship. It is a summary, not legal advice; the files `LICENSE` and `LICENSE.brand` are the authority.

## The two licences

| What | Licence | File |
|---|---|---|
| Everything in the repository except the brand assets | GNU General Public License, version 3 or later | `LICENSE` |
| The Nubo name, the Nubo mark and the Nubo OS name | Trademarks of Chandorkar Technologies, with a limited permission | `LICENSE.brand` |

`debian/copyright` repeats the split. It lists `brand/logo/*` and `brand/src/*` under a licence called `Nubo-Brand`, and everything else as `GPL-3+`.

## What `LICENSE.brand` says

In short:

- The Nubo name, the Nubo mark (the files in `brand/logo/` and `brand/src/`) and the name "Nubo OS" belong to Chandorkar Technologies.
- You may **redistribute these files unmodified as part of Nubo OS**.
- You may **not** use them to name or brand any other product, service or distribution.
- You may **not** modify them without written permission from Chandorkar Technologies.

## What you may do

| You want to | Allowed? |
|---|---|
| Use, study, change and share the code under GPL-3.0-or-later | Yes, with the licence's conditions (source, notices, same licence for derived work). |
| Redistribute Nubo OS with the logo files untouched | Yes. |
| Build your own distribution from this repository | Yes for the code. Replace the name, the mark and the files in `brand/logo/` and `brand/src/` first, or ask for written permission. |
| Edit the logo or recolour it | Not without written permission. |
| Use "Nubo" or "Nubo OS" as the name of another product | Not without written permission. |
| State that your system is "based on Nubo OS" | A plain, true statement of origin is normal practice; do not suggest it is made or endorsed by Chandorkar Technologies when it is not. Ask when in doubt. |

To ask for permission, write to support@nubo.email.

## Replacing the brand when you fork

A fork needs its own identity. The places where the Nubo brand appears:

- `brand/logo/*.svg` and `brand/src/` (the mark).
- `data/os/` and `server/`: `os-release` (`NAME`, `PRETTY_NAME`, `HOME_URL`), `issue`, `lsb-release`, `legal`.
- `data/gschema/90_nubo.gschema.override`: theme names such as `Nubo-Grey-Dark`, the sound theme `Nubo`, the logo path.
- `data/apps/rebrand.list` and the `debian/` package names.
- Installer branding in `installer/` and the strings in `iso/`.
- The service names `archive.nubosuite.tech`, `docs.nubosuite.tech` and the signing key. Never reuse the archive key or domains; they identify Nubo's packages.

## Third-party licences in the build

Upstream sources fetched by `vendor/fetch.sh` keep their own licences, noted beside each pin:

| Source | Licence noted in `fetch.sh` |
|---|---|
| Colloid GTK theme | GPL-3.0 |
| Blur my Shell | GPL-3.0 |
| App Grid Tuner | MIT |
| Glass widgets | GPL-3.0+ |
| Vicinae launcher | GPL-3.0 |

The wallpapers are photographs from Wikimedia Commons. Each one is recorded with its author, source page and licence in `brand/wallpapers/SOURCES.md`. The set currently holds public-domain works and CC0 images, none that need a credit under their licence. Keep it that way: add only images whose licence permits redistribution, and record the licence when you add the file.

:::caution
`debian/copyright` says the wallpapers were "generated with an image model from Nubo prompts; no third-party artwork". That does not match `SOURCES.md`, which describes downloaded photographs. One of the two needs correcting before release. <!-- verify: which statement is current -->
:::

## Using the Ubuntu name

Nubo OS is based on Ubuntu 26.04 LTS. "Ubuntu" is a trademark of Canonical Ltd. Follow these rules in code, packages and documentation:

- Say "based on Ubuntu 26.04 LTS" when naming the base system.
- Use the name only for the base system or Ubuntu's own things: the package archive, its keyring, Ubuntu's documentation.
- Do not use Ubuntu's logos or wordmarks. Nubo OS replaces them with the Nubo mark (see the logo files diverted in [Packaging notes](/developers/packaging-notes/)).
- Do not suggest that Canonical makes, supports or endorses Nubo OS.
- Technical identifiers that other software reads are allowed to stay. `/usr/lib/os-release` keeps `ID=ubuntu`, `VERSION_CODENAME=resolute` and `UBUNTU_CODENAME=resolute` on purpose: third-party installers (Docker, Node and others) check `ID`, and package sources are chosen from the codename. The boot loader keeps the name `ubuntu` on desktops because the signed loader looks under `EFI/ubuntu`. `data/os/README.md` records each case.
- Do not copy Ubuntu's documentation. Write your own text and link to Ubuntu's.

The file `tools/audit-ubuntu-traces.sh` lists where an installed system still shows or links to Ubuntu, and `docs/ubuntu-endpoints.md` lists the Ubuntu and Canonical addresses a machine still contacts.

## Verify

1. `LICENSE.brand` is present and unchanged: `cat LICENSE.brand`.
2. No new logo or brand file has been added without a licence line in `debian/copyright`.
3. On an installed system, run the audit and read the report:

   ```bash
   sudo bash tools/audit-ubuntu-traces.sh
   ```

   <!-- verify: the script is read-only per its header, but it is meant for the target system -->

## Troubleshooting

- **A contributor edited the logo.** Revert the change, or get written permission first.
- **A new dependency has a licence that does not fit.** Do not vendor it. Open the question with support@nubo.email before adding it to `vendor/fetch.sh`.
- **A page or screen says "Ubuntu" for no reason.** Replace it with the Nubo name unless it names the base system or a technical identifier above.

## See also

- [Packaging notes](/developers/packaging-notes/)
- [Customising the desktop](/developers/customising-the-desktop/)
