#!/usr/bin/env bash
# .devcontainer/setup.sh
# Post-create setup script for GitHub Codespaces.
# Runs automatically after the dev container is created (postCreateCommand).
set -euo pipefail

echo "▶ Installing workspace dependencies (pnpm install)…"
pnpm install

# Copy the example env file so the developer has a ready-to-edit template.
if [ ! -f .env ]; then
  echo "▶ Copying .env.example → .env (fill in your API keys and tokens)…"
  cp .env.example .env
fi

echo ""
echo "✅ OpenClaw dev environment is ready!"
echo ""
echo "   Next steps:"
echo "   1. Edit .env and set at least OPENCLAW_GATEWAY_TOKEN and one AI provider key."
echo "   2. Run:  pnpm build          (compile TypeScript)"
echo "   3. Run:  pnpm openclaw gateway run --bind lan"
echo "      or:   pnpm dev"
echo "   4. The gateway will be available at the forwarded port 18789."
echo ""
echo "   Useful commands:"
echo "   pnpm test          – run unit tests"
echo "   pnpm check         – lint + type-check"
echo "   pnpm openclaw --help"
