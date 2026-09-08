# `<describe your app here>` — agent instructions

This repo is a **coding agent harness** for `<describe your app here>`: `<describe stack and domain here>`. Customize this file and `.cursor/` for your product — do not invent services, runtimes, or deploy paths that `PRODUCT.md` / `docs/` / `.cursor/rules/stack.mdc` do not describe.

**Context disclosure:** short always-on hotlines + routers; open full bodies on demand. Punchlines: `.cursor/rules/harness-hotline.mdc`. User-facing decisions: `.cursor/rules/user-action-visibility.mdc`. Depth (`tdd`, `test-doubles`, `prove-bug-with-test`, `agent-test-gate`): **Read when coding/testing**.

Cursor rules: `.cursor/rules/` (stack: `stack.mdc`, style: `code_style.mdc`, **skeptical expert: `skeptical-expert.mdc`**, **okf: `okf.mdc`**, **harness hotline: `harness-hotline.mdc`**, **session audit: `agent-tasks-session-audit.mdc`**). Workflows: `.cursor/skills/`. **OKF:** `knowledge/` = portable engineering notes; `docs/` = this project's contracts (`docs/README.md`, `docs/index.md`). Rule: `.cursor/rules/okf.mdc`, SOP: `.cursor/skills/how-to-okf/SKILL.md`.

**Expert stance (always)** — `.cursor/rules/skeptical-expert.mdc` — challenge impossible asks and unverified diagnoses with evidence.

**Bug proof (hotline)** — failing harness test before claiming root cause. Depth: `.cursor/rules/prove-bug-with-test.mdc` + `.cursor/skills/how-to-prove-a-bug/SKILL.md`.

**First move on a new task** — new Cursor chat tab = new branch + new PR scope (`.cursor/rules/branch-and-pr.mdc`) when git is usable; then **five-phase delivery** (`.cursor/rules/five-phase-delivery.mdc`). Every ticket: `.agent_tasks/<session-id>/command.md` + `lesson_learnt.md`.

**Design/safety conflict** — loud **Conflict** + stop until explicit go-ahead (`.cursor/rules/clarify-before-acting.mdc`).

## Boundaries

- **Local Docker** — `.cursor/rules/docker-ops-boundary.mdc` — do not restart/rebuild Compose unless the user asks; stop gate rebuilds after product edits (`.cursor/hooks/README.md`).
- **No cloud product path** — `<describe runtime boundary here>` (default assumption: local Compose / local process only). Do not invent cloud deploy workflows unless `PRODUCT.md` / `docs/` explicitly define them.

## Workflows

- **Branch / PR** — `.cursor/skills/how-to-branch-and-pr/SKILL.md` + `.cursor/rules/branch-and-pr.mdc` — one tab = one PR scope; leave WIP uncommitted; user commits/pushes/opens PR. If `.git` is incomplete, say so and edit in place.
- **Planning** — `.cursor/skills/how-to-plan/SKILL.md` + `.cursor/rules/plan-mode.mdc`
- **Five-phase delivery** — `.cursor/rules/five-phase-delivery.mdc` — Phases 3–5 via fresh subagents on implementation tasks; **Phase report** at handback
- **Code / bug fix** — `.cursor/skills/how-to-code/SKILL.md` + `harness-hotline.mdc` + TDD depth rules; run `make test parallel=true` before handback when product code changed
- **Make targets** — `.cursor/skills/how-to-sync-make-help/SKILL.md` + `.cursor/rules/makefile-help-sync.mdc`
- **OKF** — `.cursor/skills/how-to-okf/SKILL.md` + `.cursor/rules/okf.mdc`
- **End-user how-tos** — `.cursor/rules/user-feature-guides.mdc` + `.cursor/skills/how-to-user-feature-guide/SKILL.md` (under `docs/`)

## Domain knowledge

- **Product** — `PRODUCT.md`, `README.md`, `api/README.md`, `frontend/README.md` — `<describe your app here>`
- **Project docs** — `docs/index.md` (architecture, contracts, runtime, testing, UI how-tos)
- **Design primers** — `knowledge/SOLID_principles.md`, `DRY_principles.md`, `CRUD_principles.md`, `api_first_paradigm.md`, `c4_model_software_diagram.md`, `avoid_mock_testing.md`, `mock_vs_stub_testing.md`
- **Frontend UI** — `frontend/README.md`, `.cursor/rules/frontend-styling.mdc`, `.cursor/rules/frontend-tsc-gate.mdc`
- **Documentation diagrams** — `.cursor/rules/documentation-diagrams.mdc`
- **Coding conventions** — `.cursor/rules/code_style.mdc`
