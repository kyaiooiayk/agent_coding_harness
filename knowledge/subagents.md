---
type: Reference
title: Subagents
description: Decision criteria for when to create a sub-agent versus a tool — expertise, tools, lifecycle, and prompt size.
tags: [reference, agent, subagent, orchestration]
timestamp: 2026-07-20T00:00:00Z
disclosure: on_demand
---

# Subagents
---

## When to use subagents?
- Vreate a sub-agent when a capability becomes complex enough that it needs its own reasoning, tools, context, policies, or lifecycle.
- Do not create sub-agents just to split up tasks — orchestration overhead can easily outweigh the benefit.
- When a sub-agent must collaborate as an opaque peer (own prompt/tools/lifecycle), communicate over **A2A**, not MCP — see [Agent2Agent (A2A)](/knowledge/A2A.md).
---

## Decision boundaries
| Signal                                          | Create a sub-agent? | Why                                          |
| ----------------------------------------------- | ------------------- | -------------------------------------------- |
| The task has a different goal or expertise area | ✅ Yes               | Separate expertise reduces prompt complexity |
| It needs different tools or permissions         | ✅ Yes               | Isolation improves security and control      |
| It has its own business rules/process           | ✅ Yes               | Easier to maintain and test                  |
| It needs a different tone/personality           | ✅ Yes               | Avoids one agent becoming inconsistent       |
| It has a long-running workflow                  | ✅ Yes               | Better state management                      |
| The main agent prompt is becoming huge          | ✅ Yes               | Reduce cognitive load                        |
| It is only a small step in a conversation       | ❌ No                | Just use a tool/function                     |
| It is just a different API call                 | ❌ No                | A tool is usually enough                     |
---
