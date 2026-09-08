---
name: how-to-code
description: >-
  <describe your app here> coding workflow — clarify, TDD, verify, handback. Use when writing,
  reviewing, or fixing application code or tests. Read service/package READMEs
  and docs/ on demand; do not load everything upfront.
---

# How to code (<describe your app here>)

Read this file when the skill triggers. **OKF entry:** `index.md` → section index → concept (`.cursor/rules/okf.mdc`). **Project knowledge:** service READMEs and `docs/index.md`. **General patterns:** `knowledge/index.md` — read only when the task needs it.

## Mandatory context (before editing)

1. **Service or package README** — if your change is under `microservices/<svc>/`, read `microservices/<svc>/README.md` first. Same for `shared_packages/<pkg>/`, `api/`, `frontend/` when a README exists. Non-trivial change without a README → create/update per `.cursor/rules/code_style.mdc`.
2. **Cross-cutting doc** — use the routing table below for logging, config, migrations, etc.

## Five-phase delivery (mandatory)

Follow `.cursor/rules/five-phase-delivery.mdc` on every implementation task:

| Phase | What | Where |
|-------|------|--------|
| 1 Understand & interview | Split requests; restate goal, scope, DoD | Parent agent |
| 2 Interview / grilling | Stress-test assumptions; `.cursor/skills/grill-me/SKILL.md` when deep | Parent agent |
| 3 Make it work | Failing test → minimal correct behaviour | **Fresh subagent** |
| 4 Optimise | Refactor without behaviour change | **Fresh subagent** |
| 5 Extensible / scalable | Safe extension points; no speculative frameworks | **Fresh subagent** |

Append the **Phase report** table before **Used** on every handback; when Phases 3–5 ran, append **Phase subagent Used** from each child’s **Used** (first bullet **what was changed** — `.cursor/rules/reply-attribution.mdc`). Phases 3–5 map to steps 4–9 below; do not skip TDD, the agent test gate, or session audit file maintenance.

## Workflow

1. **Clarify (Phases 1–2)** — `.cursor/rules/skeptical-expert.mdc` + `.cursor/rules/clarify-before-acting.mdc` + `.cursor/rules/five-phase-delivery.mdc` (session gate on **new Cursor chat tab**, then interview/grill — push back on broken premises before code). Non-trivial scope: work top-down Context → Container → Component → Code (`knowledge/c4_model_software_diagram.md`) with owners from `docs/architecture.md`. Rare skip: bug with clear repro/logs → step 6.
2. **Branch + ticket** — **before the first repo file edit in this tab:** `.cursor/skills/how-to-branch-and-pr/SKILL.md` steps 0–2 (`git branch --show-current`, `git status`, pull main, `git checkout -b <project-prefix>-(<tag>)-<slug>`). If current branch is another session's work, create **this tab's** branch — do not append here. If you already edited without branching, create the branch before handback.
3. **Plan** — non-trivial tasks: follow `.cursor/skills/how-to-plan/SKILL.md` (Read gate + Decision/Basis citations required); plan mode / Cursor plan UI / chat (see **Task files** — no plan snapshot under `.agent_tasks/`). C4 containers and owners per `docs/architecture.md`; check in before implementing.
4. **TDD** — hotline `.cursor/rules/harness-hotline.mdc` (always on); depth `.cursor/rules/tdd.mdc` (Read when writing tests). On any behaviour change, bug fix, or user-reported gap: failing unit test first, then implementation. See `docs/testing_strategy.md` § **When unit tests are required**. **DB / store write paths:** same cadence — failing test that asserts **persisted row state** before product edit; **Before picking mocks:** Read `.cursor/rules/test-doubles.mdc`; Vitest: `.cursor/rules/frontend-test-mocking.mdc`; rationale: `knowledge/avoid_mock_testing.md`, `knowledge/mock_vs_stub_testing.md`. Bugs: follow **Bug fix order** (step 7) instead.
5. **Implement** — minimal diff; follow service README + `.cursor/rules/code_style.mdc`. Maintain session audit files (below) as you go.
6. **Verify in-turn** — before handback on product edits: run `make test parallel=true`; fix failures and re-run until green (`.cursor/rules/agent-test-gate.mdc`). Stop hook also runs lint → dev-build → `make test parallel=true` after turn end — **backup**, not a substitute for in-turn test runs. Do not run `make dev-build` in chat (hook owns rebuild). `make test-agent-stop` is the faster unit-only escape when E2E is out of scope.
7. **Autonomous bug fix** — `.cursor/skills/how-to-prove-a-bug/SKILL.md` + strict order below; verify cause yourself (`.cursor/rules/fix-root-cause.mdc`, `.cursor/rules/prove-bug-with-test.mdc`). Rare skip for step 1: user supplied a failing test that already reproduces the bug.
8. **Session audit** — keep `.agent_tasks/<session-id>/` up to date per **Task files**. Optional chat or specialist `code-reviewer` only if the user asks (`.cursor/skills/how-to-review/SKILL.md`).
9. **Handback** — **mandatory** per `.cursor/skills/how-to-branch-and-pr/SKILL.md` step 4: agent rebases; user reviews diff and **user commits**; agent suggests commit message only. Push/PR after user commits and approves. Incomplete if you only say "done." Append non-obvious lessons to `lesson_learnt.md` ongoing (not handback-only).

