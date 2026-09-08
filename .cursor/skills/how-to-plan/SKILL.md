---
name: how-to-plan
description: >-
  <describe your app here> planning workflow for plan mode, CreatePlan, architecture plans, and
  feature scoping. Mandates complete delivery (no deferral), Read-tool documentation,
  architecture alignment against docs and code, senior-engineer pushback, mandatory
  agentic critique subagent with auditable **Agentic critiques** section, mandatory
  E2E verification sections, and Decision + Basis citations in every plan.
---

# How to plan (<describe your app here>)

Read this file when plan mode is active or the user asks for a plan. Bound by `.cursor/rules/plan-mode.mdc`.

## Workflow

1. **Clarify** — `.cursor/rules/skeptical-expert.mdc` + `.cursor/rules/clarify-before-acting.mdc` (interview, challenge nonsense with evidence).
2. **C4** — non-trivial scope: state level (`knowledge/c4_model_software_diagram.md`) and owners per `docs/architecture.md`.
3. **Read gate** — Read tool on routed docs (table below).
4. **Architecture alignment** — compare user's goal and existing code/APIs/stores against what you read. Note fits, conflicts, and gaps before planning.
5. **Research** — codebase search ok after reads and alignment pass.
6. **Agentic critique** — assemble draft plan (goal, tasks, verification, decisions). Spawn a **readonly** `generalPurpose` subagent via `Task` to critique it: test/regression risk, service boundaries, data invariants, missing E2E, deferral smells, blast radius. Record results in **`## Agentic critiques`** (template below). Apply **Accepted** findings before `CreatePlan`; log **Rejected** with basis. On revision: re-run critique when Tasks, Verification, or Decisions change materially; document skip when change is cosmetic only. `explore` subagents for research do **not** replace this step.
7. **CreatePlan** — **complete delivery** (below — no deferral); **Agentic critiques** section included; **E2E verification section (required)**; inline Decision + Basis; **Architecture alignment** section; **Docs consulted** footer.
8. **Revise** — when updating an existing plan (user feedback, new constraints, scope change), call `CreatePlan` again. Lead with a numbered **Revision** section (below): display the revision number in the heading, log every user feedback item as **Accepted** or **Rejected** with plan impact, then rewrite the full plan body — do not append-only patch notes at the bottom.

## Plan structure (required)

**Default: one plan = full goal, full implementation, full E2E.** Do not ship a thin slice in "Phase 1" and park the real work in "Phase 2."

**Do not use a "Non-goals" or "Out of scope" section.** That pattern hides work and reads like "ignore forever."

### Forbidden deferral patterns

Do **not** write any of the following in a plan:

- `Deferred:` / `deferred to Phase 2` / `out of scope for Phase 1`
- `Phase 1 only …` / `without rewriting … (Phase 2)` / "minimal change now, refactor later"
- Verification that proves only a partial fix while the plan admits the root change is later
- Parking required work in a later phase instead of listing it as a concrete task with E2E

If the goal needs refactoring four collectors **and** adding `resolve_invokable_tool()`, the plan includes **both**, with E2E that proves the end behaviour — not "add helper now, refactor collectors in Phase 2."

Use these sections instead:

| Section | Use for |
|---|---|
| **Revision** | **Every plan** — numbered heading (`Revision 1`, `Revision 2`, …); **Feedback processed** table logs each user item as Accepted or Rejected with plan impact; one-sentence summary of net change (first draft: `Revision 1 — Initial draft`, empty feedback table) |
| **Agentic critiques** | **Every plan** — readonly critique subagent run (or documented skip); auditable table of findings and what changed in the plan |
| **Architecture alignment** | How the goal fits current docs, boundaries, and code — conflicts called out; wrong-owner or anti-pattern paths rejected |
| **Diagrams** | At least one Mermaid diagram — container or data/information flow (`.cursor/rules/documentation-diagrams.mdc`, `knowledge/c4_model_software_diagram.md`) |
| **Goal** | What the initiative achieves end-to-end |
| **Tasks** | Every implementation step for the full goal — files, owners, concrete changes |
| **Verification** | Unit tests **and** E2E (see below) — both are first-class; E2E proves the **stated goal**, not a stub |
| **Decisions** | Permanent boundaries and tradeoffs (Decision + Basis) — fixed product/infra limits only, not "we'll do it later" |

