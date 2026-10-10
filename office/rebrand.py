#!/usr/bin/env python3
"""Apply the Nubo Office names to a checkout of Collabora's monorepo.

Usage: rebrand.py CHECKOUT [--version X.Y.Z] [--platform linux|macos|windows] [--report]

Run on a fresh checkout of the release we build (for example tag coda-26.04.3.3-1).
It is safe to run twice. It never touches:
  - copyright, licence, SPDX or "part of the ... project" lines,
  - translations (browser/po, browser/l10n, qt/translations),
  - tests, and third-party code.
Marks are replaced in the desktop app (qt/) and the web interface (browser/).
The engine takes its name from configure (--with-product-name, --with-vendor).
--report only lists what is left afterwards.
"""

import os
import re
import shutil
import subprocess
import sys

NAME = "Nubo Office"
CREDIT = "Built on Collabora Online and LibreOffice technology"   # attribution; never renamed
APP_ID = "tech.nubosuite.Office"
HOME = "https://os.nubosuite.tech"
DOCS = "https://docs.nubosuite.tech/"
ISSUES = "https://github.com/Chandorkar-Technologies/nubo-os/issues"

ROOTS = ("qt", "browser")
SKIP_DIRS = {"node_modules", "l10n", "po", "translations", "test", "mocha_tests", "dist", ".git", "cypress_test"}
TEXT_EXT = {".ts", ".tsx", ".js", ".jsx", ".mjs", ".html", ".m4", ".css", ".cpp", ".hpp", ".xml", ".desktop", ".json", ".am", ".md", ".py", ".in", ".svg"}
KEEP_LINE = re.compile(r"copyright|licen[cs]e|spdx|part of the .* project|\(C\)", re.I)

# Ordered: specific before general.
TEXT_RULES = [
    ("Collabora Online Development Edition (unbranded)", NAME),
    ("Collabora Online Development Edition", NAME),
    ("https://help.collaboraoffice.com/", DOCS),
    ("https://forum.collaboraonline.com", DOCS),
    ("https://github.com/CollaboraOnline/online/issues", ISSUES),
    ("https://www.collaboraonline.com/", HOME),
    ("https://collaboraonline.com", HOME),
    ("https://www.collaboraoffice.com", HOME),
    ("https://collaboraoffice.com", HOME),
    ("/com/collaboraoffice/Office", "/tech/nubosuite/Office"),
    ("com.collaboraoffice.Office", APP_ID),
    ("collaboraoffice-startcenter", "nubosuite-startcenter"),
    ("https://www.collaboraoffice.org/post/faq/", DOCS),
    ("Collabora Office", NAME),
    ("Collabora Online", NAME),
]


def files(root):
    for base in ROOTS:
        for d, dirs, names in os.walk(os.path.join(root, base)):
            dirs[:] = [x for x in dirs if x not in SKIP_DIRS]
            for n in names:
                if os.path.splitext(n)[1] in TEXT_EXT or n.startswith("com.collaboraoffice"):
                    yield os.path.join(d, n)


def rewrite(path):
    try:
        text = open(path, encoding="utf-8").read()
    except (UnicodeDecodeError, OSError):
        return 0
    out, changed = [], 0
    for line in text.split("\n"):
        new = line
        if not KEEP_LINE.search(line) and CREDIT not in line:
            for old, rep in TEXT_RULES:
                new = new.replace(old, rep)
        changed += new != line
        out.append(new)
    if changed:
        open(path, "w", encoding="utf-8").write("\n".join(out))
    return changed


def rename_files(root):
    n = 0
    for d, _dirs, names in os.walk(os.path.join(root, "qt")):
        if os.path.basename(d) in SKIP_DIRS:
            continue
        for name in names:
            if "com.collaboraoffice.Office" in name:
                src = os.path.join(d, name)
                dst = os.path.join(d, name.replace("com.collaboraoffice.Office", APP_ID))
                subprocess.run(["git", "-C", root, "mv", "-f", os.path.relpath(src, root), os.path.relpath(dst, root)], check=False)
                if os.path.exists(src):
                    os.rename(src, dst)
                n += 1
    return n


def replace_icons(root, icon_svg):
    """The start-centre icon is Collabora artwork: draw ours at every size it ships."""
    n = 0
    for d, _dirs, names in os.walk(os.path.join(root, "qt")):
        for name in names:
            if name.startswith(APP_ID + ".startcenter"):
                path = os.path.join(d, name)
                if name.endswith(".svg"):
                    shutil.copy(icon_svg, path)
                elif name.endswith(".png"):
                    size = re.search(r"(\d+)x\d+", path)
                    px = int(size.group(1)) if size else 128
                    if shutil.which("rsvg-convert"):
                        subprocess.run(["rsvg-convert", "-w", str(px), "-h", str(px), icon_svg, "-o", path], check=True)
                    else:   # inside the Flathub sandbox: use the pictures drawn from the same SVG ahead of time
                        shutil.copy(os.path.join(os.path.dirname(os.path.abspath(icon_svg)), "png", "Office-%d.png" % px), path)
                n += 1
    return n


