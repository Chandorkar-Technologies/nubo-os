---
title: Printing
description: Add a printer, print a document and fix common problems on Nubo OS.
sidebar:
  order: 60
---

**Applies to:** Desktop

Printing on Nubo OS works as on Ubuntu 26.04 LTS. It uses CUPS, with driver packages for many printers. This page shows the short route to a working printer. For more detail see Ubuntu's documentation at https://ubuntu.com/desktop/docs.

## What is installed

The desktop depends on or recommends the common printing pieces: `cups` and its client tools, `cups-filters`, `foomatic-db-compressed-ppds`, `openprinting-ppds`, `printer-driver-pnm2ppa`, `ghostscript` and, as a recommendation, `hplip` for HP printers, `bluez-cups` for Bluetooth printers and `avahi-daemon` for finding network printers. The Document Scanner app (`simple-scan`) is in the Accessories folder of the app grid.

## Before you begin

- The printer turned on, with paper.
- For a USB printer: the cable.
- For a network printer: it must be on the same network as your computer.

## Add a printer

1. Connect a USB printer. Most modern printers appear without any setup, and are ready to print.
2. If it does not, open [Settings](/desktop/settings/) and go to the printers page. <!-- verify label -->
3. Click to unlock the page if asked; changing printers needs your password.
4. Click the button to add a printer. Network printers found on your network are listed.
5. Choose your printer. If a driver is needed, choose one from the list.

Settings can also add a printer by its address, for example `ipp://printer.local/ipp/print`. Many modern network printers support the standard IPP protocol and need no vendor driver. <!-- verify label -->

## Print a document

1. Open the document and press <kbd>Ctrl</kbd>+<kbd>P</kbd>.
2. Choose your printer, the pages and number of copies.
3. Click **Print**.

To see and cancel jobs, open the printer in Settings, or use the printer's queue from the print dialog. <!-- verify label -->

## Scan

If you have a scanner, open Document Scanner (`simple-scan`) from the Accessories folder. Many multi-function printers connect to it over the network or USB.

## Verify

1. Print a test page: in Settings, open the printer and use the option to print a test page. <!-- verify label -->
2. The page comes out.
3. Run `lpstat -p` in a terminal. It lists your printer as idle or printing.

## Troubleshooting

**The printer is not listed.**
Cause: not connected, off or on another network. Fix: switch it off and on, check the cable or network, and add it by address.

**The job is stuck in the queue.**
Cause: the printer is offline or out of paper, or the driver is wrong. Fix: clear the cause, then resume or cancel the job in the queue. Try a different driver in the printer's settings.

**"Filter failed" or a blank page.**
Cause: a wrong driver. Fix: remove the printer and add it again, choosing the driver that names your model, or the generic IPP option if supported.

**An HP printer needs a plug-in.**
Cause: some HP models need extra files from HP. Fix: run `hp-setup` from the HPLIP package, if it is installed, and follow its steps. <!-- verify label: hplip is only recommended -->

**The Printers page needs a password.**
Cause: system settings are locked. Fix: unlock it with your account password if your account is an administrator.

## See also

- [Network, Wi-Fi and Bluetooth](/desktop/settings/network-wifi-bluetooth/)
- [Dock and app grid](/desktop/use/dock-and-app-grid/)
- Ubuntu's documentation: https://ubuntu.com/desktop/docs