### Bug fix order

Proof contract: `.cursor/rules/prove-bug-with-test.mdc` — tell the user when proof is missing; hand back with **Bug proof** block pointing to the harness test.

1. **Reproduce** — run the failing path yourself (pytest, curl, UI steps, logs). Confirm the symptom; do not patch from narrative.
2. **Failing test** — encode the repro as a unit test closest to the bug (`.cursor/rules/tdd.mdc`, `.cursor/skills/how-to-prove-a-bug/SKILL.md`). Run it; it must fail for the same reason. An existing failing test from the user counts. **Tell the user the test path when red.**
3. **Diagnose** — symptom → hypothesis → invariant → fix site (owner that writes state, not display-only callers). Root cause is **verified** only after step 2.
4. **Fix** — minimal product-code diff; test green; no symptom-only patches.
5. **Verify** — run `make test parallel=true` in this turn; fix failures until green (`.cursor/rules/agent-test-gate.mdc`). Stop hook re-runs lint → dev-build → `make test parallel=true` after turn end. Add `make test parallel=true remote=true` when the bug is cloud/UI-only (see **Remote E2E** below). Handback includes **Bug proof** block.

Do not edit product code until steps 1 and 2 are done. Exception: user explicitly asks for test-after.

### Task files (session audit SSOT)

**Always-on mandate:** `.cursor/rules/agent-tasks-session-audit.mdc` (every ticket). This section is the depth/templates SSOT.

Directory: `.agent_tasks/<session-id>/` where `<session-id>` is the last segment of `{{VSCODE_TARGET_SESSION_LOG}}`. All under `.agent_tasks/` are **gitignored**.

| File | Role |
|---|---|
| `command.md` | Append-only log of **every Shell tool command** run on the machine, each with a short what/why |
| `lesson_learnt.md` | Ongoing append of non-obvious lessons learnt during implementation |

**Only these two files.** Do not create `plan.md`, `todo.md`, `lessons.md`, `review.stamp`, or `review-feedback.md` here. Plans stay in Cursor plan UI / chat.

**When to append**

- **`command.md`** — after each Shell tool use that runs on the machine (Make/git/gh/docker/pytest/etc.), append in the same turn (or batch appends before handback if many — prefer soon after running).
- **`lesson_learnt.md`** — whenever something non-obvious is learned (ongoing), not only at handback.

**Templates**

```markdown
# Commands

- `git status` — inspect working tree before branching
- `make test parallel=true` — verify agent-edited tests (+ E2E) before handback
- `make test-agent-stop` — faster unit-only escape when E2E out of scope
```

```markdown
# Lessons learnt

- <date or turn>: <one lesson>
```

### Agent tactics

- Subagents for research — one focused task each.
- If sideways, stop and re-plan.
- Before done: run tests, check logs, "Would a staff engineer approve this?"

## Non-negotiables

- **Tests on behaviour change** — `.cursor/rules/tdd.mdc`, `docs/testing_strategy.md` § **When unit tests are required**. New/changed behaviour, bug fix, or user gap → new or updated unit test in the same change. **Mocking:** `.cursor/rules/test-doubles.mdc` — assert user-visible state or HTTP body, not `toHaveBeenCalledWith` alone; tab/BFF/DB wiring → E2E. Frontend Vitest: `.cursor/rules/frontend-test-mocking.mdc`. No test = incomplete handback (exception: user asks test-after, or docs-only diff).
- **Cause over effect** — `.cursor/rules/fix-root-cause.mdc`, `docs/create_conflicts.md`
- **No `print()`** in `api/` product code
- **No runtime schema changes** — `docs/migrations.md`
- **100% line coverage** on changed Python — `docs/testing_strategy.md`
- **Secrets** — `require_env` in `docs/config_management.md`
- **No container restart/rebuild** unless user asks

