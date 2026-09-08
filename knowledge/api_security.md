---
type: Reference
title: API security
description: This file is a curated list of best-practices design rule related to API security best practices
tags: [reference, api, security]
timestamp: 2026-07-12T00:00:00Z
---

# API security
***

# What is this file about?
- This file is a curated list of best-practices design rule related to API security best practices
***

## Best practices
Use Modern OAuth/OIDC + MFA: PKCE for public clients, short-lived tokens, and step-up MFA for anything sensitive. Implicit and password grants should be dead by now.

Enforce Fine-Grained Authorization: Check object, function, and field-level permissions on every request. BOLA is still the top API vulnerability.

Minimize Scopes and Data: Give each client the smallest token scope and the least data it needs. Only return the fields the caller actually needs.

- Encrypt Every Hop: TLS for external traffic and mTLS between services. If it crosses a network boundary, encrypt it.
- Protect Secrets and Keys: Store signing keys in HSM-backed vaults. Rotate them.
- Validate Requests with Schemas: Reject unknown fields, oversized payloads, and suspicious URLs at the gateway. Don't let bad input reach your business logic.
- Rate Limit and Cap Resources: Quotas per user, payload size caps, and execution timeouts. Without these, one misbehaving client takes down your entire system.
- Defend Sensitive Business Flows: Protect login, checkout, and OTP with anti-bot, idempotency keys, and step-up auth.
- Control Outbound and Third-Party Calls: Allowlist where your API can call out to and block internal metadata endpoints. Your security is only as strong as your weakest integration.
- Harden Config and Error Handling: Deny by default on CORS, methods, and debug endpoints. Return generic errors, never stack traces.
- Inventory APIs and Versions: Track every endpoint, version, and shadow API. You can't secure what you don't know exists.
- Log, Detect, and Respond: Push auth decisions and anomalies to a SIEM. Alert on 401 spikes before they become incidents
***

## Refernces
- https://blog.bytebytego.com/p/ep220-rag-vs-graph-rag-vs-agentic?utm_source=post-email-title&publication_id=817132&post_id=203732633&utm_campaign=email-post-title&isFreemail=true&r=1b0gyr&triedRedirect=true&utm_medium=email
***