#!/usr/bin/env python3
"""Make product keys and serial numbers for the Nubo scratch cards.

  ./make-codes.py --product os --batch 2610 --count 1000

Writes, into codes/ (git-ignored: keys are secrets, never commit them):
  <product>-<batch>-print.csv   serial,key       for the printer's variable-data merge
  <product>-<batch>-import.csv  serial,sha256    for the licence server (it stores the hash, never the key)

A key looks like ABCD-EFGH-JKLM-NPQ7: 16 characters from an alphabet without 0, O, 1, I or L,
about 74 bits of randomness, and the last character is a check so typing mistakes are caught
before the key is sent to the server. The serial (NBOS-2610-000123) is printed OUTSIDE the
scratch panel so shops can count stock without revealing keys.
"""
import argparse, csv, hashlib, os, secrets, sys

ALPHABET = "ABCDEFGHJKMNPQRSTUVWXYZ23456789"        # 31 letters and digits: no 0 O 1 I L
assert len(ALPHABET) == 31
BASE = len(ALPHABET)
PREFIX = {"os": "NBOS", "office": "NBOF"}


def check_char(body: str) -> str:
    total = sum((i + 1) * ALPHABET.index(c) for i, c in enumerate(body))
    return ALPHABET[total % BASE]


def make_key() -> str:
    body = "".join(secrets.choice(ALPHABET) for _ in range(15))
    raw = body + check_char(body)
    return "-".join(raw[i:i + 4] for i in range(0, 16, 4))


def key_ok(key: str) -> bool:
    raw = key.replace("-", "").upper()
    return len(raw) == 16 and all(c in ALPHABET for c in raw) and check_char(raw[:15]) == raw[15]


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--product", choices=sorted(PREFIX), required=True)
    ap.add_argument("--batch", required=True, help="four digits, year and month, for example 2610")
    ap.add_argument("--count", type=int, required=True)
    ap.add_argument("--start", type=int, default=1, help="first serial number (default 1)")
    ap.add_argument("--out", default=os.path.join(os.path.dirname(os.path.abspath(__file__)), "codes"))
    a = ap.parse_args()
    os.makedirs(a.out, exist_ok=True)
    stem = f"{a.product}-{a.batch}"
    seen, rows = set(), []
    for n in range(a.start, a.start + a.count):
        key = make_key()
        while key in seen:
            key = make_key()
        seen.add(key)
        rows.append((f"{PREFIX[a.product]}-{a.batch}-{n:06d}", key))
    assert all(key_ok(k) for _, k in rows)
    for name in (f"{stem}-print.csv", f"{stem}-import.csv"):
        if os.path.exists(os.path.join(a.out, name)):
            sys.exit(f"{name} already exists in {a.out}. Refusing to overwrite a printed batch.")
    with open(os.path.join(a.out, f"{stem}-print.csv"), "w", newline="") as f:
        w = csv.writer(f); w.writerow(["serial", "key"]); w.writerows(rows)
    with open(os.path.join(a.out, f"{stem}-import.csv"), "w", newline="") as f:
        w = csv.writer(f); w.writerow(["serial", "sha256"])
        w.writerows((s, hashlib.sha256(k.encode()).hexdigest()) for s, k in rows)
    os.chmod(os.path.join(a.out, f"{stem}-print.csv"), 0o600)
    print(f"{len(rows)} keys written to {a.out}/{stem}-print.csv (for the printer) and {stem}-import.csv (for the server)")


if __name__ == "__main__":
    main()
