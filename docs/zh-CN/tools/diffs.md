---
read_when:
  - 你想让智能体以差异对比的形式展示代码或 Markdown 编辑内容
  - 你需要一个可供 Canvas 使用的查看器 URL 或已渲染的差异文件
  - 你需要具有安全默认值的受控临时差异产物
summary: 供智能体使用的只读差异查看器和文件渲染器（可选插件工具）
title: 差异对比（Diffs）
x-i18n:
  generated_at: "2026-03-12T12:15:44Z"
  model: claude-opus-4-5
  provider: pi
  source_hash: ef3b7a0fb4c20da0eef5f8d7f44668d979486a5a3d648d4abccd09388c69eea0
  source_path: tools/diffs.md
  workflow: 15
---

# 差异对比（Diffs）

`diffs` 是一个可选的插件工具，内置简洁的系统提示词指导，并配有一个配套 Skill，可将变更内容转换为只读的差异产物供智能体使用。

它接受以下输入之一：

- `before` 和 `after` 文本
- 一个统一格式的 `patch`

它可以返回：

- 供 Canvas 展示的 Gateway 网关查看器 URL
- 用于消息投递的已渲染文件路径（PNG 或 PDF）
- 一次调用同时返回上述两种输出

启用后，插件会将简洁的使用指导注入到系统提示词空间，同时提供一个详细的 Skill，供智能体在需要完整说明时使用。

## 快速开始

1. 启用插件。
2. 以 `mode: "view"` 调用 `diffs`，适用于以 Canvas 为主的流程。
3. 以 `mode: "file"` 调用 `diffs`，适用于通过聊天投递文件的流程。
4. 以 `mode: "both"` 调用 `diffs`，当你同时需要两种产物时使用。

## 启用插件

```json5
{
  plugins: {
    entries: {
      diffs: {
        enabled: true,
      },
    },
  },
}
```

## 禁用内置系统提示词指导

如果你想保持 `diffs` 工具启用，但禁用其内置的系统提示词指导，可将 `plugins.entries.diffs.hooks.allowPromptInjection` 设为 `false`：

```json5
{
  plugins: {
    entries: {
      diffs: {
        enabled: true,
        hooks: {
          allowPromptInjection: false,
        },
      },
    },
  },
}
```

这会阻止 diffs 插件的 `before_prompt_build` 钩子，同时保持插件、工具和配套 Skill 可用。

如果你想同时禁用指导和工具，请直接禁用插件。

## 典型智能体工作流

1. 智能体调用 `diffs`。
2. 智能体读取 `details` 字段。
3. 智能体选择以下操作之一：
   - 使用 `canvas present` 打开 `details.viewerUrl`
   - 使用 `message` 通过 `path` 或 `filePath` 发送 `details.filePath`
   - 同时执行上述两步

## 输入示例

前后对比：

```json
{
  "before": "# Hello\n\nOne",
  "after": "# Hello\n\nTwo",
  "path": "docs/example.md",
  "mode": "view"
}
```

Patch 方式：

```json
{
  "patch": "diff --git a/src/example.ts b/src/example.ts\n--- a/src/example.ts\n+++ b/src/example.ts\n@@ -1 +1 @@\n-const x = 1;\n+const x = 2;\n",
  "mode": "both"
}
```

## 工具输入参考

除非特别说明，所有字段均为可选：

- `before`（`string`）：原始文本。当省略 `patch` 时，需与 `after` 一起提供。
- `after`（`string`）：更新后的文本。当省略 `patch` 时，需与 `before` 一起提供。
- `patch`（`string`）：统一格式的差异文本。与 `before` 和 `after` 互斥。
- `path`（`string`）：前后对比模式下的显示文件名。
- `lang`（`string`）：前后对比模式下的语言覆盖提示。
- `title`（`string`）：查看器标题覆盖。
- `mode`（`"view" | "file" | "both"`）：输出模式。默认为插件默认值 `defaults.mode`。
- `theme`（`"light" | "dark"`）：查看器主题。默认为插件默认值 `defaults.theme`。
- `layout`（`"unified" | "split"`）：差异布局。默认为插件默认值 `defaults.layout`。
- `expandUnchanged`（`boolean`）：在有可展开上下文数据时展开未修改的部分。仅适用于单次调用（不是插件默认键）。
- `fileFormat`（`"png" | "pdf"`）：渲染文件格式。默认为插件默认值 `defaults.fileFormat`。
- `fileQuality`（`"standard" | "hq" | "print"`）：PNG 或 PDF 渲染的质量预设。
- `fileScale`（`number`）：设备缩放覆盖（`1`-`4`）。
- `fileMaxWidth`（`number`）：最大渲染宽度（CSS 像素，`640`-`2400`）。
- `ttlSeconds`（`number`）：查看器产物的 TTL（秒）。默认 1800，最大 21600。
- `baseUrl`（`string`）：查看器 URL 来源覆盖。必须为 `http` 或 `https`，不含查询参数/哈希。

