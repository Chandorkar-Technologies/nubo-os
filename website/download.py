"""The download page: two big squares (Nubo OS, Nubo Office), then one logo per edition or platform,
then an email step and the download. Same page on nubosuite.tech and os.nubosuite.tech.

Everything shown comes from data/releases.json (Nubo OS images) and data/office.json (Nubo Office builds), which the
release pipeline refreshes, so a newly published file appears here without editing this page. A choice with no file
yet says "coming soon" and takes the visitor's email instead.

Logos: Simple Icons (CC0 artwork) for the platforms; official store badges are kept in src/logos/badges for the day
a store listing goes live. See download_data() for which choice uses which logo."""
import html, json, os, re

HERE = os.path.dirname(os.path.abspath(__file__))
LOGOS = os.path.join(HERE, 'src', 'logos')
DOCS = 'https://docs.nubosuite.tech'

# Windows logo (four panes), drawn here: Simple Icons no longer carries Microsoft's marks
WINDOWS = {'vb': '0 0 24 24', 'd': 'M0 0h11.4v11.4H0zM12.6 0H24v11.4H12.6zM0 12.6h11.4V24H0zM12.6 12.6H24V24H12.6z'}
# our own line icons for the choices that have no brand logo
OWN = {
    'desktop': {'vb': '0 0 24 24', 'stroke': 'M3 5h18v11H3zM8 20h8M12 16v4'},
    'server': {'vb': '0 0 24 24', 'stroke': 'M4 4h16v6H4zM4 14h16v6H4zM8 7h.01M8 17h.01M12 7h4M12 17h4'},
    'edge': {'vb': '0 0 24 24', 'stroke': 'M7 7h10v10H7zM10 3v4M14 3v4M10 17v4M14 17v4M3 10h4M3 14h4M17 10h4M17 14h4'},
    'web': {'vb': '0 0 24 24', 'stroke': 'M12 3a9 9 0 100 18 9 9 0 000-18zM3 12h18M12 3c3 3 3 15 0 18M12 3c-3 3-3 15 0 18'},
    'phone': {'vb': '0 0 24 24', 'stroke': 'M7 2h10v20H7zM11 18h2'},
    'store': {'vb': '0 0 24 24', 'stroke': 'M4 9l1.5-5h13L20 9M4 9v11h16V9M4 9h16M9 20v-6h6v6'},
}


def _simple(name):
    """The path data of a Simple Icons file."""
    s = open(os.path.join(LOGOS, name + '.svg'), encoding='utf-8').read()
    vb = re.search(r'viewBox="([^"]+)"', s).group(1)
    d = ' '.join(re.findall(r'<path[^>]* d="([^"]+)"', s))
    return {'vb': vb, 'd': d}


def logo_svg(key):
    """Inline SVG for a logo key; colour comes from the CSS variable --c on the tile (fill = currentColor)."""
    if key == 'windows':
        g = WINDOWS
    elif key in OWN:
        g = OWN[key]
    else:
        g = _simple(key)
    if 'stroke' in g:
        return ('<svg viewBox="%s" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">'
                '<path d="%s"/></svg>' % (g['vb'], g['stroke']))
    return '<svg viewBox="%s" fill="currentColor" aria-hidden="true"><path d="%s"/></svg>' % (g['vb'], g['d'])


def human(n):
    if not n:
        return ''
    for unit, div in (('GB', 1e9), ('MB', 1e6)):
        if n >= div:
            return '%.1f %s' % (n / div, unit) if unit == 'GB' else '%d %s' % (round(n / div), unit)
    return '%d KB' % round(n / 1e3)


ARCH = {'amd64': 'Intel and AMD', 'arm64': 'Arm', 'x86_64': 'Intel and AMD', 'aarch64': 'Arm'}
FMT = {'iso': 'Installer (ISO)', 'qcow2': 'Virtual disk (qcow2)', 'vmdk': 'Virtual disk (VMware)', 'raw.xz': 'Raw disk image',
       'gcp.tar.gz': 'Google Cloud image', 'img.xz': 'Raspberry Pi image', 'tar': 'Container image', 'tar.gz': 'Container image'}


