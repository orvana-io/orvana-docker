# Orvana Docker

Docker Compose configuration and one-line install script for **Orvana** — web-based radio playout software.

## Quick Install

```bash
curl -fsSL https://get.orvana.io | bash
```

> Requires Docker and Docker Compose. SSL via Let's Encrypt is provisioned automatically (required for WebRTC).

## Services

| Service | Description |
|---------|-------------|
| `orvana` | Main application (Node.js + React) |
| `postgres` | PostgreSQL database |
| `redis` | Redis cache and real-time state |
| `caddy` | Reverse proxy + automatic SSL |

## Manual Install

```bash
git clone https://github.com/orvana-io/orvana-docker.git
cd orvana-docker
cp .env.example .env
# Edit .env with your domain and settings
docker compose up -d
```

## Configuration

All configuration is done via the `.env` file. See `.env.example` for all available options.

Key settings:

```env
ORVANA_DOMAIN=radio.yourstationname.com
ORVANA_LICENSE_KEY=           # Leave blank for Core (free) tier
POSTGRES_PASSWORD=changeme
REDIS_PASSWORD=changeme
```

## Upgrading

**Core (manual):** Pull the latest image and restart.

```bash
docker compose pull
docker compose up -d
```

**Pro (automatic):** Enable auto-upgrades in the Orvana admin interface.

## Links

- Documentation: https://github.com/orvana-io/orvana-docs
- Main repository: https://github.com/orvana-io/orvana
