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

  # Generate secure passwords
  PG_PASS=$(openssl rand -base64 32)
  REDIS_PASS=$(openssl rand -base64 32)
  sed -i "s/change-me-to-something-secure/$PG_PASS/" .env
  # Set redis password separately
  sed -i "s/REDIS_PASSWORD=.*/REDIS_PASSWORD=$REDIS_PASS/" .env

  echo ""
  echo "Created .env file. Please set your domain:"
  echo "  ORVANA_DOMAIN=your-station.example.com"
  echo ""
  echo "Edit $ORVANA_DIR/.env then run:"
  echo "  cd $ORVANA_DIR && docker compose up -d"
  echo ""
else
  echo ""
  echo "Starting Orvana..."
  docker compose pull
  docker compose up -d
  echo ""
  echo "Orvana is running."
  echo "Open https://$(grep ORVANA_DOMAIN .env | cut -d= -f2) in your browser."
  echo ""
fi
