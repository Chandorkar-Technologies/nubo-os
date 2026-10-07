#!/usr/bin/env python3
"""Build the two Nubo websites into website/dist/.

  dist/www/  -> https://nubosuite.tech      (company, apps, legal)
  dist/os/   -> https://os.nubosuite.tech   (Nubo OS: desktop story, server, downloads)

The two animated front pages come from src/page.tpl.html (one scroll story each).
Everything else is generated here. All files are self-hosted: no third-party requests.
Run:  python3 build.py
"""
import base64, glob, html, json, os, re, shutil, sys
from datetime import date

ROOT = os.path.dirname(os.path.abspath(__file__))
SRC = os.path.join(ROOT, 'src')
DIST = os.path.join(ROOT, 'dist')
NM = os.path.join(ROOT, 'node_modules')
sys.path.insert(0, ROOT)
import pages  # static page content

SITES = {
    'www': {'host': 'https://nubosuite.tech', 'name': 'Nubo Suite'},
    'os': {'host': 'https://os.nubosuite.tech', 'name': 'Nubo OS'},
}
TODAY = date.today().isoformat()
REL = json.load(open(os.path.join(ROOT, 'data', 'releases.json')))
OFFICE = json.load(open(os.path.join(ROOT, 'data', 'office.json')))


def rd(p, mode='r'):
    with open(p, mode) as f:
        return f.read()


def wr(p, s, mode='w'):
    os.makedirs(os.path.dirname(p), exist_ok=True)
    with open(p, mode) as f:
        f.write(s)


# ------------------------------------------------------------------ assets
IMG_JPG = ['dunes', 'dusk', 'mist', 'night', 'ridge', 'pastel', 'pplb', 'pplp', 'pplt',
           'desktop', 'grid1', 'grid2', 'notif', 'quick', 'about', 'login']
IMG_PNG = {'win': 'win', 'notif_hi': 'notifp', 'clock': 'clock', 'quick': 'quickp', 'dock': 'dock', 'bar': 'bar'}
WALL = {'dunes', 'dusk', 'mist', 'night', 'ridge', 'pastel'}


def image_vars():
    """CSS custom properties: --i-<wallpaper> and --r-<screen>."""
    v, files = [], []
    for n in IMG_JPG:
        key = ('i-' + n) if (n in WALL or n.startswith('ppl')) else ('r-' + n)
        v.append('--%s:url(/assets/img/%s.jpg)' % (key, n))
        files.append((os.path.join(SRC, 'img', n + '.jpg'), n + '.jpg'))
    for n, key in IMG_PNG.items():
        v.append('--r-%s:url(/assets/img/%s.png)' % (key, n))
        files.append((os.path.join(SRC, 'img', n + '.png'), n + '.png'))
    return ':root{' + ';'.join(v) + '}', files


def svg_uri(txt):
    return 'data:image/svg+xml;base64,' + base64.b64encode(txt.encode()).decode()


def icon_map(used_ic, used_sym):
    symmap = {os.path.basename(f)[:-13]: f for f in glob.glob(os.path.join(SRC, 'sym', '**', '*-symbolic.svg'), recursive=True)}
    out = {}
    for n in used_ic | {'org.gnome.Geary', 'libreoffice-writer', 'firefox', 'org.gnome.Settings'}:
        out[n] = svg_uri(rd(os.path.join(SRC, 'icons', n + '.svg')))
    for n in used_sym | {'applications-engineering', 'security-high', 'computer', 'emblem-system', 'drive-harddisk', 'channel-secure'}:
        svg = rd(symmap[n])
        svg = re.sub(r'fill="#[0-9a-fA-F]{3,8}"', 'fill="#F5F5F7"', svg)
        svg = re.sub(r'fill:#[0-9a-fA-F]{3,8}', 'fill:#F5F5F7', svg)
        if 'fill=' not in svg and 'fill:' not in svg:
            svg = svg.replace('<path ', '<path fill="#F5F5F7" ')
        out['sym:' + n] = svg_uri(svg)
    return out


FONT_CSS = """
@font-face{font-family:Inter;font-style:normal;font-weight:100 900;font-display:swap;src:url(/assets/fonts/inter.woff2) format('woff2')}
@font-face{font-family:'Noto Sans Devanagari';font-weight:500;font-display:swap;src:url(/assets/fonts/dev500.woff2) format('woff2')}
@font-face{font-family:'Noto Sans Devanagari';font-weight:700;font-display:swap;src:url(/assets/fonts/dev700.woff2) format('woff2')}
@font-face{font-family:'Noto Sans Arabic';font-weight:500;font-display:swap;src:url(/assets/fonts/ar500.woff2) format('woff2')}
@font-face{font-family:'Noto Sans Arabic';font-weight:700;font-display:swap;src:url(/assets/fonts/ar700.woff2) format('woff2')}
"""
FONT_FILES = [
    (NM + '/@fontsource-variable/inter/files/inter-latin-wght-normal.woff2', 'inter.woff2'),
    (NM + '/@fontsource/noto-sans-devanagari/files/noto-sans-devanagari-devanagari-500-normal.woff2', 'dev500.woff2'),
    (NM + '/@fontsource/noto-sans-devanagari/files/noto-sans-devanagari-devanagari-700-normal.woff2', 'dev700.woff2'),
    (NM + '/@fontsource/noto-sans-arabic/files/noto-sans-arabic-arabic-500-normal.woff2', 'ar500.woff2'),
    (NM + '/@fontsource/noto-sans-arabic/files/noto-sans-arabic-arabic-700-normal.woff2', 'ar700.woff2'),
]