**Tasks template:**

```markdown
## Tasks

- [ ] [task tied to todo id] — `path/to/file.py`
- ...
```

### Phased delivery (exception — user must request)

Use **Phased delivery** only when the user **explicitly** asks for a multi-release roadmap (e.g. "plan Phase 1 only", "split across sprints"). Even then:

- Each phase has a **complete, shippable** outcome for **that phase's** stated goal — not a stub awaiting a later phase.
- Each phase includes full E2E for that outcome.
- Never use Phase 2+ as a parking lot for work required to satisfy the **current** goal.

```markdown
## Phased delivery

### Phase 1 — [user-scoped outcome]
- [task]
- **E2E:** `e2e_test/...` — proves Phase 1 outcome end-to-end

### Phase 2 — [only if user requested multi-release]
- ...
```

**Revision template** — **first section in every plan body** (mandatory):

```markdown
## Revision 1 — Initial draft

**Prior revision:** none

### Feedback processed

| Feedback | Disposition | Plan impact |
|---|---|---|
| _(none — first draft)_ | — | — |

### Summary

First plan for [one-line goal].
```

**User decisions required + Agents used** — **immediately after Revision, before Agentic critiques** (mandatory):

```markdown
## User decisions required

**None.**
```

Or, when the user still must choose/approve/supply something:

```markdown
## User decisions required

1. **[Topic]** — default: [X]. Impact: [A vs B]. Reply with: `[exact choice or command]`.
```

```markdown
## Agents used

- [Friendly name](<agent-id>) — short purpose
```

Or `None` when no Task/Subagent ran during planning. List every research/critique launch for this plan revision; do not recurse into child agents. Policy: `.cursor/rules/user-action-visibility.mdc`, `.cursor/rules/reply-attribution.mdc`.

**Agentic critiques template** — **after Agents used, before Architecture alignment** (mandatory):

```markdown
## Agentic critiques

**Subagent:** `generalPurpose` (readonly) — id: `<agent-id>` | **Skipped:** no

| Finding | Disposition | Plan impact |
|---|---|---|
| [e.g. Phase-list tests in test_transcript_publisher.py will break if phases are reordered] | **Accepted** | Additive phase only; no reorder |
| [e.g. Store turns in BFF] | **Rejected** — session owns turns per data invariants | PATCH on session service |

**Applied:** [one sentence — what changed in Tasks/Verification/Decisions because of Accepted rows]
```

When critique is skipped, set **Skipped:** yes and add one table row: `Critique waived` | **Skipped** — [reason] | —

**Role split:** `Agents used` = roster (links + purpose); `Agentic critiques` = findings table; Phase report (handback) = phase status only.

When updating after user feedback, increment the number and **log every feedback item** — do not silently drop rejected items:

```markdown
## Revision 2

**Prior revision:** 1

### Feedback processed

| Feedback | Disposition | Plan impact |
|---|---|---|
| Move collector refactor into this release | **Accepted** | Added Tasks for all four collectors; E2E covers full path |
| Defer E2E to manual smoke | **Rejected** — E2E is mandatory for MCP/API wiring per skill | Default CI E2E kept in Verification |
| Store tool results in BFF | **Rejected** — domain state in `api/` violates anti-patterns | Corrected path: persist via `mcp_server` |

### Summary

Collector refactor and default-run E2E now cover full `resolve_invokable_tool` behaviour end-to-end.
```

**Revision rules (non-negotiable):**

