---
type: Reference
title: Agent harness
description: An agent operating in the wild cannot be ephemeral.
tags: [reference, agent, harness]
timestamp: 2026-07-12T00:00:00Z
---

# Agent harness
***

## The State Controller & Continuation Loop
- An agent operating in the wild cannot be ephemeral.
- If a network request drops or a rate limit is hit, the agent must resume exactly where it left off.
- The State Controller maintains a durable, append-only conversation history, every prompt sent, every tool result received, so that each new step picks up with full context intact.
***

## The Tool Registry and Schema Manager
- Models do not natively understand APIs, file systems, or shells.
- The Tool Registry translates between model intent and real-world system interfaces by maintaining a catalogue of declarative tool schemas, structured definitions the model reads to understand what a tool does and what parameters it expects.
- The registry also validates inputs before execution, rejecting malformed calls at the harness level and saving expensive API roundtrips.
***

## The Execution Sandbox
- A raw terminal is a liability. A robust harness isolates every tool call: commands run inside constrained environments (Docker containers, microVMs, or at minimum a subprocess with strict timeouts and blocked patterns) rather than directly on your host.
- In our implementation we use a subprocess with a blocklist and timeout, and we are honest about what a production sandbox looks like in Part 3.
***

## Deterministic Middleware & Lifecycle Hooks
- Hooks intercept every tool call before and after execution, the same pattern HTTP frameworks use for authentication and logging middleware. Pre-execution hooks can block or rewrite a call (a linter catching bad syntax before wasting a compile cycle).
- Post-execution hooks can run tests and return pass/fail as feedback.
***

## Boundary Controls & Guardrails
- The harness is the last line of defense against runaway costs and infinite loops. Hard iteration caps guarantee a termination point regardless of what the model decides internally. 
- Token budgets and timeout limits enforce financial boundaries.
***


## References
- [Hidden Technical Debt of AI Systems: Agent Harness](https://leehanchung.github.io/blogs/2026/05/08/hidden-technical-debt-agent-harness/?utm_source=substack&utm_medium=email)
- [Inside the Machine: The Anatomy of an Agent Harness](https://mlnotes.substack.com/p/inside-the-machine-the-anatomy-of)
***