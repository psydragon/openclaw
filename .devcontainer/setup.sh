#!/usr/bin/env bash
# .devcontainer/setup.sh
# Post-create setup script for GitHub Codespaces.
# Installs dependencies and prints getting-started instructions.
set -euo pipefail

echo "==> Enabling corepack (pnpm) ..."
corepack enable

echo "==> Installing project dependencies ..."
pnpm install

echo ""
echo "✅ OpenClaw Codespace is ready!"
echo ""
echo "Quick start:"
echo "  # Install OpenClaw CLI globally (one-time)"
echo "  npm install -g openclaw@latest"
echo ""
echo "  # Or run from source in this workspace"
echo "  pnpm openclaw onboard"
echo ""
echo "  # Start the gateway (source)"
echo "  pnpm openclaw gateway --port 18789 --bind loopback"
echo ""
echo "  # Open the Control UI"
echo "  pnpm openclaw dashboard"
echo ""
echo "Ports 18789 (Gateway) and 18790 (Bridge) are forwarded automatically."
echo "Docs: https://docs.openclaw.ai/install/codespaces"
