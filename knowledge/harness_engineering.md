---
type: Reference
title: Harness engineering
description: Reliability is a property of the model–harness–environment system — guides (feedforward) and sensors (feedback), computational vs inferential checks, and harnessability.
tags: [reference, agent, harness, guides, sensors, feedforward, feedback]
timestamp: 2026-08-27T10:00:00Z
disclosure: on_demand
---

# Harness engineering
***

## What is harness engineering
- An agent is a model plus a harness. The model you rent; the harness you own.
- When an AI coding agent works in your repository, only part of its behavior comes from the model. The rest comes from everything around the model: the instructions it loads, the tools it can call, the checks that run on its output, the gates that stop it from doing something destructive. That surrounding machinery is the harness, and building it deliberately is harness engineering.
- The core insight from both: reliability is a property of the whole model–harness–environment system, not of the model weights. A well-harnessed repository makes a mediocre model useful; an unharnessed repository makes a frontier model dangerous.
***

## Guides and sensors
- Böckeler's framework splits harness controls into two families, drawn from cybernetics and control systems:
- The principles are the same across Cursor, Claude Code, Windsurf, and any other AI coding tool — what differs is where you configure them (different directories and frontmatter formats), not what you're building. Harness Score recognizes these tool-specific variants via OR semantics, so your harness works everywhere.
- A harness needs both. Guides without sensors produce confident, unverified output. Sensors without guides catch the same mistakes over and over because the agent was never told how to avoid them.
***

## Feedforward vs feedback

| **Guides (feedforward)** | |
|---|---|
| **When** | *Before* the agent acts |
| **Purpose** | Steer toward good outcomes |
| **Examples (tool-agnostic)** | `AGENTS.md`, rules, skills, commands, MCP context |
| **Failure mode when missing** | Agent guesses your conventions |

| **Sensors (feedback)** | |
|---|---|
| **When** | *After* the agent acts |
| **Purpose** | Detect and correct bad outcomes |
| **Examples (tool-agnostic)** | tests, linters, type checkers, CI, hooks |
| **Failure mode when missing** | Agent ships mistakes confidently |
***

## Computational vs inferential checks
- Böckeler draws a second distinction that this guide — and the harness-score scanner — takes seriously:
- **Computational checks** are deterministic: linters, type checkers, tests, structural analysis. They run in milliseconds to seconds, cost nothing, and give the same answer every time. They belong everywhere: in hooks, in pre-commit, in CI.
- **Inferential checks** use a model: AI code review, LLM-as-judge, semantic audits. They are powerful but slow, costly, and probabilistic. Use them where semantics matter and computation can't reach.
- The strategic principle is "keep quality left": push the fast, cheap, deterministic checks as early as possible in the loop, and reserve inferential judgment for what remains. This is also why harness-score itself is 100% computational — a maturity measurement you can't reproduce is not a measurement.
***

## What the harness buys you — the LangChain lessons
1. **Self-verification loops.** The agent is required to plan → implement → test → fix before declaring victory; a pre-completion checklist middleware refuses "done" without a verification pass. In your repo, the equivalent is having tests the agent can actually run — and conventions that tell it to.
2. **Context assembly on the agent's behalf.** Their middleware maps the working directory at session start so the agent doesn't burn steps exploring. In Cursor, AGENTS.md and scoped rules do this job.
3. **Loop detection.** Middleware interrupts "doom loops" where the agent retries the same failing edit. Hooks give you the same observation point.
4. **A reasoning budget shaped like a sandwich.** Maximum thinking at planning and final verification, moderate in between. You don't control Cursor's models, but you control what the plan and the verification check against: your rules and your tests.

All four are harness properties, not model properties.
***

## Harnessability — some codebases are easier to harness
- Böckeler frames this as harnessability. Her colleague Ned Letcher's term *ambient affordances* — which she quotes — names properties of the environment that make agents more governable:
    - Typed languages give every edit a free, instant sensor (the compiler).
    - Clear module boundaries shrink the context an agent needs per task.
    - Consistent conventions turn guides from essays into bullet lists.
    - Fast test suites make self-verification cheap enough to be habitual.
- This is why the maturity model scores type checking and test infrastructure alongside Cursor-specific artifacts: they are part of the same control system.
***

## References
- [What is Harness Engineering? — Harness Score](https://paladini.io/harness-score/guide/what-is-harness-engineering.html)
***
