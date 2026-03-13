---
summary: "Practical ways to use OpenClaw — personal assistant, home automation, developer tools, and more"
read_when:
  - You want to know what you can build with OpenClaw
  - Looking for real-world application ideas and setup guides
title: "Application Scenarios"
---

# OpenClaw Application Scenarios

OpenClaw is a self-hosted AI gateway. Here are practical ways to use it.

## Personal AI assistant

The most common setup: one dedicated messaging number that acts as your always-on AI.

- Use a second phone number (SIM or eSIM) for the assistant
- Pair it with WhatsApp, Telegram, or iMessage
- Message it from your personal phone to get answers, summaries, reminders, or to run tasks

Guide: [Personal Assistant Setup](/start/openclaw)

## Developer productivity tools

Use OpenClaw as a coding companion accessible from any device.

- Ask it to review code, write tests, or explain errors
- Run it on your laptop or a VPS so it has access to your codebase
- Connect it to Discord or Slack for team access (with allowlists)
- Trigger CI workflows or scripts via message commands

Tools: [Tools overview](/tools), [Workspace](/concepts/agent-workspace)

## Home automation and workflows

OpenClaw supports cron-style scheduled tasks and can trigger actions via hooks.

- Schedule daily briefings (weather, calendar summaries, news)
- Set up reminders and to-do tracking via WhatsApp
- Trigger home automation scripts via message commands
- Chain actions with webhooks

Guide: [Automation](/automation), [Cron Jobs](/cron-jobs)

## Team bots

Connect OpenClaw to a team channel with allowlisted members.

- Share a Discord or Slack bot with teammates
- Give each user an isolated session (sandbox mode)
- Add a custom persona via `AGENTS.md` and `SOUL.md`
- Log usage for auditing

Guide: [Routing and sessions](/concepts/routing), [Skills](/plugins)

## Voice assistant (macOS)

On macOS, OpenClaw integrates with the menu bar app to support voice input and output.

- Speak to the assistant via the macOS companion app
- Receive spoken replies via TTS
- Works while your screen is locked or lid is closed

Guide: [macOS app](/platforms/macos), [TTS](/tts)

## Canvas and rich content

OpenClaw supports live Canvas rendering for rich, interactive responses on iOS and Android.

- Render charts, tables, or formatted output as a live Canvas
- Share links that open a read-only Canvas view
- Use on-device mobile apps to interact with Canvas sessions

Guide: [Mobile apps](/platforms/ios), [Android](/platforms/android)

## Hosted / VPS deployment

Run OpenClaw on a VPS or cloud host for 24/7 availability.

- Deploy on Fly.io, Hetzner, GCP, Railway, Render, or any VPS
- Use Docker for a containerised setup
- Add a domain and HTTPS via a reverse proxy

Guide: [VPS hosting](/vps), [Docker](/install/docker)

---

<Columns>
  <Card title="Getting Started" href="/start/getting-started" icon="rocket">
    Install OpenClaw and run your first chat.
  </Card>
  <Card title="Showcase" href="/start/showcase" icon="sparkles">
    See what the community has built.
  </Card>
  <Card title="Features" href="/concepts/features" icon="list">
    Full feature reference.
  </Card>
</Columns>