验证与限制：

- `before` 和 `after` 各自最大 512 KiB。
- `patch` 最大 2 MiB。
- `path` 最大 2048 字节。
- `lang` 最大 128 字节。
- `title` 最大 1024 字节。
- Patch 复杂度上限：最多 128 个文件，总行数不超过 120000。
- 同时提供 `patch` 和 `before`/`after` 会被拒绝。
- 渲染文件安全限制（适用于 PNG 和 PDF）：
  - `fileQuality: "standard"`：最大 8 MP（8,000,000 渲染像素）。
  - `fileQuality: "hq"`：最大 14 MP（14,000,000 渲染像素）。
  - `fileQuality: "print"`：最大 24 MP（24,000,000 渲染像素）。
  - PDF 还有最多 50 页的限制。

## 输出 details 协议

工具在 `details` 下返回结构化元数据。

创建查看器的模式共享字段：

- `artifactId`
- `viewerUrl`
- `viewerPath`
- `title`
- `expiresAt`
- `inputKind`
- `fileCount`
- `mode`

渲染 PNG 或 PDF 时的文件字段：

- `filePath`
- `path`（与 `filePath` 值相同，兼容 message 工具）
- `fileBytes`
- `fileFormat`
- `fileQuality`
- `fileScale`
- `fileMaxWidth`

模式行为摘要：

- `mode: "view"`：仅返回查看器字段。
- `mode: "file"`：仅返回文件字段，不创建查看器产物。
- `mode: "both"`：同时返回查看器字段和文件字段。若文件渲染失败，查看器仍会返回，并附带 `fileError`。

## 折叠未修改的部分

- 查看器可以显示类似"N 行未修改"的折叠行。
- 这些行上的展开控件为条件性显示，并非对所有输入都保证出现。
- 展开控件在渲染后的差异具有可展开上下文数据时出现，通常在前后对比输入中可见。
- 对于许多统一格式 Patch 输入，省略的上下文内容在解析的 Patch 块中不可用，因此折叠行可能不带展开控件。这是预期行为。
- `expandUnchanged` 仅在可展开上下文存在时生效。

## 插件默认值

在 `~/.openclaw/openclaw.json` 中设置全局插件默认值：

```json5
{
  plugins: {
    entries: {
      diffs: {
        enabled: true,
        config: {
          defaults: {
            fontFamily: "Fira Code",
            fontSize: 15,
            lineSpacing: 1.6,
            layout: "unified",
            showLineNumbers: true,
            diffIndicators: "bars",
            wordWrap: true,
            background: true,
            theme: "dark",
            fileFormat: "png",
            fileQuality: "standard",
            fileScale: 2,
            fileMaxWidth: 960,
            mode: "both",
          },
        },
      },
    },
  },
}
```

支持的默认值：

- `fontFamily`
- `fontSize`
- `lineSpacing`
- `layout`
- `showLineNumbers`
- `diffIndicators`
- `wordWrap`
- `background`
- `theme`
- `fileFormat`
- `fileQuality`
- `fileScale`
- `fileMaxWidth`
- `mode`

显式工具参数会覆盖这些默认值。

## 安全配置

- `security.allowRemoteViewer`（`boolean`，默认 `false`）
  - `false`：拒绝来自非 loopback 地址的查看器路由请求。
  - `true`：当令牌化路径有效时，允许远程查看器访问。

示例：

```json5
{
  plugins: {
    entries: {
      diffs: {
        enabled: true,
        config: {
          security: {
            allowRemoteViewer: false,
          },
        },
      },
    },
  },
}
```

## 产物生命周期与存储

- 产物存储在临时子目录下：`$TMPDIR/openclaw-diffs`。
- 查看器产物元数据包含：
  - 随机产物 ID（20 个十六进制字符）
  - 随机令牌（48 个十六进制字符）
  - `createdAt` 和 `expiresAt`
  - 存储的 `viewer.html` 路径
