---
title: Configuration keys
description: The desktop defaults Nubo OS sets, the extension keys, and the settings files in your home folder.
sidebar:
  order: 40
---

**Applies to:** Desktop

Nubo OS sets its desktop defaults in one file, `/usr/share/glib-2.0/schemas/90_nubo.gschema.override`. It changes the default value of existing GNOME settings. It does not lock them: you can change any of them in Settings or with `gsettings`.

Ubuntu sets its own defaults for the `ubuntu` session, and those win over plain ones. For that reason the Nubo file gives most sections twice: once plain and once with `:ubuntu` added to the section name. The tables below show each section once. Where the two copies differ, it is noted.

## Read and change a key

```bash
gsettings get org.gnome.desktop.interface color-scheme
gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
gsettings reset org.gnome.desktop.interface color-scheme
```

`reset` returns the key to the Nubo default. For extension keys, name the extension's schema, for example `org.gnome.shell.extensions.glass-widgets`. Your own change is stored in your user settings and wins over the system default. <!-- verify: gsettings get/set works for extension schemas shipped by nubo-glass -->

## Interface

| Schema and key | Default |
|---|---|
| `org.gnome.desktop.interface` `gtk-theme` | `'Nubo-Grey-Dark'` |
| `org.gnome.desktop.interface` `icon-theme` | `'Nubo-Dark'` |
| `org.gnome.desktop.interface` `cursor-theme` | `'Bibata-Modern-Classic'` |
| `org.gnome.desktop.interface` `color-scheme` | `'prefer-dark'` |
| `org.gnome.desktop.interface` `accent-color` | `'slate'` |
| `org.gnome.desktop.interface` `font-name` | `'Inter 11'` |
| `org.gnome.desktop.interface` `document-font-name` | `'Inter 12'` |
| `org.gnome.desktop.interface` `monospace-font-name` | `'JetBrains Mono 11'` |
| `org.gnome.desktop.wm.preferences` `titlebar-font` | `'Inter Bold 11'` |
| `org.gnome.desktop.sound` `theme-name` | `'Nubo'` |
| `org.gnome.shell.extensions.user-theme` `name` | `'Nubo-Grey-Dark'` |
| `org.gnome.login-screen` `logo` | `'/usr/share/nubo/logo/nubo-mark-white-small.svg'` |

