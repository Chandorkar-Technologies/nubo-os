#!/usr/bin/env python3
"""Package the Windows build of Nubo Office as an unsigned .msix for the Microsoft Store, without any Windows tools.
The Store signs the package itself, so only the identity values from Partner Center (Product identity) matter.

Usage: make-office-msix.py ZIP SOURCE_ROOT OUT.msix --name NAME --publisher "CN=..." --publisher-display NAME [--version 26.4.3.0]
  ZIP          the portable zip from ci/build-office-windows.sh (program/, share/, ... at its root)
  SOURCE_ROOT  the rebranded source checkout (windows/coda has the manifest template, engine/ the filter lists)
Everything is stored uncompressed, so the block map needs no per-block sizes."""
import argparse, base64, hashlib, importlib.util, os, re, struct, sys, tempfile, zipfile
from urllib.parse import quote
from xml.sax.saxutils import escape

p = argparse.ArgumentParser()
p.add_argument("zip"); p.add_argument("source"); p.add_argument("out")
p.add_argument("--name", required=True); p.add_argument("--publisher", required=True)
p.add_argument("--publisher-display", required=True)
p.add_argument("--version", default="26.4.3.0"); p.add_argument("--display", default="Nubo Office")
p.add_argument("--exe", default="Nubo Office.exe"); p.add_argument("--arch", default="x64")
a = p.parse_args()
if not re.fullmatch(r"\d+\.\d+\.\d+\.0", a.version):
    sys.exit("the Store needs a four-part version ending in .0")

coda = os.path.join(a.source, "windows", "coda")
spec = importlib.util.spec_from_file_location("package_appx", os.path.join(coda, "package_appx.py"))
pa = importlib.util.module_from_spec(spec); spec.loader.exec_module(pa)

work = tempfile.mkdtemp(prefix="msix-")
with zipfile.ZipFile(a.zip) as z:
    z.extractall(work)
files = work

# the manifest: the upstream template filled with our identity, our file types, no Microsoft Office URI schemes
resources = pa.buildLangResouces(files)
exts = pa.buildExtensions(os.path.join(a.source, "engine"))
m = open(os.path.join(coda, "AppxManifest.xml.in"), encoding="utf8").read()
m = (m.replace("%IDENTITY", a.name).replace("%DISPLAYNAME", a.display).replace("%EXE", a.exe)
       .replace("%VER", a.version).replace("%RES", resources).replace("%EXT", exts).replace("%ARCH", a.arch))
m = m.replace('Publisher="CN=E9F172FF-9203-4DB8-A589-184C7A58C071"', 'Publisher="%s"' % escape(a.publisher, {'"': "&quot;"}))
m = m.replace("<PublisherDisplayName>Collabora Productivity Ltd</PublisherDisplayName>",
              "<PublisherDisplayName>%s</PublisherDisplayName>" % escape(a.publisher_display))
m = m.replace("Collabora Office", a.display).replace('Description="sofficeUapDescription"', 'Description="%s"' % a.display)
if any(t in m for t in ("%IDENTITY", "%VER", "%ARCH", "%RES", "%EXE", "%DISPLAYNAME", "%EXT")):
    sys.exit("manifest still has an unfilled placeholder")

# program/bootstrap.ini keeps the user profile inside the app's own folder, like the upstream package
ini = os.path.join(files, "program", "bootstrap.ini")
lines = open(ini, encoding="utf8").read().splitlines(keepends=True)
lines = ["UserInstallation=$SYSUSERCONFIG/%s/appx\n" % a.display if l.startswith("UserInstallation=") else l for l in lines]
open(ini, "w", encoding="utf8").write("".join(lines))

# the tile and logo pictures
assets = os.path.join(files, "Assets"); os.makedirs(assets, exist_ok=True)
for f in os.listdir(os.path.join(coda, "Assets")):
    open(os.path.join(assets, f), "wb").write(open(os.path.join(coda, "Assets", f), "rb").read())
open(os.path.join(files, "AppxManifest.xml"), "w", encoding="utf8").write(m)

CT = {".png": "image/png", ".xml": "application/xml", ".dll": "application/x-msdownload", ".exe": "application/x-msdownload",
      ".json": "application/json", ".txt": "text/plain", ".html": "text/html", ".css": "text/css", ".js": "text/javascript",
      ".svg": "image/svg+xml", ".ini": "text/plain", ".xcu": "application/xml", ".xcd": "application/xml"}
payload = []
for d, _, names in os.walk(files):
    for n in names:
        full = os.path.join(d, n)
        rel = os.path.relpath(full, files).replace(os.sep, "/")
        if rel in ("AppxManifest.xml",) or rel.lower().endswith((".pdb", ".lib", ".exp", ".ilk")):
            continue   # debug and link files are not needed to run
        payload.append(rel)
payload.sort(); payload.insert(0, "AppxManifest.xml")

defaults, overrides = {}, []
for rel in payload:
    ext = os.path.splitext(rel)[1].lower()
    if ext and re.fullmatch(r"\.[A-Za-z0-9]+", ext):
        defaults.setdefault(ext[1:], CT.get(ext, "application/octet-stream"))
    elif rel != "AppxManifest.xml":
        overrides.append(rel)
ct = ['<?xml version="1.0" encoding="UTF-8" standalone="yes"?>',
      '<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">']
for e, t in sorted(defaults.items()):
    ct.append('<Default Extension="%s" ContentType="%s"/>' % (e, t))
for rel in overrides:
    ct.append('<Override PartName="/%s" ContentType="application/octet-stream"/>' % quote(rel))
ct.append('<Override PartName="/AppxManifest.xml" ContentType="application/vnd.ms-appx.manifest+xml"/>')
ct.append('<Override PartName="/AppxBlockMap.xml" ContentType="application/vnd.ms-appx.blockmap+xml"/>')
ct.append("</Types>")

BLOCK = 65536
block_xml = []
with zipfile.ZipFile(a.out + ".tmp", "w", zipfile.ZIP_STORED, allowZip64=True) as z:
    z.writestr(zipfile.ZipInfo("[Content_Types].xml", (2026, 1, 1, 0, 0, 0)), "\n".join(ct))
    for rel in payload:
        full = os.path.join(files, rel)
        zi = zipfile.ZipInfo(quote(rel), (2026, 1, 1, 0, 0, 0)); zi.compress_type = zipfile.ZIP_STORED
        size = os.path.getsize(full)
        blocks = []
        with open(full, "rb") as src, z.open(zi, "w", force_zip64=size > 0x7FFFFFFF) as dst:
            while True:
                chunk = src.read(BLOCK)
                if not chunk:
                    break
                blocks.append(base64.b64encode(hashlib.sha256(chunk).digest()).decode())
                dst.write(chunk)
        lfh = 30 + len(zi.filename.encode("utf-8")) + (len(zi.extra) if zi.extra else 0)
        block_xml.append('<File Name="%s" Size="%d" LfhSize="%d">%s</File>' % (
            escape(rel.replace("/", "\\"), {'"': "&quot;"}), size, lfh,
            "".join('<Block Hash="%s"/>' % h for h in blocks)))
    bm = ('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'
          '<BlockMap xmlns="http://schemas.microsoft.com/appx/2010/blockmap" HashMethod="http://www.w3.org/2001/04/xmlenc#sha256">'
          + "".join(block_xml) + "</BlockMap>")
    z.writestr(zipfile.ZipInfo("AppxBlockMap.xml", (2026, 1, 1, 0, 0, 0)), bm)
os.replace(a.out + ".tmp", a.out)
print("wrote", a.out, os.path.getsize(a.out), "bytes,", len(payload), "files")
