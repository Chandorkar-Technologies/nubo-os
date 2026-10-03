---
title: Light and dark appearance
description: How the Nubo glass theme switches between dark and light, and what the session helper does when you flip the switch.
sidebar:
  order: 100
---

**Applies to:** Desktop

Nubo OS is dark by default and supports a light appearance too. One switch changes the whole desktop: the top bar, menus, apps, icons and the Nubo Search window. This page explains how that works and what you can do when part of the desktop does not follow.

## How to switch

1. Open [quick settings](/desktop/use/quick-settings/) from the top right.
2. Click **Dark Style**. The tile is lit when dark is on.

You can also change it in Settings, on the appearance page. <!-- verify label -->

## What the defaults are

| Setting | Nubo value |
|---|---|
| Color scheme | `prefer-dark` |
| App theme (GTK) | `Nubo-Grey-Dark` |
| Icon theme | `Nubo-Dark` |
| Shell theme (top bar, menus) | `Nubo-Grey-Dark` |
| Accent color | `slate` |
| Cursor | `Bibata-Modern-Classic` |
| Interface font | Inter 11 |
| Document font | Inter 12 |
| Monospace font | JetBrains Mono 11 |

In light mode the app and shell theme become `Nubo-Grey-Light` and the icon theme becomes `Nubo`. The theme is Nubo's build of the Colloid GTK theme.

## Why a session helper is needed

GNOME's own switch, the `color-scheme` setting, is enough for modern apps that use libadwaita. Those switch by themselves. But three other things do not follow it:

1. Older GTK 3 apps, which use the GTK theme setting.
2. The icon theme.
3. The shell theme, which controls the top bar, popups and menus.

For these, Nubo OS runs a small helper at login, `nubo-session-helper`. It watches the color scheme and, when it changes, sets the GTK theme, icon theme and shell theme to match. It also points the GTK 4 config in your home folder at the system copy of the Nubo theme, so modern apps pick it up. It runs for as long as your session lasts.

The helper also does two other login jobs that are explained elsewhere: it adds Nubo's shell extensions to your list, once each, and sets the default [profile picture](/desktop/settings/users-and-profile-picture/) if you have none.

## When the helper leaves your theme alone

The helper only acts while a Nubo theme is your GTK theme (or the MacTahoe theme, which Nubo recognizes too). If you picked a different theme yourself, such as a high contrast one, the helper does nothing, and your choice stays.

To go back to Nubo's theme set the GTK theme to `Nubo-Grey-Dark`:

```bash
gsettings set org.gnome.desktop.interface gtk-theme 'Nubo-Grey-Dark'
```

The helper picks the right variant the next time you switch light and dark, or when you log in again.

## Verify

1. Click **Dark Style** in quick settings to switch to light.
2. Run `gsettings get org.gnome.desktop.interface gtk-theme`. It prints `'Nubo-Grey-Light'`.
3. Run `gsettings get org.gnome.desktop.interface icon-theme`. It prints `'Nubo'`.
4. Switch back to dark. The first command now prints `'Nubo-Grey-Dark'`, the second `'Nubo-Dark'`.

## Troubleshooting

**The top bar stays dark when the apps turn light (or the reverse).**
Cause: the shell theme did not follow. Fix: run `gsettings get org.gnome.shell.extensions.user-theme name`. It should match the app theme. The User Themes extension (`user-theme@gnome-shell-extensions.gcampax.github.com`) must be on. Log out and in.

**Nothing follows the switch.**
Cause: you set a theme that is not a Nubo or MacTahoe theme. Fix: set `Nubo-Grey-Dark` as shown above.

**The helper is not running.**
Cause: the session service did not start. Fix: run `pgrep -af nubo-session-helper`. If nothing shows, log out and in. The service is not started on the installation media.

**The wallpaper does not change with the switch.**
Cause: there are two settings for the wallpaper, one for each mode. See [Wallpapers](/desktop/use/wallpapers/).

## See also

- [Wallpapers](/desktop/use/wallpapers/)
- [Accessibility](/desktop/settings/accessibility/)
- [Nubo Search](/desktop/use/nubo-search/)