def copy_assets(site, files):
    base = os.path.join(DIST, site, 'assets')
    for src, name in files:
        os.makedirs(os.path.join(base, 'img'), exist_ok=True)
        shutil.copy(src, os.path.join(base, 'img', name))
    for src, name in FONT_FILES:
        os.makedirs(os.path.join(base, 'fonts'), exist_ok=True)
        shutil.copy(src, os.path.join(base, 'fonts', name))
    os.makedirs(os.path.join(base, 'js'), exist_ok=True)
    shutil.copy(NM + '/gsap/dist/gsap.min.js', os.path.join(base, 'js', 'gsap.min.js'))
    shutil.copy(NM + '/gsap/dist/ScrollTrigger.min.js', os.path.join(base, 'js', 'ScrollTrigger.min.js'))
    office = os.path.join(SRC, 'office')
    if os.path.isdir(office):
        os.makedirs(os.path.join(base, 'office'), exist_ok=True)
        for n in os.listdir(office):
            shutil.copy(os.path.join(office, n), os.path.join(base, 'office', n))
    shutil.copy(os.path.join(SRC, 'favicon.svg'), os.path.join(DIST, site, 'favicon.svg'))
    shutil.copy(os.path.join(SRC, 'og.jpg'), os.path.join(DIST, site, 'assets', 'og.jpg'))


# ------------------------------------------------------------------ shared chrome
def nav_html(site):
    if site == 'www':
        links = [('Nubo OS', 'https://os.nubosuite.tech/'), ('Server', 'https://os.nubosuite.tech/server/'),
                 ('Office', '/office/'), ('Apps', '/apps/'), ('Email', 'https://nubo.email'), ('Docs', 'https://docs.nubosuite.tech/')]
        dl = '<a class="dl" href="https://os.nubosuite.tech/download/">Download</a>'
        name = 'Nubo Suite'
    else:
        links = [('Desktop', '/'), ('Server', '/server/'), ('Releases', '/releases/'),
                 ('Office', 'https://nubosuite.tech/office/'), ('Docs', 'https://docs.nubosuite.tech/'), ('Suite', 'https://nubosuite.tech/')]
        dl = '<a class="dl" href="/download/">Download</a>'
        name = 'Nubo OS'
    a = ''.join('<a class="hide" href="%s">%s</a>' % (h, t) for t, h in links)
    return ('<div class="nav"><a class="brand" href="/"><svg class="mk"><use href="#mark"/></svg><span id="navname">%s</span></a>%s%s</div>'
            % (name, a, dl))


def footer_html(photos=False):
    cols = [
        ('Nubo OS', [('Desktop', 'https://os.nubosuite.tech/'), ('Server', 'https://os.nubosuite.tech/server/'),
                     ('Download', 'https://os.nubosuite.tech/download/'), ('Releases', 'https://os.nubosuite.tech/releases/')]),
        ('Nubo Suite', [('Nubo Office', 'https://nubosuite.tech/office/'), ('All apps', 'https://nubosuite.tech/apps/'), ('Nubo Email', 'https://nubo.email'),
                        ('Nubo Send', 'https://send.nubosuite.tech/')]),
        ('Learn', [('Documentation', 'https://docs.nubosuite.tech/'), ('Install guide', 'https://docs.nubosuite.tech/desktop/get-started/'),
                   ('Server guide', 'https://docs.nubosuite.tech/server/'), ('FAQ', 'https://docs.nubosuite.tech/start/faq/')]),
        ('Company', [('About', 'https://nubosuite.tech/about/'), ('Contact', 'https://nubosuite.tech/contact/'),
                     ('Security', 'https://nubosuite.tech/security/'), ('Privacy', 'https://nubosuite.tech/privacy/'),
                     ('Terms', 'https://nubosuite.tech/terms/'), ('Source code', 'https://github.com/Chandorkar-Technologies/nubo-os')]),
    ]
    c = ''.join('<div class="fcol"><b>%s</b>%s</div>' % (t, ''.join('<a href="%s">%s</a>' % (h, n) for n, h in links)) for t, links in cols)
    return ('<footer class="foot2"><div class="fwrap"><div class="fcols">%s</div>'
            '<p class="flegal">&copy; 2026 Chandorkar Technologies. Nubo and the Nubo mark are trademarks of Chandorkar Technologies. '
            'Nubo OS is built on Ubuntu 26.04 LTS; Ubuntu is a trademark of Canonical Ltd and is used here only to name the base system. '
            'App names and icons belong to their owners. %sEarly access builds may change.</p></div></footer>' % (c, 'Portraits in the call mock-up are CC0 images from Wikimedia Commons. Wallpaper credits are in the documentation. ' if photos else ''))


