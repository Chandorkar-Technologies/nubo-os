---
title: Windows and workspaces
description: Move, resize, tile and switch windows, and use workspaces to keep tasks apart.
sidebar:
  order: 40
---

**Applies to:** Desktop

Windows and workspaces on Nubo OS are the GNOME ones. Nubo changes how they look (theme, rounded corners, frosted bars) but not how they behave. This page is a short working guide; GNOME's own help and [Ubuntu's desktop documentation](https://ubuntu.com/desktop/docs) go deeper.

## Before you begin

You need nothing special. The shortcuts below are stock GNOME defaults. A full list is in [Keyboard shortcuts](/desktop/use/keyboard-shortcuts/).

## Windows

### Move, resize, close

1. Drag a window by its title bar to move it.
2. Drag an edge or corner to resize.
3. Use the close button in the title bar, or press <kbd>Alt</kbd>+<kbd>F4</kbd>.
4. Double-click the title bar to maximize it, and again to restore.

The title bar font is Inter Bold. By default, windows have a close button; whether minimize and maximize buttons are shown depends on the app. <!-- verify label: Nubo does not override the titlebar button layout in gsettings -->

### Tile windows side by side

Drag a window to the left or right edge of the screen until an outline appears, then let go. The window fills half the screen. Drag to the top edge to maximize. With the keyboard use <kbd>Super</kbd>+<kbd>Left</kbd>, <kbd>Super</kbd>+<kbd>Right</kbd> and <kbd>Super</kbd>+<kbd>Up</kbd>; <kbd>Super</kbd>+<kbd>Down</kbd> restores.

### Switch between windows

- <kbd>Alt</kbd>+<kbd>Tab</kbd> cycles through the open windows or applications. Hold <kbd>Alt</kbd> and press <kbd>Tab</kbd> again to go further.
- <kbd>Alt</kbd>+<kbd>Esc</kbd> cycles windows directly.
- Open the overview (<kbd>Super</kbd>) and click a thumbnail.

## Workspaces

A workspace is a separate desktop with its own set of windows. They let you keep work and personal tasks apart or keep a video call out of the way.

Nubo OS uses GNOME's dynamic workspaces: there is always one empty workspace at the end, and an empty workspace in the middle is removed when you close its last window. The top bar shows your workspaces as a small group of shapes next to the Nubo logo, and the overview shows them as thumbnails at the top.

![The overview with two workspaces shown as thumbnails above the app grid](../../../../assets/screens/grid1.jpg)

### Move around

1. Open the overview with <kbd>Super</kbd>.
2. Click a workspace thumbnail to go there.
3. Or press <kbd>Super</kbd>+<kbd>Page Down</kbd> or <kbd>Super</kbd>+<kbd>Page Up</kbd> to go to the next or previous workspace.

### Send a window to another workspace

1. Open the overview.
2. Drag a window thumbnail onto another workspace.
3. Or, with the window selected, press <kbd>Shift</kbd>+<kbd>Super</kbd>+<kbd>Page Down</kbd>.

## Verify

1. Open two apps, for example Files and Settings.
2. Press <kbd>Super</kbd>+<kbd>Left</kbd> on one and <kbd>Super</kbd>+<kbd>Right</kbd> on the other. They should each fill half of the screen.
3. Open the overview and drag Settings to the empty workspace at the end. A new empty workspace should appear after it.

## Troubleshooting

**The shortcut does nothing.**
Cause: another app captured the shortcut, or you changed shortcuts in Settings. Fix: open Settings, go to the keyboard shortcuts page and look for a conflict or reset the shortcut. <!-- verify label -->

**A window opens off screen after unplugging a monitor.**
Cause: the window remembered the other display. Fix: open the overview and click the window's thumbnail, then press <kbd>Super</kbd>+<kbd>Left</kbd> to pull it back onto the screen. See [Multiple displays](/desktop/use/multiple-displays/).

**Tiling snaps to the wrong half.**
Cause: the drag ended too far from the edge. Fix: drag until the outline appears.

## See also

- [Keyboard shortcuts](/desktop/use/keyboard-shortcuts/)
- [Multiple displays](/desktop/use/multiple-displays/)
- [The Nubo menu and top bar](/desktop/use/the-nubo-menu-and-top-bar/)