def os_tiles(rel):
    ch = rel.get('channels', {})
    pick = ch.get('stable') or ch.get('beta')
    images = (pick or {}).get('images', [])
    channel = 'stable' if ch.get('stable') else 'beta'
    editions = [
        ('desktop', 'Desktop', 'For your PC or laptop', 'desktop', '#F2A65A'),
        ('server', 'Server', 'For servers and the cloud', 'server', '#9FB4FF'),
        ('virt', 'Virtualization', 'Run virtual machines (KVM)', 'qemu', '#FF6600'),
        ('containers', 'Containers', 'Run containers (Podman)', 'podman', '#B05ACB'),
        ('edge', 'Edge', 'Small and always on', 'edge', '#7FE0A8'),
    ]
    tiles = []
    for fid, name, sub, logo, color in editions:
        files = []
        for i in images:
            if i.get('flavour') != fid:
                continue
            label = FMT.get(i.get('format'), i.get('label') or i.get('format', 'File'))
            files.append({'label': label, 'detail': ARCH.get(i.get('arch'), i.get('arch', '')), 'url': i['url'],
                          'size': human(i.get('size')), 'sha256': i.get('sha256') or '', 'file': i.get('file', '')})
        files.sort(key=lambda f: (f['label'] != 'Installer (ISO)', f['label'], f['detail'] == 'Arm'))
        tiles.append({'id': 'os-' + fid, 'product': 'os', 'name': 'Nubo OS ' + name if fid != 'desktop' else 'Nubo OS Desktop',
                      'short': name, 'sub': sub, 'logo': logo, 'color': color, 'files': files,
                      'status': 'live' if files else 'soon',
                      'version': (pick or {}).get('version', ''), 'channel': channel,
                      'help': {'text': 'How to install', 'url': DOCS + ('/desktop/get-started/write-the-installer-usb/' if fid == 'desktop' else '/server/install/choose-an-image/')},
                      'soonText': 'The ' + name + ' image for this release is being finished. Leave your email and we send you the link the day it is ready.'})
    tiles.append({'id': 'os-pi', 'product': 'os', 'name': 'Nubo OS for Raspberry Pi', 'short': 'Raspberry Pi', 'sub': 'Server and Edge on a Pi',
                  'logo': 'raspberrypi', 'color': '#E0446A', 'files': [], 'status': 'soon', 'version': '', 'channel': '',
                  'soonText': 'Raspberry Pi images are on the way. Leave your email and we tell you when they are ready.'})
    return tiles


