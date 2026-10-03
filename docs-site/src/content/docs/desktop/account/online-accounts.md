---
title: Add your Nubo account to Online Accounts
description: Connect mail, calendar, contacts and files with one Nubo sign-in in Settings, and understand what is still in preview.
sidebar:
  order: 40
---

**Applies to:** Desktop

GNOME Online Accounts is the part of Settings where you connect cloud accounts once, so that Mail, Calendar, Contacts and Files all find them. Nubo OS includes a patched version with a **Nubo** provider. You type your Nubo email address and password, and it sets up everything against `mail.nubo.email`.

:::caution[Preview]
The Nubo provider was tested against a fake server and against `mail.nubo.email` only as far as a rejected password. A successful login with a real account, and calendar, contacts and files actually syncing, have not been verified. The patched Settings list is not installed by default, so Nubo may not appear where you expect. Use [Mail with Geary](/desktop/account/mail-with-geary/) or [Calendar and contacts](/desktop/account/calendar-and-contacts/) to connect by hand if it does not work for you.
:::

## What it syncs

| Service | Protocol | Endpoint |
|---|---|---|
| Mail | IMAP over TLS | `mail.nubo.email:993` |
| Mail, sending | SMTP over TLS, PLAIN authentication, same credentials | `mail.nubo.email:465` |
| Calendar | CalDAV | `https://mail.nubo.email/dav/cal` |
| Contacts | CardDAV | `https://mail.nubo.email/dav/card` |
| Files | WebDAV through GVfs | `davs://mail.nubo.email/dav/file` |

The login name is the full email address, also for custom domains. One password is used for everything. There is no OAuth and no second factor in this provider. If your account uses two-factor authentication, you need an app password.

## Before you begin

- The patched `gnome-online-accounts` package (version `3.58.0-1+nubo1`). The patched packages are built from the `goa/` folder of the project and are not a default part of the desktop yet.
- Optional: the patched `gnome-control-center` (`50.3-0ubuntu0.2+nubo1`), which lists Nubo first in Settings. Without it, Nubo is listed last among the providers.
- Your Nubo email address and password.
- An internet connection.

## Steps

1. Open **Settings** and go to **Online Accounts**. <!-- verify label -->
2. Choose **Nubo**. If you do not see it near the top, scroll down to the end of the list.
3. Enter your **Email Address** and **Password**.
4. Choose **Sign In**.

The provider checks your credentials before it creates the account: first an IMAP and SMTP login, then the three DAV endpoints. Only if all checks pass is the account added, with Mail, Calendar, Contacts and Files all switched on.

5. Open the account's page in Online Accounts. Mail, Calendar, Contacts and Files each have a switch. Turn off any you do not want.

## Where your password goes

The password is stored in your login keyring (GNOME Keyring) under three names, all with the same value: `password`, `imap-password` and `smtp-password`. Different programs ask for different names. Evolution reads the IMAP and SMTP ones, GVfs and evolution-data-server read `password`. Nothing is written to a plain file. See [Account security](/desktop/account/account-security/).

## Verify

- The account appears in Online Accounts without a warning icon.
- Open **Files**: a Nubo entry for your account appears in the sidebar and opens the WebDAV folder. <!-- verify label -->
- Open Calendar and Contacts. The server's calendars and address books should be listed. This is untested against a real account, so report what you see to support@nubo.email.
- On a terminal, check that the daemon is running without errors:

```bash
journalctl --user -b | grep -i goa
```

## Troubleshooting

**"The email address or password is incorrect".** The server rejected the login. Check the full address (for example `name@nubo.email`) and the password. If you use two-factor authentication, create an app password.

**The account shows "attention needed" later.** The password changed on the server. Open the account in Online Accounts and choose **Sign In** to enter the new password. <!-- verify label -->

**Nubo is not in the list.** The patched `gnome-online-accounts` is not installed, or the daemon has not restarted. Log out and in again, or run `pkill goa-daemon` (it restarts when needed).

**Nubo is at the bottom of the list.** Without the patched `gnome-control-center`, Settings puts unknown providers last. This only affects the order.

**Calendar or Contacts stay empty.** The DAV paths were taken from the server description and have not been confirmed with a real account. Add the calendar by hand as described in [Calendar and contacts](/desktop/account/calendar-and-contacts/).

**Ubuntu updates replace the patched packages.** Pin them with `/etc/apt/preferences.d/nubo-goa`. The pin text is in `goa/README.md` of the project. While pinned, Ubuntu's fixes for these packages are not installed until the project rebuilds them.

## Limits to know about

- Names and labels of the provider are not translated and fall back to English.
- There is no name field. The display name of your mail defaults to your computer user's real name and can be changed in the mail app.
- Only GOA 3.58.x on arm64 was built and tested.

## See also

- [Add Google, Microsoft and other accounts](/desktop/account/other-accounts/)
- [Read and send mail with Geary](/desktop/account/mail-with-geary/)
