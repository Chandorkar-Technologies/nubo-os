#!/usr/bin/env python3
"""Write latest-<arch>.json next to a Nubo Office Flatpak bundle, for the website's download table.
Usage: make-office-manifest.py DIR BUNDLE_FILE VERSION ARCH   (ARCH: x86_64 or aarch64)"""
import json, os, sys
d, name, ver, arch = sys.argv[1:5]
path = os.path.join(d, name)
sha = open(path + ".sha256").read().split()[0]
base = "https://archive.nubosuite.tech/dl/office/%s/%s" % (ver, name)
entry = {"platform": "Linux", "name": "Linux, Intel and AMD" if arch == "x86_64" else "Linux, Arm",
         "detail": "Flatpak: one file, or install from the Nubo repository", "status": "available",
         "url": base, "sha256": sha, "size": os.path.getsize(path),
         "torrent": base + ".torrent" if os.path.exists(path + ".torrent") else None,
         "command": "flatpak remote-add --if-not-exists nubo https://archive.nubosuite.tech/flatpak/nubo.flatpakrepo\nflatpak install nubo tech.nubosuite.Office"}
json.dump({"version": ver, "variants": [entry]}, open(os.path.join(d, "latest-%s.json" % arch), "w"), indent=1)
print("wrote latest-%s.json" % arch)
