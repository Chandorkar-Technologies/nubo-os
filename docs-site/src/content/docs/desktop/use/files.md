---
title: Files
description: Browse your files with the Files app, change the view, and open network locations such as shared folders and WebDAV.
sidebar:
  order: 120
---

**Applies to:** Desktop

Files is the file manager. It is GNOME's Nautilus app, listed as "Files" in Nubo OS. Nubo changes its look through the theme and sets a few defaults. This page covers the basics and how to reach files on other computers.

## The basics

Open Files from the dock (it is pinned by default) or from the app grid. The sidebar on the left lists your Home folder, common folders such as Documents, Downloads and Pictures, the Trash, drives and network places.

Nubo changes these Files defaults:

- Folders open in **icon view**, like a grid of large icons.
- Items are sorted **by name**, in normal order.

Change either with the view buttons in the toolbar. Files remembers the choice per folder. <!-- verify label -->

### Everyday actions

| To do this | Do this |
|---|---|
| Open a file | Double-click it |
| Copy or move | Drag between windows, or <kbd>Ctrl</kbd>+<kbd>C</kbd> then <kbd>Ctrl</kbd>+<kbd>V</kbd>; <kbd>Ctrl</kbd>+<kbd>X</kbd> to move |
| Rename | Select, press <kbd>F2</kbd> |
| Search | <kbd>Ctrl</kbd>+<kbd>F</kbd> |
| Show hidden files | <kbd>Ctrl</kbd>+<kbd>H</kbd> |
| New folder | <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>N</kbd> |
| Go to a location by typing | <kbd>Ctrl</kbd>+<kbd>L</kbd> |
| Move to Trash | <kbd>Delete</kbd> |

Removable drives appear in the sidebar when you plug them in. They are not shown in the dock. The Trash is shown in the dock. Nubo turns off icons on the desktop (Home, Trash and drives), so Files is where you find them.

Archives open with Archive Manager. PDFs open in PDF Viewer and pictures in Image Viewer. To share a file with a nearby device, see LocalSend in the Utilities folder of the [app grid](/desktop/use/dock-and-app-grid/).

## Connect to a network location

Files can connect to shared folders on another computer through GNOME's GVfs. The desktop recommends `gvfs-fuse`, and the other gvfs parts come with GNOME.

### Before you begin

- The computer or server must be on, reachable, and sharing a folder.
- You need the address and, if it needs one, a user name and password.

### Steps

1. Open Files.
2. Click **Other Locations** in the sidebar. <!-- verify label -->
3. At the bottom, type the address in the "Connect to Server" box.
4. Press **Connect** and enter your credentials if asked.
5. The location appears in the sidebar. Click the eject symbol next to it to disconnect.

### Address examples

| Kind | Address |
|---|---|
| Windows or Samba share | `smb://server-name/share` |
| SFTP over SSH | `sftp://user@server/path` |
| WebDAV with TLS | `davs://host/path` |
| FTP | `ftp://host/path` |
| NFS | `nfs://server/path` |

Nubo includes an optional Nubo account provider for GNOME Online Accounts. Among other things, it can add a WebDAV folder from `mail.nubo.email` to Files. That provider is a preview. It was tested against a test server only and is not installed in the default build. Do not rely on it yet.

## Verify

1. Open Files and click Home. You should see your folders as large icons.
2. Press <kbd>Ctrl</kbd>+<kbd>L</kbd>, type an address from the table, and press <kbd>Enter</kbd>. A password prompt or the folder contents appear.
3. The location shows in the sidebar.

## Troubleshooting

**"Unable to access location" or "Failed to mount".**
Cause: wrong address, the host is off, or the network blocks the port. Fix: check the address and try from the same network. Try `ping` on the host name from a terminal.

**An SMB share asks for a password every time.**
Cause: the password was not saved. Fix: in the credentials dialog choose to remember the password, if it is offered. Passwords are kept in the GNOME keyring (the Passwords and Keys app in Utilities). <!-- verify label -->

**I cannot see network computers automatically.**
Cause: network discovery depends on the Avahi service and on the other computer announcing itself. Fix: type the address instead.

**A drive does not show in the sidebar.**
Cause: it has no recognised file system or is not mounted. Fix: open Disks from the Utilities folder and check it.

## See also

- [Phone link](/desktop/use/phone-link/)
- [Dock and app grid](/desktop/use/dock-and-app-grid/)
- [Privacy and security](/desktop/settings/privacy-and-security/)
- GNOME Files help in the Help of your desktop and Ubuntu's documentation: https://ubuntu.com/desktop/docs