def flatpak_manifest(root, brand_dir):
    path = os.path.join(root, "qt", "flatpak", APP_ID + ".json")
    if not os.path.exists(path):
        return False
    text = open(path, encoding="utf-8").read()
    # Collabora's brand pack is proprietary: use ours, shipped inside the checkout.
    dest = os.path.join(root, "qt", "brand-nubo")
    if os.path.isdir(dest):
        shutil.rmtree(dest)
    shutil.copytree(brand_dir, dest)
    # Collabora's manifest uses Node 20, whose WebAssembly crashes ("Fatal JavaScript invalid size
    # error") when esbuild minifies the web interface here. Node 22 runs it every time.
    text = text.replace("org.freedesktop.Sdk.Extension.node20", "org.freedesktop.Sdk.Extension.node22") \
               .replace("/usr/lib/sdk/node20/bin", "/usr/lib/sdk/node22/bin")
    # The engine is built inside the Flatpak: give it our product name and vendor.
    text = text.replace("--with-distro=CPLinuxQtFlatpak",
                        "--with-distro=CPLinuxQtFlatpak --with-product-name='Nubo Office' --with-vendor=Nubo")
    if '"name": "collabora-office-branding"' not in text:   # already switched to our pack
        open(path, "w", encoding="utf-8").write(text)
        return True
    start = text.index('"name": "collabora-office-branding"')
    start = text.rindex("{", 0, start)
    end = text.index("\n    }\n", start) + len("\n    }\n")
    module = '''{
      "name": "nubo-office-branding",
      "buildsystem": "simple",
      "build-commands": [
        "cp -a branding* images /app/share/coolwsd/browser/dist/"
      ],
      "sources": [
        { "type": "dir", "path": "../brand-nubo" }
      ]
    }
'''
    text = text[:start] + module + text[end:]
    open(path, "w", encoding="utf-8").write(text)
    return True


def installer_product(root):
    """The engine's packaging step looks its product up by the configured name
    (--with-product-name 'Nubo Office' -> NuboOffice) in this list, so rename the entry."""
    path = os.path.join(root, "engine", "instsetoo_native", "util", "openoffice.lst.in")
    if not os.path.exists(path):
        return False
    text = open(path, encoding="utf-8").read()
    out = text.replace("CollaboraOffice", "NuboOffice").replace("PRODUCTNAME Collabora Office", "PRODUCTNAME Nubo Office")
    if out != text:
        open(path, "w", encoding="utf-8").write(out)
    return "NuboOffice" in out


def macos_app(root, icon_svg):
    """The macOS app (macos/coda): its visible labels, and the app icon set, in our names."""
    base = os.path.join(root, "macos", "coda")
    if not os.path.isdir(base):
        return (0, 0)
    exts = {".swift", ".mm", ".h", ".plist", ".in", ".xcconfig", ".strings"}
    changed = 0
    for d, dirs, names in os.walk(base):
        dirs[:] = [x for x in dirs if x not in SKIP_DIRS and not x.endswith((".xcodeproj", "Tests", "UITests"))]
        for n in names:
            if os.path.splitext(n)[1] in exts or n.endswith(".in"):
                changed += rewrite(os.path.join(d, n))
    icons = 0
    iconset = os.path.join(base, "coda", "Assets.xcassets", "AppIcon.appiconset")
    if os.path.isdir(iconset):
        for name in os.listdir(iconset):
            m = re.match(r"icon_(\d+)x\d+(@2x)?\.png$", name)
            if m:
                px = int(m.group(1)) * (2 if m.group(2) else 1)
                subprocess.run(["rsvg-convert", "-w", str(px), "-h", str(px), icon_svg, "-o", os.path.join(iconset, name)], check=True)
                icons += 1
    return (changed, icons)