The dark default is for the whole system. When `color-scheme` changes, the session helper switches the GTK 3, icon and shell themes between the dark and light Nubo variants. It does this only while a Nubo theme is selected. See [Commands](/reference/commands/#nubo-session-helper).

## Wallpaper and screen saver

| Schema and key | Default |
|---|---|
| `org.gnome.desktop.background` `picture-uri` | `file:///usr/share/backgrounds/nubo/05-pastel-dunes.jpg` |
| `org.gnome.desktop.background` `picture-uri-dark` | `file:///usr/share/backgrounds/nubo/02-misty-bay-layers.jpg` |
| `org.gnome.desktop.background` `picture-options` | `'zoom'` |
| `org.gnome.desktop.background` `primary-color` | `'#060606'` |
| `org.gnome.desktop.screensaver` `picture-uri` | `file:///usr/share/backgrounds/nubo/06-golden-dunes.jpg` |
| `org.gnome.desktop.screensaver` `primary-color` | `'#060606'` |

## Shell: extensions and dock

| Schema and key | Default |
|---|---|
| `org.gnome.shell` `enabled-extensions` | `user-theme@gnome-shell-extensions.gcampax.github.com`, `blur-my-shell@aunetx`, `app-grid-tuner@m-lab`, `glass-widgets@peter-njoro.github.io`, `gsconnect@andyholmes.github.io`, `nubo-notify-center@nubosuite.tech`, `nubo-menu@nubosuite.tech` |
| `org.gnome.shell` `favorite-apps` (plain section) | `org.mozilla.firefox.desktop`, `org.gnome.Geary.desktop`, `org.gnome.Nautilus.desktop`, `org.gnome.Calendar.desktop`, `io.github.mrvladus.List.desktop`, `org.gnome.Software.desktop`, `org.gnome.Settings.desktop` |
| `org.gnome.shell:ubuntu` `favorite-apps` | Same list, with `firefox.desktop` as the first entry |
| `org.gnome.shell.extensions.dash-to-dock` `dock-position` | `'BOTTOM'` |
| `org.gnome.shell.extensions.dash-to-dock` `extend-height` | `false` |
| `org.gnome.shell.extensions.dash-to-dock` `dock-fixed` | `true` |
| `org.gnome.shell.extensions.dash-to-dock` `dash-max-icon-size` | `44` |
| `org.gnome.shell.extensions.dash-to-dock` `show-apps-at-top` | `true` |
| `org.gnome.shell.extensions.dash-to-dock` `show-apps-always-in-the-edge` | `true` |
| `org.gnome.shell.extensions.dash-to-dock` `show-mounts` | `false` |
| `org.gnome.shell.extensions.dash-to-dock` `show-trash` | `true` |
| `org.gnome.shell.extensions.dash-to-dock` `custom-theme-shrink` | `true` |
| `org.gnome.shell.extensions.dash-to-dock` `transparency-mode` | `'FIXED'` |
| `org.gnome.shell.extensions.dash-to-dock` `background-opacity` | `0.35` |

The `enabled-extensions` default is replaced by your own list as soon as you turn any extension on or off. The session helper therefore adds Nubo's extensions to your own list once each.

## Desktop icons

| Schema and key | Default |
|---|---|
| `org.gnome.shell.extensions.ding` `show-home` | `false` |
| `org.gnome.shell.extensions.ding` `show-trash` | `false` |
| `org.gnome.shell.extensions.ding` `show-volumes` | `false` |

## Glass (blur)

Schema `org.gnome.shell.extensions.blur-my-shell` and its children.

| Schema and key | Default |
|---|---|
| `org.gnome.shell.extensions.blur-my-shell` `pipelines` | Two pipelines, `pipeline_default` ("Nubo glass") and `pipeline_default_rounded` ("Nubo glass, rounded"). Each is a Gaussian blur with radius 36 and brightness 0.82, a white tint of alpha 0.07, and noise 0.05 at lightness 1.0. The rounded one adds a corner radius of 24 |
| `...blur-my-shell.panel` `static-blur` | `true` |
| `...blur-my-shell.panel` `unblur-in-overview` | `true` |
| `...blur-my-shell.dash-to-dock` `corner-radius` | `24` |
| `...blur-my-shell.popup` `blur` | `true` |
| `...blur-my-shell.popup` `corner-radius` | `16` |
| `...blur-my-shell.popup` `menu-corner-radius` | `16` |
| `...blur-my-shell.popup` `quick-settings-corner-radius` | `24` |
| `...blur-my-shell.popup` `notification-corner-radius` | `24` |
| `...blur-my-shell.popup` `osd-corner-radius` | `24` |
| `...blur-my-shell.popup` `dialog-corner-radius` | `24` |

## App grid

| Schema and key | Default |
|---|---|
| `org.gnome.shell.extensions.app-grid-tuner` `appgrid-max-rows` | `4` |
| `org.gnome.shell.extensions.app-grid-tuner` `appgrid-max-columns` | `7` |

Grid folders (contents are desktop file ids) are set in `/etc/dconf/db/nubo.d/nubo-app-folders` instead (a separate dconf database added by the Nubo profile):

| Folder | Name shown | Contents |
|---|---|---|
| `NuboUtilities` | Utilities | `gnome-language-selector`, `net.nokyan.Resources`, `org.gnome.Characters`, `org.gnome.baobab`, `org.gnome.DiskUtility`, `org.gnome.Logs`, `org.gnome.font-viewer`, `org.gnome.FileRoller`, `org.gnome.DejaDup`, `org.gnome.seahorse.Application`, `org.gnome.Ptyxis`, `org.localsend.localsend_app` |
| `NuboAccessories` | Accessories | `simple-scan`, `org.gnome.Calculator`, `org.gnome.SoundRecorder`, `org.gnome.clocks`, `org.gnome.TextEditor` |
| `NuboMore` | More apps | Every app with the category `X-Nubo-Placeholder` (the grey placeholders for apps not yet installed) |

## Desktop widgets

Schema `org.gnome.shell.extensions.glass-widgets`.

| Key | Default | Meaning |
|---|---|---|
| `show-clock` | `true` | Show the clock card |
| `show-weather` | `true` | Show weather in the clock card |
| `show-stats` | `true` | Show the System card (memory and processor) |
| `show-calendar` | `true` | Show the calendar card. This key is added by Nubo's build |
| `weather-auto-location` | `true` | Find the location automatically |
| `weather-temperature-unit` | `0` | Temperature unit. The meaning of the numbers is defined by the extension; the value `0` is what Nubo sets <!-- verify: which unit 0 is --> |
| `blur-enabled` | `true` | A setting of the extension; Nubo sets it to `true` |

Changing a `show-*` key rebuilds the cards at once.

### widgets.json

Each card remembers where you dragged it. The positions are saved in `~/.config/nubo/widgets.json`, a JSON object with one key per card:

```json title="~/.config/nubo/widgets.json"
{
  "clock": [0.5, 0.2],
  "stats": [0.84, 0.32],
  "calendar": [0.16, 0.34]
}
```

| Item | Meaning |
|---|---|
| Key | The card: `clock`, `stats` or `calendar` |
| Value | Two numbers, `[x, y]`: the centre of the card as a fraction of the main screen's width and height, from the top left. `[0.5, 0.2]` is the middle of the screen, a fifth of the way down |
| Missing key or file | The card uses the default position, which is the values in the example |

The file is written when you finish dragging a card. Delete it to put all cards back in their default places. Positions are relative to the main monitor, so they follow a change of resolution.

## Files, terminal and keyboard

| Schema and key | Default |
|---|---|
| `org.gnome.Ptyxis.Profile` `palette` | `'gnome'` |
| `org.gnome.nautilus.preferences` `default-folder-viewer` | `'icon-view'` |
| `org.gnome.nautilus.preferences` `default-sort-order` | `'name'` |
| `org.gnome.nautilus.preferences` `default-sort-in-reverse-order` | `false` |
| `org.gnome.desktop.wm.keybindings` `switch-input-source` | `['<Alt>Shift_L', 'XF86Keyboard']` |
| `org.gnome.desktop.wm.keybindings` `switch-input-source-backward` | `['<Shift><Alt>Shift_L']` |

The keyboard-layout shortcut moves to <kbd>Alt</kbd>+<kbd>Shift</kbd> so that <kbd>Super</kbd>+<kbd>Space</kbd> can open Nubo Search.

### The Nubo Search shortcut

The session helper creates a custom keyboard shortcut at login, but only if you have no custom shortcuts yet:

| Key | Value |
|---|---|
| `name` | `Nubo Search` |
| `command` | `/usr/bin/nubo-search toggle` |
| `binding` | `<Super>space` |

It lives in the schema `org.gnome.settings-daemon.plugins.media-keys` under the path `/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/nubo-search/`.

## Launcher settings

The file `/usr/share/nubo/search/nubo.json` sets defaults for the launcher, and every user's launcher settings import it.

| Key | Default |
|---|---|
| `telemetry.system_info` | `false` |
| `tray.enabled` | `false` |
| `theme.light.name` | `libadwaita-light` |
| `theme.light.icon_theme` | `auto` |
| `theme.dark.name` | `libadwaita-dark` |
| `theme.dark.icon_theme` | `auto` |

## Notification agent

`~/.config/nubo/notify.json` is written by `nubo-notify-agent disable ID` and `enable ID`:

```json title="~/.config/nubo/notify.json"
{
  "disabled": ["com.slack.Slack"]
}
```

`disabled` is a list of app ids the agent must not start. The apps the agent knows about are in `/usr/share/nubo/notify/background-apps.json`: Mail (Geary), Telegram, Slack, Discord and Signal.

## See also

- [Files and paths](/reference/files-and-paths/)
- [Commands](/reference/commands/)
- [Desktop](/desktop/)
