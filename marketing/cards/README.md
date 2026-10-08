# Nubo scratch cards (retail activation cards)

White A6 cards for **Nubo OS (Nubo Pro)** and **Nubo Office**, like the activation cards sold for
Tally and antivirus in electronics stores. The customer scratches off the silver panel, finds a
product key, and types it in to activate.

Defaults (change them in the `C` object at the top of the script in `card.html`):

| Card | Plan on the card | MRP |
|---|---|---|
| Nubo OS | Nubo Pro, 1 device, 1 year | Rs. 499, inclusive of all taxes |
| Nubo Office | Nubo Office, 1 device, 1 year | Rs. 499, inclusive of all taxes |

## Files (`out/`)

| File | Use |
|---|---|
| `os-card.pdf`, `office-card.pdf` | **Send to the printer.** Page 1 is the front, page 2 the back. 111 x 154 mm, which is A6 (105 x 148 mm) plus 3 mm bleed on every side |
| `os-card-under.pdf`, `office-card-under.pdf` | Proof of the back **as printed under the silver coating**: the key box, in black on white |

Rebuild after any change: `./build.sh` (needs Google Chrome). Source: `card.html`.

## Instructions for the printer

1. **Size and stock:** trim to 105 x 148 mm. About 300 to 350 gsm art card, matte or soft-touch, white.
2. **Colour:** the artwork is RGB. Please convert to CMYK and send a proof first; the orange will
   look duller in CMYK. The text and images are already high resolution (300 dpi or better).
3. **Scratch panel:** apply silver scratch-off (latex) coating on the back, over the key box.
   The box is about **95 x 19 mm, 5 mm from the left trim edge and about 42.5 mm from the top
   trim edge**. Use the `-under.pdf` proof for the exact position. Print the key first, then the
   coating. Use an opaque coating that cannot be read through, even against light.
4. **Variable data (one record per card)** from the CSV we supply (`serial,key`):
   - **Key:** black, monospaced, 13 to 14 pt, centred under the silver coating.
   - **Serial number:** printed in the line "Serial no." just below the panel, outside the coating.
5. **Barcode:** the dashed box at the bottom left is reserved for the retail **EAN-13 barcode**.
   Shops scan it at the till. Replace the box with the real barcode once we have the number.
6. **Packing:** the card goes in a clear sleeve. A hang hole can be punched at the top centre.
7. **Security:** keys are secret. Send the CSV only to the printer, through a secure channel,
   and ask them to delete it after the job and to keep a record of the batch numbers.

## Making the keys

```
./make-codes.py --product os --batch 2610 --count 1000
./make-codes.py --product office --batch 2610 --count 1000
```

Each run writes two files into `codes/` (this folder is git-ignored: **never commit keys**):

- `os-2610-print.csv`: `serial,key`. This goes to the printer.
- `os-2610-import.csv`: `serial,sha256`. This goes into our licence system, which keeps only the
  hash of each key. Nobody, including us, can read a key back from the server.

A key looks like `RTNQ-AJ85-8R2Y-RQZX`: 16 characters, no confusing letters (no 0, O, 1, I, L),
about 74 bits of randomness, and the last character is a check, so a typing mistake is caught
before it reaches the server. The tool refuses to overwrite an existing batch.

## Before these cards can be sold

1. **The activation system must exist.** Nothing in Nubo OS or Nubo Office accepts a key yet. The
   cards say "Open Nubo Setup, choose Activate" and point to `nubosuite.tech/activate`. Both need
   to be built: a licence server (Keygen was the candidate), the Activate screen, and the page.
   Do not print or sell until a key from a test batch has been activated end to end.
2. **Marketer details.** The back has a placeholder line, "Marketed by: [company name and address
   to be filled in before printing]". Fill it in. Indian packaged-goods rules usually also expect
   the MRP, the marketer's name and address and a customer-care contact; please check the
   exact list with a legal adviser.
3. **EAN-13 barcodes.** Retail chains need them. They come from GS1 India (a registration fee and
   a company prefix).
4. **Retail terms.** Shops like Croma have their own margin, return and stock-keeping terms for
   software cards. Agree the margin before setting the MRP.
5. **Printer sample.** Order a small sample first. Check the coating scratches cleanly and the key
   is fully hidden.
