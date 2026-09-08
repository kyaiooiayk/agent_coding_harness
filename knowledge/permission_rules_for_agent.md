---
type: Reference
title: Permission rules for agents
description: plan: The model drafts a plan. Nothing executes until the user approves.
tags: [reference, permission, rules, for]
timestamp: 2026-07-12T00:00:00Z
---

# Permission rules for agents
***

## Options
- plan: The model drafts a plan. Nothing executes until the user approves.
- default: Standard interactive use. Most tool calls require user approval.
- acceptEdits: Edits in the working directory are auto-approved. Other shell commands still prompt.
- auto: An ML classifier decides on requests that miss the fast path.
- dontAsk: No prompts shown. Deny rules are still enforced.
- bypassPermissions: Most prompts are skipped. Safety-critical guards still apply.
- bubble: A subagent escalates its permission request to the parent.
***

## Refernces
- [Permission modes for agent](https://blog.bytebytego.com/p/ep217-latency-vs-throughput-vs-bandwidth?img=https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F1b5057ba-3667-446b-9760-b726da1431f4_2484x3002.png&open=false)
***