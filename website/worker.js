// Worker "nubo-web": serves nubosuite.tech (www/) and os.nubosuite.tech (os/) from the
// R2 bucket nubo-archive, and stores early-access requests in KV (os site only).
const SITES = { 'nubosuite.tech': 'www/', 'os.nubosuite.tech': 'os/' };
const SEC = {
  'x-content-type-options': 'nosniff',
  'referrer-policy': 'strict-origin-when-cross-origin',
  'x-frame-options': 'SAMEORIGIN',
  'permissions-policy': 'camera=(), microphone=(), geolocation=()',
  'strict-transport-security': 'max-age=15552000',
};
const CSP = "default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline'; img-src 'self' data:; font-src 'self'; connect-src 'self'; base-uri 'self'; form-action 'self'; frame-ancestors 'self'";
const json = (o, status = 200) => new Response(JSON.stringify(o), { status, headers: { 'content-type': 'application/json', 'cache-control': 'no-store', ...SEC } });

async function waitlist(req, env) {
  if (req.method !== 'POST') return json({ error: 'Method not allowed' }, 405);
  if (req.headers.get('origin') !== 'https://os.nubosuite.tech') return json({ error: 'Not allowed' }, 403);
  let b;
  try { b = await req.json(); } catch { return json({ error: 'Invalid request' }, 400); }
  if (b.company) return json({ ok: true }); // honeypot: pretend it worked
  const email = String(b.email || '').trim().toLowerCase();
  if (email.length > 254 || !/^[^@\s]+@[^@\s]+\.[^@\s]+$/.test(email)) return json({ error: 'Please enter a valid email address.' }, 400);
  const arch = ['amd64', 'arm64', 'unsure'].includes(b.arch) ? b.arch : 'unsure';
  // Light rate limit per address of the sender (counter only; the address itself is not kept)
  const ip = req.headers.get('cf-connecting-ip') || 'unknown';
  const h = Array.from(new Uint8Array(await crypto.subtle.digest('SHA-256', new TextEncoder().encode(ip + 'nubo')))).slice(0, 8).map(x => x.toString(16).padStart(2, '0')).join('');
  const rk = 'rl:' + h;
  const n = parseInt((await env.WAITLIST.get(rk)) || '0', 10);
  if (n >= 10) return json({ error: 'Too many requests. Please try again later.' }, 429);
  await env.WAITLIST.put(rk, String(n + 1), { expirationTtl: 3600 });
  await env.WAITLIST.put('wl:' + email, JSON.stringify({ arch, ts: new Date().toISOString() }));
  return json({ ok: true });
}

export default {
  async fetch(req, env) {
    const url = new URL(req.url);
    const host = url.hostname;
    if (host === 'www.nubosuite.tech') return Response.redirect('https://nubosuite.tech' + url.pathname + url.search, 301);
    const prefix = SITES[host];
    if (!prefix) return new Response('Not found', { status: 404 });
    if (url.pathname === '/api/waitlist' && host === 'os.nubosuite.tech') return waitlist(req, env);
    if (req.method !== 'GET' && req.method !== 'HEAD') return new Response('Method not allowed', { status: 405 });

    const path = decodeURIComponent(url.pathname);
    const base = path.replace(/^\/+/, '');
    const candidates = path.endsWith('/') || base === '' ? [base + 'index.html'] : [base, base + '/index.html', base + '.html'];
    let obj = null, key = '';
    for (const c of candidates) { obj = await env.SITE.get(prefix + c); if (obj) { key = c; break; } }
    if (obj && !path.endsWith('/') && key.endsWith('/index.html')) return Response.redirect(url.origin + path + '/' + url.search, 301);
    let status = 200;
    if (!obj) { obj = await env.SITE.get(prefix + '404.html'); key = '404.html'; status = 404; if (!obj) return new Response('Not found', { status: 404 }); }
    const hd = new Headers(SEC);
    obj.writeHttpMetadata(hd);
    hd.set('etag', obj.httpEtag);
    const isHtml = key.endsWith('.html');
    if (isHtml) hd.set('content-security-policy', CSP);
    hd.set('cache-control', isHtml ? 'public, max-age=300' : key.startsWith('assets/') ? 'public, max-age=86400' : 'public, max-age=3600');
    if (req.headers.get('if-none-match') === obj.httpEtag) return new Response(null, { status: 304, headers: hd });
    return new Response(req.method === 'HEAD' ? null : obj.body, { status, headers: hd });
  },
};