- **Number in heading** — always `## Revision N` (integer, monotonic). First draft is `Revision 1 — Initial draft`; each `CreatePlan` update increments by one.
- **Prior revision** — one line naming the previous number (`none` on first draft).
- **Feedback processed** — table with one row per user comment, constraint, or pushback from the thread since the prior revision. Use **Accepted** or **Rejected** in Disposition; Rejected rows must cite why (doc, invariant, scope) in Plan impact.
- **No silent edits** — if user feedback changed the plan, it appears in the table; if you rejected it, say so explicitly — do not omit and drift.
- **Summary** — one or two sentences on net plan change after applying the table; not a line-by-line diff.

## Unit test verification (required)

**Every behaviour change needs a unit test in the same change** — `.cursor/rules/tdd.mdc`, `docs/testing_strategy.md` § **When unit tests are required**. Plans are incomplete if Tasks omit the test file(s) that encode new invariants.

**Every Verification section must name:**

| Item | Required detail |
|---|---|
| **File(s)** | Path under `microservices/*/tests/`, `api/tests/`, `frontend/tests/`, or `shared_packages/*/tests/` |
| **What it proves** | Output shape, error path, or invariant — not only “code runs” |
| **Order** | Failing test first, then implementation (TDD) |

Applies to new features, bug fixes, and user-reported coverage gaps. Only skip when the plan is docs-only with zero runtime behaviour change.

## Test design — mocks vs stubs (required when tests are in scope)

**Read before naming test files:** `.cursor/rules/test-doubles.mdc`, `knowledge/avoid_mock_testing.md`, `knowledge/mock_vs_stub_testing.md`. Vitest/React: `.cursor/rules/frontend-test-mocking.mdc`.

**Every Verification section that includes unit or frontend tests must state:**

| Item | Required detail |
|---|---|
| **Double choice** | Real code, fake, stub, or mock — and why (fidelity ladder) |
| **What is asserted** | User-visible state, HTTP body, or persisted field — not `toHaveBeenCalledWith` / `mock.assert_called()` alone |
| **E2E backstop** | When E2E triggers apply (`docs/testing_strategy.md` § When E2E is required), name the `e2e_test/` file — do not plan a Vitest-only mock journey as substitute |

**Reject in plans:** full `vi.mock('api/client')` screen tests with no E2E; reimplementing tab/BFF/DB wiring entirely in Vitest; mock-call assertions as the only proof for “user sees wrong/empty data.”

## E2E verification (required)

**Unit tests prove logic; E2E proves the wired stack.** A plan is incomplete without an explicit E2E section when the change touches any of:

- MCP tools or agent tool selection (including **admin Tools tab** / `GET /tools/catalog`)
- HTTP/API routes consumed by the frontend or API gateway
- Job execution, session lifecycle, or other user-facing channels described in `PRODUCT.md` / `docs/`
- Cross-service flows (when the app has more than one deployable service)

Read [`docs/testing_strategy.md`](docs/testing_strategy.md) and [`e2e_test/README.md`](e2e_test/README.md) in the Read gate when planning E2E.

**Every E2E section must specify:**

| Item | Required detail |
|---|---|
| **File(s)** | Path under `e2e_test/` (create if new) |
| **Stack** | Services/ports (e.g. mcp-server `8011`, configs volume) |
| **Steps** | ACTION → service contract → assertion (pattern in existing job_execution tests) |
| **Session cleanup** | `track_e2e_session(session_id)` when a session is created |
| **HTTP** | `api_request()` from `e2e_test/ui_helpers.py` — never bare `page.request.*` |
| **Default CI** | Which `make e2e-test file=…` must pass before merge |
| **Optional live** | Marker + make flag when external API keys needed (e.g. `@pytest.mark.web_search_live`, excluded from default `make e2e-test`) |

**Complete delivery rule:** The plan is not done on unit tests alone when E2E applies — include at least one **default-run** E2E proving registration/wiring for the **full stated goal**; live-vendor E2E may use a marker + documented `make e2e-test …` flag. Do not defer E2E or the implementation it depends on to a later phase unless the user explicitly scoped a multi-release plan.

