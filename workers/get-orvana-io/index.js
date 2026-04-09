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

    // Fetch install script from GitHub
    const response = await fetch(INSTALL_SCRIPT_URL, {
      cf: { cacheEverything: false },
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
