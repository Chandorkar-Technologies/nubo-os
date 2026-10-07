#!/usr/bin/env python3
"""Apply the Nubo Office names to a checkout of Collabora's monorepo.

Usage: rebrand.py CHECKOUT [--version X.Y.Z] [--report]

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
                    subprocess.run(["rsvg-convert", "-w", str(px), "-h", str(px), icon_svg, "-o", path], check=True)
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


def metainfo(root, here, version):
    """Our own AppStream file replaces Collabora's (name, text, links, screenshots)."""
    path = os.path.join(root, "qt", APP_ID + ".metainfo.xml")
    if not os.path.isdir(os.path.join(root, "qt")):
        return False
    text = open(os.path.join(here, APP_ID + ".metainfo.xml"), encoding="utf-8").read()
    import datetime
    text = text.replace("@VERSION@", version).replace("@DATE@", datetime.date.today().isoformat())
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
    changed = sum(rewrite(p) for p in files(root))
    renamed = rename_files(root)
    icons = replace_icons(root, os.path.join(here, "icons", "tech.nubosuite.Office.svg"))
    manifest = flatpak_manifest(root, os.path.join(here, "brand"))
    version = sys.argv[sys.argv.index("--version") + 1] if "--version" in sys.argv else "0.0.0"
    meta = metainfo(root, here, version)
    slides = welcome(root)
    defaults(root)
    about_credit(root)
    art = welcome_art(root, os.path.join(here, "brand", "welcome"))
    logos = logo_images(root, os.path.join(here, "brand", "images", "toolbar-bg-logo-dark.svg"))
    print("lines changed: %d, files renamed: %d, icons redrawn: %d, flatpak manifest: %s, metainfo: %s, logo images: %d, welcome texts: %d, welcome pictures: %d"
          % (changed, renamed, icons, manifest, meta, logos, slides, art))
    report(root)
    return 0


if __name__ == "__main__":
    sys.exit(main())