def office_tiles(office):
    ver = office.get('version') or ''
    by = {v['name']: v for v in office.get('variants', [])}

    def f(v, label, detail, kind='download'):
        return {'label': label, 'detail': detail, 'url': v['url'], 'size': human(v.get('size')), 'sha256': v.get('sha256') or '', 'kind': kind}

    tiles = []
    v = by.get('Windows 11, Intel and AMD')
    tiles.append({'id': 'of-windows', 'product': 'office', 'name': 'Nubo Office for Windows', 'short': 'Windows', 'sub': 'Windows 11 · Intel and AMD',
                  'logo': 'windows', 'color': '#2B8CFF', 'status': 'live' if v and v.get('url') else 'soon',
                  'files': [f(v, 'Download for Windows', 'Portable: unzip it and run Nubo Office')] if v and v.get('url') else [],
                  'note': 'Also coming to the Microsoft Store.', 'version': ver,
                  'help': {'text': 'How to install', 'url': DOCS + '/office/install/'}})
    v = by.get('macOS, Apple silicon')
    tiles.append({'id': 'of-macos', 'product': 'office', 'name': 'Nubo Office for Mac', 'short': 'Mac', 'sub': 'macOS · Apple silicon',
                  'logo': 'apple', 'color': '#F5F5F7', 'status': 'live' if v and v.get('url') else 'soon',
                  'files': [f(v, 'Download for Mac', 'Disk image, notarized by Apple')] if v and v.get('url') else [],
                  'note': 'Also coming to the Mac App Store.', 'version': ver,
                  'help': {'text': 'How to install', 'url': DOCS + '/office/install/'}})
    v = by.get('Nubo OS and Ubuntu 26.04 (.deb)')
    tiles.append({'id': 'of-deb', 'product': 'office', 'name': 'Nubo Office for Ubuntu and Nubo OS', 'short': 'Ubuntu', 'sub': 'Ubuntu 26.04 and Nubo OS (.deb)',
                  'logo': 'ubuntu', 'color': '#E95420', 'status': 'live' if v and v.get('url') else 'soon',
                  'files': [f(v, 'Download the .deb package', 'Then: sudo apt install ./nubo-office_*.deb')] if v and v.get('url') else [],
                  'command': 'sudo apt install ./nubo-office_*_amd64.deb', 'version': ver,
                  'help': {'text': 'How to install', 'url': DOCS + '/office/install/'}})
    v = by.get('Linux, Intel and AMD')
    tiles.append({'id': 'of-flatpak', 'product': 'office', 'name': 'Nubo Office for Linux (Flatpak)', 'short': 'Linux', 'sub': 'Any Linux · Flatpak',
                  'logo': 'flatpak', 'color': '#5AA0E8', 'status': 'live' if v and v.get('url') else 'soon',
                  'files': [f(v, 'Download the Flatpak file', 'One file, runs on any Linux')] if v and v.get('url') else [],
                  'command': (v or {}).get('command') or '', 'note': 'Also coming to Flathub.', 'version': ver,
                  'help': {'text': 'How to install', 'url': DOCS + '/office/install/'}})
    v = by.get('Android phones and tablets')
    tiles.append({'id': 'of-android', 'product': 'office', 'name': 'Nubo Office for Android', 'short': 'Android', 'sub': 'Phones and tablets',
                  'logo': 'android', 'color': '#3DDC84', 'status': 'live' if v and v.get('url') else 'soon',
                  'files': [f(v, 'Download the app (APK)', 'Allow installs from your browser when asked')] if v and v.get('url') else [],
                  'note': 'Also coming to Google Play.', 'version': ver,
                  'help': {'text': 'How to install', 'url': DOCS + '/office/install/'}})
    tiles.append({'id': 'of-ios', 'product': 'office', 'name': 'Nubo Office for iPhone and iPad', 'short': 'iPhone and iPad', 'sub': 'iOS and iPadOS · App Store',
                  'logo': 'apple', 'color': '#F5F5F7', 'status': 'soon', 'files': [], 'version': '',
                  'soonText': 'Nubo Office for iPhone and iPad is with Apple for review. Leave your email and we send you the App Store link the moment it is out.'})
    v = by.get('In your browser')
    tiles.append({'id': 'of-web', 'product': 'office', 'name': 'Nubo Office in your browser', 'short': 'Web', 'sub': 'Any computer or phone · no install',
                  'logo': 'web', 'color': '#F2A65A', 'status': 'live' if v and v.get('url') else 'soon',
                  'files': [f(v, 'Open Nubo Office', 'Opens in a new tab. No account needed', 'open')] if v and v.get('url') else [], 'version': ''})
    return tiles


def _json(o):
    return json.dumps(o, ensure_ascii=False, separators=(',', ':')).replace('</', '<\\/')


STORES = [  # shown under the Office choices until the listing goes live
    ('Microsoft Store', 'windows'), ('Mac App Store', 'apple'), ('App Store', 'appstore'), ('Google Play', 'googleplay'), ('Flathub', 'flathub')]


