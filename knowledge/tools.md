---
type: Reference
title: Agent tool design
description: Portable principles for defining agent tools — contracts, task-centric actions, schema validation, and error messages the model can act on.
tags: [agents, tools, mcp, prompting]
timestamp: 2026-07-16T00:00:00Z
disclosure: on_demand
---

# Tools
***

## What is this?
- A curated guide for creating tools that agents can select and call reliably.
- Companion to MCP intent design: [/knowledge/MCP.md](/knowledge/MCP.md). When to use tools vs skills vs graphs: [/knowledge/agent_primitives.md](/knowledge/agent_primitives.md).
***

## What is a tool?
In an AI system, a tool is defined like a function in a non-AI program. The tool
definition declares a contract between the model and the tool. At a minimum this
includes a clear name, parameters, and a natural-language description of its
purpose and when to use it.
***

## Types of tools
- **Function tools** — an external capability the agent can invoke to perform
  actions or access information beyond built-in reasoning. Functions bridge the
  model to APIs, databases, services, devices, or business processes.
- **Built-in tools** — the tool definition is given to the model implicitly, or
  behind the scenes of the model service (e.g. Gemini Grounding with Google Search).
- **Agent tools** — another agent invoked as a tool. This avoids a full handoff
  of the user conversation so the primary agent keeps control and processes the
  sub-agent's input and output.
***

## Describe what, not how
Explain what the model needs to do, not how to do it. Prefer
"create a bug to describe the issue" over "use the create_bug tool".
***

## Don't duplicate instructions
Do not repeat or restate the tool instructions or documentation in the system
prompt. That confuses the model and creates a dependency between system
instructions and the tool implementation.
***

## Don't dictate workflows
Describe the objective and leave room for the model to use tools autonomously,
rather than dictating a fixed sequence of actions.
***

## DO explain tool interactions
If one tool has a side effect that may affect another tool, document it. For
example, a `fetch_web_page` tool may store the retrieved page in a file —
document that so the agent knows how to access the data.
***

## Publish tasks, not API calls
Tools should encapsulate a task the agent needs to perform, not an external API.
Thin wrappers over an existing API surface are a common mistake. Define tools
that capture specific actions the agent might take on behalf of the user, and
document the action and parameters needed. APIs are for human developers who
know the full parameter surface; agent tools are chosen dynamically at runtime.
If the tool represents a specific task, the agent is much more likely to call it
correctly.
***

## Use validation effectively
Most tool-calling frameworks support optional schema validation for inputs and
outputs. Use it wherever possible. Schemas document capabilities for the model
and provide a runtime check that the tool was called correctly.
***

## Provide descriptive error messages

- Tool error messages are an overlooked way to refine and document capabilities.
- Avoid bare error codes or opaque short strings. In most tool-calling systems the
tool response is returned to the calling LLM, so the message is another
instruction channel. The error should tell the model what to do next. Example: a
product lookup might return "No product data found for product ID XXX. Ask the
customer to confirm the product name, and look up the product ID by name."
---

## What is LLM tool calling?
- LLM tool calling is when an LLM selects a declared function and returns structured arguments so your app can execute it. The model plans the call; your code performs the action.
- You define tools (name + JSON schema); the LLM outputs a tool call with arguments, and your application runs the function.

- **Schemas + validation**: Argument schemas constrain formats; your system validates inputs before execution to prevent malformed or unsafe requests.
- **Authorization + safety**: Execution should be gated by user/session permissions and allowlists so the model can’t call restricted actions.
- **Idempotency + tool results**: Use idempotency keys for retries and return tool results back to the model so it can continue the conversation with real outcomes.

---

# Related
- [/knowledge/MCP.md](/knowledge/MCP.md) — atomic, intent-centric MCP tool design
- [/knowledge/agent_primitives.md](/knowledge/agent_primitives.md) — tools vs skills vs orchestration
- [/docs/mcp.md](/docs/mcp.md) — `<describe your MCP server contract here>` (when present)
- `<path to MCP server README>` — implementation and skills boundary (when present)
- `.cursor/rules/` — tool wiring belongs in tool metadata, not a free-form system prompt
---
