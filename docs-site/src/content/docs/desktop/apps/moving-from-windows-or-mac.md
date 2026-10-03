---
title: Moving from Windows or Mac
description: A task-based guide to bring your files, mail, browser data and documents to Nubo OS, and what to expect from your old apps.
sidebar:
  order: 100
---

**Applies to:** Desktop

This guide helps you move to Nubo OS by task: files, mail, calendar and contacts, your browser, documents and apps. It uses tools that are already in Nubo OS and common tools from your old system. Do the tasks in any order.

:::caution[Planned]
A migration app that moves cloud accounts, files and settings for you is planned and not built. Nothing in this guide needs it. Until it exists, you move things with the steps below.
:::

## Before you begin

- Keep your old computer, or a copy of its files, until you have checked that everything arrived.
- An external drive (USB) or a network folder, to carry files over.
- An internet connection for accounts and apps.
- Passwords: Nubo OS cannot read passwords from an old disk. Export them from your old password manager, or sign in again where you need them.

## Move your files

1. On the old computer, copy your Documents, Pictures, Music and other folders to the external drive.
2. Plug the drive into the Nubo OS computer. It appears in **Files** in the sidebar.
3. Copy the folders into your home folder.

Drives formatted as exFAT or NTFS (usual on Windows) open in Files. A Mac drive formatted as APFS may not. Format the transfer drive as exFAT on the Mac first, or use a network folder or a cloud service. <!-- verify: APFS support -->

If you have an account at a cloud service, you can also connect it in [Online Accounts](/desktop/account/other-accounts/) and open its files from Files.

## Move your mail

Mail that lives on a server does not need to be moved. Connect the account again and it is all there.

- **Google or Microsoft:** add the account in [Online Accounts](/desktop/account/other-accounts/), then open **Mail** (Geary).
- **Other providers:** add the account in Geary with your provider's IMAP and SMTP details. See [Mail with Geary](/desktop/account/mail-with-geary/).
- **Mail only on your old computer** (for example local folders in Outlook or Apple Mail): export it to mailbox files with the old program, or move it to an IMAP account on a server first. Geary does not import mailbox files. Thunderbird can, and it is on the [popular list](/desktop/apps/popular-apps-click-to-download/).
- **A new Nubo address:** see [What is a Nubo account?](/desktop/account/what-is-a-nubo-account/).

## Move calendar and contacts

Calendars and address books stored with Google, Microsoft or a CalDAV server come with the account. See [Calendar and contacts](/desktop/account/calendar-and-contacts/). If they are only local, export them as `.ics` (calendar) and `.vcf` (contacts) files from the old program, and import those into Calendar and Contacts. <!-- verify: import options in Calendar and Contacts -->

## Move your browser

Firefox is the browser. See [Web browser: Firefox](/desktop/apps/web-browser-firefox/).

1. Open Firefox.
2. Use its import tool for bookmarks and history from another browser, or sign in to Firefox sync if you used it elsewhere. <!-- verify label -->
3. If you used Chrome, Brave or Edge and want to keep them, Chrome and Brave are on the popular list as Flatpaks.

For passwords, export a CSV file from the old browser or password manager and import it in the new one. Delete the CSV afterwards, because it holds your passwords in plain text.

## Move your documents

Open `.docx`, `.xlsx` and `.pptx` files in Collabora Office. See [Office with Collabora](/desktop/apps/office-with-collabora/). Check an important file once before you send it to others.

## Your old apps

Windows and Mac programs do not run on Nubo OS as they are. For each, look for:

| You used | Look for |
|---|---|
| A web app (Gmail, Google Docs, Notion, Figma, Canva) | The same site in Firefox. Some are on the [popular list](/desktop/apps/popular-apps-click-to-download/). |
| Spotify, Slack, Discord, Zoom, Telegram, Signal, VLC, OBS, GIMP, Steam | The Linux version. They are on the popular list. |
| Microsoft Office | Collabora Office, or Microsoft's web apps in Firefox. |
| Something else | Search in the [Nubo Store](/desktop/apps/nubo-store/). |

## Verify

- Open a few files from different folders and check they are complete.
- Send and receive a mail in Geary.
- Open one `.docx` and one `.xlsx` file.
- Only then clear the old computer.

## Troubleshooting

**The drive does not show up.** Open **Files** and check the sidebar. If it appears greyed out, click it to mount it. Drives with Windows hibernation or fast start enabled may open read-only. Shut the Windows computer down fully and try again.

**File names look odd.** Windows forbids some characters that Linux allows and the reverse. Rename the file.

**An app is missing.** Search the Nubo Store, or look for a web version.

**Fonts differ.** See [Office with Collabora](/desktop/apps/office-with-collabora/).

## See also

- [Apps](/desktop/apps/)
- Ubuntu's desktop documentation: https://ubuntu.com/desktop/docs