def body(ctx, site):
    os_t, of_t = os_tiles(ctx['REL']), office_tiles(ctx['OFFICE'])
    data = {'os': os_t, 'office': of_t, 'site': site}
    logos = {}
    for t in os_t + of_t:
        logos[t['logo']] = logo_svg(t['logo'])
    for _, k in STORES:
        logos[k] = logo_svg(k)

    def tile_html(t):
        soon = t['status'] != 'live'
        return ('<button class="lt%s" type="button" data-id="%s" style="--c:%s">'
                '<span class="lg">%s</span><b>%s</b><span class="sb">%s</span>%s</button>'
                % (' soon' if soon else '', html.escape(t['id']), t['color'], logos[t['logo']], html.escape(t['short']), html.escape(t['sub']),
                   '<i class="chip">Coming soon</i>' if soon else ''))

    os_ver = next((t['version'] for t in os_t if t['version']), '')
    os_ch = next((t['channel'] for t in os_t if t['channel']), 'beta')
    of_ver = ctx['OFFICE'].get('version') or ''
    stores = ''.join('<span class="st">%s<em>%s</em></span>' % (logos[k], html.escape(n)) for n, k in STORES)
    return """<style>%(css)s</style>
<div class="dlp" id="dlp" data-view="home">
<p class="eyebrow">Download</p>
<h1 id="dlh">What would you like to download?</h1>
<p class="lead" id="dll">Choose one. It takes two clicks.</p>

<div class="back" id="dlback" hidden><button type="button" id="dlbtn">&larr; Choose another product</button></div>

<div class="big" role="group" aria-label="Choose a product">
<button type="button" class="sq sq-os" data-product="os" aria-controls="panel-os">
  <span class="sqbg"></span>
  <span class="sqmark"><svg class="mk"><use href="#mark"/></svg></span>
  <span class="sqt"><b>Nubo OS</b><span>The operating system. Desktop, server, virtual machines and containers.</span></span>
  <span class="sqgo">Choose <i>&rarr;</i></span>
</button>
<button type="button" class="sq sq-of" data-product="office" aria-controls="panel-office">
  <span class="sqbg"></span>
  <span class="sqmark"><img src="/assets/office/icon-Office.svg" alt="" width="64" height="64"></span>
  <span class="sqt"><b>Nubo Office</b><span>Write, calculate, present and draw. For Windows, Mac, Linux, Android, iPhone and the web.</span></span>
  <span class="sqgo">Choose <i>&rarr;</i></span>
</button>
</div>

<section class="dlpanel" id="panel-os" aria-label="Nubo OS downloads" hidden>
<p class="pl">Pick what you want to install. %(os_ver)s</p>
<div class="lg-grid">%(os_tiles)s</div>
<p class="more">Looking for older releases, checksums or other formats? <a class="in" href="/download/all/">All Nubo OS files</a>.</p>
</section>

<section class="dlpanel" id="panel-office" aria-label="Nubo Office downloads" hidden>
<p class="pl">Pick your device. Free to download and use. %(of_ver)s</p>
<div class="lg-grid">%(of_tiles)s</div>
<div class="stores"><span class="stl">Also on the way to the stores</span>%(stores)s</div>
</section>

<div class="dlmodal" id="dlmodal" role="dialog" aria-modal="true" aria-labelledby="dmt" hidden>
<div class="dmbox" id="dmbox">
<button class="dmx" type="button" id="dmx" aria-label="Close">&times;</button>
<div class="dmhead"><span class="dmlogo" id="dmlogo"></span><div><h3 id="dmt"></h3><p id="dms"></p></div></div>
<form id="dmform" novalidate>
<label for="dmemail">Your email</label>
<input type="email" id="dmemail" name="email" placeholder="you@example.com" autocomplete="email" required>
<input class="hp" type="text" id="dmco" name="company" tabindex="-1" autocomplete="off" aria-hidden="true">
<label class="chk"><input type="checkbox" id="dmnews"> Send me release news (optional)</label>
<div class="dmfiles" id="dmfiles"></div>
<p class="priv">We keep your email and what you download, to help with installing and updating. See the <a class="in" href="https://nubosuite.tech/privacy/">privacy page</a>.</p>
</form>
<div class="dmdone" id="dmdone" hidden></div>
<div class="dmmsg" id="dmmsg" role="status" aria-live="polite"></div>
</div>
</div>
</div>
<script id="dl-data" type="application/json">%(data)s</script>
""" % {'css': CSS, 'data': _json(data), 'os_tiles': ''.join(tile_html(t) for t in os_t),
       'of_tiles': ''.join(tile_html(t) for t in of_t), 'stores': stores,
       'os_ver': (('%s release %s.' % (os_ch.capitalize(), html.escape(os_ver))) if os_ver else ''),
       'of_ver': ('Version %s.' % html.escape(of_ver)) if of_ver else ''}


