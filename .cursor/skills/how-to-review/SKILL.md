---
name: how-to-review
description: >-
  File-based one-shot review is removed. Handback does not require a review
  stamp. Optional advisory self-check or specialist code-reviewer only when the
  user asks. Session audit is always-on: `.cursor/rules/agent-tasks-session-audit.mdc`.
---

# How to review (<describe your app here>)

**File-based one-shot review is removed.** Handback does not require a review
gate. Session audit is **always on** via
`.cursor/rules/agent-tasks-session-audit.mdc` (`command.md` + `lesson_learnt.md`);
templates/depth in `.cursor/skills/how-to-code/SKILL.md` § **Task files**.

## When this skill applies

- **Default handback:** skip this skill; use `how-to-code` self-check +
  `how-to-branch-and-pr` step 4.
- **Optional:** user asks for a chat review, self-check, or specialist pass —
  use the advisory checklist below and/or Task `subagent_type: code-reviewer`.
- **No file outputs** from this skill — findings stay in chat (or the
  specialist’s report).

## Optional advisory checklist (chat only)

Bound by `.cursor/rules/code_style.mdc`, `.cursor/rules/documentation-diagrams.mdc`,
`.cursor/rules/tdd.mdc`, `.cursor/rules/test-doubles.mdc`,
`.cursor/rules/fix-root-cause.mdc`, `.cursor/rules/prove-bug-with-test.mdc`.

When the user asks for a review, scan `git diff main...HEAD` (or working tree)
and report in chat:

| Check | Severity hint |
|---|---|
| Control flow followable; no nested hacks / magic constants | Critical if egregious |
| Non-trivial functions have docstrings per `code_style.mdc` | Advisory unless public API |
| Touched folders with non-trivial logic have README + `## Information flow` + diagram | Critical when behaviour/layout changed |
| Domain invariants respected (`docs/create_conflicts.md`) | Critical on clear violation |
| Bug fix has new/updated repro test (`.cursor/rules/prove-bug-with-test.mdc`) | Critical |
| Tests assert outcomes (DOM/HTTP/persisted), not mock-call-only | Critical when that is sole proof |
| Vitest full `api/client` mock without E2E when triggers apply | Critical |
| Plan/goal tasks have diff evidence; E2E ran when required | Critical if missing |

Style nits → suggestions only. Do not auto-fix unless the user asks. Do not
launch Bugbot/security unless the user explicitly requests them.

## Routing (spot-checks)

| Area | Rule / doc |
|---|---|
| Store ownership, deletes | `docs/create_conflicts.md`, `.cursor/rules/fix-root-cause.mdc` |
| ECS env / secrets | `.cursor/rules/local-vs-cloud-env.mdc` |
| BFF / API contract | `knowledge/api_first_paradigm.md` |
| E2E triggers | `docs/testing_strategy.md` § When E2E is required |
| Test doubles | `.cursor/rules/test-doubles.mdc`, `.cursor/rules/frontend-test-mocking.mdc` |

## Related

- Session audit SSOT: `.cursor/skills/how-to-code/SKILL.md` § Task files
- Handback: `.cursor/skills/how-to-branch-and-pr/SKILL.md`
- On-demand specialist: `.cursor/agents/code-reviewer.md`
