---
type: Reference
title: Agent2Agent (A2A) Protocol
description: Open Agent2Agent protocol — client vs remote agents, Agent Cards, Tasks, artifacts, message parts, JSON-RPC/SSE; complements MCP (agent-to-tool).
tags: [reference, a2a, agents, interoperability, protocol]
timestamp: 2026-07-20T00:00:00Z
disclosure: on_demand
---

# Agent2Agent (A2A) Protocol
---

## Core idea
- **A2A** is an open protocol for **agent-to-agent** collaboration across frameworks and vendors.
- Agents discover each other, negotiate modalities, and coordinate **tasks** without sharing internal memory, prompts, or tool implementations (**opacity**).
- It standardised the way agents discover, communicate, and collaborate, regardless of their underlying implementation.
- A2A **complements** MCP: MCP connects an agent to **tools**; A2A connects an agent to **other agents**.
---

## Universal language
- Think of it as a universal language that allows AI agents to (by standardising each):
    - **Discover** each other’s capabilities through standardized metadata
    - **Communicate** using a common JSON-RPC based protocol
    - **Collaborate** on complex tasks through orchestration
    - **Stream** responses for real-time interactions
---

## Why standardisation?
- Each agent exposes its capabilities through a standardised endpoint.
- This allows other agents to understand what it can do *without* knowing its internal implementation.
---

## Mental model
- **A2A Client** = the customer placing an order -> when you make a request in a chat.
- **A2A Server** = the waiter taking the order -> refers to the communication endpoint.
- **Remote Agent** = the kitchen -> is the intelligence behind it.
---

## Client agent vs remote agent

| Role | Responsibility |
|---|---|
| **Client agent** | Formulates and communicates tasks; discovers remotes via Agent Cards; may stream or await results |
| **Remote agent** | Acts on tasks; returns messages and **artifacts**; does not need to expose internals |
- A user-facing “main” agent is typically the **client**. Specialized **subagents** are typically **remotes**.
---

## What Makes A2A Essential
- A2A protocol serves as a universal communication standard that allows AI agents to:
    - Share goals and coordinate tasks across platforms
    - Exchange data and context in standardized formats
    - Collaborate regardless of underlying technology stack
    - Operate in distributed, cloud-agnostic environments
---

## Correct separation

| Protocol | Relationship | Use for |
|---|---|---|
| **MCP** | Agent ↔ tools / capabilities | Atomic actions, data access, side effects the agent selects |
| **A2A** | Agent ↔ agent | Delegation, specialized peers, long-running collaboration |

- Do not use MCP as an agent-to-agent bus. Do not treat a remote agent as a thin “tool wrapper” when it needs its own reasoning, lifecycle, and opaque internals — that is A2A (see also [Subagents](/knowledge/subagents.md)).
---

## Design principles (from the public A2A work)

1. **Embrace agentic collaboration** — agents work in unstructured modalities without sharing memory/tools/context.
2. **Build on existing standards** — HTTP(S), JSON-RPC 2.0, Server-Sent Events (SSE).
3. **Secure by default** — authentication/authorization schemes advertised on the Agent Card (OpenAPI-parity style).
4. **Long-running tasks** — task lifecycle with status updates; hours/days with humans in the loop when needed.
5. **Modality agnostic** — text, files, structured JSON; audio/video when Cards declare support.
---

## Key protocol objects

### Agent Card
- JSON capability advertisement: identity, endpoint, skills/capabilities, supported input/output modes, **security schemes**.
- Client agents use Cards for **capability discovery** (which remote can do the job).
- Cards must **not** dump the remote’s private MCP tool inventory or system prompt — only declared skills/capabilities (**opacity**).

### Task
- Stateful unit of work representing one user goal between client and remote.
- Has a **lifecycle** (submitted → working → completed / failed / canceled, etc.).
- May complete immediately or run long; peers stay in sync via status updates (often over **SSE**).
- Its unique task ID disambiguates multiple goals progressing in parallel and associates later
  messages with the correct goal.
- Under the current protocol model, one client message represents at most one overall goal and
  therefore maps to at most one Task. That goal may have multiple steps and produce multiple
  artifacts; representation and tracking of its sub-goals is not standardized.
- Task **outputs** are one or more **artifacts** (result payloads the client can use).

### Message and parts
- A **message** is one communication turn, not a unit of tracked work. Either the client or remote
  agent can send one.
- Standalone messages suit greetings, capability discovery, general conversation, quick questions,
  clarifications, and immediate responses that do not need lifecycle tracking.
- Messages also carry instructions, additional input, clarification requests, and progress
  communication within an existing Task.
- Each Message contains one or more **Parts**, the smallest typed content units (e.g. text,
  structured JSON, or files). Artifacts are also composed of Parts.
- Messages communicate; Artifacts deliver Task results. Do not use a Message as the Task's result
  container.

### Choosing Message or Task

