---
title: Keyboard and input
description: Add keyboard layouts, switch between them with Alt+Shift, and set your own shortcuts, including Nubo Search.
sidebar:
  order: 50
---

**Applies to:** Desktop

This page covers keyboard layouts, how to switch between them on Nubo OS, and how to create custom shortcuts. Nubo changes one thing from stock GNOME: layout switching moves from <kbd>Super</kbd>+<kbd>Space</kbd> to <kbd>Alt</kbd>+<kbd>Shift</kbd>, so that <kbd>Super</kbd>+<kbd>Space</kbd> can open [Nubo Search](/desktop/use/nubo-search/).

## Before you begin

- Know the name of the layout you want, such as a language and variant.
- For languages that need an input method (Chinese, Japanese, Korean, Indic scripts and others), the desktop recommends IBus and its helper packages. <!-- verify label: availability of each input method engine -->

## Add a keyboard layout

1. Open [Settings](/desktop/settings/) and go to the keyboard page. <!-- verify label -->
2. Under input sources, click the add button.
3. Choose a language, then a layout.
4. Click **Add**. The layout is now in the list. Drag layouts to set their order.

When you have more than one layout, an indicator appears in the top bar that shows the current one. Click it to choose a layout with the mouse.

## Switch layouts with the keyboard

Nubo sets these shortcuts:

| Shortcut | Action |
|---|---|
| <kbd>Alt</kbd>+<kbd>Shift</kbd> | Next layout |
| The <kbd>XF86Keyboard</kbd> key (some keyboards have it) | Next layout |
| <kbd>Shift</kbd>+<kbd>Alt</kbd>+<kbd>Shift</kbd> (left) | Previous layout |

These are set in the desktop's settings overrides under `org.gnome.desktop.wm.keybindings` (`switch-input-source` and `switch-input-source-backward`). To see them:

```bash
gsettings get org.gnome.desktop.wm.keybindings switch-input-source
```

To go back to GNOME's own <kbd>Super</kbd>+<kbd>Space</kbd>, run:

```bash
gsettings set org.gnome.desktop.wm.keybindings switch-input-source "['<Super>space']"
```

If you do that, Nubo Search will need another shortcut (see below), because both cannot use the same keys.

## Custom shortcuts

Custom shortcuts run a command when you press keys.

1. In Settings, open the keyboard page and its shortcuts view. <!-- verify label -->
2. Scroll to the custom shortcuts and add one.
3. Give it a name, a command and press the keys.

### Nubo Search shortcut

Nubo's login script adds a custom shortcut named **Nubo Search**, with the command `/usr/bin/nubo-search toggle` and the keys <kbd>Super</kbd>+<kbd>Space</kbd>. It does so only if you have no custom shortcuts yet. If you already had some, it does not touch your list, so add this one yourself with the same name, command and keys.

## Compose key and typing options

The keyboard page may offer options such as a Compose key, a key to switch layouts or a different Caps Lock behavior. Which options exist depends on your version of GNOME. <!-- verify label --> For repeat keys, sticky keys and slow keys, see [Accessibility](/desktop/settings/accessibility/).

## Emoji and special characters

Use the Characters app, in the Utilities folder of the app grid, to find and copy symbols. In many apps, <kbd>Ctrl</kbd>+<kbd>.</kbd> or <kbd>Ctrl</kbd>+<kbd>;</kbd> opens an emoji picker. <!-- verify label: depends on IBus -->

## Verify

1. Add a second layout. The indicator appears in the top bar.
2. Press <kbd>Alt</kbd>+<kbd>Shift</kbd>. The indicator changes to the other layout, and typing changes with it.
3. Press <kbd>Super</kbd>+<kbd>Space</kbd>. Nubo Search opens.

## Troubleshooting

**<kbd>Alt</kbd>+<kbd>Shift</kbd> does nothing.**
Cause: you have only one layout, or an app captures the keys. Fix: add a layout. Test in another app.

**<kbd>Super</kbd>+<kbd>Space</kbd> switches layouts instead of opening Nubo Search.**
Cause: your own settings override Nubo's, or the Nubo shortcut was not added. Fix: set `switch-input-source` as in Nubo's default shown above, and add the Nubo Search shortcut yourself.

**A layout switches on its own in one app.**
Cause: some apps keep a layout per window. Fix: check the layout setting for "per window" behaviour in Settings. <!-- verify label -->

**Characters for my language do not appear.**
Cause: no input method installed. Fix: install the packages for the language with the Languages app. See [Language and region](/desktop/settings/language-and-region/).

## See also

- [Keyboard shortcuts](/desktop/use/keyboard-shortcuts/)
- [Nubo Search](/desktop/use/nubo-search/)
- [Language and region](/desktop/settings/language-and-region/)
- [Accessibility](/desktop/settings/accessibility/)