## Read when (routing)

| If you are… | Read |
|---|---|
| Any task needing background knowledge | `index.md` → section index → concept; `.cursor/rules/okf.mdc` |
| Editing `microservices/<svc>/**` | `microservices/<svc>/README.md` |
| Editing `shared_packages/<pkg>/**` | `shared_packages/<pkg>/README.md` (or owning service README) |
| Observability design (logs, metrics, traces, correlation, alerting) | `knowledge/observability.md` |
| Editing `logging_tracing` or adding metrics/traces | `knowledge/observability.md`, `microservices/logging_tracing/README.md` |
| `config.py`, env vars, secrets | `docs/config_management.md` |
| Tests, coverage, E2E | `docs/testing_strategy.md`, `e2e_test/README.md` |
| Choosing mocks, stubs, or fakes | `.cursor/rules/test-doubles.mdc`, `.cursor/rules/frontend-test-mocking.mdc` (Vitest), `knowledge/avoid_mock_testing.md`, `knowledge/mock_vs_stub_testing.md` |
| Dockerfile, compose, rebuild map | `docs/local_dev_docker.md` |
| Code style, README rules, FE/BE split | `.cursor/rules/code_style.mdc`, `.cursor/rules/documentation-diagrams.mdc` |
| Stack choices (languages, infra, data stores) | `.cursor/rules/stack.mdc` |
| New endpoint, API contract, or BFF route | `knowledge/api_first_paradigm.md`, owning service README |
| Design refactor, cohesion, duplication | `knowledge/SOLID_principles.md`, `knowledge/DRY_principles.md` |
| Auth, MCP tools, agent architecture, terraform, etc. | `knowledge/index.md` (pick the matching row) |
| Scoping a feature, project, or cross-service change | `docs/architecture.md`, `knowledge/c4_model_software_diagram.md` |

## Self-check before handback

**Agent test gate** — `.cursor/rules/agent-test-gate.mdc`: ran `make test parallel=true` this turn on product edits and fixed failures until green? Stop hook (`.cursor/hooks/README.md`) is backup only — do not hand back without an in-turn test run.

**Session audit** — `.agent_tasks/<session-id>/command.md` lists Shell commands run this session (with explanations)? `lesson_learnt.md` updated when non-obvious lessons were found? Only those two files (see **Task files**)?

**You still judge:**

1. Read the relevant service/package README?
2. **Unit test added/updated** for every behaviour change, bug fix, or user-reported gap (`docs/testing_strategy.md` § When unit tests are required)?
3. Invariant stated in one sentence if fixing data inconsistency?
4. 100% line coverage on touched Python (`make test-coverage svc=…`)?
5. **E2E added/updated when triggers apply** (`docs/testing_strategy.md` § When E2E is required) — `make e2e-test file=…` **ran** this turn (or handback **Blocked: stack down**), command named in handback? Collecting under plain `pytest e2e_test/` without `make e2e-test` does **not** satisfy this.
6. **Tests assert outcomes, not wiring alone** — DOM text, HTTP body, or persisted fields; not `toHaveBeenCalledWith` / `mock.assert_called()` as sole proof (`.cursor/rules/test-doubles.mdc` § Over-mocking red flags)?
7. Did not suggest `make dev-build` in handback (stop gate `stop-gate-on-stop.sh` owns rebuild)?
8. README/docs updated if behaviour or layout changed — `## Information flow` + four-level C4 placement + primary diagram per `.cursor/rules/documentation-diagrams.mdc` (same edit; prose-only is incomplete)?
9. **OKF map** — `docs/` changes: frontmatter + `docs/index.md` + `python3 scripts/okf-check.py` green. `knowledge/`: frontmatter only on existing human-owned files — never create/rename/delete or edit body (`.cursor/rules/okf.mdc`). Service READMEs: not OKF.

### Remote E2E (stop hook covers local E2E — remote still manual)

Stop-hook `make test parallel=true` covers parallel backend + frontend Vitest + local Playwright E2E. For production UI:

- Iterate: `make e2e-test remote=true file=<failing_test>.py` after deploy lands.
- Before handback: `make test parallel=true remote=true` — required to claim “remote is green”.
- Do not substitute API `curl`, local docker E2E, or a single targeted `file=` pass for the full remote suite at handback.

