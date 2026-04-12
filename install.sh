#!/usr/bin/env bash
set -euo pipefail

# Orvana install script
# Usage: curl -fsSL https://get.orvana.io | bash

ORVANA_DIR="${ORVANA_DIR:-/opt/orvana}"
REPO="https://github.com/orvana-io/orvana-docker"

echo ""
echo "  ██████  ██████  ██    ██  █████  ███    ██  █████  "
echo " ██    ██ ██   ██ ██    ██ ██   ██ ████   ██ ██   ██ "
echo " ██    ██ ██████  ██    ██ ███████ ██ ██  ██ ███████ "
echo " ██    ██ ██   ██  ██  ██  ██   ██ ██  ██ ██ ██   ██ "
echo "  ██████  ██   ██   ████   ██   ██ ██   ████ ██   ██ "
echo ""
echo " Web-based radio playout software — orvana.io"
echo ""

# Check dependencies
for cmd in docker curl git; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "Error: $cmd is required but not installed."
    exit 1
  fi
done

# Check Docker Compose
if ! docker compose version &>/dev/null; then
  echo "Error: Docker Compose v2 is required."
  exit 1
fi

echo "Installing Orvana to $ORVANA_DIR..."

# Clone or update
if [ -d "$ORVANA_DIR/.git" ]; then
  echo "Updating existing installation..."
  git -C "$ORVANA_DIR" pull
else
  git clone "$REPO" "$ORVANA_DIR"
fi

cd "$ORVANA_DIR"

# Create .env if it doesn't exist
if [ ! -f .env ]; then
  cp .env.example .env

  # Generate secure passwords (use printf to avoid newlines, tr to strip base64 padding issues)
  PG_PASS=$(openssl rand -hex 32)
  REDIS_PASS=$(openssl rand -hex 32)

  # Use | as delimiter to avoid issues with / in base64 passwords
  sed -i "s|POSTGRES_PASSWORD=change-me-to-something-secure|POSTGRES_PASSWORD=${PG_PASS}|" .env
  sed -i "s|REDIS_PASSWORD=change-me-to-something-secure|REDIS_PASSWORD=${REDIS_PASS}|" .env

  echo ""
  echo "✓ Created .env with secure passwords."
  echo ""
  echo "Next step — set your domain in $ORVANA_DIR/.env:"
  echo "  ORVANA_DOMAIN=your-station.example.com"
  echo ""
  echo "Then start Orvana:"
  echo "  cd $ORVANA_DIR && docker compose up -d"
  echo ""
else
  echo ""
  echo "Starting Orvana..."
  docker compose pull
  docker compose up -d
  echo ""
  echo "✓ Orvana is running."
  DOMAIN=$(grep '^ORVANA_DOMAIN=' .env | cut -d= -f2)
  echo "  Open https://${DOMAIN} in your browser."
  echo ""
fi
