---
title: GitHub Codespaces
description: Run the OpenClaw Gateway inside a GitHub Codespace
summary: "Deploy OpenClaw in a GitHub Codespace: install, configure auth, and access the Control UI via port forwarding"
read_when:
  - You want to run OpenClaw inside a GitHub Codespace
  - You installed OpenClaw in a Codespace and haven't configured auth yet
---

# GitHub Codespaces

Run the OpenClaw Gateway inside a [GitHub Codespace](https://github.com/features/codespaces)
and access the Control UI directly from your browser via Codespaces port forwarding.

<Note>
Codespaces environments are **ephemeral** by default: they pause when idle and are deleted after
30 days of inactivity. State stored in `~/.openclaw` is lost when the Codespace is deleted.
For persistent setups, use a dedicated VPS ([VPS Hosting](/vps)) or export your config before
rebuilding the Codespace.
</Note>

## Option A — One-click (recommended)

If the OpenClaw repo already includes a `.devcontainer/devcontainer.json`, open it in a Codespace
and OpenClaw is installed automatically on container creation.

1. On [github.com/openclaw/openclaw](https://github.com/openclaw/openclaw), click **Code → Codespaces → Create codespace on main**.
2. Wait for the container to finish building (OpenClaw installs in the background).
3. Jump to [Step 2 — Run onboarding](#step-2--run-onboarding) below.

## Option B — Manual install in an existing Codespace

If you already have a Codespace (or another repo's Codespace) and want to run OpenClaw there,
install it the same way as on any Linux machine.

<Steps>
  <Step title="Install OpenClaw">
    Open the **Terminal** panel in VS Code (`` Ctrl+` ``) and run:

    ```bash
    curl -fsSL https://openclaw.ai/install.sh | bash -s -- --no-onboard
    ```

    The `--no-onboard` flag skips the interactive wizard so the install completes cleanly in
    a headless terminal. You will run onboarding manually in the next step.

    After install, reload your PATH:

    ```bash
    source ~/.bashrc
    ```

    Verify:

    ```bash
    openclaw --version
    ```
  </Step>
  <Step title="Run onboarding">
    See [Step 2 — Run onboarding](#step-2--run-onboarding) below.
  </Step>
</Steps>

---

## Step 2 — Run onboarding

The onboarding wizard configures your model provider (API key), gateway settings, and optional channels.

```bash
openclaw onboard
```

<Tip>
Choose **QuickStart** when prompted. It applies sensible defaults so you can start chatting quickly.
You can reconfigure everything later with `openclaw configure`.
</Tip>

### Import your API key

When the wizard reaches the **Model / Auth** step, choose your provider (for example **OpenAI**,
**Anthropic**, or **OpenRouter**) and paste your API key.

If you already have a key stored in a Codespace secret (or a GitHub Actions secret reused as a
Codespaces secret), you can reference it as an environment variable instead of pasting it:

```bash
openclaw onboard --non-interactive \
  --auth-choice openai-api-key \
  --secret-input-mode ref \
  --accept-risk
```

This requires `OPENAI_API_KEY` to be set in the environment (add it under
**GitHub → Settings → Codespaces → Secrets**).

For a full list of non-interactive flags, see [CLI Automation](/start/wizard-cli-automation).

### Skip daemon install

When the wizard asks about installing a **systemd daemon**, choose **Skip** (or pass
`--no-install-daemon`). Codespaces do not support systemd, so you will start the Gateway
manually instead.

---

## Step 3 — Start the Gateway

Run the Gateway in the foreground in a terminal:

```bash
openclaw gateway --port 18789
```

<Tip>
Keep this terminal open while you work. Open additional terminals (`` Ctrl+Shift+` ``) for other commands.
</Tip>

To run the Gateway in the background within the same session:

```bash
nohup openclaw gateway --port 18789 > /tmp/openclaw-gateway.log 2>&1 &
echo "Gateway PID: $!"
```

View logs:

```bash
tail -f /tmp/openclaw-gateway.log
```

---

## Step 4 — Access the Control UI

Codespaces automatically forward listening ports to a public (or private) HTTPS URL.

1. In VS Code, open the **Ports** panel (**Terminal → Ports** or the **Ports** tab at the bottom).
2. Find port **18789** — Codespaces detects it and assigns a forwarded URL.
3. Click **Open in Browser** (or the globe icon) to open the Control UI.

Alternatively, run:

```bash
openclaw dashboard
```

This opens the forwarded URL directly in your default browser.

<Note>
By default Codespaces forwards ports as **Private** (only visible to you). If you want to share
access with teammates, right-click port 18789 in the Ports panel and set **Port Visibility → Public**.
Keep in mind this makes your Control UI accessible to anyone with the URL until you make it private
again.
</Note>

---

## Using Codespaces secrets for API keys

Store sensitive values as Codespaces secrets so they are available as environment variables
without being committed to the repo.

1. Go to **github.com → Settings → Codespaces → Secrets**.
2. Add a secret, for example `OPENAI_API_KEY`.
3. Select the repository that the Codespace runs from.
4. The secret is automatically injected as an environment variable the next time the Codespace
   starts or rebuilds.

Reference the secret during onboarding:

```bash
openclaw onboard --non-interactive \
  --auth-choice openai-api-key \
  --secret-input-mode ref \
  --accept-risk
```

Or use `openclaw configure --section model` to update auth later without re-running the full
wizard.

---

## Persisting state across Codespace rebuilds

Codespaces reset `~/.openclaw` when the container rebuilds. To preserve your config:

- **Export before rebuild**: `openclaw config export > ~/codespace-backup.json` (then save it outside the Codespace).
- **Re-import after rebuild**: `openclaw config import ~/codespace-backup.json`.
- **Use a volume or mounted storage**: see [dotfiles support](https://docs.github.com/en/codespaces/setting-your-user-preferences/personalizing-github-codespaces-for-your-account) to automatically run a setup script on every new Codespace.

---

## Troubleshooting

<AccordionGroup>
  <Accordion title="`openclaw` not found after install">
    Reload your shell profile and try again:

    ```bash
    source ~/.bashrc
    openclaw --version
    ```

    If still not found:

    ```bash
    npm prefix -g
    # Add the printed path + /bin to your PATH:
    export PATH="$(npm prefix -g)/bin:$PATH"
    ```
  </Accordion>

  <Accordion title="Port 18789 not appearing in the Ports panel">
    The Ports panel only shows ports that are actively listening. Start the Gateway first:

    ```bash
    openclaw gateway --port 18789
    ```

    Then switch to the **Ports** tab — it should appear within a few seconds.
  </Accordion>

  <Accordion title="Control UI shows a connection error">
    Check that the Gateway is running and listening on the expected port:

    ```bash
    openclaw gateway status
    ```

    If the Gateway stopped, restart it:

    ```bash
    openclaw gateway --port 18789
    ```
  </Accordion>

  <Accordion title="Onboarding wizard fails: 'no TTY'">
    Some terminal configurations inside Codespaces may not expose a proper TTY.
    Use non-interactive mode instead:

    ```bash
    openclaw onboard --non-interactive \
      --flow quickstart \
      --auth-choice openai-api-key \
      --openai-api-key "$OPENAI_API_KEY"
    ```

    See [CLI Automation](/start/wizard-cli-automation) for all available flags.
  </Accordion>

  <Accordion title="Systemd / daemon install fails">
    Codespaces do not run systemd. Skip daemon install when the wizard asks, then start
    the Gateway manually with `openclaw gateway --port 18789`.
  </Accordion>
</AccordionGroup>

---

## Next steps

- Connect a channel (Telegram, Discord, Slack, etc.): [Channels](/channels)
- Add more model providers: [Model Providers](/providers)
- Advanced CLI reference: [CLI Reference](/cli)
