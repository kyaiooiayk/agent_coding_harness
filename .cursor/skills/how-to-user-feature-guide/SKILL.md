---
name: how-to-user-feature-guide
description: >-
  Write or update a short end-user how-to under docs/ when shipping a
  user-facing feature. Use when the feature changes how humans start or use
  product behaviour (UI flows, commands).
---

# User feature how-tos (`docs/`)

End users need a **short how-to** in `docs/` (`type: Guide`). Contracts, runtime, and how-tos share that one folder.

## When required

Add or update `docs/<slug>.md` in the **same PR** when the change introduces or materially changes:

- How an end user **starts** or **uses** a feature (modals, tabs, commands)
- User-visible steps that are not covered by a single service README

**Not required:** internal refactors, operator-only runbook tweaks (use `how-to-document-procedure-changes`), or docs-only contract edits with no new UI steps.

## Workflow

1. **Pick slug** — kebab-case, feature-shaped: `load_sample_<resource>.md`, not ticket ids.
2. **Write** `docs/<slug>.md` with OKF frontmatter (`type: Guide`, title, description, tags, timestamp):
   - Title + one-line purpose
   - Quick reference table (where / you do / result) when multiple paths exist
   - Numbered steps per path; defaults and config file named once
   - Link sibling `docs/` contracts for operator setup — do not duplicate Compose/ports
3. **Index** — add a row to [`docs/index.md`](../../docs/index.md) and the End-user how-tos table in [`docs/README.md`](../../docs/README.md).
4. **Cross-link** — one line from related contract docs when they send readers to the flow.
5. **Service README** — one-line link from owning service README if ingress/API changed.

## Template

```markdown
---
type: Guide
title: <Feature title>
description: One sentence for the OKF map.
tags: [guide, ui, …]
timestamp: 2026-07-24T00:00:00Z
---

# <Feature title>

One sentence: who this is for and what they achieve.

## Quick reference

| Where | You do | Result |
|---|---|---|

## <Path 1>

1. …

## More detail

| Topic | Doc |
|---|---|
| Operator setup | [local_dev_docker.md](local_dev_docker.md) |
```

## Anti-patterns

- Pasting full Docker/Compose setup into a Guide — link [local_dev_docker.md](../../docs/local_dev_docker.md)
- Shipping user-facing steps only in a plan or chat — add the `docs/` Guide too
- Forgetting `docs/index.md` / README how-to table

Rule: [`.cursor/rules/user-feature-guides.mdc`](../../rules/user-feature-guides.mdc). Phase 5 checklist: [`.cursor/rules/five-phase-delivery.mdc`](../../rules/five-phase-delivery.mdc).
