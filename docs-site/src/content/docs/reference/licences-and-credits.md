---
title: Licences and credits
description: The licences of Nubo OS, the rules for the Nubo name and logo, and the components Nubo OS builds on.
sidebar:
  order: 90
---

Nubo OS is free software built on the work of many people. This page names the licences and credits the main components. It does not replace the licence files that ship with each package. On an installed system, each package's licence is in `/usr/share/doc/<package>/copyright`.

## Nubo OS itself

- The source code of Nubo OS is licensed under the **GNU General Public License, version 3 or later** (GPL-3.0-or-later). The full text is in the file `LICENSE` in the repository at https://github.com/Chandorkar-Technologies/nubo-os.
- The packaging metadata names the copyright holder as Chandorkar Technologies, 2026.
- You may use, study, change and share the code under the terms of that licence.

## The Nubo name and logo

The Nubo name, the Nubo mark and the Nubo OS name are trademarks of Chandorkar Technologies. They are covered by a separate file, `LICENSE.brand`, which says:

- You may redistribute the brand files unmodified as part of Nubo OS.
- You may not use them to name or brand another product, service or distribution, and you may not modify them, without written permission from Chandorkar Technologies.
- Everything else in the repository is under the GPL.

The brand files are the logo files in `brand/logo/` and the sources in `brand/src/`. If you want to build a derived system from the source code, replace the name and logo first.

## Ubuntu

Nubo OS 1 "Flow" is based on Ubuntu 26.04 LTS. Ubuntu is a trademark of Canonical Ltd. Ubuntu's packages keep their own licences and stay signed by Ubuntu. Nubo does not change them. See [Nubo Cumulus](/updates/nubo-cumulus/).

## Components fetched by the build

The Nubo package build fetches these upstream sources, pinned to an exact version or commit and checked against a checksum where it is a download. The pins are in `vendor/fetch.sh`.

| Component | Used for | Version pinned | Licence stated in the repository | Author |
|---|---|---|---|---|
| Colloid GTK theme | Base of the Nubo application, shell and login theme | One commit (`fe11342f...`) | GPL-3.0 | vinceliuice and contributors |
| Blur my Shell | The glass effect, package `nubo-glass` | Release 73 | GPL-3.0 | aunetx and contributors |
| App Grid Tuner | App grid rows and columns | Release 9 | MIT | m-lab |
| Glass Widgets | Desktop clock, weather and system card. Nubo changes it (draggable cards, calendar) | Release 8 | GPL-3.0 or later | peter-njoro |
| Vicinae | The launcher behind Nubo Search | Release 0.29.1, as an AppImage for amd64 and arm64 | GPL-3.0 | The Vicinae project |

The Colloid theme and Blur my Shell are also named in the package's copyright file as GPL-3+.

The extensions and the launcher are shipped with their own libraries where needed. `nubo-search` carries the launcher's libraries inside the package.

## Components from the Ubuntu archive

These are ordinary dependencies. They update with Ubuntu and are not part of the Nubo source: the GNOME desktop, the Papirus icon theme (used by `nubo-icons`), the Ocean sound theme (used by `nubo-sounds`), the Inter and JetBrains Mono fonts, the Bibata cursor theme, GSConnect, scrcpy and the default apps. Check each package's copyright file for its licence.

## Third-party software installed at first boot

Apps that come from Flathub (Firefox, LocalSend, Newelle, Collabora Office, Shortwave, Spotify, VLC and any you add) are not part of Nubo OS and are covered by their own licences and terms. Proprietary apps such as Spotify are not bundled in the image: they are downloaded by your machine from Flathub. Firefox is installed from Mozilla's own package source.

## Wallpapers

The eight wallpapers in `/usr/share/backgrounds/nubo/` are photographs. The file `brand/wallpapers/SOURCES.md` records, for each one, its source page, author and licence. All are public domain works of the US government or are released under CC0 1.0 (public domain dedication), so no credit is required. Credit is recorded here anyway.

| File | Title | Credit | Licence |
|---|---|---|---|
| `01-blue-ridge-dusk.jpg` | Sunset, Moormans River Overlook (Shenandoah National Park) | US National Park Service | Public domain (US government work) |
| `02-misty-bay-layers.jpg` | Misty bay, early morning (Cancabato Bay, Philippines) | Staff Sgt. Jeffrey Anderson, US Marine Corps | Public domain (US government work) |
| `04-himalaya-sunrise-haze.jpg` | Himalaya sunrise (Poon Hill, Nepal) | Ali Sabbagh | CC0 1.0 |
| `05-pastel-dunes.jpg` | Utah dunes, Little Sahara | Bureau of Land Management Utah / Bob Wick | Public domain (US government work) |
| `06-golden-dunes.jpg` | The Merzouga dunes of Morocco | Mustang Joe | CC0 1.0 |
| `07-twilight-sea.jpg` | Sunset over Stangehuvud, Lysekil, Sweden | W.carter | CC0 1.0 |
| `10-sunrise-surf.jpg` | Umhlanga Sunrise (Poly Haven) | Greg Zaal (Poly Haven) | CC0 1.0 |
| `12-milky-way-pacific.jpg` | Milky Way over the Pacific Ocean | Paul Stewart (astrostew) | CC0 1.0 |

## Reporting a licence problem

If you think a file is used in a way its licence does not allow, write to support@nubo.email.

## See also

- [Packages](/reference/packages/)
- [Known issues](/reference/known-issues/)
- [Files and paths](/reference/files-and-paths/)
