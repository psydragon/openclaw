---
summary: "Run OpenClaw in GitHub Codespaces (browser-based dev environment)"
read_when:
  - Setting up OpenClaw on GitHub Codespaces
  - Contributing to OpenClaw without a local Node install
  - Evaluating or testing OpenClaw in a sandboxed cloud environment
title: "GitHub Codespaces"
---

# GitHub Codespaces

GitHub Codespaces gives you a full Linux development environment in your browser
(or in VS Code) with no local setup required. This guide walks through running the
OpenClaw Gateway inside a Codespace.

<Note>
Codespaces is a **development environment**, not a long-running production server.
Codespaces sleep after periods of inactivity and are billed by usage hours.
For a persistent 24/7 Gateway, use a VPS — see [VPS hosting](/vps).
</Note>

## Prerequisites

- A GitHub account
- An AI provider API key (e.g., OpenAI, Anthropic, or any [supported provider](/providers))
- Optional: a messaging channel token (Telegram bot token, Discord token, etc.)

## 1. Open the repository in a Codespace

Go to the OpenClaw repository on GitHub and click **Code → Codespaces → Create codespace on main**.

Or use the direct link:

```
https://codespaces.new/openclaw/openclaw
```

GitHub will build the dev container (defined in `.devcontainer/devcontainer.json`).
This takes about 2–3 minutes the first time. The container uses:

- **Node 22** (Debian Bookworm base image)
- **pnpm 10** (via corepack)

Dependencies are installed automatically via `pnpm install` as part of the container setup.

## 2. Verify the environment

Once the terminal opens, confirm the environment is ready:

```bash
node --version   # should be v22.x.x
pnpm --version   # should be 10.x.x
pnpm openclaw --version
```

## 3. Configure your AI provider

Run the onboarding wizard to set your API key and model:

```bash
pnpm openclaw onboard
```

The wizard will ask for:

1. **AI provider** — choose your provider (OpenAI, Anthropic, Gemini, etc.)
2. **API key** — paste your key (stored in `~/.openclaw/credentials/`)
3. **Model** — pick a model or accept the default
4. **Channel setup** — you can skip this step and add channels later

Skip the **daemon install** step when prompted — in Codespaces the Gateway is
started manually (see step 5).

Alternatively, set your provider key directly:

```bash
# Example: OpenAI
pnpm openclaw config set providers.openai.apiKey sk-...

# Example: Anthropic
pnpm openclaw config set providers.anthropic.apiKey sk-ant-...
```

<Tip>
Store secrets as **Codespaces secrets** in your GitHub account settings
(`github.com/settings/codespaces`) so they are available automatically
as environment variables when the Codespace starts. OpenClaw reads standard
provider env vars like `OPENAI_API_KEY` and `ANTHROPIC_API_KEY`.
</Tip>

## 4. (Optional) Connect a messaging channel

You can connect a channel from inside the Codespace. For example, Telegram:

```bash
# Add a Telegram bot token
pnpm openclaw channels login telegram
```

Or WhatsApp (scan QR code in the terminal):

```bash
pnpm openclaw channels login whatsapp
```

See [Channels](/channels) for the full list of supported platforms.

## 5. Start the Gateway

```bash
pnpm openclaw gateway run
```

The Gateway starts on port **18789**. GitHub Codespaces automatically forwards
this port and shows a notification with a link to open the Control UI.

To keep the Gateway running in the background while you use the terminal for
other commands:

```bash
# Run in background
pnpm openclaw gateway run &

# Or use a separate terminal tab (Codespaces supports multiple terminals)
```

## 6. Open the Control UI

In the Codespaces **Ports** panel (bottom of VS Code), find port **18789** and
click **Open in Browser**. The OpenClaw dashboard loads in a new tab.

If the port is not yet listed:

1. Open the **Ports** panel: `Ctrl+Shift+P` → "Ports: Focus on Ports View"
2. Click **Add Port**, enter `18789`
3. Click the globe icon next to the forwarded port

<Warning>
By default, forwarded Codespaces ports require GitHub authentication (only you
can access them). Do **not** set port visibility to "Public" unless you have
gateway authentication enabled (`gateway.auth.mode: token` or `password`).
</Warning>

## 7. Run from source (development)

For active development, run the CLI directly from source instead of the installed package:

```bash
# Type-check
pnpm tsgo

# Lint and format
pnpm check

# Run tests
pnpm test

# Build
pnpm build

# Run CLI from source
pnpm dev
```

## Persisting configuration between Codespace sessions

Codespaces do not persist the home directory between rebuilds by default.
OpenClaw stores all state under `~/.openclaw/`. To avoid re-entering credentials
every session:

1. **Use Codespaces secrets** for provider API keys (they are injected as env vars).
2. **Commit a config template** to your fork at `config/openclaw.json` or use
   `openclaw config set` commands in a `postStartCommand` in `devcontainer.json`.
3. **Mount a persisted volume** — Codespaces supports this via the
   `"mounts"` field in `devcontainer.json`.

Example `devcontainer.json` override (add to `.devcontainer/devcontainer.json`):

```json
{
  "postStartCommand": "openclaw config set providers.openai.apiKey ${OPENAI_API_KEY} 2>/dev/null || true"
}
```

## Limitations

| Feature | Status in Codespaces |
| ------- | -------------------- |
| Gateway (API + WebSocket) | ✅ Works via port forwarding |
| Control UI (web dashboard) | ✅ Works via port forwarding |
| Telegram / Discord / Slack | ✅ Works (outbound connections only) |
| WhatsApp (QR scan) | ✅ QR renders in terminal |
| iMessage | ❌ Requires macOS + BlueBubbles |
| Companion desktop app | ❌ Codespaces is headless |
| Persistent 24/7 uptime | ❌ Codespaces sleep when idle |
| Nodes (Mac/iOS/Android) | ✅ Can pair with external Codespace URL |

## Troubleshooting

### Gateway fails to start

```bash
pnpm openclaw doctor --non-interactive
pnpm openclaw gateway status
```

### Port 18789 not available

Check if another process is using the port:

```bash
lsof -i :18789
```

Run on a different port:

```bash
pnpm openclaw gateway run --port 18790
```

Then add port `18790` in the **Ports** panel.

### Node version mismatch

```bash
node --version  # must be >=22.12.0
```

If the wrong version is active, switch with `fnm` or `nvm`:

```bash
fnm use 22
# or
nvm use 22
```

### pnpm not found

```bash
corepack enable
# corepack reads the packageManager field from package.json automatically
pnpm --version
```

## See Also

- [VPS hosting](/vps) — persistent 24/7 deployment
- [Fly.io](/install/fly) — low-cost managed container hosting
- [Configuration](/gateway/configuration) — full config reference
- [Channels](/channels) — connect messaging platforms
- [Gateway runbook](/gateway) — Gateway internals and operations
