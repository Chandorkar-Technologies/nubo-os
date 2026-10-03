---
title: Screenshots and screen recording
description: Take a screenshot of the screen, a window or an area, and record the screen with the built-in tool.
sidebar:
  order: 140
---

**Applies to:** Desktop

Nubo OS uses the screenshot and screen recording tool that is part of GNOME. There is nothing extra to install. This page shows how to capture the screen, where the files go and what to do when a capture fails.

## Before you begin

Nothing is required. For recording you need some free disk space; recordings can grow quickly.

## Take a screenshot

1. Press <kbd>Print</kbd>. The screenshot tool opens, with a toolbar at the bottom of the screen. <!-- verify label -->
2. Choose whether to capture an area, the screen or a window.
3. Press the capture button (or <kbd>Enter</kbd>).

Quicker keys, which skip the toolbar:

| Keys | What it captures |
|---|---|
| <kbd>Print</kbd> | Opens the tool |
| <kbd>Shift</kbd>+<kbd>Print</kbd> | An area you select |
| <kbd>Alt</kbd>+<kbd>Print</kbd> | The current window |
| <kbd>Ctrl</kbd>+<kbd>Print</kbd> | Copies the capture to the clipboard instead of saving it (hold with the others) |

<!-- verify label: Ctrl modifier behavior is the GNOME default, not tested on the Nubo build -->

You can also use the **Screenshot** button, the first round button in the top row of [quick settings](/desktop/use/quick-settings/).

### Where the pictures go

By default GNOME saves screenshots in the `Screenshots` folder inside your `Pictures` folder, and shows a notification you can click to open the file. <!-- verify label: default folder is GNOME's, not set by Nubo -->

## Record the screen

1. Press <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>Alt</kbd>+<kbd>R</kbd>. A red dot appears in the top bar while recording.
2. Press the same keys again to stop.

Or open the screenshot tool with <kbd>Print</kbd> and switch from the camera to the video option, then choose the screen or an area and start.

Recordings are saved as video files in the `Screencasts` folder inside `Videos`. <!-- verify label: default folder is GNOME's, not set by Nubo -->

Screen recording shows what is on the screen. Sound from the computer or microphone might not be included by default; check the options in the tool. <!-- verify label: audio options -->

## Edit or share

- Open a screenshot in Image Viewer to look at it.
- Drag the file from Files into a chat or email, or attach it.
- To send it to a nearby device, use LocalSend in the Utilities folder of the [app grid](/desktop/use/dock-and-app-grid/), or [Phone link](/desktop/use/phone-link/).

## Verify

1. Press <kbd>Shift</kbd>+<kbd>Print</kbd> and drag over an area.
2. Open Files, go to Pictures, then Screenshots. The new file is there.
3. Start a recording, wait a few seconds, stop it. A file appears in Videos, in Screencasts.

## Troubleshooting

**The Print key does nothing.**
Cause: some laptops need the <kbd>Fn</kbd> key, or the shortcut was changed. Fix: check the shortcut in Settings on the keyboard page. See [Keyboard shortcuts](/desktop/use/keyboard-shortcuts/).

**The recording is empty or does not start.**
Cause: not enough disk space, or the video encoder is missing. Fix: free space; check that the desktop's GStreamer packages are installed (`gstreamer1.0-plugins-base-apps` is a dependency). <!-- verify label: encoder requirements -->

**The screenshot is black in some apps.**
Cause: protected content, such as some video players, is hidden by design. Fix: none; this is by design.

## See also

- [Keyboard shortcuts](/desktop/use/keyboard-shortcuts/)
- [Quick settings](/desktop/use/quick-settings/)
- [Files](/desktop/use/files/)
