---
title: "Sign-in and files"
description: "Files on your computer need no account. Documents on a server open through that server's own sign-in, and only Nubo servers."
sidebar:
  order: 10
---

## The rules

- **Files on your computer need no account.** You can open and save them with no sign-in and no internet.
- **Nubo OS sign-in** is the Nubo account that logs you in to the machine. It is separate from the office apps.
- **Documents on a server** open through a file picker. You sign in on the server's own page, not in a window that Nubo Office draws.
- **Only Nubo servers.** The server address in the picker is fixed to Nubo, so the app cannot be pointed at other providers.
- **No separate account** for the suite itself. Nothing in Nubo Office sends you to an account with another company.

## Why local files stay free of sign-in

An office suite is expected to open a file on your disk the moment you double-click it, also on a plane. A forced login would break that. If a Nubo organisation wants staff to work only on server documents, that is a server setting and not a rule inside the app.

## How a server document opens

The desktop app opens a picker that shows the server's own page. When you choose a document, the server gives the app a short-lived address and token for that one document, using the open WOPI protocol that Nextcloud and other servers use. The app downloads the document, you edit it, and it is saved back to the server.

:::caution[Planned]
Opening documents from Nubo Email's drive in the desktop apps is planned. Today, documents in Nubo Email open in the editor that Nubo Email already has.
:::

## Shared editing

Comments and tracked changes work in the desktop apps. Several people editing one document at the same time is planned, for documents stored on a Nubo server.

## See also

- [Start an app](/office/use/start-an-app/)