### New MCP tool checklist (required in plan + implementation)

Planning and handback for a **new MCP tool** are incomplete without all of:

| Step | Prove |
|---|---|
| Tool module + `{name}_is_tool_visible` in `configs/mcp.yaml` | `collect_tool_catalog()` unit test names the tool |
| Agent/summary path | `GET /tools/summary` E2E includes the tool when visible |
| **Admin UI path** | `GET /tools/catalog` E2E **and** Playwright Tools tab lists `code.mcp-tool-name` |
| Observability proxy | `POST /observability/services/mcp-server/request` with `{method:GET,path:/tools/catalog}` returns the tool (same path as `fetchMcpTools()` in `frontend/src/api/observability.ts`) |
| Built-in skill | **Not by default.** Atomic tools use `TOOL_DESCRIPTION` / `TOOL_EXAMPLES` only (`.cursor/rules/agent-system-prompt.mdc` § MCP tools vs built-in skills). Add `skills/{name}/SKILL.md` only for a multi-step SOP. |
| Stack | `make dev-build svc="mcp-server"` after tool or dependency changes |

**Decision + Basis:** `/tools/summary` omits hidden tools and is what the agent uses for Phase A discovery; the **Tools tab uses `/tools/catalog`** via the logging_tracing proxy — summary-only E2E does not prove the UI.

**Template:**

```markdown
## E2E verification

### Default CI (required before handback)
- **File:** `e2e_test/.../test_feature_e2e.py`
- **Prove:** …
- **Run:** `make e2e-test file=.../test_feature_e2e.py`

### Live / marked (when external vendor)
- **Marker:** `@pytest.mark.web_search_live`
- **Run:** `make e2e-test file=... web_search_live=true` (or documented env)
- **Prove:** …
```

## Read gate (before CreatePlan)

Grep/search alone does **not** satisfy the gate. At least one Read per affected area. If a path does not exist, note that in Basis.

| Touch area | Must Read (Read tool) |
|---|---|
| OKF bundle / knowledge navigation | `index.md`, `.cursor/skills/how-to-okf/SKILL.md` |
| Any MCP tool | `knowledge/MCP.md`, owning service README (e.g. `microservices/mcp_server/README.md`) |
| Cross-service feature | `docs/architecture.md`, `knowledge/anti-patterns_service_architecture.md`, `knowledge/c4_model_software_diagram.md` |
| LLM / provider integration | `shared_packages/llm/README.md`, relevant provider file |
| Data / stores | `docs/data_invariants.md`, `docs/dbt.md`, `.cursor/rules/dbt-and-db-testing.mdc` |
| Postgres / Alembic / dbt models | `docs/dbt.md`, `docs/migrations.md`, `docs/database_structure.md`, `dbt/README.md` |
| Observability / logging changes | `knowledge/observability.md`, `docs/operational_logging.md` |
| Editing `microservices/<svc>/**` | `microservices/<svc>/README.md` |
| Editing `shared_packages/<pkg>/**` | `shared_packages/<pkg>/README.md` |
| New endpoint, API contract, BFF route | `knowledge/api_first_paradigm.md`, owning service README |
| Resource CRUD, persistence, store ownership | `knowledge/CRUD_principles.md`, `docs/data_invariants.md` |
| Ownership move, scoping change, or resource rename (session↔user, attach vs exist, search filters) | `.cursor/skills/how-to-code-intelligence/SKILL.md` — **Consumer fanout gate** below (mandatory) |
| Tests, coverage, E2E | `docs/testing_strategy.md`, `e2e_test/README.md` (mandatory when plan includes E2E) |
| Config, env vars, secrets | `docs/config_management.md` |
| Schema, migrations | `docs/migrations.md` |
| Docker, compose, rebuild map | `docs/local_dev_docker.md` |
| README / runbook / architecture docs | `.cursor/rules/documentation-diagrams.mdc` |
| Cloud deploy / ECS-only | `.cursor/skills/how-to-fix-cloud-deployment/SKILL.md` |
| Other topics | `knowledge/index.md` (pick the matching row) |

