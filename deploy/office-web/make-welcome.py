#!/usr/bin/env python3
"""Rebrand the web editor's first-run slides and English strings the same way office/rebrand.py does for the desktop app.
Usage: make-welcome.py IMAGE OUTDIR   (IMAGE: the collabora/code image the web version runs; needs docker)
Writes OUTDIR/welcome.html, OUTDIR/ui-en_GB.json and our welcome pictures; deploy.sh turns them into a ConfigMap."""
import os, subprocess, sys, shutil, tempfile
here = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(here, "..", "..", "office"))
import rebrand

image, out = sys.argv[1:3]
os.makedirs(out, exist_ok=True)
with tempfile.TemporaryDirectory() as tmp:
    cid = subprocess.check_output(["docker", "create", "--platform", "linux/amd64", image], text=True).strip()
    try:
        root = os.path.join(tmp, "root")
        os.makedirs(os.path.join(root, "browser", "welcome"))
        for f in ("welcome.html",):
            subprocess.check_call(["docker", "cp", "%s:/usr/share/coolwsd/browser/dist/welcome/%s" % (cid, f), os.path.join(root, "browser", "welcome", f)])
        subprocess.check_call(["docker", "cp", "%s:/usr/share/coolwsd/browser/dist/l10n/ui-en_GB.json" % cid, os.path.join(tmp, "ui-en_GB.json")])
    finally:
        subprocess.call(["docker", "rm", cid], stdout=subprocess.DEVNULL)
    path = os.path.join(root, "browser", "welcome", "welcome.html")
    print("welcome texts:", rebrand.welcome(root))
    text = open(path, encoding="utf-8").read()
    for old, new in rebrand.TEXT_RULES:
        text = text.replace(old, new)
    open(os.path.join(out, "welcome.html"), "w", encoding="utf-8").write(text)
    l10n = open(os.path.join(tmp, "ui-en_GB.json"), encoding="utf-8").read()
    for old, new in rebrand.TEXT_RULES:
        l10n = l10n.replace(old, new)
    open(os.path.join(out, "ui-en_GB.json"), "w", encoding="utf-8").write(l10n)
art = os.path.join(here, "..", "..", "office", "brand", "welcome")
for n in os.listdir(art):
    if n.endswith(".png"):
        shutil.copy(os.path.join(art, n), os.path.join(out, n))
print("done:", sorted(os.listdir(out)))
