---
name: how-to-document-procedure-changes
description: >-
  Reminds the agent to sync runbooks when an operational procedure changes —
  CI/CD, deploy scripts, Make/CLI commands, infra apply steps, or anything that
  changes how humans or automation run the system. Use when editing workflows,
  ops scripts, task runners, README/runbook deploy sections, or agent skills
  that describe operational flows.
---

# Document procedure changes

When you change **how** something is run — not just what the application does — update the canonical runbook in the **same task**. Code diffs do not replace procedure docs.

## What counts as a procedure change

Anything that changes the steps, order, flags, prerequisites, or side effects of running the system:

- CI/CD pipelines and workflow files
- Deploy, migrate, bootstrap, or release scripts
- Make targets, npm/poetry scripts, shell entrypoints operators use
- Infrastructure apply/destroy paths that affect runtime config or secrets
- Runbooks, README ops sections, `make help`, agent skills describing workflows
- “Preview” or dry-run tooling (what gets skipped vs forced)

Application-only changes (logic, UI, tests with no ops impact) do **not** need runbook updates unless they change what operators must do after merge.

## Mandatory checklist

Complete before marking the task done:

```
- [ ] Update every runbook/skill/help text that still describes the old flow
- [ ] Add or update preview/verify commands if operators can dry-run the new behaviour
- [ ] Run existing self-checks or smoke commands for touched scripts
- [ ] Tell the user what changed in the procedure (short paragraph in the handback)
- [ ] Runbooks and README ops sections include at least one flow diagram when steps branch or cross services (`.cursor/rules/documentation-diagrams.mdc`)
```

## Where to write things

| What | Typical location (adapt to this repo) |
|------|--------------------------------------|
| Canonical operator runbook | `docs/*`, `README.md`, or `BAU/*` |
| Agent workflows | `.cursor/skills/*/SKILL.md` |
| CLI discoverability | `make help`, `--help`, workflow input descriptions |

Search for stale references to the old command or flag before finishing.

## Examples (illustrative — not exhaustive)

**CI pipeline:** workflow now skips a job unless an input is set → update workflow README + fix skill that said “always runs terraform.”

**Deploy script:** migrations run only for services in the deploy list → update deploy doc + fix handback steps in a bugfix skill.

**Makefile:** new `ALL=1` flag to force full rebuild → `make help` + runbook table of commands. New or renamed target → **both** `HELP_<SECTION>` and `HELP_<SECTION>_ONLY` in `make/help.mk`; handback names `make help <topic>`. Full gate: `.cursor/rules/makefile-help-sync.mdc`.

## Anti-patterns

- Procedure code changed; runbook still shows the old command sequence
- Skill or README contradicts the Makefile/workflow that actually runs
- Documenting implementation detail without stating what operators should do differently
- **Handback lists `make aws-ecr-push SERVICE=…` / `make aws-deploy` as the routine prod fix** — use `git push` + `gh workflow run cd.yml` instead (see `how-to-fix-cloud-deployment` skill)
- **Agent runs terraform apply, ECR push, ECS deploy, or CD** — user or GitHub Actions only (see `.cursor/rules/no_cloud_deploy.mdc`)
- **Agent deploys because "fix remote e2e" or "run tests and fix"** — patch git + hand back CD; remote e2e is read-only verification
