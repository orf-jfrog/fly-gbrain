#!/bin/bash
set -e

echo "==> Cloning/updating fly-product-brain from GitHub..."
if [ -d "/brain/.git" ]; then
  git -C /brain pull
else
  git clone "https://x-access-token:${GITHUB_TOKEN}@github.com/orf-jfrog/fly-product-brain.git" /brain
fi

echo "==> Syncing any new/changed files..."
gbrain import /brain --no-embed --yes

echo "==> Embedding stale pages..."
gbrain embed --stale

echo "==> Starting HTTP MCP server..."
exec gbrain serve --http \
  --port "${PORT:-3000}" \
  --bind 0.0.0.0 \
  --public-url "${PUBLIC_URL}"