def head_html(site, path, title, desc, extra_json=None, css_vars='', inline_css=''):
    host = SITES[site]['host']
    url = host + path
    ld = ''
    if extra_json:
        ld = '<script type="application/ld+json">%s</script>' % json.dumps(extra_json)
    return f"""<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover">
<title>{html.escape(title)}</title>
<meta name="description" content="{html.escape(desc)}">
<link rel="canonical" href="{url}">
<link rel="icon" href="/favicon.svg" type="image/svg+xml">
<meta name="theme-color" content="#050608">
<meta property="og:type" content="website">
<meta property="og:site_name" content="{SITES[site]['name']}">
<meta property="og:title" content="{html.escape(title)}">
<meta property="og:description" content="{html.escape(desc)}">
<meta property="og:url" content="{url}">
<meta property="og:image" content="{host}/assets/og.jpg">
<meta property="og:image:width" content="1200"><meta property="og:image:height" content="630">
<meta name="twitter:card" content="summary_large_image">
<meta name="twitter:title" content="{html.escape(title)}">
<meta name="twitter:description" content="{html.escape(desc)}">
<meta name="twitter:image" content="{host}/assets/og.jpg">
{ld}
<style>{FONT_CSS}{css_vars}</style>
{inline_css}
</head>"""


# ------------------------------------------------------------------ the animated front pages
def downloads_section():
    return """<section class="sec" id="download" style="padding:40px 24px 160px">
<div class="dlbox">
<div class="eyebrow">Download</div>
<h2 class="h2" style="margin-top:10px;font-size:clamp(40px,6vw,88px)">Nubo OS 1</h2>
<p class="lead" style="margin-top:14px">Free. The desktop is in early access. The server images are ready to download today.</p>
<div class="cta-row" style="justify-content:flex-start"><a class="btn" href="/download/#desktop" style="min-height:56px;padding:0 34px;font-size:18px">Get desktop early access</a><a class="btn2" href="/download/#server" style="min-height:56px">Download the server</a></div>
<div class="dlmeta"><span><b>Version</b> 1, early access</span><span><b>Desktop</b> request a build</span><span><b>Server</b> amd64 and arm64</span><span><b>Cost</b> free</span></div>
<div class="tabs" id="osTabs"><button class="on" data-t="win">Windows</button><button data-t="mac">macOS</button><button data-t="lin">Linux</button></div>
<div class="tabc" id="tabc"></div>
</div>
</section>
"""


