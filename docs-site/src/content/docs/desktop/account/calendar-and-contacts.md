---
title: Calendar and contacts
description: Use Calendar and Contacts with your Nubo account and other CalDAV and CardDAV servers.
sidebar:
  order: 60
---

**Applies to:** Desktop

Nubo OS uses GNOME's **Calendar** and **Contacts** apps. In the launcher they are named "Calendar" (See your events) and "Contacts" (Your address book). Both read their accounts from [Online Accounts](/desktop/account/online-accounts/). Calendar is also in the dock by default, and the desktop can show a Calendar widget.

## Before you begin

- A Nubo account, or an account from another provider that offers calendars and contacts.
- The Calendar and Contacts apps. They are recommended packages of the desktop (`gnome-calendar` and `gnome-contacts`), so they are present unless you removed them.

## Connect your Nubo account

Follow [Add your Nubo account to Online Accounts](/desktop/account/online-accounts/). With the Calendar and Contacts switches on, the apps use these endpoints:

| What | Protocol | Endpoint |
|---|---|---|
| Calendar | CalDAV | `https://mail.nubo.email/dav/cal` |
| Contacts | CardDAV | `https://mail.nubo.email/dav/card` |

## Use an account that is not in the list

For a CalDAV or CardDAV server that Online Accounts does not know by name, choose the generic WebDAV or Nextcloud style entries in Online Accounts. See [Add Google, Microsoft and other accounts](/desktop/account/other-accounts/).

## Everyday use

1. Open **Calendar**. Choose which calendars to show with the calendars button. <!-- verify label -->
2. Add an event by double-clicking a day, or with the add button. Pick the calendar it belongs to.
3. Open **Contacts** to see people from all connected accounts. New contacts are saved to the address book you choose.

The Calendar widget on the desktop is separate from the app. You can turn it off with the `show-calendar` setting in the shell defaults. See [the desktop section](/desktop/) for widgets.

## Verify

- After you add an event in Calendar, open the same account in another app, such as a phone calendar app on the same account. The event should appear.
- A new contact shows in Contacts under the account you chose.

## Troubleshooting

**Calendar or Contacts are empty after connecting.** The Nubo DAV paths have not been confirmed against a real account, because the provider was only tested on a fake server. If your account needs `/dav/cal/<user>/`, report it to support@nubo.email. Meanwhile add the calendar address in a generic account.

**Events do not sync.** Check the account in Online Accounts for an "attention needed" mark and sign in again.

**Contacts from another account are missing.** Each account has its own switch for Contacts. Turn it on in Online Accounts.

## See also

- [Read and send mail with Geary](/desktop/account/mail-with-geary/)
- [Account security](/desktop/account/account-security/)
