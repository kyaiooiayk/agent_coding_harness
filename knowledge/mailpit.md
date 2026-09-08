---
type: Reference
title: Mailpit (email testing)
description: How Mailpit works as a local SMTP catcher with web UI and REST API for developer email testing — not a real mail relay.
tags: [reference, email, smtp, testing, mailpit, local-dev]
timestamp: 2026-07-18T00:00:00Z
disclosure: on_demand
---

# Mailpit

Portable primer for developers who need to understand email testing without sending real mail. Upstream project: [axllent/mailpit](https://github.com/axllent/mailpit). Project Compose/E2E wiring (when present): [/docs/local_dev_docker.md](/docs/local_dev_docker.md#local-smtp-mailpit).

## What it is

**Mailpit is a local email testing tool** — a fake SMTP server that *accepts* messages your app sends, stores them, and lets you inspect them. It does **not** deliver mail to the public internet (unless you deliberately configure relay/forwarding).

It was inspired by MailHog (largely unmaintained). Typical install shapes: single static binary, Homebrew, or Docker (`axllent/mailpit`).

Mental model:

> Your app speaks normal SMTP to Mailpit. Mailpit answers “accepted,” keeps the message, and exposes it in a UI and HTTP API. No Gmail inbox required.

## Default ports

| Port | Role |
|---|---|
| **1025** | SMTP — point `SMTP_HOST` / app config here |
| **8025** | HTTP — web UI + REST API (default `http://0.0.0.0:8025`) |

Apps under test must send to the SMTP port. Humans and automated tests use the HTTP side to read what arrived.

## How a message flows

```text
Application (auth, MCP send_email, …)
        │  SMTP (host:1025)
        ▼
   Mailpit SMTP listener
        │  store message
        ▼
   In-memory / local store
        │
        ├── Web UI  (:8025)  — browse HTML, text, headers, attachments
        └── REST API (:8025) — list / get / search / delete for tests
```

1. The app opens an SMTP session to Mailpit (often with “accept any” auth in local setups).
2. Mailpit accepts the message and stores it (pruning keeps recent volume manageable — default order of hundreds of messages).
3. You open the UI or call the API to assert subject, body, links, or confirmation tokens.

## What you get beyond SMTP

- **Web UI** — view HTML (and source), plain text, headers, raw MIME, attachments; search; optional HTTPS/auth.
- **REST API** — integration tests poll or fetch messages without a real mailbox or IMAP.
- **Optional extras** (when enabled): POP3 download into a real client, SMTP relay/release, auto-forward, Chaos (inject SMTP errors), HTML/link/spam checks, webhooks, tagging.

For most local stacks you only need SMTP + UI/API.

## When to use it

| Use Mailpit when… | Prefer a real relay when… |
|---|---|
| Local/dev email must not leave the laptop | Staging/prod must reach real inboxes |
| E2E must read confirmation links without Gmail/IMAP | You are verifying a vendor SMTP path end-to-end |
| You want deterministic, free, offline-friendly capture | Compliance or deliverability against a live provider |

## Common pitfalls

- **App still points at Gmail/SMTP relay** — Mailpit never sees the mail; fix the app’s `SMTP_HOST`/`SMTP_PORT`.
- **Looking at the wrong port** — SMTP is **1025**; browsing **8025** only shows what SMTP already accepted.
- **Assuming delivery** — “sent OK” in the app means Mailpit accepted it, not that a human inbox received it.
- **Treating it as production infrastructure** — it is a developer catcher; production uses a real MTA/relay.

## References

- [Mailpit GitHub repository](https://github.com/axllent/mailpit)
- [Mailpit documentation](https://mailpit.axllent.org/)
- [Mailpit API](https://mailpit.axllent.org/docs/api-v1/)
