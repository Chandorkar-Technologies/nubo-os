---
title: Reset desktop settings
description: Put the Nubo desktop settings back to their defaults, one area at a time or all at once.
sidebar:
  order: 80
---

**Applies to:** Desktop

Nubo OS sets its look and behaviour through GNOME's settings system. Nubo's defaults live in a system-wide file, `/usr/share/glib-2.0/schemas/90_nubo.gschema.override`. Your own changes are stored in your user's settings database and win over the defaults. To go back to Nubo's defaults, you remove your own changes. You do not edit the system file.

:::caution
`dconf reset` removes your own values. It cannot be undone, and it only affects your user. Write down any value you want to keep. Your files are not touched.
:::

## Before you begin

- Sign in to the desktop. Open a terminal with Nubo Search (<kbd>Super</kbd>+<kbd>Space</kbd>), then type Terminal.
- Decide what you want to reset. Start with the smallest area.

## Steps

### Reset one setting

```bash
gsettings reset org.gnome.desktop.interface color-scheme
```

This sets the scheme back to the Nubo default, which is dark.

### Reset the look

Theme, icons, cursor and fonts:

```bash
dconf reset -f /org/gnome/desktop/interface/
dconf reset -f /org/gnome/shell/extensions/user-theme/
```

The defaults are the Nubo-Grey-Dark theme, the Nubo-Dark icons, the Bibata-Modern-Classic cursor, and Inter and JetBrains Mono fonts.

### Reset the wallpaper

```bash
dconf reset -f /org/gnome/desktop/background/
dconf reset -f /org/gnome/desktop/screensaver/
```

### Reset the widgets

```bash
dconf reset -f /org/gnome/shell/extensions/glass-widgets/
rm -f ~/.config/nubo/widgets.json
```

### Reset the blur and dock

```bash
dconf reset -f /org/gnome/shell/extensions/blur-my-shell/
dconf reset -f /org/gnome/shell/extensions/dash-to-dock/
```

### Reset the shortcut for Nubo Search

Nubo moves layout switching to <kbd>Alt</kbd>+<kbd>Shift</kbd> so that <kbd>Super</kbd>+<kbd>Space</kbd> can open Nubo Search.

```bash
dconf reset -f /org/gnome/desktop/wm/keybindings/
```

The Nubo Search shortcut itself is a custom keybinding named "Nubo Search" that runs `/usr/bin/nubo-search toggle`. The session helper creates it at login, but only if you have no custom keybindings of your own. To have it created again:

```bash
dconf reset -f /org/gnome/settings-daemon/plugins/media-keys/
```

Sign out and in. If <kbd>Super</kbd>+<kbd>Space</kbd> still does nothing, start the launcher by hand to see if it works:

```bash
nubo-search toggle
```

### Reset the extensions

To go back to Nubo's list of extensions:

```bash
dconf reset /org/gnome/shell/enabled-extensions
dconf reset /org/gnome/shell/favorite-apps
rm -f ~/.local/state/nubo/seeded-extensions
```

The session helper adds each Nubo extension to your list once, and records it in the `seeded-extensions` file, so that an extension you turn off later stays off. Removing that file lets the helper add them again at the next login. Sign out and in. The extensions are `user-theme`, `blur-my-shell`, `app-grid-tuner`, `glass-widgets`, `gsconnect`, `nubo-notify-center` and `nubo-menu`.

### Reset everything for your user

This resets every GNOME setting you have changed, including those of apps:

```bash
dconf reset -f /
```

Sign out and in afterward.

### Reset Nubo Search

Nubo Search keeps its settings in `~/.config/vicinae/settings.json`. Remove that file and the launcher recreates it, pointing at the Nubo defaults, the next time it runs:

```bash
rm ~/.config/vicinae/settings.json
```

### Reset the notification agent

```bash
rm -f ~/.config/nubo/notify.json
systemctl --user restart nubo-notify-agent
```

## Verify

After you sign out and in:

1. The theme and wallpaper are Nubo's.
2. The widgets and the floating dock appear.
3. <kbd>Super</kbd>+<kbd>Space</kbd> opens Nubo Search.

Check any value with `gsettings get`, for example:

```bash
gsettings get org.gnome.desktop.interface gtk-theme
```

The answer is `'Nubo-Grey-Dark'`.

## Troubleshooting

- **The look is still wrong after a reset.** Another setting may override it. Check `gsettings get org.gnome.desktop.interface color-scheme` and the theme name.
- **The settings come back wrong after an update.** Nubo's defaults can change between releases. A reset takes the new defaults.
- **An extension still does not load.** See [Widgets not showing](/desktop/troubleshooting/widgets-not-showing/) or [Display flickers or resizes in a VM](/desktop/troubleshooting/display-flickers-or-resizes-in-a-vm/).
- **You reset too much.** The system defaults are still there, so the desktop is usable. Your own choices are gone, and you set them again in Settings.

## See also

- [Settings](/desktop/settings/)
- [Collect logs for support](/desktop/troubleshooting/collect-logs-for-support/)
