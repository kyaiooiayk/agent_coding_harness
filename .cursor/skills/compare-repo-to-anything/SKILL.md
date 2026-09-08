---
name: compare-repo-to-anything
description: >-
  Compares an external article, doc, or pasted text against this repository and
  produces a human-facing reconciliation matrix (Item | Current | Source |
  Reconcile). Use when the user asks to compare this against the current code,
  compare this article to the repo, compare against this repository, gap-check
  a blog/post/RFC vs the codebase, or pastes/attaches content / gives a URL to
  evaluate against this <describe your app here> repo.
---

# Compare repo to anything

Compare this repo to an external article, doc, RFC, or paste. Deliver a
**human** reconciliation matrix — do not auto-implement unless asked after.

## When to use

- User supplies a **URL** and/or **paste/attachment** and asks to gap-check vs
  this codebase
- Explicit compare / stack-up phrasing (triggers live in the description above)

## When NOT to use

- Pure PR review (`code-reviewer` / optional how-to-review advisory)
- Implementing from an article with no comparison ask
- Comparing two internal files with no external source

## Workflow

### 1. Ingest the source

| Input | Action |
|-------|--------|
| URL | Fetch (WebFetch / equivalent); note title + URL |
| Paste / attachment | Treat text as source; note filename if any |
| Both | Prefer paste for body; URL as citation |

If neither is present, ask once for a URL or paste before continuing.

### 2. Build a technical map

Extract load-bearing **items** (one practice / architecture claim / technique
each):

- **Novelty** — new, non-obvious, or differentiated claims
- **Best practices** — patterns, invariants, anti-patterns
- Skip marketing fluff, author bio, unrelated asides

### 3. Compare against this repository

If the user names a service, package, or area, limit evidence gathering to that
scope; still flag cross-cutting conflicts when they appear.

Evidence from code, `docs/`, service READMEs, `.cursor/rules/`, configs — not
vibes.

| Status | Meaning |
|--------|---------|
| **Already covered** | Repo meets or exceeds the suggestion |
| **Partial** | Related pieces exist; gaps remain |
| **Missing** | No meaningful equivalent |
| **N/A / reject** | Wrong stack, conflicts with a documented invariant, or symptom-only |

Call out where the source conflicts with this repo’s boundaries (api/frontend,
API-first, store ownership, no laptop cloud deploy, etc.).

### 4. Output the human matrix

```markdown
## Comparison: <source title or short label>

**Source:** <URL and/or "pasted content" / attachment name>
**Scope:** <one sentence — what was compared>

| Item | Current (repo) | Source (article/doc) | Reconcile suggestion |
|------|----------------|----------------------|----------------------|
| … | path + brief evidence | what the source says | adopt / adapt / skip + why |

## Summary
- Already strong: …
- Worth adopting: …
- Reject / N/A: …
```

Column rules: **Current** = concrete paths or "not found"; **Source** =
paraphrase, not a page dump; **Reconcile** = ticket-sized action or explicit
skip + why. Do **not** auto-implement unless the user asks after reviewing the
matrix.
