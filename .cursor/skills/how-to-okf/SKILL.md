---
name: how-to-okf
description: >-
  Open Knowledge Format (OKF) — folder ownership (knowledge human-only files,
  docs agent-writable, microservice READMEs not OKF), maintain map, rehydrate indexes.
  Use when editing knowledge/ frontmatter, docs/, or OKF index files.
---

# How to OKF (<describe your app here>)

Invariants: `.cursor/rules/okf.mdc` (always applied).

## Knowledge vs docs

| Folder | Purpose | README |
|---|---|---|
| `knowledge/` | General knowledge (portable reference) | `knowledge/README.md` |
| `docs/` | This project's implementation (architecture, contracts, local runtime, verification) | `docs/README.md` |

## Folder ownership

| Path | File creation | Agent write scope | OKF indexed |
|---|---|---|---|
| `knowledge/` | **Human only** | **Frontmatter only** on existing files | Yes |
| `docs/` | Human or agent | Full content + frontmatter + index | Yes |
| `microservices/*/README.md` | Human or agent (service scope) | Full README per `documentation-diagrams.mdc` | **No** |

### `knowledge/` — human corpus, agent metadata only

- **Humans** add portable reference concepts (`knowledge/*.md`).
- **Agents** may **only** add or update YAML frontmatter on files that already exist.
- **Agents must not:** create, delete, or rename `knowledge/*.md`; edit body prose; add new index entries for files they created.
- **Need new project documentation?** Create or edit under `docs/` (or the owning `microservices/<svc>/README.md`), not `knowledge/`.

When a human adds a knowledge file, agent may complete OKF frontmatter and update `knowledge/index.md` for that file.

### `docs/` — agent-writable implementation detail

- Agents may create, edit, rename, and remove `docs/*.md` concepts.
- Every concept needs full OKF frontmatter and a bullet in `docs/index.md`.
- Run `python3 scripts/okf-rehydrate-index.py` and `python3 scripts/okf-check.py` before handback.

### `microservices/*/README.md` — outside OKF

- Container docs: API tables, config, `## Information flow`, diagrams.
- **Not** listed in OKF indexes; **no** OKF frontmatter required.
- Agents edit when working in that service; follow `documentation-diagrams.mdc` and service README structure in `code_style.mdc`.

## Full map invariant (OKF folders only)

1. Every `knowledge/` and `docs/` concept has frontmatter (`type`, `title`, `description`, `tags`).
2. Every such concept has a bullet in that folder's `index.md`.
3. `python3 scripts/okf-check.py` exits 0.

Per-file frontmatter is the queryable map; `index.md` is progressive disclosure.

Optional frontmatter `disclosure:` — `router` | `on_demand` | `background` (see `docs/agent_context_disclosure.md` and `.cursor/skills/how-to-agent-context-disclosure/SKILL.md`). Assign when adding concepts so agents know whether to skim or open the body.

## Bundle layout

| Path | Role |
|---|---|
| [/index.md](/index.md) | Bundle root |
| [/knowledge/index.md](/knowledge/index.md) | Human-owned reference TOC |
| [/docs/index.md](/docs/index.md) | Agent-writable contracts TOC |
| `microservices/<svc>/README.md` | Service container doc — **not OKF** |

**No `log.md`:** git history is the changelog.

## Navigation (read)

1. [/index.md](/index.md) → `knowledge/index.md` or `docs/index.md`.
2. Scan frontmatter before full body.
3. For implementation detail → `microservices/<svc>/README.md` (not via OKF index).

## Type taxonomy

| `type` | Folder |
|---|---|
| `Reference` | `knowledge/` (default) |
| `Contract`, `Runbook`, `Guide` | `docs/` |

## Frontmatter template

```yaml
---
type: Reference
title: Short display name
description: One sentence for the map.
tags: [topic, area]
timestamp: 2026-07-12T00:00:00Z
---
```

## Write workflows

### Human added a `knowledge/` file

1. Human creates `knowledge/new_topic.md` (body content).
2. Agent adds frontmatter only (unless user requests body co-edit).
3. Human or agent updates `knowledge/index.md` bullet for that file.
4. Rehydrate + check.

### Agent documents a contract or runbook

1. Create or edit `docs/<name>.md` with frontmatter + body.
2. Update `docs/index.md`.
3. Rehydrate + check.

### Agent edits a microservice

1. Edit `microservices/<svc>/README.md` as needed — **not** OKF.
2. Do not add OKF frontmatter or `docs/`/`knowledge/` index entries for service READMEs.

## Promoting to enforceable docs

When a `knowledge/` idea becomes a hard repo rule: copy the minimum into `docs/` or `.cursor/rules/*.mdc` — agent may write `docs/`; do not add new `knowledge/` files for enforcement.

## Conformance scripts

| Script | Scope |
|---|---|
| `scripts/okf-check.py` | `knowledge/` + `docs/` only |
| `scripts/okf-rehydrate-index.py` | `knowledge/index.md` + `docs/index.md` |

## Related

- Rule: `.cursor/rules/okf.mdc`
- Human knowledge policy: `knowledge/README.md` § Ownership