CSS = """
.dlp .big{display:grid;grid-template-columns:1fr 1fr;gap:20px;margin-top:34px}
.sq{position:relative;overflow:hidden;aspect-ratio:1/1;border-radius:28px;border:1px solid var(--line);color:#fff;text-align:left;cursor:pointer;display:flex;flex-direction:column;justify-content:space-between;padding:clamp(22px,3.4vw,40px);font:inherit;isolation:isolate;transition:transform .25s ease,border-color .25s ease}
.sq:hover{transform:translateY(-4px);border-color:rgba(255,255,255,.4)}
.sq:focus-visible{outline:3px solid #7FE0A8;outline-offset:4px}
.sqbg{position:absolute;inset:0;z-index:-1}
.sq-os .sqbg{background:linear-gradient(160deg,rgba(7,9,14,.15),rgba(7,9,14,.9)),url(/assets/img/dusk.jpg) center/cover,#0b1020}
.sq-of .sqbg{background:radial-gradient(120% 90% at 85% 8%,rgba(242,166,90,.38),rgba(242,166,90,0) 60%),radial-gradient(90% 70% at 10% 100%,rgba(176,90,203,.22),rgba(176,90,203,0) 60%),linear-gradient(160deg,#1b130b,#0b0907)}
.sqmark{font-size:64px;line-height:1;display:block}.sqmark .mk{width:64px;height:64px;fill:#fff;stroke:#fff}.sqmark img{display:block}
.sqt b{display:block;font-size:clamp(34px,5vw,56px);letter-spacing:-.035em;line-height:1.02;font-weight:700}
.sqt span{display:block;margin-top:12px;color:#d4d6dc;font-size:clamp(15px,1.5vw,18px);max-width:30ch;line-height:1.45}
.sqgo{display:inline-flex;align-items:center;gap:8px;align-self:flex-start;padding:11px 22px;border-radius:999px;background:#fff;color:#000;font-weight:600;font-size:16px;margin-top:18px}
.sq-of .sqgo{background:var(--amber)}
.sqgo i{font-style:normal;transition:transform .2s}.sq:hover .sqgo i{transform:translateX(4px)}
.dlpanel{margin-top:6px;animation:dlin .35s ease both}
.dlpanel .pl{margin-top:2px}
.lg-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(200px,1fr));gap:14px;margin-top:24px}
.lt{position:relative;display:flex;flex-direction:column;align-items:flex-start;gap:6px;text-align:left;padding:22px 20px 20px;min-height:190px;border-radius:22px;background:var(--card);border:1px solid var(--line);color:#fff;font:inherit;cursor:pointer;transition:transform .2s ease,border-color .2s ease,background .2s ease}
.lt:hover{transform:translateY(-3px);border-color:var(--c);background:#10131a}
.lt:focus-visible{outline:3px solid #7FE0A8;outline-offset:3px}
.lt .lg{display:block;width:54px;height:54px;color:var(--c);margin-bottom:14px}.lt .lg svg{width:100%;height:100%;display:block}
.lt b{font-size:19px;letter-spacing:-.01em}
.lt .sb{color:var(--mu2);font-size:14px;line-height:1.4}
.lt.soon .lg{opacity:.55}.lt.soon{background:#0c0e13}
.chip{position:absolute;top:14px;right:14px;font-style:normal;font-size:11px;font-weight:600;letter-spacing:.04em;padding:3px 10px;border-radius:999px;border:1px solid rgba(242,166,90,.4);color:var(--amber)}
.stores{display:flex;flex-wrap:wrap;align-items:center;gap:10px 18px;margin-top:26px;padding:16px 20px;border:1px dashed var(--line);border-radius:16px}
.stl{color:var(--mu2);font-size:14px;margin-right:6px}
.st{display:inline-flex;align-items:center;gap:8px;color:#8d9099;font-size:14px}.st svg{width:18px;height:18px}.st em{font-style:normal}
.more{font-size:14px}
.back{margin-top:22px}.back button{background:none;border:0;padding:0;color:var(--amber);font:inherit;font-size:16px;cursor:pointer}.back button:hover{text-decoration:underline}.back button:focus-visible{outline:3px solid #7FE0A8;outline-offset:4px;border-radius:6px}
.dlp[data-view=home] .dlpanel,.dlp[data-view=home] .back{display:none}
.dlp[data-view=os] #panel-office,.dlp[data-view=office] #panel-os{display:none}
.dlp[data-view=os] .big,.dlp[data-view=office] .big{display:none}
.dlp[data-view=os] #dll,.dlp[data-view=office] #dll{display:none}
@keyframes dlin{from{opacity:0;transform:translateY(10px)}to{opacity:1;transform:none}}
@media (prefers-reduced-motion:reduce){.dlpanel{animation:none}.sq,.lt{transition:none}}
.dlmodal{position:fixed;inset:0;z-index:100;background:rgba(3,4,7,.78);display:flex;align-items:center;justify-content:center;padding:16px;backdrop-filter:blur(6px)}
.dlmodal[hidden]{display:none}
.dmbox{position:relative;width:100%;max-width:520px;max-height:calc(100vh - 32px);overflow:auto;background:#0E1014;border:1px solid rgba(255,255,255,.16);border-radius:24px;padding:28px 26px 24px}
.dmx{position:absolute;top:12px;right:14px;width:36px;height:36px;border-radius:50%;border:0;background:transparent;color:#a1a1a6;font-size:26px;cursor:pointer}.dmx:hover{color:#fff}
.dmhead{display:flex;gap:16px;align-items:center}
.dmlogo{display:block;width:52px;height:52px;flex:none;color:var(--c,#fff)}.dmlogo svg{width:100%;height:100%}
.dmhead h3{margin:0;font-size:21px}.dmhead p{margin:4px 0 0;font-size:14px;color:var(--mu2)}
#dmform label{display:block;margin-top:22px;font-size:14px;font-weight:600;color:#fff}
#dmform .chk{display:flex;gap:10px;align-items:center;margin-top:12px;font-weight:400;color:var(--mu2)}
#dmemail{width:100%;min-height:50px;margin-top:8px;padding:0 18px;border-radius:999px;border:1px solid rgba(255,255,255,.28);background:#080a0e;color:#fff;font:inherit;font-size:16px}
#dmemail:focus-visible{outline:3px solid #7FE0A8;outline-offset:2px}
.dmfiles{display:flex;flex-direction:column;gap:10px;margin-top:20px}
.dmfiles .btn{width:100%;justify-content:space-between;min-height:54px;text-align:left;gap:12px;border:0;cursor:pointer;font:inherit;font-weight:600}
.dmfiles .btn small{font-weight:500;opacity:.75;font-size:13px;margin-left:auto}
.dmfiles .btn span{display:flex;flex-direction:column;align-items:flex-start;line-height:1.25}
.dmfiles .btn span small{margin:0;opacity:.7}
.priv{font-size:13px;margin-top:16px}
.dmmsg{min-height:1.4em;margin-top:10px;font-size:15px}
.dmdone h4{margin:22px 0 0;font-size:20px}
.dmdone p{margin-top:10px}
.dmdone .cmd{display:flex;gap:8px;align-items:center;margin-top:10px}.dmdone .cmd code{flex:1;white-space:pre-wrap}
.dmdone .cp{min-height:40px;padding:0 16px;border-radius:999px;border:1px solid rgba(255,255,255,.28);background:transparent;color:#fff;cursor:pointer;font:inherit}
.dmdone .sha{font-size:12px;word-break:break-all}
@media(max-width:700px){.dlp .big{grid-template-columns:1fr;gap:14px}.sq{aspect-ratio:auto;min-height:300px}.lg-grid{grid-template-columns:repeat(2,1fr);gap:10px}.lt{min-height:170px;padding:18px 16px}.lt b{font-size:17px}}
"""

