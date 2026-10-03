// Worker "nubo-docs": serves the documentation site from the docs/ folder of the R2
// bucket nubo-archive at docs.nubosuite.tech (the CI access key only covers that bucket). Deployed with the Cloudflare API (see ci/deploy-docs.sh for the content).
const SEC = {
  'x-content-type-options': 'nosniff',
  'referrer-policy': 'strict-origin-when-cross-origin',
  'x-frame-options': 'SAMEORIGIN',
  'permissions-policy': 'camera=(), microphone=(), geolocation=()',
};
const PREFIX = 'docs/';
async function get(env, key) { return env.DOCS.get(PREFIX + key); }
export default {
  async fetch(req, env) {
    if (req.method !== 'GET' && req.method !== 'HEAD') return new Response('Method not allowed', { status: 405 });
    const url = new URL(req.url);
    let path = decodeURIComponent(url.pathname);
    const base = path.replace(/^\/+/, '');
    const candidates = path.endsWith('/') || base === '' ? [base + 'index.html'] : [base, base + '/index.html', base + '.html'];
    let obj = null, key = '';
    for (const c of candidates) { obj = await get(env, c); if (obj) { key = c; break; } }
    if (obj && !path.endsWith('/') && key.endsWith('/index.html')) {
      return Response.redirect(url.origin + path + '/' + url.search, 301);
    }
    let status = 200;
    if (!obj) { obj = await get(env, '404.html'); key = '404.html'; status = 404; if (!obj) return new Response('Not found', { status: 404 }); }
    const h = new Headers(SEC);
    obj.writeHttpMetadata(h);
    h.set('etag', obj.httpEtag);
    const html = key.endsWith('.html');
    h.set('cache-control', html ? 'public, max-age=300' : 'public, max-age=31536000, immutable');
    if (req.headers.get('if-none-match') === obj.httpEtag) return new Response(null, { status: 304, headers: h });
    return new Response(req.method === 'HEAD' ? null : obj.body, { status, headers: h });
  },
};
