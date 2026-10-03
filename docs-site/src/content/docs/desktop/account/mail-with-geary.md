---
title: Read and send mail with Geary
description: Use Geary, the default mail app, with your Nubo address or any other IMAP account.
sidebar:
  order: 50
---

**Applies to:** Desktop

Geary is the default mail app in Nubo OS. In the app grid it is named **Mail** and its description reads "Read and send email". It is installed from the system's package archive (the `geary` package), not from Flathub, and it sits in the dock by default.

Nubo OS no longer ships Thunderbird. The Thunderbird snap is removed on first boot. If you prefer Thunderbird, it is in the popular apps list and you can download it from Flathub. See [Popular apps: click to download](/desktop/apps/popular-apps-click-to-download/).

## Before you begin

- Your email address and password.
- For a Nubo address: the server details below.
- An internet connection.

## Add a Nubo address

The simplest way is [Online Accounts](/desktop/account/online-accounts/), because Geary reads accounts from there. It is in preview. If it is not available, add the account inside Geary.

1. Open **Mail**.
2. Add an account. On first start Geary asks for one, later you can find the option in its main menu. <!-- verify label -->
3. Enter your name, your full address (for example `name@nubo.email`) and your password.
4. If Geary does not find the settings by itself, enter them by hand:

| Setting | Value |
|---|---|
| Incoming server (IMAP) | `mail.nubo.email`, port 993, TLS |
| Outgoing server (SMTP) | `mail.nubo.email`, port 465, TLS |
| Login name | Your full email address |
| Password | The same password for both |

5. Confirm. Geary downloads your folders.

## Add another address

Geary works with any provider that offers IMAP and SMTP. For Google and Microsoft accounts, use [Online Accounts](/desktop/account/other-accounts/), which handles their sign-in pages. For other providers, enter the incoming and outgoing server names your provider gives you.

## Notifications when the window is closed

Geary is one of the apps that Nubo keeps running in the background without a window, so new mail can still raise a notification. This is done by the notification agent. See [Messaging and background apps](/desktop/apps/messaging-and-background-apps/). To stop it for Geary:

```bash
nubo-notify-agent disable geary
```

## Verify

- Send a message to yourself. It should arrive in the inbox within a minute.
- Close the Geary window and send another message from your phone. A notification should still appear.

## Troubleshooting

**"Authentication failed".** The login name must be the full email address. Check the password. If your provider uses two-factor authentication, use an app password.

**Sending fails but receiving works.** The outgoing server needs the same login. On a Nubo address, SMTP uses port 465 with TLS and the same credentials as IMAP. Some home networks block other mail ports, so keep to the ports above.

**A certificate warning appears for `mail.nubo.email`.** Do not accept it. The Nubo provider always verifies this certificate. A warning usually means a network that intercepts connections, or a wrong date on the computer. Fix the date or change network.

**No notification when the window is closed.** Run `nubo-notify-agent list` and check that Mail shows "on". If it shows "off", run `nubo-notify-agent enable geary`.

**The Nubo Mail app is missing.** There is a repack script for a separate Nubo Mail app in the project, but it is not part of the default desktop. Geary is the default.

## See also

- [Calendar and contacts](/desktop/account/calendar-and-contacts/)
- [Account security](/desktop/account/account-security/)
