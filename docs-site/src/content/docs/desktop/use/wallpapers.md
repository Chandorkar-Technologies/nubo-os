---
title: Wallpapers
description: The eight wallpapers that come with Nubo OS, who took them, and how to set one or add your own.
sidebar:
  order: 110
---

**Applies to:** Desktop

Nubo OS includes eight photographs as wallpapers. All of them are public domain or CC0, so you can use and share them freely. This page lists them with credits and shows how to choose one or use your own picture.

## The eight wallpapers

They are stored in `/usr/share/backgrounds/nubo/` as 16:9 JPEG files, 3840 pixels wide. They are listed in the wallpaper picker under the names in the first column.

| Name in the picker | File | Credit | Licence |
|---|---|---|---|
| Blue Ridge Dusk | `01-blue-ridge-dusk.jpg` | NPS (Shenandoah National Park), via NPGallery. "Sunset - Moormans River Overlook" | Public domain, US federal government work |
| Misty Bay | `02-misty-bay-layers.jpg` | Staff Sgt. Jeffrey Anderson, U.S. Marine Corps (DVIDS 1678147). "Misty bay, early morning" (Cancabato Bay, Philippines) | Public domain, US federal government work |
| Himalaya Sunrise | `04-himalaya-sunrise-haze.jpg` | Ali Sabbagh. "Himalaya sunrise" (Poon Hill, Nepal) | CC0 1.0 |
| Pastel Dunes | `05-pastel-dunes.jpg` | Bureau of Land Management Utah / Bob Wick. "Utah dunes, Little Sahara" | Public domain, US federal government work |
| Golden Dunes | `06-golden-dunes.jpg` | Mustang Joe. "The Merzouga dunes of Morocco" | CC0 1.0 |
| Twilight Sea | `07-twilight-sea.jpg` | W.carter. "Sunset over Stangehuvud, Lysekil, Sweden" | CC0 1.0 |
| Sunrise Surf | `10-sunrise-surf.jpg` | Greg Zaal (Poly Haven). "Umhlanga Sunrise" | CC0 1.0 |
| Milky Way | `12-milky-way-pacific.jpg` | Paul Stewart (astrostew). "Milky Way over the Pacific Ocean" | CC0 1.0 |

The images came from Wikimedia Commons originals. None of these licences needs a credit, and the credits are given here as a courtesy. The full source list with links, written for the Nubo team, is in the Nubo OS repository at `brand/wallpapers/SOURCES.md`. The files have no metadata and were not enlarged. Nubo changed some: Misty Bay was converted to the sRGB color space, Sunrise Surf was cropped from 3:2 to 16:9, and Milky Way was cropped slightly in width.

## Which one is the default

| Where | Wallpaper |
|---|---|
| Desktop, light appearance | Pastel Dunes |
| Desktop, dark appearance | Misty Bay |
| Lock screen background | Golden Dunes |
| Login screen | Golden Dunes (built into the login theme) |

Because Nubo is dark by default, you will see Misty Bay on a new machine, as in the screenshots in these docs. The picture is set for each mode separately, so the wallpaper changes when you switch [light and dark](/desktop/use/light-and-dark/).

## Before you begin

For your own picture, have an image file in your home folder. JPEG and PNG work. A picture at least as large as your screen looks best; the desktop zooms to fill the screen.

## Choose a wallpaper

1. Open Settings.
2. Go to the appearance page. <!-- verify label -->
3. Pick one of the pictures shown, or use the option to add a photo of your own. <!-- verify label -->
4. The wallpaper changes at once.

You can also right-click an image file in Files and choose the option to set it as the wallpaper. <!-- verify label -->

## Add your own wallpaper

1. Put your image in a folder such as `~/Pictures`.
2. In Settings, on the appearance page, choose to add a picture and select your file. <!-- verify label -->
3. Or set it from a terminal. GNOME has one wallpaper setting for light mode and one for dark mode:

```bash
gsettings set org.gnome.desktop.background picture-uri 'file:///home/you/Pictures/mine.jpg'
gsettings set org.gnome.desktop.background picture-uri-dark 'file:///home/you/Pictures/mine.jpg'
```

Replace `you` with your user name. Use the same file for both settings if you want one picture in both modes. The default fit is `zoom`, set by Nubo with `picture-options`. You can change that, for example to `centered` or `spanned`.

To change the lock screen picture:

```bash
gsettings set org.gnome.desktop.screensaver picture-uri 'file:///home/you/Pictures/lock.jpg'
```

<!-- verify label: whether GNOME 50 still shows a separate lock screen picture in Settings -->

Do not put your pictures into `/usr/share/backgrounds/nubo/`. Package updates manage that folder.

## Verify

1. Run `gsettings get org.gnome.desktop.background picture-uri-dark`. It prints the path of the picture you set.
2. Switch light and dark in [quick settings](/desktop/use/quick-settings/) to see the other picture.

## Troubleshooting

**The desktop turns black.**
Cause: the path is wrong or the file cannot be read. Fix: check that the file exists, and that the path starts with `file://` and has three slashes after `file:`.

**The picture looks stretched.**
Cause: its shape is different from your screen. Fix: set `picture-options` to `zoom` or `scaled`.

**The wallpaper only changes in one mode.**
Cause: you set only one of the two keys. Fix: set both.

## See also

- [Light and dark appearance](/desktop/use/light-and-dark/)
- [Desktop widgets](/desktop/use/widgets/)
- [Multiple displays](/desktop/use/multiple-displays/)
