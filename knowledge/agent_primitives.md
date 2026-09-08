---
type: Reference
title: Agent primitives — skills, subagents, plugins, MCP, graph
description: Portable framing for agent building blocks — when to use skills, subagents, plugins, MCP tools, CLIs, graph orchestration, and AGENTS.md as a router.
tags: [reference, agents, skills, subagents, plugins, mcp, graph, cli]
timestamp: 2026-08-25T15:30:00Z
disclosure: on_demand
---

# Agent primitives — skills, subagents, plugins, MCP, graph
***

## The issue
- Several building blocks. Several different jobs.
- Teams that use them interchangeably end up with agent systems harder to maintain than the code they replaced.
***

## Skills → reusable expertise
- A folder with `SKILL.md` plus optional scripts, templates, references.
- The consuming agent discovers and loads them when the task matches.
- Progressive disclosure: only relevant pieces enter context.
- Reach for skills when you want the agent to know how to do X consistently.
- Use case: PDF generation, brand-compliant docs, domain-specific workflows.
- A skill is about know-how: repeatable reasoning patterns, standardized transformations, consistent outputs.
- Skills are typically conditional (discovery metadata first), composable within one agent environment, and owned by a versioned tree or session scope.
***

## Subagents → delegated specialists
- A separate agent instance with its own context, system prompt, and tools.
- Main agent hands off; specialist returns a result.
- Keeps the primary context clean.
- Reach for subagents when the task is isolated and context-heavy.
- Use case: code review, deep research, parallel investigation, security audits.
***

## Plugins → distributable bundles
- A package combining skills, subagents, hooks, slash commands, MCP servers.
- Install once; the entire capability stack arrives.
- Version-controlled, marketplace-ready.
- Reach for plugins when shipping to others or standardizing across teams.
- Use case: internal dev platforms, shared team toolchains, public releases.
***

## Skills vs subagents vs plugins (mental model)
- Skill = teach the agent a recipe
- Subagent = hire a specialist
- Plugin = ship the whole kitchen
- A skill pretending to be a subagent leaks context.
- A subagent pretending to be a skill wastes tokens.
- A plugin without clear boundaries becomes a dependency nightmare.
***

## MCP → reach outside the model
- Model Context Protocol connects the agent to an external system (Drive, Salesforce, BigQuery, or an internal API).
- Use when you need external systems/APIs, real-time data or side effects, or infrastructure integration.
- Use this when: “I need to reach outside the model.”
***

## Graph → orchestration over time
- Multiple steps, decisions, or agents; long-running or stateful workflows.
- Orchestration across skills and tools.
- Use this when: “I need a system that runs itself over time.”
- A graph procedure is a structured control system when flow must stay tight and deterministic; MCP and skills empower that graph.
***

## CLI
- Any command-line program the agent can invoke through bash.
- No protocol, no manifest; the agent reads --help or gets told the commands in its instructions.
- Skills and CLIs pair naturally: many of the most popular skills are a page of instructions teaching the agent an existing CLI.
---

## MCP vs. CLI
- Pick MCP when the tool is a hosted service: it needs OAuth, holds state on someone else's server, benefits from typed schemas and approval gating, or must work in a harness without shell access.
- Pick a skill wrapping a CLI when the tool is local, composable, or used only occasionally: you get near-zero context cost and full shell composition.
- Pick a bare CLI when the agent is already shell-first and the tool's `--help` is self-explanatory.
---

## AGENTS.md → always-on router
- Keep AGENTS.md tight (project conventions, stack, build commands).
- Optionally route into a skills library with a short catalog of what is available.
- AGENTS.md (or equivalent) is always-on for a coding agent; skills load on demand when their description matches the task.
***

## Skill vs MCP
- A skill teaches how to reason; an MCP tool reaches outside the model for data or side effects.
- When a skill needs external data or a side effect, it tells its consuming agent to call an exposed tool.
***

## The decision table
| Dimension | MCP server | Skill | CLI |
|---|---|---|---|
| Context cost | Schemas loaded every turn | Metadata only; body on demand | Near zero until invoked |
| Portability | Any MCP client | Any `SKILL.md`-aware harness | Anything with a shell |
| OAuth / hosted auth | Built in | None (inherits shell) | None (inherits shell) |
| Typed inputs/outputs | Yes, JSON schemas | No | No (JSON flags help) |
| Per-tool approval gating | Yes, in most harnesses | Shell-level only | Shell-level only |
| Composability | One call at a time | Full shell | Full shell |
| Works without local install | Yes (remote servers) | No | No |
***

## Layered mental model
```
GRAPH PROCEDURE (orchestrator = brain)
    ↓
SKILLS (reasoning units / SOPs = habits)
    ↓
MCP (external systems / tools = hands+sense)
```
Subagents sit beside the main agent (delegated context), not as a layer in this stack. Plugins package several of these primitives for distribution.
***

## References
- https://www.linkedin.com/posts/jeanmalaquias_if-you-want-to-be-on-top-of-claude-code-in-share-7467038442590261248-LEyI/?utm_source=share&utm_medium=member_ios&rcm=ACoAAAtIwEUBArru5MCyINlM3N6qdprHeyov2Cw
- https://parallel.ai/articles/mcp-vs-skills-vs-clis?utm_source=chatgpt.com
***
