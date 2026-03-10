---
title: "GitHub Codespaces"
summary: "Run OpenClaw in a GitHub Codespace — zero-install, browser-based dev environment"
read_when:
  - You want to try OpenClaw without installing anything locally
  - You are developing or testing OpenClaw in a GitHub Codespace
---

# GitHub Codespaces

GitHub Codespaces gives you a full Linux dev environment in the browser (or VS Code) without installing anything on your local machine.
The repository ships a ready-to-use `.devcontainer` configuration so you can be up and running in minutes.

## Prerequisites

- A GitHub account with Codespaces enabled (free tier: 60 hours/month)
- An API key from your chosen [model provider](/providers)

## Launch a Codespace

1. Open the repository on GitHub: [openclaw/openclaw](https://github.com/openclaw/openclaw)
2. Click **Code → Codespaces → Create codespace on main** (or your branch).
3. GitHub will build the container and run the post-create setup script automatically.
   This installs Node 22, enables `pnpm` via corepack, and runs `pnpm install`.

<Note>
First build takes 2–4 minutes. Subsequent starts are much faster because the container image is cached.
</Note>

## Forwarded ports

The devcontainer configuration forwards two ports automatically:

| Port  | Service          |
| ----- | ---------------- |
| 18789 | OpenClaw Gateway |
| 18790 | OpenClaw Bridge  |

Codespaces makes these ports available as HTTPS URLs in the **Ports** panel.
Copy the Gateway URL — you will need it for remote channel pairing.

## Run the onboarding wizard

Open the integrated terminal in Codespaces and run:

```bash
# Option A — install the published CLI globally (recommended for quick setup)
npm install -g openclaw@latest
openclaw onboard

# Option B — run directly from source in the workspace
pnpm openclaw onboard
```

The wizard guides you through:

1. Choosing and authenticating a model provider
2. Configuring the Gateway (port, bind address)
3. Optionally connecting messaging channels

<Tip>
When the wizard asks for the gateway bind address, choose **loopback** (`127.0.0.1`).
Codespaces handles port forwarding and TLS termination for you — no public IP needed.
</Tip>

## Start the Gateway

```bash
# From source
pnpm openclaw gateway --port 18789 --bind loopback

# Or from the globally installed CLI
openclaw gateway --port 18789 --bind loopback
```

The **Gateway** port (18789) will appear as `Open in Browser` in the Codespaces Ports panel.

## Open the Control UI

```bash
openclaw dashboard
```

Or navigate directly to the forwarded Gateway URL shown in the **Ports** panel.

## Persist configuration across sessions

Codespaces storage is ephemeral by default — if you stop and delete a Codespace your config is lost.
To keep your configuration:

- Use a [dotfiles repository](https://docs.github.com/en/codespaces/setting-your-user-preferences/personalizing-github-codespaces-for-your-account) to restore `~/.openclaw` on each new Codespace.
- Or export/import your config manually:

```bash
# Export
tar -czf openclaw-config.tar.gz -C ~ .openclaw

# Import on a new Codespace
tar -xzf openclaw-config.tar.gz -C ~
```

## Environment variables

Set secrets in **Codespaces → Manage user secrets** (GitHub Settings) so they are injected automatically into every Codespace:

| Secret name              | Purpose                                      |
| ------------------------ | -------------------------------------------- |
| `OPENAI_API_KEY`         | OpenAI model access                          |
| `ANTHROPIC_API_KEY`      | Anthropic model access                       |
| `OPENCLAW_GATEWAY_TOKEN` | Pre-set gateway token (skips wizard prompt)  |
| `CLAUDE_AI_SESSION_KEY`  | Claude web session (if using web provider)   |

## Customizing the devcontainer

The devcontainer configuration lives in `.devcontainer/devcontainer.json`.
You can fork the repository and adjust it — for example to pre-install extensions, change the base image, or add extra apt packages.

To rebuild the container after changes:

- **Command Palette** → `Codespaces: Rebuild Container`

## Troubleshooting

**`openclaw` not found after install**

```bash
export PATH="$HOME/.npm-global/bin:$PATH"
# Or re-open the terminal; the PATH is set in the container profile.
```

**Port 18789 not accessible**

Check the **Ports** panel in VS Code / the Codespaces UI and make sure port 18789 is listed.
If not, forward it manually:

```bash
# In the VS Code Command Palette:
# "Codespaces: Forward a Port" → 18789
```

**Gateway exits immediately**

Run in verbose mode to see the error:

```bash
openclaw gateway --port 18789 --bind loopback --verbose
```

## Related

- [Getting Started](/start/getting-started)
- [Docker](/install/docker)
- [VPS deployment](/vps)
- [Onboarding Wizard](/start/wizard)