JS = r"""<script>
(function(){
var root=document.getElementById('dlp'); if(!root) return;
var DATA=JSON.parse(document.getElementById('dl-data').textContent);
var LOGOS=null; var byId={}; DATA.os.concat(DATA.office).forEach(function(t){byId[t.id]=t;});
var h1=document.getElementById('dlh'), lead=document.getElementById('dll'), back=document.getElementById('dlback');
var modal=document.getElementById('dlmodal'), form=document.getElementById('dmform'), email=document.getElementById('dmemail');
var filesEl=document.getElementById('dmfiles'), msg=document.getElementById('dmmsg'), done=document.getElementById('dmdone');
var cur=null, lastFocus=null;
function store(k,v){try{if(v===undefined)return localStorage.getItem(k);localStorage.setItem(k,v);}catch(e){return null;}}
function view(v,push){
  if(!modal.hidden) close();
  root.setAttribute('data-view',v);
  document.getElementById('panel-os').hidden=(v!=='os'); document.getElementById('panel-office').hidden=(v!=='office'); back.hidden=(v==='home');
  h1.textContent = v==='os' ? 'Get Nubo OS' : v==='office' ? 'Get Nubo Office' : 'What would you like to download?';
  if(push!==false){try{history.replaceState(null,'', v==='home' ? location.pathname : '#'+v);}catch(e){}}
  window.scrollTo({top:0,behavior:'smooth'});
}
Array.prototype.forEach.call(root.querySelectorAll('.sq'),function(b){b.addEventListener('click',function(){view(b.getAttribute('data-product'));});});
document.getElementById('dlbtn').addEventListener('click',function(){view('home');});
function fromHash(){var h=(location.hash||'').replace('#',''); view(h==='desktop'||h==='server'||h==='os'?'os':h==='office'?'office':'home',false);}
if(location.hash) fromHash(); window.addEventListener('hashchange',fromHash);
Array.prototype.forEach.call(root.querySelectorAll('.lt'),function(b){b.addEventListener('click',function(){open(byId[b.getAttribute('data-id')],b);});});

function esc(s){return String(s).replace(/[&<>"]/g,function(c){return {'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;'}[c];});}
function open(t,from){
  cur=t; lastFocus=from;
  var lt=from.querySelector('.lg'); var logo=document.getElementById('dmlogo'); logo.innerHTML=lt?lt.innerHTML:''; logo.style.setProperty('--c',t.color);
  document.getElementById('dmt').textContent=t.name;
  document.getElementById('dms').textContent=t.status==='live' ? (t.version?('Version '+t.version):'') : 'Coming soon';
  msg.textContent=''; msg.style.color=''; done.hidden=true; done.innerHTML=''; form.hidden=false;
  email.value=store('nubo-dl-email')||'';
  var html='';
  if(t.status==='live'){
    t.files.forEach(function(f,i){
      html+='<button type="button" class="btn" data-i="'+i+'"><span>'+esc(f.label)+(f.detail?'<small>'+esc(f.detail)+'</small>':'')+'</span>'+(f.size?'<small>'+esc(f.size)+'</small>':'')+'</button>';
    });
  } else {
    html='<p style="margin:0">'+esc(t.soonText||'This is coming soon. Leave your email and we tell you the day it is ready.')+'</p><button type="button" class="btn" data-soon="1"><span>Notify me</span></button>';
  }
  filesEl.innerHTML=html;
  modal.hidden=false; document.body.style.overflow='hidden';
  setTimeout(function(){email.focus();},30);
}
function close(){modal.hidden=true; document.body.style.overflow=''; if(lastFocus&&lastFocus.focus) lastFocus.focus();}
document.getElementById('dmx').addEventListener('click',close);
modal.addEventListener('click',function(e){if(e.target===modal)close();});
document.addEventListener('keydown',function(e){if(e.key==='Escape'&&!modal.hidden)close();});
form.addEventListener('submit',function(e){e.preventDefault(); var b=filesEl.querySelector('.btn'); if(b) b.click();});

function send(item,soon){
  var body=JSON.stringify({email:email.value.trim(),product:cur.product,item:item,soon:!!soon,news:document.getElementById('dmnews').checked,company:document.getElementById('dmco').value});
  var ctl=('AbortController' in window)?new AbortController():null; var to=setTimeout(function(){if(ctl)ctl.abort();},5000);
  return fetch('/api/download',{method:'POST',headers:{'content-type':'application/json'},body:body,signal:ctl?ctl.signal:undefined,keepalive:true})
    .then(function(r){clearTimeout(to);return r.json().then(function(j){return {ok:r.ok,j:j,status:r.status};});})
    .catch(function(){clearTimeout(to);return {ok:false,net:true};});
}
filesEl.addEventListener('click',function(e){
  var b=e.target.closest('.btn'); if(!b) return;
  var v=email.value.trim();
  if(!/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(v)||v.length>254){msg.style.color='#F2A65A';msg.textContent='Please enter a valid email address.';email.focus();return;}
  var soon=b.hasAttribute('data-soon'); var f=soon?null:cur.files[+b.getAttribute('data-i')];
  b.disabled=true; msg.style.color='#A1A1A6'; msg.textContent=soon?'Saving...':'Starting your download...';
  send(f?f.label:'notify',soon).then(function(x){
    if(!x.ok&&!x.net&&x.status!==404&&x.status!==405){ // a real refusal (bad address, too many requests): say so
      b.disabled=false; msg.style.color='#F2A65A'; msg.textContent=(x.j&&x.j.error)||'Something went wrong. Please try again.'; return; }
    store('nubo-dl-email',v);
    form.hidden=true; msg.textContent=''; done.hidden=false;
    if(soon){ done.innerHTML='<h4>Thank you.</h4><p>We will email '+esc(v)+' when '+esc(cur.short)+' is ready.</p><p><button type="button" class="btn2" id="dmclose">Close</button></p>'; document.getElementById('dmclose').addEventListener('click',close); return; }
    var out='<h4>'+(f.kind==='open'?'Opening Nubo Office...':'Your download has started.')+'</h4>';
    out+='<p>If nothing happens, <a class="in" id="dmagain" href="'+esc(f.url)+'"'+(f.kind==='open'?' target="_blank" rel="noopener"':'')+'>use this link</a>.</p>';
    if(cur.command) out+='<p>Then install it with:</p><div class="cmd"><code id="dmcmd">'+esc(cur.command)+'</code><button type="button" class="cp" id="dmcp">Copy</button></div>';
    if(f.sha256) out+='<p class="sha">SHA-256: '+esc(f.sha256)+'</p>';
    if(cur.help) out+='<p><a class="in" href="'+esc(cur.help.url)+'">'+esc(cur.help.text)+'</a></p>';
    if(cur.note) out+='<p>'+esc(cur.note)+'</p>';
    done.innerHTML=out;
    var cp=document.getElementById('dmcp'); if(cp) cp.addEventListener('click',function(){var t=document.getElementById('dmcmd').textContent; (navigator.clipboard?navigator.clipboard.writeText(t):Promise.reject()).then(function(){cp.textContent='Copied';},function(){var r=document.createRange();r.selectNode(document.getElementById('dmcmd'));var s=getSelection();s.removeAllRanges();s.addRange(r);});});
    var a=document.createElement('a'); a.href=f.url; if(f.kind==='open'){a.target='_blank';a.rel='noopener';} document.body.appendChild(a); a.click(); a.remove();
  });
});
})();
</script>
"""