- 未指定时，默认查看器 TTL 为 30 分钟。
- 最大接受的查看器 TTL 为 6 小时。
- 清理在产物创建后按需运行。
- 过期产物会被删除。
- 当元数据缺失时，兜底清理会移除超过 24 小时的过期目录。

## 查看器 URL 与网络行为

查看器路由：

- `/plugins/diffs/view/{artifactId}/{token}`

查看器资源：

- `/plugins/diffs/assets/viewer.js`
- `/plugins/diffs/assets/viewer-runtime.js`

URL 构建行为：

- 若提供 `baseUrl`，在严格验证后使用该值。
- 未提供 `baseUrl` 时，查看器 URL 默认使用 loopback 地址 `127.0.0.1`。
- 若 Gateway 网关绑定模式为 `custom` 且设置了 `gateway.customBindHost`，则使用该主机。

`baseUrl` 规则：

- 必须为 `http://` 或 `https://`。
- 拒绝包含查询参数和哈希。
- 允许来源加可选的基础路径。

## 安全模型

查看器加固：

- 默认仅限 loopback 访问。
- 使用令牌化查看器路径，严格验证 ID 和令牌。
- 查看器响应 CSP：
  - `default-src 'none'`
  - 脚本和资源仅允许来自自身
  - 无出站 `connect-src`
- 启用远程访问时的远程失败限流：
  - 每 60 秒最多 40 次失败
  - 60 秒锁定期（`429 Too Many Requests`）

文件渲染加固：

- 截图浏览器请求路由默认拒绝。
- 仅允许来自 `http://127.0.0.1/plugins/diffs/assets/*` 的本地查看器资源。
- 外部网络请求被阻止。

## 文件模式的浏览器要求

`mode: "file"` 和 `mode: "both"` 需要一个兼容 Chromium 的浏览器。

解析顺序：

1. OpenClaw 配置中的 `browser.executablePath`。
2. 环境变量：
   - `OPENCLAW_BROWSER_EXECUTABLE_PATH`
   - `BROWSER_EXECUTABLE_PATH`
   - `PLAYWRIGHT_CHROMIUM_EXECUTABLE_PATH`
3. 平台命令/路径发现兜底。

常见失败提示：

- `Diff PNG/PDF rendering requires a Chromium-compatible browser...`

解决方法：安装 Chrome、Chromium、Edge 或 Brave，或设置上述可执行文件路径选项之一。

## 故障排除

输入验证错误：

- `Provide patch or both before and after text.`
  - 请同时提供 `before` 和 `after`，或提供 `patch`。
- `Provide either patch or before/after input, not both.`
  - 不要混用输入模式。
- `Invalid baseUrl: ...`
  - 使用带可选路径的 `http(s)` 来源，不含查询参数/哈希。
- `{field} exceeds maximum size (...)`
  - 减小负载大小。
- 大型 Patch 被拒绝
  - 减少 Patch 中的文件数量或总行数。

查看器访问问题：

- 查看器 URL 默认解析到 `127.0.0.1`。
- 对于远程访问场景，可选择：
  - 每次工具调用时传入 `baseUrl`，或
  - 使用 `gateway.bind=custom` 和 `gateway.customBindHost`
- 仅在需要外部查看器访问时才启用 `security.allowRemoteViewer`。

未修改行没有展开按钮：

- 当 Patch 输入不携带可展开上下文时可能发生。
- 这是预期行为，不表示查看器故障。

产物未找到：

- 产物因 TTL 过期。
- 令牌或路径已更改。
- 清理操作移除了过期数据。

## 操作指南

- 对于本地 Canvas 交互审查，优先使用 `mode: "view"`。
- 对于需要附件的出站聊天渠道，优先使用 `mode: "file"`。
- 除非部署需要远程查看器 URL，否则保持 `allowRemoteViewer` 禁用。
- 对敏感差异设置较短的明确 `ttlSeconds`。
- 在不必要时，避免在差异输入中发送密钥。
- 若你的渠道对图片压缩较大（例如 Telegram 或 WhatsApp），优先选择 PDF 输出（`fileFormat: "pdf"`）。

差异渲染引擎：

- 由 [Diffs](https://diffs.com) 提供支持。

## 相关文档

- [工具概览](/tools)
- [插件](/tools/plugin)
- [浏览器](/tools/browser)