def build_front(site):
    t = rd(os.path.join(SRC, 'page.tpl.html'))
    t = t.replace('%%MARK%%', rd(os.path.join(SRC, 'mark.symbol')))
    css_vars, files = image_vars()
    for n in WALL | {'pplb', 'pplp', 'pplt'}:
        t = t.replace('url(%%' + n + '%%)', 'var(--i-' + n + ')').replace('%%' + n + '%%', 'var(--i-' + n + ')')
    # icons
    used_ic = set(re.findall(r'src="%%ic:([A-Za-z0-9_.\-]+)%%"', t))
    used_sym = set(re.findall(r'src="%%sym:([A-Za-z0-9_.\-]+)%%"', t))
    t = re.sub(r'src="%%ic:([A-Za-z0-9_.\-]+)%%"', lambda m: 'data-ic="%s"' % m.group(1), t)
    t = re.sub(r'src="%%sym:([A-Za-z0-9_.\-]+)%%"', lambda m: 'data-sym="%s"' % m.group(1), t)
    t = t.replace('%%ICONJSON%%', json.dumps(icon_map(used_ic, used_sym)))
    left = re.findall(r'%%[^%]+%%', t)
    assert not left, left[:5]

    # split: keep one view
    keep, drop = ('home', 'os') if site == 'www' else ('os', 'home')
    a = t.index('<main id="%s"' % drop)
    b = t.index('</main>', a) + len('</main>')
    t = t[:a] + t[b:]
    t = t.replace('<main id="%s" hidden>' % keep, '<main id="%s">' % keep).replace('<main id="%s">' % keep, '<main id="%s">' % keep)

    # body chrome: replace the page switcher and nav
    a = t.index('<div class="nav">'); b = t.index('</div>', t.index('<a class="dl"', a)) + 6
    t = t[:a] + nav_html(site) + t[b:]
    t = re.sub(r'<div class="switch">.*?</div>\n', '', t, flags=re.S)
    # download bar and footers
    t = re.sub(r'<div class="dlbar" id="dlbar">.*?</div>\n',
               '<div class="dlbar" id="dlbar"><span><b>Nubo OS 1</b> &nbsp;·&nbsp; free</span><a class="btn" href="%s">Download</a></div>\n'
               % ('https://os.nubosuite.tech/download/' if site == 'www' else '/download/'), t, count=1, flags=re.S)
    t = re.sub(r'<div class="foot">.*?</p></div>\n(?=</main>)', lambda m: footer_html(True) + '\n', t, flags=re.S)

    # links that jumped between the two views
    if site == 'www':
        t = t.replace('href="#os" data-go="', 'href="https://os.nubosuite.tech/#').replace('href="#os"', 'href="https://os.nubosuite.tech/"')
        t = re.sub(r'href="https://os\.nubosuite\.tech/#([a-z]+)"', r'href="https://os.nubosuite.tech/#\1" data-ext="1"', t)
        t = t.replace('href="#home"', 'href="/"')
    else:
        t = t.replace('href="#os" data-go="', 'href="#" data-go="').replace('href="#os"', 'href="/"')
        t = t.replace('href="#home"', 'href="https://nubosuite.tech/"')
        # real download block
        a = t.index('<section class="sec" id="download"'); b = t.index('</section>', a) + len('</section>\n')
        t = t[:a] + downloads_section() + t[b:]

    if site == 'www':
        a = t.index('<section class="scene" id="hero"'); b = t.index('<div class="scr" id="heroScr"')
        t = t[:a] + """<section class="scene" id="hero" style="background:#050608">
<div class="txt">
<div class="eyebrow">Nubo Suite &nbsp;·&nbsp; private by design</div>
<h1 class="h1 grad" style="margin-top:14px">Private apps.<br>A system to match.</h1>
<p class="lead" style="margin:20px auto 0;text-align:center">Nubo Suite is the family behind Nubo OS, Nubo Email and a set of peer-to-peer apps. One Nubo ID, and your data stays yours.</p>
<div class="cta-row"><a class="btn" href="https://os.nubosuite.tech/" style="min-height:54px;padding:0 32px;font-size:18px">Explore Nubo OS</a><a class="btn2" href="/apps/" style="min-height:54px">See the apps</a></div>
<div class="trust"><i>Free to try</i><i>Open source OS</i><i>5 years of security updates</i><i>No ads, no trackers on our sites</i></div>
</div>
""" + t[b:]
        suite_cards = ''.join(
            '<%s class="nsc"%s><span class="nst %s">%s</span><b>%s</b><span class="nsv">%s</span><span>%s</span></%s>'
            % ('a' if url else 'div', ' href="%s"' % url if url else '', st, pages.STATUS[st], n, vs, d, 'a' if url else 'div')
            for n, vs, d, st, url in pages.SUITE)
        suite = ('<section class="sec" id="suite" style="padding:120px 24px 40px"><div class="wrap" style="max-width:1180px;margin:0 auto">'
                 '<div class="center"><div class="eyebrow">The family</div><h2 class="h2 grad" style="margin-top:12px;font-size:clamp(34px,5.4vw,78px)">One Nubo ID. Many private apps.</h2>'
                 '<p class="lead" style="margin:16px auto 0;text-align:center">Each app copies a category leader and removes the server in the middle. Statuses are as of today.</p></div>'
                 '<div class="nsg" style="margin-top:44px">'
                 '<a class="nsc big" href="https://os.nubosuite.tech/"><span class="nst live">Early access</span><b>Nubo OS</b><span>A free desktop and a minimal server, built on Ubuntu 26.04 LTS.</span></a>'
                 '<a class="nsc big" href="https://nubo.email"><span class="nst live">Live</span><b>Nubo Email</b><span>Privacy-first business email on JMAP, with calendar, drive, meetings and chat.</span></a>'
                 + suite_cards + '</div>'
                 '<div class="cta-row" style="margin-top:34px"><a class="btn2" href="/apps/">All apps and their status</a></div></div></section>\n')
        i = t.index('<section class="sec" id="midcta"')
        t = t[:i] + suite + t[i:]

    # honest copy
    reps = [
        ('A calm desktop with mail, calendar, chat, documents and files already set up.', 'A calm desktop with mail, calendar, documents and files ready to use.'),
        ('Sign in once and your mail, calendar, contacts and files are there. Run it from a USB stick first. Keep your PC exactly as it is.',
         'Mail, calendar, contacts and files are built in. Connect them with a Nubo account (early access). Run it from a USB stick first and keep your PC exactly as it is.'),
        ('<span>One image, 6.8 GB, free</span>', '<span>One image, free</span>'),
        ('Included and set up', 'Apps included; Nubo account connects them (early access)'),
        ('Shared mail, calendar and files from one account. No per-seat desktop licence.', 'Shared mail and calendar with Nubo Email, and no per-seat desktop licence.'),
    ]
    for old, new in reps:
        if old in t:
            t = t.replace(old, new)

    # script: one page per site, local assets
    t = t.replace('<script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.5/gsap.min.js"></script>', '<script src="/assets/js/gsap.min.js"></script>')
    t = t.replace('<script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.5/ScrollTrigger.min.js"></script>', '<script src="/assets/js/ScrollTrigger.min.js"></script>')
    t = t.replace("if (location.hash === '#os') { goTo(id); } else { pendingGo = id; location.hash = '#os'; }", "goTo(id);")
    t = t.replace("function route(){ show(location.hash === '#os' ? 'os' : 'home'); }",
                  "function route(){ show('%s'); var h = location.hash.replace('#',''); if (h && document.getElementById(h)) { setTimeout(function(){ goTo(h); }, 400); } }" % keep)
    t = t.replace("window.addEventListener('hashchange', route);", "")
    t = t.replace("q('#navname').textContent = page === 'os' ? 'Nubo OS' : 'Nubo Suite';", "")
    t = t.replace('window.scrollTo(0, 0);\n    if (ctx)', 'if (ctx)')

    # head: take the template <style> body, drop its Google fonts link and title
    style = re.search(r'<style>(.*?)</style>', t, re.S).group(1)
    body = t[t.index('<svg width="0"'):]
    sheet = style + CHROME_CSS
    if site == 'www':
        title = 'Nubo Suite: Nubo OS, Nubo Email and private apps'
        desc = 'Nubo Suite is the family behind Nubo OS, Nubo Email and a set of private peer-to-peer apps. Free to try.'
        ld = {'@context': 'https://schema.org', '@type': 'Organization', 'name': 'Chandorkar Technologies',
              'url': 'https://nubosuite.tech', 'logo': 'https://nubosuite.tech/favicon.svg',
              'sameAs': ['https://github.com/Chandorkar-Technologies/nubo-os']}
    else:
        title = 'Nubo OS: a calm desktop and a minimal server, free'
        desc = 'Nubo OS 1 is a free operating system built on Ubuntu 26.04 LTS: a desktop that sets itself up, and a minimal server in four editions. Five years of security updates.'
        ld = {'@context': 'https://schema.org', '@type': 'SoftwareApplication', 'name': 'Nubo OS', 'operatingSystem': 'Linux',
              'applicationCategory': 'OperatingSystem', 'url': 'https://os.nubosuite.tech',
              'offers': {'@type': 'Offer', 'price': '0', 'priceCurrency': 'USD'}, 'publisher': {'@type': 'Organization', 'name': 'Chandorkar Technologies'}}
    out = head_html(site, '/', title, desc, ld, css_vars, '<style>%s</style>' % sheet) + '\n<body>\n' + body
    out = out.replace('</body>', '').replace('</html>', '') + '\n</body>\n</html>\n'
    out = out.replace('<link rel="stylesheet" href="https://fonts.googleapis.com', '<!-- removed -->')
    wr(os.path.join(DIST, site, 'index.html'), out)
    return files


