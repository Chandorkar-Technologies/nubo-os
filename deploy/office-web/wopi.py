#!/usr/bin/env python3
"""Nubo Office on the web: a tiny WOPI host for Collabora Online.

Open a file from your own computer (or start a blank one), edit it in the browser, download it again.
No accounts. A file is reachable only through its random link and is deleted after it has been idle for IDLE_HOURS.
Standard library only, so it runs in a stock python image.
"""
import hashlib, io, json, os, re, secrets, shutil, threading, time, urllib.request, zipfile
import xml.etree.ElementTree as ET
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from urllib.parse import urlparse, parse_qs, quote

DATA = os.environ.get('DATA_DIR', '/data')
COOL = os.environ.get('COOL_URL', 'http://nubo-office-cool:9980')       # how this pod reaches Collabora
WOPI_SELF = os.environ.get('WOPI_SELF', 'http://nubo-office-wopi:8080')  # how Collabora reaches this pod
MAX_FILE = int(os.environ.get('MAX_FILE_MB', '50')) * 1024 * 1024
MAX_TOTAL = int(os.environ.get('MAX_TOTAL_MB', '3000')) * 1024 * 1024
IDLE = float(os.environ.get('IDLE_HOURS', '6')) * 3600
EXTS = {'odt', 'ods', 'odp', 'odg', 'docx', 'xlsx', 'pptx', 'doc', 'xls', 'ppt', 'rtf', 'txt', 'csv', 'pdf', 'vsdx', 'epub'}
ID_RE = re.compile(r'^[0-9a-f]{32}$')
os.makedirs(DATA, exist_ok=True)
lock = threading.Lock()


def blank(kind):
    """The smallest valid OpenDocument file of each kind."""
    mime = {'odt': 'text', 'ods': 'spreadsheet', 'odp': 'presentation'}[kind]
    ns = ('xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0" '
          'xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0" '
          'xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0" '
          'xmlns:draw="urn:oasis:names:tc:opendocument:xmlns:drawing:1.0" office:version="1.3"')
    body = {'text': '<office:text><text:p/></office:text>',
            'spreadsheet': '<office:spreadsheet><table:table table:name="Sheet1"><table:table-row><table:table-cell/></table:table-row></table:table></office:spreadsheet>',
            'presentation': '<office:presentation><draw:page draw:name="Slide 1"/></office:presentation>'}[mime]
    content = f'<?xml version="1.0" encoding="UTF-8"?><office:document-content {ns}><office:body>{body}</office:body></office:document-content>'
    manifest = ('<?xml version="1.0" encoding="UTF-8"?><manifest:manifest xmlns:manifest="urn:oasis:names:tc:opendocument:xmlns:manifest:1.0" manifest:version="1.3">'
                f'<manifest:file-entry manifest:full-path="/" manifest:media-type="application/vnd.oasis.opendocument.{mime}"/>'
                '<manifest:file-entry manifest:full-path="content.xml" manifest:media-type="text/xml"/></manifest:manifest>')
    buf = io.BytesIO()
    with zipfile.ZipFile(buf, 'w') as z:
        z.writestr(zipfile.ZipInfo('mimetype'), f'application/vnd.oasis.opendocument.{mime}')  # first and stored
        z.writestr('content.xml', content, zipfile.ZIP_DEFLATED)
        z.writestr('META-INF/manifest.xml', manifest, zipfile.ZIP_DEFLATED)
    return buf.getvalue()


def paths(fid):
    d = os.path.join(DATA, fid)
    return d, os.path.join(d, 'file'), os.path.join(d, 'meta.json')


def total_size():
    n = 0
    for fid in os.listdir(DATA):
        p = paths(fid)[1]
        if os.path.exists(p):
            n += os.path.getsize(p)
    return n


