---
type: Reference
title: MCP tool design
description: Model Context Protocol — atomic, intent-centric tools; agent selects intent, MCP executes.
tags: [mcp, agents, tools]
timestamp: 2026-07-11T00:00:00Z
---

# MCP (Model Context Protocol)
***

## Core Idea
- REST APIs are designed around **resources and data manipulation**. REST exposes data.  
- MCP is designed around **capabilities and action execution**. MCP exposes intentful actions. MCP is therefore closer to. RPC systems, capability-oriented interfaces, action execution layers.
***

## Correct separation
- MCP server handles execution
- Agent handles intent selection
- Backend handles delivery
- MCP is a reminder that MCP is a protocol for exposing tools, not an orchestration layer.
- **MCP vs A2A:** MCP is **agent ↔ tools**. Agent-to-agent collaboration (opaque peers, tasks, Agent Cards) is **A2A** — see [Agent2Agent (A2A)](/knowledge/A2A.md). Do not use MCP as an agent-to-agent bus.
***

## REST Thinking
- REST is resource-centric.

You model nouns:
- users
- blogs
- invoices
- tickets

Then operate on them with CRUD semantics:
```http
GET /blogs/123
PUT /blogs/123
DELETE /blogs/123
```

This works well for:
- web applications
- dashboards
- SaaS platforms
- mobile clients
***

## MCP Thinking
MCP is action-centric.

You model verbs:

- summarizeDocument
- archiveOldPosts
- approveInvoice
- assignOnCallEngineer
- transferOwnership

These are not raw data operations. They represent meaningful business capabilities.
***

## The Common Mistake
A frequent anti-pattern is treating MCP as a thin wrapper over existing REST endpoints:

```text
REST API
   ↓
MCP wrapper
   ↓
LLM Agent
```

While technically functional, this creates poor agent ergonomics because the agent is forced to orchestrate low-level CRUD workflows itself.

## The Three Smells That Break Agent Selection
- Unstated Limitations 
- Missing Usage Guidelines
- Opaque Parameters
***

## What happens if the tools are not described correctly?
- Scenarion #1 - tools are skip and the the agent reply with internal, context or hallucinate context
- Scenarion #2 - tools are called but the parameter are hallucinated
***

## Why This Fails for Agents
- REST-style workflows create many intermediate states:

```text
GET resource
validate
transform
PUT resource
retry failures
handle partial success
```

LLMs are weak at managing long stateful workflows reliably.

Every additional step increases the chance of:

- hallucinations
- inconsistent updates
- incomplete execution
- broken recovery logic

Good MCP design minimizes these transitions.
***

## Design MCP Around Intent
- When designing MCP tools, ask: “What is the user trying to accomplish?”
- Not “Which resource is being modified?”
***

## Bad MCP Design
```text
createTicket
getTicket
updateTicket
deleteTicket
```
This is REST semantics exposed through MCP.

## Better MCP Design
```text
triageIncident
assignOnCallEngineer
closeResolvedAlert
summarizeCustomerComplaint
escalateUrgentIssue
```
These map directly to user intent and agent goals.

Another concrete example for communication workflows:

```text
fetch_email
```

This should be one capability at MCP level, while provider mechanics stay internal:

```text
imap_fetch_email
outlook_fetch_email
```

The agent should not orchestrate provider-specific branches itself.
***

## MCP Tools Should Be Atomic
- A strong MCP tool encapsulates an entire workflow.
- Instead of forcing the agent to:

1. validate ownership
2. update records
3. create audit logs
4. notify subscribers

provide a single capability:

```text
transferBlogOwnership()
```

The server should handle orchestration internally. This is the single most important aspect.

Benefits:

- fewer model decisions
- reduced state management
- lower failure rates
- transactional consistency
- simpler agent reasoning
***

## REST Still Matters
- The key point is that REST and MCP optimize for different consumers.

| System | Optimized For |
|---|---|
| REST | humans and applications |
| GraphQL | flexible data querying |
| RPC/MCP | agent capability execution |
***

## How to avoid tool signatures bloating
- Blindly enabling them bloats your context, which leads to higher cost and worse performance. Unlike Agent Skills, MCP servers don't come with progressive disclosure out of the box. It is your responsibility to select the tools needed for the task at hand. 
- There are two options: you either now before hand what tools to use and then it is easy to select the tools list you need, or you do not. If you do not then it becomes more challenging to do so. 
- Progressive disclosure pattern (example): expose skills as lightweight summary resources first, then hydrate full schemas only on invocation (e.g. FastMCP [Skills Provider](https://gofastmcp.com/servers/providers/skills) with `skill://` resources, summary endpoints parallel to `/tools/summary`, and two-phase tool discovery). Wire the concrete endpoints and event names in your project `docs/` / MCP server README — not as hardcoded product assumptions here.
***

## Security
- Scope tool visibility by user and context. Only expose tools the current user/session/channel can actually use, to improve both safety and prompt efficiency.
***

## Tags and examples
- Discovery Metadata Must Be Semantically Rich. If this is designed well then we do not need to expose the full schema for selection.
```json
{
  "name": "github_create_issue",
  "summary": "Create a GitHub issue in a repository",
  "tags": ["github", "tickets", "bugs"],
  "examples": [
    "report a bug",
    "open an issue",
    "create a ticket",
    "file a bug report"
  ]
}

```
| Metadata field    | Discovery value                       |
| ----------------- | ------------------------------------- |
| `name`            | High                                  |
| `summary`         | Very High                             |
| `tags`            | Medium–High                           |
| `example_intents` | Very High                             |
| Full JSON schema  | Low for discovery, High for execution |

The model is extremely good at semantic selection from concise descriptions.
***

# References
- [MCP is not REST API](https://leehanchung.github.io/blogs/2025/05/17/mcp-is-not-rest-api/)
- [How to correctly use MCP servers with your AI Agents](https://www.philschmid.de/use-mcp-servers?utm_source=substack&utm_medium=email)
- [How Pinterest Built a Production MCP Ecosystem](https://blog.bytebytego.com/p/how-pinterest-built-a-production?utm_source=post-email-title&publication_id=817132&post_id=196933670&utm_campaign=email-post-title&isFreemail=true&r=1b0gyr&triedRedirect=true&utm_medium=email)
- [MCP Tool Descriptions and Agent Accuracy](https://www.channel.tel/blog/mcp-tool-descriptions-agent-accuracy?utm_source=chatgpt.com)
- [Model Context Protocol](https://github.com/modelcontextprotocol) - especially nice are the discussion between contributors
- [MCP Tools: What They Are and How to Build Them Right (2026)](https://apigene.ai/blog/mcp-tools?utm_source=chatgpt.com)
make
***