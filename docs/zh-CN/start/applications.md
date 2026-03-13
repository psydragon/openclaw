---
summary: OpenClaw 的实际应用场景——个人助手、家庭自动化、开发者工具等
read_when:
  - 你想了解用 OpenClaw 能构建什么
  - 寻找真实应用场景和设置指南
title: 应用场景
x-i18n:
  source_path: start/applications.md
---

# OpenClaw 应用场景

OpenClaw 是一个自托管的 AI 网关。以下是一些实际使用方式。

## 个人 AI 助手

最常见的使用方式：用一个专用消息号码作为你的常驻 AI。

- 使用第二个手机号（SIM 卡或 eSIM）作为助手号
- 与 WhatsApp、Telegram 或 iMessage 配对
- 从你的个人手机发消息，获取回答、摘要、提醒或执行任务

指南：[个人助手设置](/zh-CN/start/openclaw)

## 开发者效率工具

将 OpenClaw 作为随时可访问的编程助手。

- 让它审查代码、编写测试或解释报错
- 在笔记本或 VPS 上运行，让它访问你的代码库
- 通过 Discord 或 Slack 提供团队访问（配合白名单使用）
- 通过消息命令触发 CI 工作流或脚本

工具：[工具概览](/zh-CN/tools)，[工作区](/zh-CN/concepts/agent-workspace)

## 家庭自动化与工作流

OpenClaw 支持定时任务（cron 风格）并可通过 hooks 触发操作。

- 安排每日简报（天气、日历摘要、新闻）
- 通过 WhatsApp 设置提醒和待办事项跟踪
- 通过消息命令触发智能家居脚本
- 通过 Webhook 串联动作

指南：[自动化](/zh-CN/automation)，[定时任务](/zh-CN/cron-jobs)

## 团队机器人

将 OpenClaw 接入团队频道，配合成员白名单使用。

- 与队友共享一个 Discord 或 Slack 机器人
- 为每个用户提供独立的隔离会话（沙箱模式）
- 通过 `AGENTS.md` 和 `SOUL.md` 添加自定义人格
- 记录使用情况以供审计

指南：[路由与会话](/zh-CN/concepts/routing)，[Skills](/zh-CN/plugins)

## 语音助手（macOS）

在 macOS 上，OpenClaw 与菜单栏应用集成，支持语音输入和输出。

- 通过 macOS 配套应用与助手对话
- 通过 TTS 接收语音回复
- 在屏幕锁定或合盖状态下正常工作

指南：[macOS 应用](/zh-CN/platforms/macos)，[TTS](/zh-CN/tts)

## Canvas 与富内容

OpenClaw 支持在 iOS 和 Android 上实时渲染 Canvas，提供丰富的交互式响应。

- 以实时 Canvas 形式渲染图表、表格或格式化输出
- 分享只读 Canvas 视图链接
- 使用移动端原生应用与 Canvas 会话交互

指南：[移动端应用](/zh-CN/platforms/ios)，[Android](/zh-CN/platforms/android)

## 云端/VPS 部署

在 VPS 或云主机上运行 OpenClaw，实现全天候可用。

- 部署到 Fly.io、Hetzner、GCP、Railway、Render 或任意 VPS
- 使用 Docker 进行容器化部署
- 通过反向代理添加域名和 HTTPS

指南：[VPS 托管](/zh-CN/vps)，[Docker](/zh-CN/install/docker)

---

<Columns>
  <Card title="入门指南" href="/zh-CN/start/getting-started" icon="rocket">
    安装 OpenClaw，开始第一次对话。
  </Card>
  <Card title="案例展示" href="/zh-CN/start/showcase" icon="sparkles">
    看看社区构建了什么。
  </Card>
  <Card title="功能" href="/zh-CN/concepts/features" icon="list">
    完整功能参考。
  </Card>
</Columns>