def store(name, data):
    ext = name.rsplit('.', 1)[-1].lower() if '.' in name else ''
    if ext not in EXTS:
        raise ValueError('That kind of file is not supported.')
    if len(data) > MAX_FILE:
        raise ValueError('Files up to %d MB can be opened here.' % (MAX_FILE // 1048576))
    with lock:
        if total_size() + len(data) > MAX_TOTAL:
            raise RuntimeError('The service is full at the moment. Please try again in a while.')
        fid = secrets.token_hex(16)
        d, f, m = paths(fid)
        os.makedirs(d)
        with open(f, 'wb') as fh:
            fh.write(data)
        name = re.sub(r'[^\w .()\-]', '_', os.path.basename(name))[:120] or ('document.' + ext)
        with open(m, 'w') as fh:
            json.dump({'name': name, 'ext': ext, 'created': time.time()}, fh)
    return fid


def meta(fid):
    with open(paths(fid)[2]) as fh:
        return json.load(fh)


def touch(fid):
    os.utime(paths(fid)[2], None)


def sweeper():
    while True:
        time.sleep(600)
        now = time.time()
        for fid in os.listdir(DATA):
            try:
                m = paths(fid)[2]
                if now - os.path.getmtime(m) > IDLE:
                    shutil.rmtree(paths(fid)[0], ignore_errors=True)
            except OSError:
                pass


_disc = {'t': 0, 'urls': {}}


def action_url(ext):
    """Collabora's editor address for a file extension, from its discovery document."""
    if time.time() - _disc['t'] > 300 or not _disc['urls']:
        with urllib.request.urlopen(COOL + '/hosting/discovery', timeout=10) as r:
            root = ET.fromstring(r.read())
        urls = {}
        for a in root.iter('action'):
            if a.get('name') in ('edit', 'view_comment', 'view') and a.get('ext'):
                if a.get('name') == 'edit' or a.get('ext') not in urls:
                    urls[a.get('ext')] = a.get('urlsrc')
        _disc.update(t=time.time(), urls=urls)
    return _disc['urls'].get(ext)


PAGE = '''<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>Nubo Office on the web</title><meta name="description" content="Write, calculate and present in your browser. Open a file from your computer or start a new one. No account needed.">
<style>
:root{--bg:#F6F6F8;--fg:#1D1D1F;--mut:#6E6E73;--card:#fff;--line:#E3E3E8;--acc:#FF8A1F}
@media(prefers-color-scheme:dark){:root{--bg:#111114;--fg:#F5F5F7;--mut:#A1A1A6;--card:#1C1C20;--line:#2C2C31}}
*{box-sizing:border-box}body{margin:0;background:var(--bg);color:var(--fg);font:16px/1.5 -apple-system,BlinkMacSystemFont,"Inter","Segoe UI",system-ui,sans-serif;-webkit-font-smoothing:antialiased}
main{max-width:760px;margin:0 auto;padding:12vh 20px 8vh}h1{font-size:clamp(34px,6vw,54px);line-height:1.05;letter-spacing:-.04em;margin:0 0 14px}
h1 em{font-style:normal;background:linear-gradient(90deg,#FF8A1F,#F2A65A);-webkit-background-clip:text;background-clip:text;color:transparent}
p.lead{color:var(--mut);font-size:19px;margin:0 0 36px}.row{display:flex;gap:12px;flex-wrap:wrap;margin-bottom:28px}
button,.drop{font:inherit;cursor:pointer}.new{flex:1 1 150px;padding:18px;border:1px solid var(--line);border-radius:14px;background:var(--card);color:var(--fg);font-weight:600;text-align:left}
.new small{display:block;font-weight:400;color:var(--mut)}.new:hover,.drop:hover{border-color:var(--acc)}
.drop{display:block;padding:44px 20px;border:2px dashed var(--line);border-radius:18px;text-align:center;color:var(--mut);background:var(--card)}
.drop.over{border-color:var(--acc);color:var(--fg)}#msg{margin-top:16px;color:#c0392b;min-height:1.5em}
footer{margin-top:44px;color:var(--mut);font-size:14px}footer a{color:inherit}
</style></head><body><main>
<h1>Nubo Office,<br>in your <em>browser</em>.</h1>
<p class="lead">Write, calculate and present. Open a file from your computer or start a new one. No account needed.</p>
<div class="row"><button class="new" data-k="odt">Write<small>New document</small></button><button class="new" data-k="ods">Cells<small>New spreadsheet</small></button><button class="new" data-k="odp">Present<small>New presentation</small></button></div>
<label class="drop" id="drop"><input id="f" type="file" hidden>Drop a file here, or choose one<br><small>.docx .xlsx .pptx .odt .ods .odp .pdf and more, up to %(mb)d MB</small></label>
<div id="msg"></div>
<footer>Your file gets a private link and is deleted automatically after %(h)s hours without use. Download your work before you leave, from File, Download as. Nubo does not read your documents. <a href="https://nubosuite.tech/privacy/">Privacy</a> &middot; <a href="https://nubosuite.tech/office/">Get the apps</a></footer>
<script>
const msg=document.getElementById('msg');
async function send(name,body){msg.style.color='';msg.textContent='Opening...';
 const r=await fetch('/upload?name='+encodeURIComponent(name),{method:'POST',body});
 const j=await r.json().catch(()=>({}));if(!r.ok){msg.style.color='#c0392b';msg.textContent=j.error||'Could not open the file.';return}
 location.href='/open/'+j.id}
document.getElementById('f').onchange=e=>{const f=e.target.files[0];if(f)send(f.name,f)};
const d=document.getElementById('drop');
d.ondragover=e=>{e.preventDefault();d.classList.add('over')};d.ondragleave=()=>d.classList.remove('over');
d.ondrop=e=>{e.preventDefault();d.classList.remove('over');const f=e.dataTransfer.files[0];if(f)send(f.name,f)};
document.querySelectorAll('.new').forEach(b=>b.onclick=async()=>{msg.textContent='Opening...';const r=await fetch('/new/'+b.dataset.k,{method:'POST'});const j=await r.json().catch(()=>({}));if(r.ok)location.href='/open/'+j.id;else msg.textContent=j.error||'Could not start.'});
</script></main></body></html>'''

OPEN = '''<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>%(name)s - Nubo Office</title><style>html,body{margin:0;height:100%%}iframe{border:0;width:100%%;height:100%%;display:block}</style></head><body>
<form id="f" action="%(url)s" method="post" target="office"><input type="hidden" name="access_token" value="%(tok)s"></form>
<iframe name="office" allow="clipboard-read; clipboard-write"></iframe><script>document.getElementById('f').submit()</script></body></html>'''


class H(BaseHTTPRequestHandler):
    server_version = 'nubo-wopi'

    def log_message(self, fmt, *a):  # no file names or addresses in logs
        pass

    def send(self, code, body, ctype='application/json', extra=None):
        if isinstance(body, (dict, list)):
            body = json.dumps(body).encode()
        elif isinstance(body, str):
            body = body.encode()
        self.send_response(code)
        self.send_header('Content-Type', ctype)
        self.send_header('Content-Length', str(len(body)))
        self.send_header('Cache-Control', 'no-store')
        self.send_header('X-Content-Type-Options', 'nosniff')
        for k, v in (extra or {}).items():
            self.send_header(k, v)
        self.end_headers()
        self.wfile.write(body)

    def fid_ok(self, fid):
        return bool(ID_RE.match(fid)) and os.path.exists(paths(fid)[2])

    def do_GET(self):
        u = urlparse(self.path)
        p = u.path
        if p in ('/', '/index.html'):
            return self.send(200, PAGE % {'mb': MAX_FILE // 1048576, 'h': int(IDLE // 3600)}, 'text/html; charset=utf-8',
                             {'Content-Security-Policy': "frame-ancestors 'none'"})
        if p == '/healthz':
            return self.send(200, 'ok', 'text/plain')
        m = re.match(r'^/open/([0-9a-f]{32})$', p)
        if m and self.fid_ok(m.group(1)):
            fid = m.group(1)
            mt = meta(fid)
            try:
                url = action_url(mt['ext'])
            except Exception:
                return self.send(503, 'The editor is starting. Please try again in a moment.', 'text/plain')
            if not url:
                return self.send(415, 'This kind of file cannot be edited here.', 'text/plain')
            touch(fid)
            src = quote(f'{WOPI_SELF}/wopi/files/{fid}', safe='')
            html = OPEN % {'name': mt['name'].replace('<', ''), 'url': f'{url}WOPISrc={src}', 'tok': fid}
            return self.send(200, html, 'text/html; charset=utf-8')
        m = re.match(r'^/wopi/files/([0-9a-f]{32})(/contents)?$', p)
        if m and self.fid_ok(m.group(1)) and parse_qs(u.query).get('access_token', [''])[0] == m.group(1):
            fid = m.group(1)
            d, f, _ = paths(fid)
            if m.group(2):
                touch(fid)
                with open(f, 'rb') as fh:
                    return self.send(200, fh.read(), 'application/octet-stream')
            mt = meta(fid)
            return self.send(200, {'BaseFileName': mt['name'], 'OwnerId': 'guest', 'UserId': 'guest', 'UserFriendlyName': 'Guest',
                                   'Size': os.path.getsize(f), 'Version': str(int(os.path.getmtime(f) * 1000)),
                                   'LastModifiedTime': time.strftime('%Y-%m-%dT%H:%M:%S.0000000Z', time.gmtime(os.path.getmtime(f))),
                                   'UserCanWrite': True, 'SupportsUpdate': True, 'UserCanNotWriteRelative': True,
                                   'DisablePrint': False, 'DisableExport': False, 'DisableCopy': False})
        return self.send(404, {'error': 'Not found'})

    def read_body(self):
        n = int(self.headers.get('Content-Length') or 0)
        if n > MAX_FILE:
            raise ValueError('Files up to %d MB can be opened here.' % (MAX_FILE // 1048576))
        return self.rfile.read(n)

    def do_POST(self):
        u = urlparse(self.path)
        p = u.path
        try:
            if p == '/upload':
                name = parse_qs(u.query).get('name', ['document'])[0]
                return self.send(200, {'id': store(name, self.read_body())})
            m = re.match(r'^/new/(odt|ods|odp)$', p)
            if m:
                return self.send(200, {'id': store('Untitled.' + m.group(1), blank(m.group(1)))})
            m = re.match(r'^/wopi/files/([0-9a-f]{32})/contents$', p)
            if m and self.fid_ok(m.group(1)) and parse_qs(u.query).get('access_token', [''])[0] == m.group(1):
                data = self.read_body()
                with lock:
                    with open(paths(m.group(1))[1], 'wb') as fh:
                        fh.write(data)
                touch(m.group(1))
                return self.send(200, {'LastModifiedTime': time.strftime('%Y-%m-%dT%H:%M:%S.0000000Z', time.gmtime())})
        except (ValueError, RuntimeError) as e:
            return self.send(413 if isinstance(e, ValueError) else 503, {'error': str(e)})
        return self.send(404, {'error': 'Not found'})


if __name__ == '__main__':
    threading.Thread(target=sweeper, daemon=True).start()
    ThreadingHTTPServer(('0.0.0.0', 8080), H).serve_forever()