CHROME_CSS = """
.nsg{display:grid;grid-template-columns:repeat(auto-fill,minmax(250px,1fr));gap:14px}
.nsc{background:#0E1014;border:1px solid var(--line);border-radius:20px;padding:22px 22px 24px;display:flex;flex-direction:column;gap:7px;transition:transform .25s,border-color .25s;min-width:0}
a.nsc:hover{transform:translateY(-3px);border-color:rgba(242,166,90,.5)}
.nsc b{font-size:20px;color:#fff;letter-spacing:-.01em}.nsc span{color:var(--mu2);font-size:15px;line-height:1.5}
.nsc .nsv{color:#6E7380;font-size:13px}
.nsc.big{grid-column:span 2;background:linear-gradient(135deg,#17120c,#0E1014)}
@media(max-width:620px){.nsc.big{grid-column:auto}}
.nst{align-self:flex-start;font-size:12px;font-weight:600;padding:2px 10px;border-radius:999px;border:1px solid var(--line);color:var(--mu2);margin-bottom:4px}
.nst.live{color:var(--ok);border-color:rgba(127,224,168,.4)}.nst.beta{color:var(--amber);border-color:rgba(242,166,90,.4)}

.foot2{background:#050608;border-top:1px solid var(--line);padding:56px 24px 40px}
.fwrap{max-width:1180px;margin:0 auto}
.fcols{display:grid;grid-template-columns:repeat(4,minmax(0,1fr));gap:28px}
.fcol{display:flex;flex-direction:column;gap:9px;font-size:15px}
.fcol b{color:#fff;font-size:14px;letter-spacing:.02em;margin-bottom:4px}
.fcol a{color:var(--mu2)}.fcol a:hover{color:#fff}
.flegal{margin-top:34px;max-width:900px;font-size:12.5px;line-height:1.65;color:#6E7380}
@media(max-width:760px){.fcols{grid-template-columns:repeat(2,minmax(0,1fr))}}
"""