def windows_app(root, icon_svg):
    """The Windows app (windows/coda): package names, publisher, the icon and the tile logos, in our names."""
    base = os.path.join(root, "windows", "coda")
    if not os.path.isdir(base):
        return (0, 0)
    changed = 0
    for rel in ("AppxManifest.xml.in", "package_appx.py", os.path.join("CODA", "CODA.cpp"), os.path.join("build", "orchestrator.mk")):
        path = os.path.join(base, rel)
        if not os.path.exists(path):
            continue
        text = open(path, encoding="utf-8", errors="surrogateescape").read()
        out = text
        for old, rep in (
            ('Publisher="CN=E9F172FF-9203-4DB8-A589-184C7A58C071"', 'Publisher="CN=Nubo"'),    # must match the certificate we sign with
            ("Collabora Productivity Ltd", "Nubo"),
            ("CollaboraProductivityLtd.CollaboraOfficeDesktop", "Nubo.NuboOffice"),
            ("Collabora Office Desktop", NAME),
            ("Collabora Office.exe", NAME + ".exe"),
        ):
            out = out.replace(old, rep)
        out = "\n".join(l if KEEP_LINE.search(l) else _apply_rules(l) for l in out.split("\n"))
        if out != text:
            open(path, "w", encoding="utf-8", errors="surrogateescape").write(out)
            changed += 1
    icons = 0
    assets = os.path.join(base, "Assets")
    sizes = {"Square150x150Logo.png": 150, "Square44x44Logo.png": 44, "logo.png": 50}
    if os.path.isdir(assets):
        for name in os.listdir(assets):
            m = re.search(r"targetsize-(\d+)\.png$", name)
            px = int(m.group(1)) if m else sizes.get(name)
            if px:
                subprocess.run(["rsvg-convert", "-w", str(px), "-h", str(px), icon_svg, "-o", os.path.join(assets, name)], check=True)
                icons += 1
    ico = os.path.join(base, "CODA", "CODA.ico")
    if os.path.exists(ico):
        tmp = []
        for px in (16, 24, 32, 48, 64, 128, 256):
            f = "/tmp/nubo-ico-%d.png" % px
            subprocess.run(["rsvg-convert", "-w", str(px), "-h", str(px), icon_svg, "-o", f], check=True)
            tmp.append(f)
        from PIL import Image
        Image.open(tmp[-1]).save(ico, format="ICO", sizes=[(16, 16), (24, 24), (32, 32), (48, 48), (64, 64), (128, 128), (256, 256)])
        icons += 1
    return (changed, icons)


def _apply_rules(line):
    for old, rep in TEXT_RULES:
        line = line.replace(old, rep)
    return line


def metainfo(root, here, version):
    """Our own AppStream file replaces Collabora's (name, text, links, screenshots)."""
    path = os.path.join(root, "qt", APP_ID + ".metainfo.xml")
    if not os.path.isdir(os.path.join(root, "qt")):
        return False
    text = open(os.path.join(here, APP_ID + ".metainfo.xml"), encoding="utf-8").read()
    import datetime
    text = text.replace("@VERSION@", version).replace("@DATE@", os.environ.get("NUBO_RELEASE_DATE") or datetime.date.today().isoformat())
    open(path, "w", encoding="utf-8").write(text)
    return True


def logo_images(root, white_logo):
    """Collabora-named logo images in the web interface get our mark."""
    n = 0
    for d, _dirs, names in os.walk(os.path.join(root, "browser", "images")):
        for name in names:
            if name.startswith("collabora-office"):
                shutil.copy(white_logo, os.path.join(d, name))
                n += 1
    return n


WELCOME = {
    "welcome-slide1-heading-1": "Welcome to Nubo Office",
    "welcome-slide1-heading-2": "Write, calculate and present",
    "welcome-slide1-content": "Nubo Write, Nubo Cells, Nubo Present and Nubo Draw open and save the files you already have, in Microsoft Office and OpenDocument formats.",
    "welcome-slide2-heading-1": "One suite, four apps",
    "welcome-slide2-heading-2": "Nubo Office",
    "welcome-slide2-content": "Write letters and reports, build spreadsheets, make presentations and draw diagrams, all in one place.",
    "welcome-slide3-heading-1": "Work together",
    "welcome-slide3-heading-2": "Comments and shared editing",
    "welcome-slide3-content": "Leave comments, track changes and review other people's edits. With a Nubo server, several people can edit the same document at once.",
}


def welcome(root):
    """First-run slides: our words, no Collabora links."""
    path = os.path.join(root, "browser", "welcome", "welcome.html")
    if not os.path.exists(path):
        return 0
    text = open(path, encoding="utf-8").read()
    n = 0
    for ident, inner in WELCOME.items():
        pat = re.compile(r'(<(h1|h2|p) id="%s"[^>]*>)(.*?)(</\2>)' % re.escape(ident), re.S)
        text, k = pat.subn(lambda m: m.group(1) + inner + m.group(4), text)
        n += k
    text = re.sub(r'<a id="view-supported-versions"[^>]*></a>', "", text)
    open(path, "w", encoding="utf-8").write(text)
    return n


