---
title: "Use Cases"
description: "Real-world application scenarios for OpenClaw"
summary: "Application scenarios for OpenClaw"
read_when:
  - You want to understand what OpenClaw is good for
  - You are evaluating OpenClaw for a specific use case
  - You want ideas for building workflows with OpenClaw
---

# Use Cases

OpenClaw is a self-hosted personal AI assistant reachable from any messaging app. This page covers the most common application scenarios.

## Personal Productivity

Use OpenClaw as an always-on AI assistant reachable from any messaging app you already use.

- **Task and project management**: send a message from WhatsApp or Telegram and have your agent update your task manager, draft a summary, or run a checklist.
- **Scheduling and reminders**: pair with a CalDAV skill or cron jobs to get proactive briefings, reminders, and daily digests.
- **Research and retrieval**: ask questions and have the agent search the web (Brave Search, Perplexity), summarize PDFs, or query your personal knowledge base.
- **Voice notes to action**: drop a voice message into Telegram; the agent transcribes it and converts it into a task, note, or email draft.

## Software Development

OpenClaw is purpose-built for coding agent workflows.

- **Code review via chat**: configure an agent that monitors pull requests and delivers review feedback directly to your Telegram or Slack.
- **Automated CI/CD assistant**: trigger code generation, test runs, or deployment pipelines by sending a message from your phone.
- **On-call assistant**: route alerts from monitoring services to your agent, which triages and drafts incident reports without you opening a laptop.
- **Multi-agent coding pipelines**: use [multi-agent routing](/concepts/multi-agent) to run an orchestrator agent that delegates to specialized sub-agents and delivers results to any channel.

## Home and IoT Automation

- **Smart home control**: connect Home Assistant or other IoT platforms via skills and control your home by chat.
- **Scheduled routines**: use cron jobs or heartbeats to trigger morning briefings, air quality checks, or appliance control on a schedule.
- **Hardware monitoring**: pipe sensor data to the gateway and let your agent alert you or take automatic action when thresholds are exceeded.

## Business and Team Workflows

- **Customer support triage**: connect a Slack or Teams channel to an agent that handles tier-1 support queries, escalates edge cases, and logs everything.
- **Document and data processing**: automate intake of emails, invoices, or PDFs — extract, summarize, and file documents without manual intervention.
- **Internal knowledge assistant**: deploy a private agent connected to your docs, wikis, and code repositories so your team can query institutional knowledge by chat.

## Education and Learning

- **Language tutoring**: build a skill that runs structured drills, checks pronunciation (via voice notes), and adapts to the learner's pace.
- **Flashcard and quiz automation**: generate practice sets from uploaded reading material and deliver them on a schedule.
- **Study companion**: ask questions mid-study and receive explanations, summaries, or exam-prep guides.

## Media and Content

- **Content drafting pipeline**: send bullet points from your phone, have the agent expand them into blog posts, social captions, or newsletters.
- **Image and chart analysis**: attach images or screenshots; the agent analyzes charts, receipts, whiteboards, or design mockups.
- **Podcast and video workflows**: transcribe audio, generate show notes, create chapter markers, or clip highlights automatically.

---

## Related Pages

- [Showcase](/start/showcase) — real projects built by the community
- [Skills](/tools/skills) — how to create and distribute skills
- [Multi-agent routing](/concepts/multi-agent) — building complex agent pipelines
- [Automation](/automation/cron-jobs) — scheduled tasks, webhooks, and hooks
- [Plugin development](/tools/plugin) — building OpenClaw extensions