# ------------------------------------------------------------------ static pages
STATIC_CSS = """

/* Office story page: full-width sections in the same style as the front pages */
.story{padding:52px 0 0}
.o-sec{position:relative;overflow:hidden;padding:clamp(72px,10vw,140px) 24px;text-align:center;isolation:isolate}
.o-sec::before{content:"";position:absolute;z-index:-1;left:50%;top:44%;width:min(1100px,130vw);height:min(760px,90vw);transform:translate(-50%,-50%);background:radial-gradient(closest-side,color-mix(in srgb,var(--c,#2f6fde) 30%,transparent),transparent);opacity:.55;-webkit-mask-image:linear-gradient(to bottom,transparent,#000 22%,#000 62%,transparent);mask-image:linear-gradient(to bottom,transparent,#000 22%,#000 62%,transparent)}
.o-sec.plain::before{display:none}
.o-eyebrow{font-size:14px;font-weight:700;letter-spacing:.1em;text-transform:uppercase;color:var(--c,var(--amber))}
.o-h1{font-size:clamp(46px,8.4vw,112px);line-height:.98;letter-spacing:-.05em;font-weight:700;margin-top:16px}
.o-h2{font-size:clamp(36px,6vw,84px);line-height:1;letter-spacing:-.045em;font-weight:700;margin-top:14px}
.o-grad{background:linear-gradient(180deg,#fff 30%,#8f94a0 125%);-webkit-background-clip:text;background-clip:text;color:transparent}
.o-lead{font-size:clamp(18px,2vw,24px);line-height:1.4;color:var(--mu2);max-width:680px;margin:20px auto 0}
.o-row{display:flex;gap:12px;flex-wrap:wrap;justify-content:center;margin-top:28px}
.o-btn{display:inline-flex;align-items:center;justify-content:center;min-height:48px;padding:0 26px;border-radius:999px;background:#F5F5F7;color:#0A0B0E;font-weight:600;font-size:16px}
.o-btn2{display:inline-flex;align-items:center;justify-content:center;min-height:48px;padding:0 24px;border-radius:999px;border:1px solid rgba(255,255,255,.3);font-weight:500;font-size:16px}
.o-btn2:hover{background:rgba(255,255,255,.08)}
.o-dots{display:flex;gap:10px 22px;flex-wrap:wrap;justify-content:center;margin-top:26px;font-size:14px;color:var(--mu2)}
.o-dots span::before{content:"";display:inline-block;width:6px;height:6px;border-radius:50%;background:var(--ok);margin-right:8px;vertical-align:middle}
.o-frame{max-width:1120px;margin:clamp(40px,6vw,72px) auto 0;border-radius:18px;padding:1px;background:linear-gradient(180deg,rgba(255,255,255,.28),rgba(255,255,255,.04));box-shadow:0 40px 120px color-mix(in srgb,var(--c,#2f6fde) 35%,transparent),0 20px 60px rgba(0,0,0,.6)}
.o-frame img{display:block;width:100%;height:auto;border-radius:17px}
.o-cards{display:grid;grid-template-columns:repeat(auto-fit,minmax(240px,1fr));gap:16px;max-width:1040px;margin:48px auto 0;text-align:left}
.o-card{background:rgba(16,18,22,.8);border:1px solid var(--line);border-radius:20px;padding:24px;backdrop-filter:blur(8px)}
.o-card h4{margin:0 0 8px;font-size:18px;letter-spacing:-.01em}
.o-card p{margin:0;font-size:15px;color:var(--mu2);line-height:1.5}
.o-ico{width:84px;height:84px;display:block;margin:0 auto 6px;border-radius:21px;box-shadow:0 14px 40px rgba(0,0,0,.5)}
.o-fmts{display:flex;gap:8px;flex-wrap:wrap;justify-content:center;margin-top:22px}
.o-fmts i{font-style:normal;font-family:ui-monospace,Menlo,Consolas,monospace;font-size:13px;padding:5px 11px;border-radius:999px;border:1px solid var(--line);color:var(--mu2)}
.o-icons{display:flex;flex-wrap:wrap;gap:22px;justify-content:center;max-width:900px;margin:44px auto 0}
.o-icons figure{margin:0;width:104px;display:flex;flex-direction:column;align-items:center;gap:10px;font-size:14px;color:var(--mu2)}
.o-icons img{width:96px;height:96px;border-radius:24px;display:block;box-shadow:0 14px 40px rgba(0,0,0,.5)}
.o-narrow{max-width:960px;margin:44px auto 0;text-align:left}
.o-narrow h3{font-size:20px;margin:30px 0 8px}
.o-narrow p,.o-narrow li{color:var(--mu2);font-size:16px}
.o-two{display:grid;grid-template-columns:repeat(auto-fit,minmax(280px,1fr));gap:20px;max-width:900px;margin:44px auto 0}
.o-two img{width:100%;height:auto;border-radius:18px;border:1px solid var(--line);display:block;background:#fff}
@media(max-width:820px){.o-sec::before{opacity:.4}}
.shot{display:block;width:100%;height:auto;border-radius:14px;border:1px solid var(--line);box-shadow:0 24px 70px rgba(0,0,0,.5);background:var(--card)}
.hero-shot{margin-top:44px}
.cap{font-size:14px;color:var(--mu);margin-top:12px;text-align:center}
.split{display:grid;grid-template-columns:minmax(0,5fr) minmax(0,8fr);gap:clamp(24px,4vw,56px);align-items:center;margin:56px 0}
.split.rev{grid-template-columns:minmax(0,8fr) minmax(0,5fr)}.split.rev .txt{order:2}
.split .txt h3{font-size:26px;letter-spacing:-.02em;margin:14px 0 8px}
.split .txt p{color:var(--mu2);font-size:16px}
.split .txt ul{margin:14px 0 0;padding-left:20px;color:var(--mu2);font-size:15px}
.split .txt ul li{margin:6px 0}
.appicon{width:76px;height:76px;display:block;border-radius:19px;box-shadow:0 10px 30px rgba(0,0,0,.45)}
.fmts{font-family:ui-monospace,Menlo,Consolas,monospace;font-size:13px;color:var(--mu);margin-top:14px}
.iconrow{display:flex;flex-wrap:wrap;gap:18px 22px;margin-top:22px}
.iconrow figure{margin:0;display:flex;flex-direction:column;align-items:center;gap:8px;font-size:13px;color:var(--mu2);width:92px;text-align:center}
.iconrow img{width:76px;height:76px;border-radius:19px;display:block}
.pair2{display:grid;grid-template-columns:repeat(auto-fit,minmax(260px,1fr));gap:18px;margin-top:22px}
.pair2 img{width:100%;height:auto;border-radius:14px;border:1px solid var(--line);display:block;background:#fff}
@media(max-width:820px){.split,.split.rev{grid-template-columns:minmax(0,1fr)}.split.rev .txt{order:0}}
:root{--bg:#050608;--bg2:#0B0C10;--card:#101216;--line:rgba(255,255,255,.1);--tx:#F5F5F7;--mu:#86868B;--mu2:#A1A1A6;--amber:#F2A65A;--ok:#7FE0A8;color-scheme:dark}
*{box-sizing:border-box}
html,body{margin:0;background:var(--bg);color:var(--tx)}
body{font:400 17px/1.6 Inter,-apple-system,"Segoe UI",Roboto,Helvetica,Arial,sans-serif;-webkit-font-smoothing:antialiased;overflow-x:hidden}
a{color:inherit;text-decoration:none}
h1,h2,h3,p{margin:0}
.mk{width:1em;height:1em;fill:currentColor}
.nav{position:fixed;z-index:60;top:0;left:0;right:0;height:52px;display:flex;align-items:center;gap:clamp(14px,2.6vw,34px);padding:0 max(16px,calc((100vw - 1180px)/2));background:rgba(5,6,8,.78);backdrop-filter:saturate(180%) blur(20px);border-bottom:1px solid var(--line);font-size:14px}
.nav .brand{display:flex;align-items:center;gap:9px;font-weight:700;font-size:16px;margin-right:auto}.nav .brand .mk{font-size:24px}
.nav a.hide{color:var(--mu2)}.nav a.hide:hover{color:#fff}
.nav .dl{padding:7px 16px;border-radius:999px;background:#fff;color:#000;font-weight:600}
@media(max-width:820px){.nav a.hide{display:none}}
.page{max-width:900px;margin:0 auto;padding:128px 24px 90px}
.page.wide{max-width:1100px}
.eyebrow{font-size:13px;letter-spacing:.14em;text-transform:uppercase;color:var(--amber);font-weight:600}
.page h1{font-size:clamp(34px,5.4vw,60px);letter-spacing:-.035em;line-height:1.05;margin-top:12px;font-weight:700}
.page .lead{font-size:clamp(18px,2vw,22px);color:var(--mu2);margin-top:18px;max-width:46ch}
.page h2{font-size:clamp(24px,3vw,32px);letter-spacing:-.02em;margin-top:56px;font-weight:700}
.page h3{font-size:19px;margin-top:28px;font-weight:600}
.page p{color:var(--mu2);margin-top:14px;max-width:68ch}
.page ul,.page ol{color:var(--mu2);max-width:68ch;padding-left:22px}.page li{margin-top:8px}
.page a.in{color:var(--amber);border-bottom:1px solid rgba(242,166,90,.4)}.page a.in:hover{border-color:var(--amber)}
.page code{font-family:'JetBrains Mono',ui-monospace,Menlo,monospace;font-size:.88em;background:#14171c;border:1px solid var(--line);border-radius:6px;padding:1px 6px;word-break:break-all}
.page pre{background:#0E1014;border:1px solid var(--line);border-radius:12px;padding:16px 18px;overflow-x:auto;color:#d6d9e0;font-size:14px;line-height:1.55;max-width:100%}
.page pre code{background:none;border:0;padding:0}
.btn{display:inline-flex;align-items:center;justify-content:center;min-height:48px;padding:0 26px;border-radius:999px;background:var(--amber);color:#111;font-weight:600;font-size:16px}
.btn2{display:inline-flex;align-items:center;justify-content:center;min-height:48px;padding:0 24px;border-radius:999px;border:1px solid rgba(255,255,255,.28);color:#fff;font-size:16px}
.row{display:flex;gap:12px;flex-wrap:wrap;margin-top:26px}
.grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(240px,1fr));gap:14px;margin-top:26px}
.card{background:var(--card);border:1px solid var(--line);border-radius:18px;padding:20px 22px;display:flex;flex-direction:column;gap:6px}
.card b{font-size:18px;color:#fff}.card span{color:var(--mu2);font-size:15px;line-height:1.5}
.card .tag{align-self:flex-start;font-size:12px;font-weight:600;padding:2px 10px;border-radius:999px;border:1px solid var(--line);color:var(--mu2);margin-bottom:6px}
.tag.live{color:var(--ok);border-color:rgba(127,224,168,.4)}.tag.beta{color:var(--amber);border-color:rgba(242,166,90,.4)}
.tablewrap{overflow-x:auto;margin-top:22px;border:1px solid var(--line);border-radius:16px}
table{border-collapse:collapse;width:100%;font-size:15px;min-width:640px}
th,td{text-align:left;padding:13px 16px;border-bottom:1px solid var(--line);vertical-align:top}
th{color:#fff;font-size:13px;letter-spacing:.04em;text-transform:uppercase;background:#0B0C10}
td{color:var(--mu2)}tr:last-child td{border-bottom:0}
td.sha{font-family:'JetBrains Mono',ui-monospace,monospace;font-size:12px;word-break:break-all;max-width:260px}
.tabs input{position:absolute;opacity:0;pointer-events:none}
.tabbar{display:flex;gap:8px;margin-top:22px;flex-wrap:wrap}
.tabbar label{cursor:pointer;padding:10px 22px;border-radius:999px;border:1px solid rgba(255,255,255,.28);color:#d0d0d4;font-weight:600}
#ch-stable:checked ~ .tabbar label[for=ch-stable],#ch-beta:checked ~ .tabbar label[for=ch-beta]{background:#fff;color:#000;border-color:#fff}
#ch-stable:focus-visible ~ .tabbar label[for=ch-stable],#ch-beta:focus-visible ~ .tabbar label[for=ch-beta]{outline:2px solid #7FE0A8;outline-offset:3px}
.panel{display:none}
#ch-stable:checked ~ .panels .p-stable,#ch-beta:checked ~ .panels .p-beta{display:block}
.note{margin-top:22px;padding:16px 20px;border-radius:14px;background:#14110c;border:1px solid rgba(242,166,90,.3);color:#e9d3b5;font-size:15px;max-width:68ch}
form.wl{display:flex;gap:10px;flex-wrap:wrap;margin-top:18px;max-width:560px}
form.wl input[type=email]{flex:1 1 240px;min-height:48px;padding:0 18px;border-radius:999px;border:1px solid rgba(255,255,255,.28);background:#0E1014;color:#fff;font:inherit}
form.wl select{min-height:48px;padding:0 14px;border-radius:999px;border:1px solid rgba(255,255,255,.28);background:#0E1014;color:#fff;font:inherit}
.hp{position:absolute;left:-9999px;width:1px;height:1px;overflow:hidden}
#wlmsg{margin-top:12px;font-size:15px;min-height:1.4em}
.fadeup{animation:fu .7s ease both}@keyframes fu{from{opacity:0;transform:translateY(14px)}to{opacity:1;transform:none}}
@media (prefers-reduced-motion:reduce){.fadeup{animation:none}}
"""


