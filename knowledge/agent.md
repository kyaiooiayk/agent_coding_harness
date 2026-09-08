---
type: Reference
title: Agent
description: This file is a curated list of best-practices design rule related to agents.
tags: [reference, agent]
timestamp: 2026-07-12T00:00:00Z
---

# Agent
***

## What is this file about?
- This file is a curated list of best-practices design rule related to agents.
***

## Major agent component 
- **System Prompt**: Defines agent's role, behavior, and tone. This sets the foundation. This is something general and not specific.
- **Brain**: The LLM is the core. It reads the situation, thinks, and decides what to do next. The big shift from chatbot to agent: the model isn't writing text anymore, it's making choices.
- **Planning**: Hard tasks need more than one step. Agents break them down using methods like Chain of Thought (think step by step), Tree of Thoughts (try options, pick the best), or Reflexion (learn from mistakes and retry). Planning turns a fuzzy goal into clear actions.
- **Tools**: An LLM without tools is a brain in a jar. Tools are functions the model can call, like web search, code execution, APIs, files, or browsers (often using the MCP standard). The model requests a tool, the system runs it, and the result comes back.
- **Tool Metadata**: Skill descriptions, MCP tool names, and deferred tool definitions. The goal is to save tokens as MCP tools may have some prettyc complex function signatures.
- **Memory**: Without memory, every turn starts from zero. Short-term memory is the context window. Long-term memory lives in vector stores, files, and knowledge bases. When the window fills up, agents summarize old turns and carry the summary forward.
- **Loop**: All four pieces work together in a cycle. The agent looks at the current state, decides what to do, uses a tool, sees the result, and repeats. It keeps going until it gives a final answer.
- **Guardrails**: Not strictly anatomy, but important. Sandboxing, human checks, token limits, output validation, and scope limits keep autonomy from turning into expensive chaos. The more autonomy you give, the more these matter.
***

## Capability
- **Reflection** makes the agent critique its own output, find problems, rewrite - one loop of self-review beats a smarter model with no review
- **Tool use** - don't just think, act - give the agent search, code execution, APIs - thinking without tools is guessing
- **Planning** - break complex tasks into steps before executing - agents that plan first solve what agents that rush can't
- **Multi-agent collaboration** - don't run one agent run a team: one writes code, another critiques it, another tests
---

## Major tools
- `LangChain` handles abstractions/tools/models
- `LangGraph` handles orchestration/retries/state
- `LangSmith` handles tracing/evals/observability
- `LangFlow` handles the creation of graph - still pretty much a manual process
***

## Notes
- There is now a shift to move agents that run in a loop
- A loop is needed to allow the agent to recover  on those unforseen errors 
- Write the perfect prompt that reduces all the uncertainty
***

## Refernces
- 
***