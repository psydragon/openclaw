---
title: "GitHub Codespaces"
summary: "Run OpenClaw entirely in the browser with GitHub Codespaces — no local install required"
read_when:
  - You want to try OpenClaw without installing anything locally
  - You are developing a plugin or extension in a cloud IDE
  - You want a reproducible, disposable dev environment
---

# GitHub Codespaces

GitHub Codespaces lets you run a full OpenClaw development environment directly in your browser (or VS Code desktop) — no local Node.js, pnpm, or Bun install required.

---

## Prerequisites

- A GitHub account (free tier includes [60 core-hours / month](https://docs.github.com/en/billing/managing-billing-for-github-codespaces/about-billing-for-github-codespaces)).
- At least one AI provider API key (e.g. `OPENAI_API_KEY`, `ANTHROPIC_API_KEY`, or `GEMINI_API_KEY`).
- *(Optional)* A messaging channel token — Telegram, Discord, Slack, etc.

---

## Quick start

### 1. Open in Codespaces

Go to **[github.com/psydragon/openclaw](https://github.com/psydragon/openclaw)** and click:

**Code → Codespaces → Create codespace on main**

Or use this direct link (replace `psydragon` with your fork owner if needed):

```
https://codespaces.new/psydragon/openclaw
```

GitHub will build the dev container — this takes **2–5 minutes** on first launch (pnpm dependency install). Subsequent opens are much faster.

### 2. Configure your secrets

When the terminal opens, edit the `.env` file that was automatically copied from `.env.example`:

```bash
# Open in the editor
code .env
```

At minimum, set:

```env
# A long random token to protect the gateway WebSocket.
# Generate one with: openssl rand -hex 32
OPENCLAW_GATEWAY_TOKEN=change-me-to-a-long-random-token

# At least one AI provider key:
OPENAI_API_KEY=sk-...
# or
ANTHROPIC_API_KEY=sk-ant-...
# or
GEMINI_API_KEY=...
```

> **Security tip:** For persistent secrets, use [Codespaces secrets](https://docs.github.com/en/codespaces/managing-your-codespaces/managing-your-account-specific-secrets-for-github-codespaces) instead of editing `.env` directly. Add each key there and it will be injected automatically as environment variables every time you open this Codespace.

### 3. Build the project

```bash
pnpm build
```

### 4. Start the gateway

```bash
pnpm openclaw gateway run --bind lan
```

The gateway binds to all interfaces (`lan`) so Codespaces port forwarding can reach it. Port **18789** will be automatically forwarded — look for the notification in the bottom-right corner, or open the **Ports** panel.

### 5. Run the onboarding wizard *(optional)*

Open a second terminal and run:

```bash
pnpm openclaw wizard
```

The wizard walks you through connecting a messaging channel (Telegram, Discord, Slack, etc.) and configuring your first AI provider.

---

## Useful commands

| Command | Description |
|---|---|
| `pnpm build` | Compile TypeScript to `dist/` |
| `pnpm dev` | Run from source with live reload |
| `pnpm openclaw --help` | Show all CLI commands |
| `pnpm openclaw gateway run --bind lan` | Start the gateway (Codespaces-compatible bind) |
| `pnpm openclaw wizard` | Interactive onboarding |
| `pnpm openclaw channels status` | Check connected channel status |
| `pnpm test` | Run unit tests |
| `pnpm check` | Lint + type-check |

---

## Port reference

| Port | Service |
|---|---|
| **18789** | OpenClaw Gateway (WebSocket + HTTP API) |
| **18790** | OpenClaw Bridge (client ↔ gateway relay) |

Both ports are forwarded automatically by the dev container configuration.

---

## Tips

### Persist your config between sessions

Your `.env` file is stored inside the Codespace and survives restarts, but it is **not** committed to git (`.gitignore` excludes it). If you delete the Codespace you will need to re-enter your secrets. Using [Codespaces secrets](https://docs.github.com/en/codespaces/managing-your-codespaces/managing-your-account-specific-secrets-for-github-codespaces) is the recommended approach for long-term use.

### Use a larger machine for heavy builds

The default 2-core machine is enough for running the gateway and most plugins. For full builds with all extensions or browser automation, select a 4-core machine when creating the Codespace.

### Forwarded URL for webhooks

Some channels (e.g. WhatsApp Business, Twilio) require a public HTTPS webhook URL. In Codespaces, every forwarded port gets a public URL like:

```
https://<codespace-name>-18789.app.github.dev
```

Set that URL as the webhook endpoint in your channel provider dashboard.

To make the port public (accessible without GitHub auth), right-click the port in the **Ports** panel → **Port Visibility → Public**.

---

## 中文指南 (Chinese tutorial)

### 在 GitHub Codespaces 上部署 OpenClaw

#### 1. 打开 Codespace

访问 **[github.com/psydragon/openclaw](https://github.com/psydragon/openclaw)**，点击：

**Code（绿色按钮）→ Codespaces → Create codespace on main**

GitHub 会自动构建开发容器（首次约需 2–5 分钟）。

#### 2. 配置密钥

Codespace 启动后，终端中会自动生成 `.env` 文件。用编辑器打开它：

```bash
code .env
```

至少填写以下内容：

```env
# 网关访问令牌（建议用 openssl rand -hex 32 生成）
OPENCLAW_GATEWAY_TOKEN=换成一个长随机字符串

# 至少填写一个 AI 提供商的 API Key：
OPENAI_API_KEY=sk-...
# 或
ANTHROPIC_API_KEY=sk-ant-...
# 或
GEMINI_API_KEY=...
```

> **推荐做法：** 在 GitHub 仓库设置中添加 [Codespaces 密钥](https://docs.github.com/cn/codespaces/managing-your-codespaces/managing-your-account-specific-secrets-for-github-codespaces)，这样密钥不需要写在文件里，每次打开 Codespace 时会自动注入。

#### 3. 编译项目

```bash
pnpm build
```

#### 4. 启动网关

```bash
pnpm openclaw gateway run --bind lan
```

端口 **18789** 会被自动转发，右下角会弹出通知。

#### 5. 运行配置向导（可选）

新开一个终端：

```bash
pnpm openclaw wizard
```

向导会引导你连接 Telegram、Discord、Slack 等消息频道，并配置 AI 提供商。

#### 6. 查看频道状态

```bash
pnpm openclaw channels status
```

#### Webhook 公开 URL

如果需要外部服务回调（如 WhatsApp Business），在 **Ports** 面板中右键点击 18789 端口，选择 **Port Visibility → Public**，获得公开 HTTPS URL：

```
https://<codespace名称>-18789.app.github.dev
```

将此 URL 配置到对应平台的 Webhook 设置中即可。
