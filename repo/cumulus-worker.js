// Nubo Cumulus: caches Ubuntu's package archive at Cloudflare's edge.
// Deployed as Worker "nubo-cumulus", route archive.nubosuite.tech/cumulus*.
const UP = { cumulus: 'https://archive.ubuntu.com/ubuntu', 'cumulus-arm': 'https://ports.ubuntu.com/ubuntu-ports' };
const SELF = 'https://archive.nubosuite.tech';
export default {
  async fetch(req) {
    if (req.method !== 'GET' && req.method !== 'HEAD') return new Response('Method not allowed', { status: 405 });
    const u = new URL(req.url);
    const m = u.pathname.match(/^\/(cumulus|cumulus-arm)(\/.*)?$/);
    if (!m) return new Response('Not found', { status: 404 });
    const rest = m[2] || '/';
    if (rest === '/mirrors.txt') {
      return new Response(SELF + '/' + m[1] + '\n' + UP[m[1]] + '\n', { headers: { 'content-type': 'text/plain', 'cache-control': 'public, max-age=300' } });
    }
    if (rest === '/') return new Response('Nubo Cumulus: a fast, cached route to the Ubuntu package archive. Packages are unchanged and signed by Ubuntu.\n', { headers: { 'content-type': 'text/plain' } });
    const immutable = /\/(pool|by-hash)\//.test(rest) || /\.(deb|udeb|dsc|tar\.[a-z0-9]+|diff\.gz)$/.test(rest);
    const ttl = immutable ? 604800 : 120;
    const upstream = await fetch(UP[m[1]] + rest + u.search, {
      method: req.method,
      headers: { 'user-agent': 'nubo-cumulus', 'accept-encoding': req.headers.get('accept-encoding') || 'identity' },
      cf: { cacheEverything: true, cacheTtlByStatus: { '200-299': ttl, '404': 30, '500-599': 0 } },
    });
    const res = new Response(upstream.body, upstream);
    res.headers.set('x-nubo-cumulus', '1');
    res.headers.delete('set-cookie');
    return res;
  },
};