def static_page(site, path, title, desc, body, ld=None):
    mark = rd(os.path.join(SRC, 'mark.symbol'))
    h = head_html(site, path, title, desc, ld, '', '<style>%s%s</style>' % (STATIC_CSS, CHROME_CSS))
    out = (h + '\n<body>\n<svg width="0" height="0" style="position:absolute" aria-hidden="true">%s</svg>\n%s\n<main class="%s">\n%s\n</main>\n%s\n%s</body>\n</html>\n'
           % (mark, nav_html(site), ('story' if path == '/office/' else 'page' + (' wide' if path in ('/download/', '/releases/', '/server/', '/apps/') else '')), body, footer_html(),
              pages.SCRIPTS.get(path, '')))
    d = os.path.join(DIST, site, path.strip('/'))
    wr(os.path.join(d, 'index.html') if path != '/404.html' else os.path.join(DIST, site, '404.html'), out)


def main():
    if os.path.exists(DIST):
        shutil.rmtree(DIST)
    ctx = {'REL': REL, 'OFFICE': OFFICE, 'fmt': lambda b: '%.2f GB' % (b / 1e9)}
    for site in SITES:
        files = build_front(site)
        copy_assets(site, files)
        urls = ['/']
        for (s, path), (title, desc, body) in pages.build_all(ctx).items():
            if s != site:
                continue
            static_page(site, path, title, desc, body)
            if path != '/404.html':
                urls.append(path)
        # sitemap and robots
        host = SITES[site]['host']
        sm = '<?xml version="1.0" encoding="UTF-8"?>\n<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n' + ''.join(
            '<url><loc>%s%s</loc><lastmod>%s</lastmod></url>\n' % (host, u, TODAY) for u in urls) + '</urlset>\n'
        wr(os.path.join(DIST, site, 'sitemap.xml'), sm)
        wr(os.path.join(DIST, site, 'robots.txt'), 'User-agent: *\nAllow: /\nDisallow: /api/\n\nSitemap: %s/sitemap.xml\n' % host)
    wr(os.path.join(DIST, 'www', '.well-known', 'security.txt'),
       'Contact: mailto:security@nubosuite.tech\nExpires: 2027-10-03T00:00:00.000Z\nPreferred-Languages: en\nCanonical: https://nubosuite.tech/.well-known/security.txt\nPolicy: https://nubosuite.tech/security/\n')
    print('built', {s: sum(len(f) for _, _, f in os.walk(os.path.join(DIST, s))) for s in SITES}, 'files')


if __name__ == '__main__':
    main()