| Interaction | Return |
|---|---|
| Greeting, discovery, chit-chat, or quick response | A direct **Message** |
| Clear user goal needing tracked work | A **Task** |
| Multi-turn collaboration or additional user input | A **Task**, with Messages exchanged in its context |
| Long-running or asynchronous operation | A **Task**, with status updates and eventual Artifacts |

- A hybrid agent can return direct Messages for simple exchanges and create Tasks only when an
  interaction becomes goal-oriented or needs state.
- Task and Message are complementary: the Task tracks the goal and lifecycle, while Messages carry
  the collaboration around that goal.

### Transports
- **JSON-RPC 2.0 over HTTP(S)** for request/response.
- **SSE** for streaming task progress.
- Optional **push** webhooks when the Card declares push support (disconnected / long-running clients).
---

## Opacity (do not violate)

Across the A2A boundary, peers should receive only:

- Agent Card (public/extended per auth)
- Task/message/artifact payloads they are intended to share

Peers should **not** receive:

- The other agent’s full MCP tool list or credentials
- Raw session memory dumps
- Internal system prompts or proprietary graph state
- Use MCP **inside** each agent for tools; use A2A **between** agents for collaboration.
---

## SDKs
- Prefer official bindings (e.g. Python `a2a-sdk`) over hand-rolled JSON-RPC surfaces so implementations stay aligned with the normative proto/spec.
- See [A2A Python SDK](https://github.com/a2aproject/a2a-python) and sibling SDKs listed on [a2aproject/A2A](https://github.com/a2aproject/A2A).
---

## When to use A2A vs a tool vs a sub-agent process

| Situation | Prefer |
|---|---|
| One atomic side effect or lookup | **MCP tool** ([MCP](/knowledge/MCP.md)) |
| Same process needs a specialist with its own prompt/tools/lifecycle | **Sub-agent** criteria ([Subagents](/knowledge/subagents.md)) + **A2A** to talk to it |
| Cross-vendor / opaque peer collaboration | **A2A** |
| User-facing channel (chat, voice, SMS) | Owning **client/main** agent — remotes do not speak to the end user over product channels |
---

## Related

- [MCP tool design](/knowledge/MCP.md) — agent ↔ tools
- [Subagents](/knowledge/subagents.md) — when to create a sub-agent vs a tool
- [Agent primitives](/knowledge/agent_primitives.md) — skills, subagents, plugins, MCP, graph
---

## A2A Communication Flow Implementation

- **Step 1: Discovery**: The Client requests the Server's `/.well-known/agent.json` file (Agent Card) to learn its capabilities, endpoint URL, and authentication requirements.

- **Step 2: Message Submission**: Using the discovered endpoint, the Client calls `message/send`
  with an initial Message whose input data is carried in **Parts**.

- **Step 3: Server Decision**: The Server may return a direct Message for a simple interaction. For
  goal-oriented or trackable work, it creates a Task with a unique ID and begins processing; the
  Task state changes (e.g., `"submitted"` → `"working"`).

- **Step 4: Collaboration and Result Delivery**: Messages may provide clarification, input, or
  progress within the Task. Once processing is complete, the Server attaches one or more
  **Artifacts**, whose output data is carried in **Parts**, and updates the Task state (e.g.,
  `"completed"`).
---

## A2A vs. LangGraph
- The question is similar to protocol vs. orchestration. They are not the same thing.
- Each framework may occasionally do what the other is trying to solve but generally the solution would be suboptimal.
- A2A answers: "How does Agent A send work to Agent B?"
- LangGraph answers: "Which agent should run next? What state do I keep? How do I recover from failures?"
- If all your agents live in the same process and are maintained by the same team, agent-as-tool composition is simpler and has less overhead. Use A2A when crossing a process, service, or organizational boundary.
---

### References
- [Mastering Google’s A2A Protocol: The Complete Guide to Agent-to-Agent Communication](https://medium.com/@genai_cybage_software/mastering-googles-a2a-protocol-the-complete-guide-to-agent-to-agent-communication-8d3ba985a10d)
- [Announcing A2A](https://developers.googleblog.com/en/a2a-a-new-era-of-agent-interoperability/), [a2aproject/A2A](https://github.com/a2aproject/A2A), [specification](https://a2a-protocol.org/latest/specification/).
- [A practical guide to building Multi-Agents AI Systems with A2A](https://medium.com/google-cloud/a-practical-guide-to-building-multi-agents-ai-systems-with-a2a-2c0e3d77af24)
- [Life of a task](https://a2a-protocol.org/dev/topics/life-of-a-task/?utm_source=chatgpt.com)
- [Demystifying Tasks vs Messages](https://discuss.google.dev/t/a2a-protocol-demystifying-tasks-vs-messages/255879?utm_source=chatgpt.com)
- [Agent-to-Agent (A2A)](https://learn.microsoft.com/en-us/agent-framework/journey/agent-to-agent?utm_source=chatgpt.com)
---