Reuse the full routing table in `.cursor/skills/how-to-code/SKILL.md` § Read when for anything not listed above.

## Consumer fanout gate (ownership / scope moves)

**When it applies** — any plan that changes **who owns** a resource, **what scopes** it (session vs user vs attach), or **which id filters** list/upload/search/delete (examples: session attachments → user library; soft vs hard delete of corpus; rename “Session Files” while keeping session-gated UX).

**Before CreatePlan (and before closing the clarify interview):**

1. **Open** `.cursor/skills/how-to-code-intelligence/SKILL.md` and run SCIP impact analysis (`index_status` → `search_symbols` / `symbol_at` → **`reference_fanout`** or `find_references`) on the **owner symbols** (store methods, API routes, FE client helpers, search filters/loaders). If MCP/code-intel is unavailable (`GetMcpTools` empty / `No MCP servers available`), say so and degrade to targeted grep — do **not** pretend you have fanout evidence. Toolchain on disk (`make code-intel-index`) does **not** imply the Cursor agent can call MCP tools.
2. **List consumers** in the plan (or interview): every UI tab, BFF route, MCP tool, search engine, and cleanup path that still assumes the old scope.
3. **Interview the user** (one hard question or batched choices) for each consumer class: stay session-bound, become user-library, or need an explicit mode (e.g. “attached only” vs “all my files”). Do **not** invent product defaults for upload/list/search gates without that answer.
4. **Agents used** must name the code-intel / explore Task that produced the fanout (or `Skipped: code-intel unavailable — degraded to grep` with paths checked).

**Reject (planning defect):** renaming or re-owning a resource while leaving session-picker / `session_id`-only search as implicit “unchanged UX” without fanout + interview.

Example grill after fanout:

> Files move to user library. Consumers still session-gated: Uploaded Files upload/list, Query Search filters, MCP search_memory. For each: attach-only, full library, or a UI mode toggle?

## Decision + Basis (inline)

Place next to the relevant plan section — not only at the end. Basis must state **what you learned** from the doc, not generic praise.

```markdown
**Decision:** Use a parallel `make_grounded_search_provider` instead of extending `make_provider`.

**Basis:** `shared_packages/llm/README.md` — chat `LLMProvider` is `complete`/`stream` only; Responses API + `web_search` is a different surface. `knowledge/MCP.md` — MCP tool stays intent-centric; provider swap is config-internal.
```

Every non-obvious architectural or behavioural choice needs a block.

## Architecture alignment (required section)

After Read gate, before Tasks. Compare **what the user asked for** and **what already exists** against routed docs and architecture. Senior engineer tone — evidence, not agreement.

Cover at minimum:

| Check | What to state |
|---|---|
| **Containers & owners** | Which service/store owns this per `docs/architecture.md` and service READMEs |
| **Existing surface** | APIs, stores, or patterns already in repo that satisfy or overlap the goal |
| **Doc contract** | Invariants, CRUD semantics, anti-patterns (`knowledge/anti-patterns_service_architecture.md`, `docs/data_invariants.md`) |
| **Mismatches** | Where the user's framing conflicts with docs or code — propose the corrected approach |
| **Risks** | Boundary violations, chatty calls, read-time reconciliation, scope creep |
| **Consumers (when fanout gate applies)** | SCIP/grep fanout of owner symbols; each consumer disposition (session / library / mode toggle) from interview |

If alignment is clean, say so briefly with citations — do not skip the section.

```markdown
## Architecture alignment

**Fits:** Session history is owned by `session` service (`microservices/session/README.md`); agent already calls `GET /sessions/{id}/history`.

**Conflicts:** User suggested storing tool results in BFF — `knowledge/anti-patterns_service_architecture.md` forbids domain state in `api/`.

**Corrected path:** Persist via `mcp_server` tool result store; BFF proxies only.
```

