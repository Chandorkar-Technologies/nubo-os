---
title: Add Google, Microsoft and other accounts
description: Connect accounts from other providers, or from a Nextcloud server, through Online Accounts.
sidebar:
  order: 70
---

**Applies to:** Desktop

You do not need a Nubo account to use mail, calendar, contacts and files. GNOME Online Accounts, in Settings, connects accounts from other providers, and the standard apps pick them up. This page shows the general steps. The providers listed are the ones the GNOME Online Accounts package offers on Ubuntu 26.04 (version 3.58). Which of them appear and what each can sync is decided by that upstream package, not by Nubo. For the full list and current behavior, see Ubuntu's desktop documentation at https://ubuntu.com/desktop/docs.

## Before you begin

- The account details: address and password, or a way to sign in on the provider's web page.
- An internet connection.
- For accounts with two-factor authentication on a provider that does not use a web sign-in page, an app password.

## Steps

1. Open **Settings** and go to **Online Accounts**. <!-- verify label -->
2. Choose a provider:
   - **Google** or **Microsoft**: a sign-in window opens with the provider's own page. Sign in and approve access.
   - **Nextcloud**: enter the server address, your user name and your password.
   - **Other WebDAV or IMAP and SMTP providers**: use the generic entries and enter the server details your provider gives you.
3. After you sign in, the account page shows switches for the services it offers, such as Mail, Calendar, Contacts and Files. Turn on those you want.

The exact entry names depend on the installed package. <!-- verify label -->

## Which app uses what

| Service | App that uses it |
|---|---|
| Mail | Geary (see [Mail with Geary](/desktop/account/mail-with-geary/)) |
| Calendar | Calendar |
| Contacts | Contacts |
| Files | Files, in the sidebar |

## Nextcloud and other file servers

Nextcloud is a common choice if you host your own files. After you add it, its folder shows in the Files sidebar through GVfs and you can open files from there. For a plain WebDAV server, the Files app can also connect directly: choose to connect to a server in the sidebar and enter an address starting with `davs://` for TLS. <!-- verify label -->

## Privacy note

Signing in to a third-party account sends your credentials, or a token, to that provider and stores them in your login keyring. Nubo does not see them. When you remove the account from Online Accounts, the stored credentials are removed with it.

## Verify

- The account shows in Online Accounts without a warning.
- Your mail arrives in Geary, and events and contacts appear in their apps.
- For files, the entry opens in Files.

## Troubleshooting

**The sign-in window stays blank.** Check your network and the clock. A wrong date breaks the provider's page.

**"Attention needed" next to an account.** The token expired or the password changed. Open the account and sign in again.

**Google or Microsoft do not offer Mail.** Some providers restrict mail access for third-party clients. Use the provider's web page in Firefox instead, or an IMAP app password if the provider supports it.

**The account does not appear in Geary.** Geary may need a restart after a new account is added. Close it and open it again.

## See also

- [Add your Nubo account to Online Accounts](/desktop/account/online-accounts/)
- [Account security](/desktop/account/account-security/)
