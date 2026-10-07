---
title: "Troubleshooting"
description: "Fix problems with starting, opening files and how documents look."
sidebar:
  order: 10
---

## The app does not start

- **A download error appears on the first start.** The first start downloads the suite. Connect to the internet and open the app again.
- **Nothing happens when you click the launcher.** Run `nubo-office write` in a terminal and read what it prints. An error about Flatpak means Flatpak is missing or the download service was not reachable.
- **The launcher is missing from the app grid.** Log out and in.

## A file will not open

- **Nothing opens, or the app closes.** Check that the file is not empty and ends in a known extension. See [Files and formats](/office/features/formats/).
- **The file opens without a ribbon.** It is in Viewing mode. Use the mode button at the top right and choose **Editing Mode**.
- **A password-protected file asks for a password.** Enter it. A file saved with a password cannot be opened without it.

## A document looks wrong

- **Text sits differently from the original.** The font is probably not installed. Install it or choose another font.
- **A layout is slightly different.** Complex layouts can differ from the program that made the file. Tell us which program and what changed.
- **Macros do not run.** Macros from other programs are not supported.

## Documents on a server

- **The server's sign-in page does not load.** Check the internet connection and the server address.
- **You cannot pick another provider.** Nubo Office opens documents only from Nubo servers. See [Accounts and files](/office/account/).

## Still stuck

Email support@nubo.email, or use **Help**, then **Report an issue** inside the app. Say which app, what you did and what happened.

## See also

- [Help inside the apps](/office/use/help-menu/)
