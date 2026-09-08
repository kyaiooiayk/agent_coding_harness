---
name: how-to-sync-make-help
description: >-
  Keep make help complete when adding or changing Make targets. Use when editing
  make/*.mk, Makefile, or when the user reports a missing make help section or
  target.
---

# Sync make help

`make help` is the CLI SSOT for operator-facing targets. Rule: `.cursor/rules/makefile-help-sync.mdc`.

## When this applies

- New or renamed `.PHONY` target in `make/*.mk` or `Makefile`
- User says a target or section is missing from `make help`
- Splitting or merging help topics (e.g. tests vs evaluation)

## Checklist (same change, before handback)

1. **Section** — pick `HELP_SECTIONS` topic in `make/help.mk`, or add one:
   - append to `HELP_SECTIONS`
   - add matching line in `HELP_SECTION_LINES` (index at bottom of `make help`)
   - add `define HELP_<TOPIC>` and `define HELP_<TOPIC>_ONLY` (twins must match)
   - wire `topic/help:` and include `$(HELP_<TOPIC>)` in the full `help:` target
2. **Target line** — in **both** twins: `make <target>  – <one-line purpose>`; document flags on the same line or in the section's flag notes.
3. **Cross-refs** — if the target belongs elsewhere (e.g. evaluation not in CI), add a pointer from the related section (`make help test` → `make help evaluation`).
4. **Aliases** — backward-compat help topics go in `HELP_TOPIC_ALIASES` with a `llm/help:` (or similar) stub delegating to the canonical section.
5. **Verify** — run:
   ```bash
   make help-check
   make help
   make help <topic>
   ```
6. **Handback** — name the section (`make help <topic>`), new flags, and aliases.

## Anti-patterns

- Target only in README/skills/hooks — must be in `make help`
- Updating `HELP_TEST` but not `HELP_TEST_ONLY`
- Adding to `HELP_SECTIONS` without `HELP_SECTION_LINES` index line
- Internal `_`-prefixed targets as public Make goals — use scripts instead

## Operator vs internal

| Document in help | Keep internal |
|---|---|
| Targets humans/hooks run (`test-agent-stop`, `test_llm_evaluation`) | `_ecr_push_one`, `docker/wait` implementation details |
| Stable aliases (`llm_evaluation`) | Typo aliases unless already shipped (`test_llm_evalution`) |
