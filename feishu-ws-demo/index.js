/**
 * feishu-ws-demo/index.js
 *
 * Minimal demonstration of Feishu/Lark WebSocket long-connection (长连接).
 *
 * This connects to the Feishu event subscription service and logs every
 * incoming im.message.receive_v1 event to stdout.  It does NOT require a
 * public URL or webhook server – the SDK maintains the outbound WebSocket
 * connection to Feishu.
 *
 * Prerequisites
 * -------------
 * 1. Create a self-built app at https://open.feishu.cn/app
 *    (Lark/global: https://open.larksuite.com/app)
 * 2. Under "Development → Events & Callbacks" (开发配置 → 事件与回调):
 *    - Select "Use long connection to receive events" (长连接接收事件)
 *    - Subscribe to event: im.message.receive_v1
 * 3. Grant permissions: im:message  im:message:send_as_bot  contact:user.id:readonly
 * 4. Publish the app (版本管理与发布)
 * 5. Copy .env.example → .env and fill in FEISHU_APP_ID + FEISHU_APP_SECRET
 *
 * Usage
 * -----
 *   npm install
 *   cp .env.example .env   # then fill in your credentials
 *   npm start
 */
"use strict";

// Load .env if present (no-op when running in production environments that
// already set these variables via the shell).
try {
  require("dotenv").config();
} catch (_) {
  // dotenv is an optional convenience; swallow if somehow missing.
}

const lark = require("@larksuiteoapi/node-sdk");

// ---------------------------------------------------------------------------
// Credentials – read from environment (set in .env or shell)
// ---------------------------------------------------------------------------
const APP_ID = process.env.FEISHU_APP_ID;
const APP_SECRET = process.env.FEISHU_APP_SECRET;
// Optional: set to "lark" when using the global (Lark) domain
const DOMAIN = process.env.FEISHU_DOMAIN || "feishu";

if (!APP_ID || !APP_SECRET) {
  console.error(
    "ERROR: FEISHU_APP_ID and FEISHU_APP_SECRET must be set.\n" +
      "  Copy .env.example → .env and fill in your credentials, or export them in your shell."
  );
  process.exit(1);
}

// ---------------------------------------------------------------------------
// Resolve domain
// ---------------------------------------------------------------------------
function resolveDomain(domain) {
  if (domain === "lark") return lark.Domain.Lark;
  if (domain === "feishu") return lark.Domain.Feishu;
  // Allow a full custom URL for private deployments
  return domain;
}

// ---------------------------------------------------------------------------
// Build the event dispatcher
// ---------------------------------------------------------------------------
const eventDispatcher = new lark.EventDispatcher({
  // encryptKey / verificationToken are only required in webhook mode.
  // In WebSocket mode they are optional but harmless to set.
  encryptKey: process.env.FEISHU_ENCRYPT_KEY || "",
});

// Register handlers for the events you subscribed to in the Feishu console.
eventDispatcher.register({
  // Triggered when the bot receives a direct message or a group @-mention.
  "im.message.receive_v1": (data) => {
    const msg = data.message;
    const senderId = data.sender?.sender_id?.open_id ?? "unknown";
    const chatId = msg?.chat_id ?? "unknown";
    const chatType = msg?.chat_type ?? "unknown";

    let text = "(non-text content)";
    try {
      const parsed = JSON.parse(msg?.content ?? "{}");
      text = parsed.text ?? text;
    } catch (_) {
      // leave default
    }

    console.log(
      `[${new Date().toISOString()}] message from ${senderId} in ${chatType} ${chatId}: ${text}`
    );

    // Return undefined – the SDK does not expect a response value here.
    // To reply, use a Lark.Client with im.message.create.
  },
});

// ---------------------------------------------------------------------------
// Create and start the WebSocket client
// ---------------------------------------------------------------------------
const wsClient = new lark.WSClient({
  appId: APP_ID,
  appSecret: APP_SECRET,
  domain: resolveDomain(DOMAIN),
  loggerLevel: lark.LoggerLevel.info,
});

console.log(`Connecting to Feishu (domain: ${DOMAIN}) with app ${APP_ID} …`);
wsClient.start({ eventDispatcher });

// ---------------------------------------------------------------------------
// Graceful shutdown
// ---------------------------------------------------------------------------
function shutdown(signal) {
  console.log(`\nReceived ${signal}; shutting down.`);
  // The SDK does not expose an explicit stop() method on WSClient.
  // Exiting the process is sufficient; the server will close the connection.
  process.exit(0);
}

process.on("SIGINT", () => shutdown("SIGINT"));
process.on("SIGTERM", () => shutdown("SIGTERM"));
