---
title: What is a Nubo account?
description: What a Nubo account is, what you can use it for today, and what is still planned.
sidebar:
  order: 20
---

**Applies to:** Desktop

A Nubo account is an identity on Nubo's own mail server, `mail.nubo.email`. The server runs Stalwart, a mail and collaboration server. One account gives you an email address, and the same login can reach calendars, address books and files on the same host. The account also acts as an identity provider (single sign-in), which is how the login screen can use it.

This page explains how the pieces fit together and is honest about which parts exist today.

## One server, several protocols

Everything an account does goes through `mail.nubo.email`. The desktop talks to it with ordinary, open protocols, so you are not locked into a Nubo app.

| What | Protocol | Where |
|---|---|---|
| Mail, receiving | IMAP over TLS | `mail.nubo.email`, port 993 |
| Mail, sending | SMTP over TLS | `mail.nubo.email`, port 465 |
| Calendar | CalDAV | `https://mail.nubo.email/dav/cal` |
| Contacts | CardDAV | `https://mail.nubo.email/dav/card` |
| Files | WebDAV | `davs://mail.nubo.email/dav/file` |
| Sign-in to the computer | OpenID Connect (device flow) | `https://mail.nubo.email` |

The first five rows come from the Nubo provider for Online Accounts. The last row comes from the sign-in setup in the `nubo-account` package.

## What exists today

- **A first-run screen.** After the first login on an installed system, a window titled Nubo Setup offers to sign in, to create an account, or to skip. You can skip it and nothing is lost.
- **Account creation.** The screen asks for a name, an address (the part before `@nubo.email`), a mobile number and a password of at least eight characters. It sends them to Nubo's sign-up service and then shows recovery codes. Read [Account security](/desktop/account/account-security/) before you rely on this.
- **Sign-in to the computer.** With `nubo-account`, the login screen can offer "Nubo Account". This is early access. See [Sign in at the login screen](/desktop/account/sign-in-at-the-login-screen/).
- **The Nubo provider in Online Accounts.** It connects mail, calendar, contacts and files in one step. This is a preview. See [Add your Nubo account to Online Accounts](/desktop/account/online-accounts/).
- **Standard apps that use those accounts.** Geary for mail, Calendar and Contacts from GNOME, and Files for the WebDAV folder.

:::caution[Early access]
The Nubo account has not yet been verified end to end with a real account in the project's own notes. The sign-in and the Online Accounts provider were tested against test servers and against `mail.nubo.email` only up to a rejected password. Treat all of it as early access.
:::

## What is planned

:::caution[Planned]
These are not built yet and are not part of Nubo OS 1 "Flow" today: Nubo Drive (cloud file storage as a product), Nubo Backup, a migration app, Nubo Pro, and a Nubo Store with its own cloud login that remembers your apps. See [Nubo Drive and backup](/desktop/account/nubo-drive-and-backup/).
:::

## What the account does not do

- It is not needed to install or update the system. Updates come from the package archive and need no login.
- It does not sync your settings or your installed apps between computers. That would be part of the planned store login.
- It does not replace your other accounts. You can keep using Google, Microsoft or others. See [Add Google, Microsoft and other accounts](/desktop/account/other-accounts/).

## How the sign-in works, briefly

```
login screen or Nubo Setup
        |  asks mail.nubo.email for a short code
        v
you open the approval page on your phone or another computer
        |  and type the code
        v
mail.nubo.email confirms it -> the computer receives tokens
```

This is called the device flow. Your password is never typed on the computer for this method. What the computer keeps afterwards is covered in [Account security](/desktop/account/account-security/).

## See also

- [Account security](/desktop/account/account-security/)
- [Updates](/updates/)