def welcome_art(root, art_dir):
    """Our welcome pictures replace Collabora's (only the ones we have)."""
    n = 0
    dest = os.path.join(root, "browser", "welcome")
    if os.path.isdir(art_dir) and os.path.isdir(dest):
        for name in os.listdir(art_dir):
            if name.endswith(".png"):
                shutil.copy(os.path.join(art_dir, name), os.path.join(dest, name))
                n += 1
    return n


def defaults(root):
    """Product defaults: hide the macro-author notice about the legacy UNO interface."""
    n = 0
    path = os.path.join(root, "common", "ConfigUtil.cpp")
    if os.path.exists(path):
        text = open(path, encoding="utf-8").read()
        out = text.replace('{ "hide_legacy_script_warning", "false" }', '{ "hide_legacy_script_warning", "true" }')
        if out != text:
            open(path, "w", encoding="utf-8").write(out)
            n += 1
    # The desktop app never gets the server's setting, so the front end hides it there itself.
    path = os.path.join(root, "browser", "src", "control", "Control.UIManager.ts")
    if os.path.exists(path):
        text = open(path, encoding="utf-8").read()
        out = text.replace("if (window.hideLegacyScriptWarning) return;",
                           "if (window.hideLegacyScriptWarning || window.mode.isCODesktop()) return;")
        if out != text:
            open(path, "w", encoding="utf-8").write(out)
            n += 1
    return n


def about_credit(root):
    """The About window credits the technology it is built on (the licence asks us to keep attribution)."""
    path = os.path.join(root, "browser", "src", "control", "Control.AboutDialog.ts")
    if not os.path.exists(path):
        return 0
    text = open(path, encoding="utf-8").read()
    if CREDIT in text:
        return 0
    anchor = "productNameElement.innerText = productName;\n"
    if anchor not in text:
        return 0
    add = (anchor + "\t\tconst nuboCredit = document.createElement('div');\n"
           "\t\tnuboCredit.id = 'nubo-credit';\n"
           "\t\tnuboCredit.textContent = '%s';\n"
           "\t\tcontent.appendChild(nuboCredit);\n" % CREDIT)
    open(path, "w", encoding="utf-8").write(text.replace(anchor, add, 1))
    return 1


def report(root):
    pat = re.compile(r"collabora|libreoffice", re.I)
    left = {}
    for path in files(root):
        try:
            for i, line in enumerate(open(path, encoding="utf-8"), 1):
                if pat.search(line) and not KEEP_LINE.search(line):
                    left.setdefault(os.path.relpath(path, root), []).append(i)
        except (UnicodeDecodeError, OSError):
            pass
    for p, lines in sorted(left.items()):
        print("%-60s %d lines (first %d)" % (p, len(lines), lines[0]))
    print("files still naming Collabora or LibreOffice:", len(left))


def main():
    if len(sys.argv) < 2:
        print(__doc__)
        return 2
    root = os.path.abspath(sys.argv[1])
    here = os.path.dirname(os.path.abspath(__file__))
    if "--report" in sys.argv:
        report(root)
        return 0
    platform = sys.argv[sys.argv.index("--platform") + 1] if "--platform" in sys.argv else "linux"
    if platform == "macos":
        icon_svg = os.path.join(here, "icons", "tech.nubosuite.Office.svg")
        labels, icons = macos_app(root, icon_svg)
        print("macOS app: %d lines changed, %d icon sizes redrawn" % (labels, icons))
        return 0
    if platform == "windows":
        icon_svg = os.path.join(here, "icons", "tech.nubosuite.Office.svg")
        labels, icons = windows_app(root, icon_svg)
        print("Windows app: %d files changed, %d icon files redrawn" % (labels, icons))
        return 0
    changed = sum(rewrite(p) for p in files(root))
    renamed = rename_files(root)
    icons = replace_icons(root, os.path.join(here, "icons", "tech.nubosuite.Office.svg"))
    manifest = flatpak_manifest(root, os.path.join(here, "brand"))
    version = sys.argv[sys.argv.index("--version") + 1] if "--version" in sys.argv else "0.0.0"
    product = installer_product(root)
    meta = metainfo(root, here, version)
    slides = welcome(root)
    defaults(root)
    about_credit(root)
    art = welcome_art(root, os.path.join(here, "brand", "welcome"))
    logos = logo_images(root, os.path.join(here, "brand", "images", "toolbar-bg-logo-dark.svg"))
    print("lines changed: %d, files renamed: %d, icons redrawn: %d, flatpak manifest: %s, installer product: %s, metainfo: %s, logo images: %d, welcome texts: %d, welcome pictures: %d"
          % (changed, renamed, icons, manifest, product, meta, logos, slides, art))
    report(root)
    return 0


if __name__ == "__main__":
    sys.exit(main())
