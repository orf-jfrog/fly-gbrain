#!/bin/bash
set -e

echo "==> Cloning ors-brain from GitHub..."
if [ -d "/brain/.git" ]; then
  git -C /brain pull
else
  git clone "https://x-access-token:${GITHUB_TOKEN}@github.com/orf-jfrog/ors-brain.git" /brain
fi

echo "==> Initializing gbrain with Supabase (DATABASE_URL)..."
gbrain init --yes 2>/dev/null || true
gbrain apply-migrations --yes 2>/dev/null || true

echo "==> Importing vault..."
gbrain import /brain --no-embed --yes

echo "==> Generating embeddings..."
gbrain embed --stale

echo "==> Starting HTTP MCP server..."
exec gbrain serve --http \
  --port "${PORT:-3000}" \
  --bind 0.0.0.0 \
  --public-url "${PUBLIC_URL}"
