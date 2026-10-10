#!/usr/bin/env python3
"""Write latest-windows.json, latest-android.json and latest-macos.json for the files in DIR (Windows zip, Android apk, Mac dmg).
Usage: make-office-extra-manifest.py DIR VERSION"""
import hashlib, json, os, sys
d, ver = sys.argv[1:3]
KINDS = [  # file suffix, manifest name, row name, detail
    ("-win-x64-portable.zip", "windows", "Windows 11, Intel and AMD", "Portable: unzip it and run Nubo Office.exe (no installer)"),
    ("-android-arm64.apk", "android", "Android phones and tablets", "APK for 64-bit phones. Allow installs from your browser once"),
    ("-arm64.dmg", "macos", "macOS, Apple silicon", "Disk image"),
]
for name in sorted(os.listdir(d)):
    for suffix, key, row, detail in KINDS:
        if not name.endswith(suffix):
            continue
        path = os.path.join(d, name)
        h = hashlib.sha256()
        with open(path, "rb") as f:
            for chunk in iter(lambda: f.read(1 << 20), b""):
                h.update(chunk)
        open(path + ".sha256", "w").write("%s  %s\n" % (h.hexdigest(), name))
        entry = {"name": row, "detail": detail, "status": "available",
                 "url": "https://archive.nubosuite.tech/dl/office/%s/%s" % (ver, name),
                 "sha256": h.hexdigest(), "size": os.path.getsize(path), "command": None}
        json.dump({"version": ver, "variants": [entry]}, open(os.path.join(d, "latest-%s.json" % key), "w"), indent=1)
        print("wrote latest-%s.json" % key)
