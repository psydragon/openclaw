# Feishu WebSocket Demo (`feishu-ws-demo`)

A minimal, self-contained example that connects to Feishu/Lark using the
**WebSocket long-connection** (长连接) event-subscription mode.  No public
URL or webhook server is required – the SDK keeps an outbound WebSocket
connection open and delivers events in real-time.

---

## Quick start

### 1. Create a Feishu app

1. Go to [Feishu Open Platform](https://open.feishu.cn/app)  
   (Lark/global tenants: [https://open.larksuite.com/app](https://open.larksuite.com/app))
2. Click **Create App** → **Self-built application**.
3. Copy the **App ID** and **App Secret** from the *Credentials & Basic Info* tab.

### 2. Enable WebSocket event subscription (长连接)

1. In the Feishu console, open your app.
2. Go to **Development** → **Events & Callbacks** (开发配置 → 事件与回调).
3. Click **Add event** and subscribe to: `im.message.receive_v1`
4. Select **"Use long connection to receive events"** (长连接接收事件).
5. Save.

### 3. Grant permissions

Under **Permissions & Scopes** (权限管理), enable:

| Permission | Purpose |
|---|---|
| `im:message` | Read messages |
| `im:message:send_as_bot` | Send replies |
| `contact:user.id:readonly` | Resolve user IDs |

### 4. Publish the app

Go to **Version Management & Release** (版本管理与发布), create a version,
submit for review, and publish.

### 5. Run the demo

```bash
cd feishu-ws-demo
npm install
cp .env.example .env   # then edit .env with your App ID and Secret
npm start
```

You should see something like:

```
Connecting to Feishu (domain: feishu) with app cli_xxx …
[INFO] WebSocket connection established
[2026-03-08T12:00:00.000Z] message from ou_xxx in p2p oc_xxx: Hello!
```

---

## Environment variables

| Variable | Required | Description |
|---|---|---|
| `FEISHU_APP_ID` | ✅ | App ID from Feishu console |
| `FEISHU_APP_SECRET` | ✅ | App Secret from Feishu console |
| `FEISHU_DOMAIN` | – | `feishu` (default) or `lark` for global tenants |
| `FEISHU_ENCRYPT_KEY` | – | Encrypt Key if configured in the console |

---

## Integrating with OpenClaw

This demo is for learning purposes.  For production use, install the
full-featured Feishu plugin for OpenClaw:

```bash
openclaw plugins install @openclaw/feishu
# or, from this repo:
openclaw plugins install ./extensions/feishu
```

Then run the onboarding wizard:

```bash
openclaw channels add
# choose Feishu
```

See [Feishu channel docs](https://docs.openclaw.ai/channels/feishu) for the
complete setup guide.
