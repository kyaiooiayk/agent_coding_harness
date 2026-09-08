---
type: Reference
title: Agent memory
description: Memory is what the system stores across runs; context is what the model sees right now — a distinction that matters when building agents.
tags: [reference, agent, memory, context, llm]
timestamp: 2026-07-20T00:00:00Z
disclosure: on_demand
---

# Agent memory

## Context vs Memory

That distinction matters when building agents.

- **Memory** is what the system stores across runs.
- **Context** is what the model sees right now.

## Why it matters

- Memory outlives a single inference call: databases, vector stores, files, session history, and other durable state.
- Context is the assembled prompt window for this turn: system instructions, retrieved snippets, tool results, and recent messages that actually reach the model.
- Designing agents means deciding what to persist as memory, then what to select and pack into context — not treating “more context” and “more memory” as the same lever.

Related: [Agent](/knowledge/agent.md) (component overview).
