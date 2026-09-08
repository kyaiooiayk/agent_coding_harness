---
name: how-to-code-intelligence
description: >-
  Use local SCIP evidence for refactors, impact analysis, who-calls questions,
  dependency exploration, symbol lookup, and find-references work.
---

# Code intelligence

Use local SCIP evidence before broad text search when the question is about symbol identity,
definitions, references, implementations, dependency fanout, or refactor impact.

Treat references as structural evidence only. Never invent CALLS edges, runtime execution order, or
dynamic dispatch claims that are absent from SCIP. State confidence, freshness, and non-claims.

## When planning (ownership / scope moves)

Plans that change **resource ownership**, **attach vs existence**, or **list/upload/search filters** must run this skill **before CreatePlan** (see `.cursor/skills/how-to-plan/SKILL.md` § Consumer fanout gate):

1. `index_status` (bootstrap/refresh if needed).
2. Resolve owner symbols (`search_symbols` / `symbol_at`) — e.g. attachment upload/list, `SearchFilters`, loaders.
3. **`reference_fanout`** (or `find_references`) — list FE tabs, BFF routes, MCP tools, search engines, cleanup paths.
4. Hand the consumer list to the clarify interview: each consumer stays session-bound, becomes user-scoped, or needs a mode toggle.

Grep alone is a **declared degrade** only when code-intel MCP is unavailable — say that in **Agents used**.

## First-use setup

Bootstrap the pinned toolchain once and build the initial workspace index. From the
monorepo root prefer Make; from an extracted package use the `uv` equivalents:

```bash
# Monorepo
make code-intel-bootstrap
make code-intel-index

# Extracted package / standalone
uv sync
uv run code-intel --workspace /path/to/workspace bootstrap
uv run code-intel --workspace /path/to/workspace doctor
uv run code-intel --workspace /path/to/workspace init
uv run code-intel --workspace /path/to/workspace index
```

In this monorepo the Cursor MCP server is wired at `.cursor/mcp.json` per Cursor's STDIO spec:
`type: "stdio"`, full-path `command` to `tools/code_intelligence/.venv/bin/code-intel-mcp`, and
`CODE_INTEL_WORKSPACE=${workspaceFolder}` (run `uv sync --project tools/code_intelligence` first —
bare `uv` is often missing from Cursor's GUI PATH). After reloading MCP / restarting Cursor, enable
or approve the `code-intel` server if prompted, then call `index_status`. If Settings shows the
server as **disconnected**, or `GetMcpTools` reports **No MCP servers available**, code-intel is not
attached to this chat — degrade to grep and say so in **Agents used**; do not claim SCIP fanout.
Extracted packages still copy `templates/mcp.json.example` into their Cursor MCP config.
Bootstrap is explicit; query and refresh operations never install executables.

## Query workflow

1. Call `index_status`.
2. If no generation exists, run the first-use setup. If it is stale, call `refresh_index`.
3. Resolve the canonical symbol with `search_symbols` or `symbol_at`; do not guess symbol strings.
4. For impact questions, prefer `reference_fanout`. Use `find_definitions`, `find_references`,
   `find_implementations`, `document_outline`, and `related_symbols` for narrower evidence.
5. Make the smallest evidence-backed edit.
6. Call `refresh_index` after source changes and confirm `index_status` selected a new generation.

If the MCP server is unavailable, say that code-intelligence evidence is unavailable and degrade to
repository text search. Do not represent text-search matches as graph edges.
