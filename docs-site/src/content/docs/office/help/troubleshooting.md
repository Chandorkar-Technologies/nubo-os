---
title: "Troubleshooting"
description: "Fix problems with starting the apps, opening files, how documents look, spreadsheets, slides and servers."
sidebar:
  order: 10
---

## The app does not start

- **A download error appears on the first start.** The first start downloads the suite. Connect to the internet and open the app again.
- **Nothing happens when you click the launcher.** Run `nubo-office write` in a terminal and read what it prints. An error about Flatpak means Flatpak is missing, or the download service could not be reached.
- **The launcher is missing from the app grid.** Log out and in.
- **The window opens but stays blank.** Close it and open it again. If it keeps happening on a virtual machine, turn off 3D acceleration for the machine.

## A file will not open

- **Nothing opens, or the app closes.** Check that the file is not empty and ends in a known extension. See [Files and formats](/office/features/formats/).
- **The file opens without a ribbon.** It is in Viewing mode. Use the button at the top right and choose **Editing Mode**.
- **A password-protected file asks for a password.** Enter it. A file saved with a password cannot be opened without it.
- **A file from another program looks different.** See "A document looks wrong" below.

## A document looks wrong

- **Text sits differently from the original.** The font is probably not installed. Install it or choose another font.
- **A layout is slightly different.** Complex layouts can differ from the program that made the file. Tell us which program and what changed.
- **Macros do not run.** Macros written for other programs are not supported.
- **A table is wider than the page.** Check the margins in **Layout** and the width of the table.

## Writing and layout (Nubo Write)

- **A style does not change the text.** The cursor was not inside the paragraph. Click in the line and apply the style again.
- **The table of contents is empty.** No text uses a Heading style. Apply one and choose **Update All** in **References**.
- **Page numbers are wrong.** Choose **Update All** after the last edit.
- **Comments are hidden.** Choose **Show Comments** in **Review**.

## Spreadsheets (Nubo Cells)

- **A cell shows `###`.** The column is too narrow. Widen it, or press <kbd>Ctrl</kbd>+<kbd>3</kbd> for the best width.
- **A formula shows as text.** The cell is formatted as text. Change the format to General and enter the formula again.
- **`#NAME?`, `#VALUE!` or `#DIV/0!`.** See [Use formulas](/office/guides/cells-formulas/).
- **A chart covers the data.** Drag it to a free place.

## Slides (Nubo Present)

- **A placeholder does not show.** The slide's layout has none. Choose another layout in the sidebar.
- **Presenter View shows nothing.** It needs a second screen.

## Documents on a server

- **The server's sign-in page does not load.** Check the internet connection and the server address.
- **You cannot pick another provider.** Nubo Office opens documents only from Nubo servers. See [Accounts and files](/office/account/).

## Still stuck

Email support@nubo.email, or use **Help**, then **Report an issue** inside the app. Say which app, what you did and what happened. If the problem is in one file, say what kind of file it is.

## See also

- [Help inside the apps](/office/use/help-menu/)
