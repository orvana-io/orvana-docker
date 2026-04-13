/**
 * Orvana install script Worker
 * Deployed at: get.orvana.io
 *
 * Fetches install.sh from GitHub and serves it with correct headers.
 * Usage: curl -fsSL https://get.orvana.io | bash
 */

const INSTALL_SCRIPT_URL =
  'https://raw.githubusercontent.com/orvana-io/orvana-docker/main/install.sh';

export default {
  async fetch(request) {
    const url = new URL(request.url);

    // Health check
    if (url.pathname === '/health') {
      return new Response('ok', { status: 200 });
    }

    // Add timestamp cache buster to bypass GitHub CDN cache
    const bustUrl = `${INSTALL_SCRIPT_URL}?t=${Date.now()}`;

    const response = await fetch(bustUrl, {
      cf: { cacheEverything: false, cacheTtl: 0 },
    });

    if (!response.ok) {
      return new Response('Failed to fetch install script', { status: 502 });
    }

    const script = await response.text();

    return new Response(script, {
      status: 200,
      headers: {
        'Content-Type': 'text/plain; charset=utf-8',
        'Cache-Control': 'no-cache, no-store, must-revalidate',
        'X-Content-Type-Options': 'nosniff',
      },
    });
  },
};