## Senior engineer stance (throughout)

Apply for the whole planning session, not only in alignment:

- **Challenge** — weak designs, wrong service ownership, "quick" fixes that violate invariants
- **Tradeoffs** — name cost, complexity, and what you are explicitly not doing
- **Minimal correct** — smallest change that respects boundaries (pairs with `.cursor/rules/ponytail.mdc`)
- **Push back** — when scope or framing is wrong, say so with doc/code evidence; offer a corrected plan
- **No rubber-stamping** — user's hypothesis is input, not the plan's conclusion

## Docs consulted (plan footer)

After the plan body, list only paths **read this session** via Read tool:

```markdown
## Docs consulted
- **readmes:** microservices/mcp_server/README.md
- **knowledge:** knowledge/MCP.md
- **docs:** docs/architecture.md
```

Categories match `.cursor/rules/reply-attribution.mdc` (readmes, knowledge, docs). Omit empty categories.

## Self-check before CreatePlan

- [ ] **Revision N** heading with monotonic number (`Revision 1` on first draft)
- [ ] **Prior revision** line present
- [ ] **Feedback processed** table — every user feedback item since last revision logged as Accepted or Rejected (empty placeholder row ok on first draft only)
- [ ] **Summary** — one or two sentences on net change; rejected items not silently dropped
- [ ] **User decisions required** section immediately after Revision (**None.** when settled)
- [ ] **Agents used** roster of every planning Task/Subagent (or `None`)
- [ ] Interview gaps closed or assumptions stated
- [ ] Read gate satisfied for every touched area (include `docs/dbt.md` when schema/data/stores touched)
- [ ] **Consumer fanout** — if ownership/scope/id-filter changes: code-intel (or declared grep degrade) + consumer list + interview dispositions before CreatePlan
- [ ] **dbt impact** Decision present (`new source` | `new mart` | `inventory-only` | `not applicable` + why) — `.cursor/rules/dbt-and-db-testing.mdc`
- [ ] **Architecture alignment** section compares user goal + existing code against docs; mismatches and corrected path stated
- [ ] Senior engineer pushback applied where framing, scope, or boundaries are weak
- [ ] Each major decision has Decision + Basis with specific learnings
- [ ] **Unit test section** — test file path(s) and invariant each proves (`docs/testing_strategy.md` § When unit tests are required); DB write paths name **persisted** outcomes
- [ ] **Test design** — doubles chosen on fidelity ladder; outcome assertions named; no mock-only substitute for required E2E (`.cursor/rules/test-doubles.mdc`)
- [ ] **E2E section** present when feature touches agent/MCP/API/UI — file path, steps, `make e2e-test file=…`
- [ ] **New MCP tool:** checklist satisfied (`/tools/catalog`, Tools tab Playwright, observability proxy)
- [ ] **Full goal in one plan** — no `Deferred:` / `Phase 1 only` / "refactor later" unless user explicitly requested multi-release phasing
- [ ] Default-run E2E proves the **stated goal** when applicable (not deferred to "manual smoke" or a later phase)
- [ ] **No "Non-goals" section** — required work is listed under **Tasks** with verification
- [ ] Docs consulted footer present
- [ ] **Agentic critiques** section present with subagent id or explicit skip reason
- [ ] Critique findings table has Disposition on every row; Accepted items reflected in Tasks/Verification

## After plan approval

Plans stay in Cursor plan UI / chat — do not snapshot under `.agent_tasks/` (allowed files: `.cursor/skills/how-to-code/SKILL.md` § Task files). Implementation follows how-to-code (unit tests first, session audit, **E2E before handback** when the plan defines E2E). Optional chat/specialist review only if the user asks (`.cursor/skills/how-to-review/SKILL.md`).
