---
title: Keyboard shortcuts
description: A table of the keyboard shortcuts on Nubo OS, with the ones Nubo changed marked.
sidebar:
  order: 50
---

**Applies to:** Desktop

This is a reference. It lists the shortcuts you can expect on the Nubo OS desktop. Two are set by Nubo; the rest are stock GNOME 50 defaults on Ubuntu 26.04 LTS, and Nubo does not override them.

## How this table was made

Nubo's shortcut overrides are in the file `data/gschema/90_nubo.gschema.override` and in the login script `nubo-session-helper`. Those two sources define everything marked "Nubo". The rows marked "GNOME" are standard GNOME defaults that Nubo leaves alone. They have not all been re-tested on the Nubo build, so a few are marked as unconfirmed. Ubuntu's own session can add or change some defaults; those are marked "Ubuntu session, unconfirmed".

You can see and change every shortcut in Settings, on the keyboard page. <!-- verify label -->

## Shortcuts set by Nubo

| Shortcut | Action | Notes |
|---|---|---|
| <kbd>Super</kbd>+<kbd>Space</kbd> | Open or close [Nubo Search](/desktop/use/nubo-search/) | Runs `/usr/bin/nubo-search toggle`. Added at login as a custom shortcut named "Nubo Search", only if you have no custom shortcuts of your own yet |
| <kbd>Alt</kbd>+<kbd>Shift</kbd> | Switch to the next keyboard layout | Replaces GNOME's <kbd>Super</kbd>+<kbd>Space</kbd>. The <kbd>XF86Keyboard</kbd> key does the same |
| <kbd>Shift</kbd>+<kbd>Alt</kbd>+<kbd>Shift</kbd> (the left Shift key) | Switch to the previous keyboard layout | Set to follow the forward shortcut |

If you already had custom shortcuts before Nubo's login script ran, it leaves your list alone and does not add <kbd>Super</kbd>+<kbd>Space</kbd>. See [Keyboard and input](/desktop/settings/keyboard-and-input/) to add it yourself.

## System and overview

| Shortcut | Action | Source |
|---|---|---|
| <kbd>Super</kbd> | Open or close the overview | GNOME |
| <kbd>Super</kbd>+<kbd>A</kbd> | Show the app grid | GNOME, unconfirmed on this build |
| <kbd>Alt</kbd>+<kbd>F2</kbd> | Run a command | GNOME |
| <kbd>Super</kbd>+<kbd>L</kbd> | Lock the screen | GNOME |
| <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>Delete</kbd> | Show the power off or log out dialog | GNOME |
| <kbd>Super</kbd>+<kbd>V</kbd> | Open the GNOME calendar and notification panel | GNOME, unconfirmed on this build |
| <kbd>Super</kbd>+<kbd>S</kbd> | Open [quick settings](/desktop/use/quick-settings/) | GNOME, unconfirmed on this build |
| <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>T</kbd> | Open a terminal | Ubuntu session, unconfirmed |
| <kbd>Super</kbd>+<kbd>1</kbd> to <kbd>9</kbd> | Start or switch to the dock's first nine apps | Ubuntu session (dock), unconfirmed |

## Windows

| Shortcut | Action | Source |
|---|---|---|
| <kbd>Alt</kbd>+<kbd>Tab</kbd> | Switch between applications | GNOME |
| <kbd>Alt</kbd>+<kbd>Esc</kbd> | Switch between windows directly | GNOME |
| <kbd>Super</kbd>+<kbd>Tab</kbd> | Switch between applications | Ubuntu session, unconfirmed |
| <kbd>Alt</kbd>+<kbd>`</kbd> | Switch between windows of the same app | GNOME |
| <kbd>Alt</kbd>+<kbd>F4</kbd> | Close the window | GNOME |
| <kbd>Alt</kbd>+<kbd>F7</kbd> | Move the window with the keyboard | GNOME |
| <kbd>Alt</kbd>+<kbd>F8</kbd> | Resize the window with the keyboard | GNOME |
| <kbd>Super</kbd>+<kbd>Up</kbd> | Maximize | GNOME |
| <kbd>Super</kbd>+<kbd>Down</kbd> | Restore, or minimize a restored window | GNOME |
| <kbd>Super</kbd>+<kbd>Left</kbd> | Tile on the left half | GNOME |
| <kbd>Super</kbd>+<kbd>Right</kbd> | Tile on the right half | GNOME |
| <kbd>Super</kbd>+<kbd>H</kbd> | Hide (minimize) the window | GNOME, unconfirmed on this build |
| <kbd>F11</kbd> | Full screen, in apps that support it | App |

## Workspaces

| Shortcut | Action | Source |
|---|---|---|
| <kbd>Super</kbd>+<kbd>Page Down</kbd> | Go to the next workspace | GNOME |
| <kbd>Super</kbd>+<kbd>Page Up</kbd> | Go to the previous workspace | GNOME |
| <kbd>Shift</kbd>+<kbd>Super</kbd>+<kbd>Page Down</kbd> | Move the window to the next workspace | GNOME |
| <kbd>Shift</kbd>+<kbd>Super</kbd>+<kbd>Page Up</kbd> | Move the window to the previous workspace | GNOME |

## Screenshots and recording

| Shortcut | Action | Source |
|---|---|---|
| <kbd>Print</kbd> | Open the screenshot tool | GNOME |
| <kbd>Alt</kbd>+<kbd>Print</kbd> | Screenshot of the current window | GNOME |
| <kbd>Shift</kbd>+<kbd>Print</kbd> | Screenshot of an area you pick | GNOME |
| <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>Alt</kbd>+<kbd>R</kbd> | Start or stop a screen recording | GNOME |

See [Screenshots and screen recording](/desktop/use/screenshots-and-screen-recording/).

## Typing and accessibility

| Shortcut | Action | Source |
|---|---|---|
| <kbd>Super</kbd>+<kbd>Alt</kbd>+<kbd>S</kbd> | Turn the screen reader (Orca) on or off | GNOME, unconfirmed on this build |
| <kbd>Ctrl</kbd>+<kbd>C</kbd>, <kbd>Ctrl</kbd>+<kbd>V</kbd>, <kbd>Ctrl</kbd>+<kbd>X</kbd> | Copy, paste, cut | Apps |
| <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>C</kbd>, <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>V</kbd> | Copy and paste in the Terminal | Terminal app |

## Not set on Nubo OS

- There is no Nubo-specific shortcut to open the Nubo logo menu, because the logo has no menu; it opens the overview.
- There is no Nubo shortcut for the notification history panel. Open it with the mouse or add your own keyboard shortcut in Settings.
- Nubo Search has its own shortcuts inside its window; those belong to the search tool, not to Nubo OS. <!-- verify label: Vicinae in-window keys not documented in the repo -->

## Changing a shortcut

1. Open Settings.
2. Go to the keyboard page and open the shortcuts view. <!-- verify label -->
3. Click the shortcut you want to change.
4. Press the new key combination. Press <kbd>Backspace</kbd> to clear it, or <kbd>Esc</kbd> to cancel.

## See also

- [Keyboard and input](/desktop/settings/keyboard-and-input/)
- [Windows and workspaces](/desktop/use/windows-and-workspaces/)
- [Nubo Search](/desktop/use/nubo-search/)
