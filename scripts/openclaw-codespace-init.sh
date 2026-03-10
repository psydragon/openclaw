#!/usr/bin/env bash
# OpenClaw Codespace Initializer
# Runs once when a GitHub Codespace is created (or manually via: bash scripts/openclaw-codespace-init.sh).
#
# What it does:
#   1. Ensures Node 22+ is available.
#   2. Installs pnpm dependencies for the monorepo.
#   3. Builds the CLI so `pnpm openclaw` works immediately.
#   4. Prints Feishu setup instructions (WebSocket long-connection mode).
set -euo pipefail

BOLD='\033[1m'
SUCCESS='\033[38;2;0;229;204m'
INFO='\033[38;2;136;146;176m'
WARN='\033[38;2;255;176;32m'
ERROR='\033[38;2;230;57;70m'
NC='\033[0m'

step()  { echo -e "${BOLD}▶ $*${NC}"; }
ok()    { echo -e "${SUCCESS}✔ $*${NC}"; }
info()  { echo -e "${INFO}  $*${NC}"; }
warn()  { echo -e "${WARN}⚠ $*${NC}"; }
fail()  { echo -e "${ERROR}✖ $*${NC}"; exit 1; }

# ---------------------------------------------------------------------------
# 1. Node version check
# ---------------------------------------------------------------------------
step "Checking Node.js version..."
NODE_MAJOR="$(node --version 2>/dev/null | sed 's/v\([0-9]*\).*/\1/' || echo 0)"
if [[ "$NODE_MAJOR" -lt 22 ]]; then
  fail "Node.js 22+ is required (found: $(node --version 2>/dev/null || echo 'not installed')). Install via https://nodejs.org"
fi
ok "Node.js $(node --version) ✓"

# ---------------------------------------------------------------------------
# 2. pnpm
# ---------------------------------------------------------------------------
if ! command -v pnpm &>/dev/null; then
  step "Installing pnpm..."
  npm install -g pnpm@latest
fi
ok "pnpm $(pnpm --version) ✓"

# ---------------------------------------------------------------------------
# 3. Install workspace dependencies
# ---------------------------------------------------------------------------
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

step "Installing workspace dependencies (this may take a minute)..."
pnpm install --frozen-lockfile 2>&1 | tail -5
ok "Dependencies installed ✓"

# ---------------------------------------------------------------------------
# 4. Build CLI
# ---------------------------------------------------------------------------
step "Building OpenClaw CLI..."
pnpm build 2>&1 | tail -5
ok "CLI built ✓"

# ---------------------------------------------------------------------------
# 5. Config directory
# ---------------------------------------------------------------------------
CONFIG_DIR="${HOME}/.openclaw"
if [[ ! -d "$CONFIG_DIR" ]]; then
  mkdir -p "$CONFIG_DIR"
  info "Created config directory: $CONFIG_DIR"
else
  info "Config directory already exists: $CONFIG_DIR"
fi

# In Codespaces, /workspaces is the persistent volume.
# Offer to symlink ~/.openclaw → /workspaces/.openclaw so config survives rebuilds.
if [[ -d "/workspaces" && ! -L "$CONFIG_DIR" ]]; then
  PERSISTENT_DIR="/workspaces/.openclaw"
  warn "Detected GitHub Codespaces."
  info "Tip: symlink your config dir to the persistent volume so it survives rebuilds:"
  info "  mv ~/.openclaw /workspaces/.openclaw && ln -s /workspaces/.openclaw ~/.openclaw"
fi

# ---------------------------------------------------------------------------
# 6. Feishu plugin
# ---------------------------------------------------------------------------
step "Installing Feishu/Lark plugin..."
# Use the local checkout so CI doesn't hit npm.
pnpm openclaw plugins install "$REPO_ROOT/extensions/feishu" --yes 2>/dev/null \
  || warn "Could not auto-install Feishu plugin (run manually: openclaw plugins install ./extensions/feishu)"
ok "Feishu plugin ready ✓"

# ---------------------------------------------------------------------------
# Done – print next steps
# ---------------------------------------------------------------------------
echo ""
echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BOLD}  OpenClaw Codespace ready!${NC}"
echo -e "${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${BOLD}To set up Feishu (飞书) with WebSocket long-connection:${NC}"
echo ""
echo -e "  1. Go to https://open.feishu.cn/app and create a self-built app."
echo -e "     (Lark/global tenants: https://open.larksuite.com/app)"
echo ""
echo -e "  2. Under ${BOLD}Development → Events & Callbacks${NC} (开发配置 → 事件与回调):"
echo -e "     • Choose ${BOLD}\"Use long connection to receive events\"${NC} (长连接)."
echo -e "     • Add event: ${BOLD}im.message.receive_v1${NC}"
echo ""
echo -e "  3. Grant the app these permissions (权限管理):"
echo -e "     ${INFO}im:message  im:message:send_as_bot  im:chat  contact:user.id:readonly${NC}"
echo ""
echo -e "  4. Publish the app (版本管理与发布)."
echo ""
echo -e "  5. Add the Feishu channel to OpenClaw:"
echo -e "     ${BOLD}pnpm openclaw channels add${NC}"
echo -e "     (choose Feishu and enter App ID + App Secret)"
echo ""
echo -e "  6. Start the gateway:"
echo -e "     ${BOLD}pnpm openclaw gateway run${NC}"
echo ""
echo -e "  For a minimal stand-alone WebSocket demo, see ${BOLD}feishu-ws-demo/README.md${NC}."
echo ""
