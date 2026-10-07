---
title: "Start an app"
description: "Open Nubo Write, Cells, Present or Draw from the app grid, from a file, or from a terminal."
sidebar:
  order: 20
---

**Applies to:** Desktop

## Before you begin

You need Nubo OS with the `nubo-office` package. It is part of the desktop. On the first start, the computer must be online, because the suite is downloaded then.

:::note[What is downloaded today]
Until the suite built under Nubo's own names is published, the launchers download **Collabora Office** from Flathub the first time you open one of them. After our Flatpak repository carries the Nubo build, the launchers switch to it. See [Installing on Linux](/office/install/linux/).
:::

## From the app grid

1. Open the app grid and find **Nubo Office**, **Nubo Write**, **Nubo Cells**, **Nubo Present** or **Nubo Draw**.
2. Open one. On the first start, a small window shows the download. Wait for it to finish.
3. The app opens. With **Nubo Office**, you get the start screen with templates.

## From a file

In Files, right-click a document and choose **Open With**. Word, Excel, PowerPoint and OpenDocument files list the matching Nubo app: documents open in Nubo Write, spreadsheets in Nubo Cells, presentations in Nubo Present.

## From a terminal

```bash
nubo-office write       # Nubo Write
nubo-office cells       # Nubo Cells
nubo-office present     # Nubo Present
nubo-office draw        # Nubo Draw
nubo-office office      # the start screen
nubo-office write ~/Documents/letter.docx
```

## Verify

The app window has the app's name in its title and its accent colour in the ribbon: blue for Write, green for Cells, orange for Present, violet for Draw.

## Troubleshooting

- **Nothing happens on the first click, or a download error appears.** The computer is offline or Flathub is unreachable. Connect and open the app again.
- **The window says "Collabora Office".** You are running the Flathub build, not the Nubo build. This is expected until the Nubo build is published.
- **"Open With" does not list the Nubo apps.** Log out and in so the desktop reads the new launchers.

## See also

- [The four apps](/office/use/the-four-apps/)
