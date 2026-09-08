---
name: how-to-branch-and-pr
description: >-
  <describe your app here> git branch, rebase, push, and PR workflow. Use when starting a
  new ticket, new Cursor chat tab, creating a branch, rebasing on main,
  handing back for user review, pushing, or opening/updating a pull request.
  Always read this skill before any git write (branch, rebase — never push or gh pr).
  **New chat tab = new branch before first edit.** **User commits, pushes, opens PR.**
---

# Branch and PR workflow (<describe your app here>)

## STOP — new Cursor chat tab = new branch + new PR

**This file applies on every agent turn that might edit the repo.** If you are in a **different Cursor chat tab** than the one that created the current branch, you are in a **new session**. Do **not** edit on the old branch. Do **not** wait for the user to say "commit" or "open PR".

**First actions in a new tab (before clarify, plan, or code):**

```bash
git branch --show-current
git status
```

Then: update main → `git checkout -b <project-prefix>-(<tag>)-<slug>` → **then** edit. If `.git` is incomplete, say so and edit in place.

A dirty tree or a checked-out feature branch from another tab does **not** waive this gate — including for `.cursor/`, docs-only, or lint fixes.

**Ticket log (optional):** `ticket_history.md`.

**Agent boundaries:** patch and rebase locally → hand back a **merge-ready** rebased base → **user commits, pushes, and opens the PR** → **user merges** on GitHub. Agents **never** run `git push` or `gh pr create`.

**Agents do not run `git commit`** unless the user explicitly asks (e.g. "commit for me").

## One PR = one agent session (mandatory)

**The agent chat session is the PR scope boundary.** Everything the user asked for and the agent implemented **in this thread** belongs in one PR. Work from **other** sessions, unrelated dirty tree state, or drive-by edits the user did not request **here** does not belong — park or stash it.

### Cursor tab = session (mandatory)

Each **Cursor agent chat tab/thread** is a separate session. Sessions do not share PR scope — a README/docs harness change in tab B is **not** part of tab A's spinout-kill PR even when both edit the same repo.

**Branch before the first edit in this tab** — including `docs/`, `knowledge/`, `.cursor/`, and `AGENTS.md`. Hook `hook_is_product_code_path` (lint/stop-gate scope) excludes those paths; that does **not** waive branch-and-PR. "Product code only" is a common miss — treat **any** `Write`/`StrReplace` as requiring a feature branch.

| Belongs in this PR | Does not belong |
|---|---|
| Files changed to fulfill this session's user messages | Changes made in a different Cursor chat session |
| Tests/docs for that same session work | Pre-existing uncommitted edits unless user explicitly includes them this session |
| Fix-ups caused by this session (rebase conflict, test for your edit) | New topic the user started in a **new** session (→ separate branch/PR) |

**Session start:** run `git status`. If the tree is already dirty, tell the user which paths are pre-session and **do not** add them to this PR unless they say to include them.

**New session:** when the user opens a fresh chat (new tab/thread), create a **new ticket row + branch before the first edit in this tab** — not when they ask to commit. Do not append to a prior session's branch without explicit instruction in **this** thread.

Ticket id/tag still name the branch and PR title; the **session** decides which paths are in the diff.

### Scope gate (before step 4 handback and before step 5 commit)

```bash
git status
git fetch origin
git diff origin/main...HEAD --name-only   # or main...HEAD on dirty trees before first commit
```

1. Summarize **what the user asked in this session** (one short paragraph).
2. List changed paths; mark any path **not** touched for this session's requests (including pre-session dirty files).
3. If foreign paths are in the diff → **do not commit or open a PR**. Stash or reset those paths; or ask the user to confirm they want them in this session's PR.
4. If the user pivoted to a second unrelated goal **in the same session**, ask whether one PR or a split before commit.

Include the session scope summary in every handback (step 4).

### Split work across sessions or topics

When the diff mixes **this session** with **other** work:

1. Keep only this session's paths for the current PR.
2. Stash or branch the rest; note which **session or ticket** owns the parked work.
3. **Stop** before commit/push if the user has not confirmed a combined PR.

For large splits already committed, use the same discipline as personal skill `split-to-prs` (stash snapshot, stage named paths only, no `git add -A`). User approves before extra branches/commits.

## PR title format

```
<project-prefix>-[<tag>] - <Short description>
```

| Part | Rule |
|---|---|
| `<PROJECT-PREFIX>` | Uppercase ticket prefix you choose for this repo (not a product brand name) |
| `<XXXX>` | Four-digit ticket id (e.g. `0194`) |
| `<tag>` | One tag from the nomenclature list below, in square brackets |
| `<Short description>` | Same words as the branch slug, but **spaces instead of hyphens** (no kebab-case in title/commit) |

Example: slug `tool-choice-plaintext-reply` → title `<project-prefix>-0194-[bug] - tool choice plaintext reply`.

If scope is unclear at branch start, use a placeholder (e.g. `<project-prefix>-0189-[imp] - WIP`) and rename once the ticket is clear.

### Tag list (square brackets)

| Tag | Meaning |
|---|---|
| `be` | Backend |
| `core` | New functionality |
| `fe` | Front end |
| `tb` | Tech debt |
| `docs` | Documentation / bookkeeping |
| `test` | Unit, integration, or E2E tests |
| `infra` | Infrastructure |
| `log` | Logging |
| `bug` | Bug fix |
| `pc` | Pulse check — nice-to-have parallel work |
| `devops` | DevOps experience |
| `rd` | Research and development |
| `etl` | Extract, transform, load pipeline |
| `feat` | New capability / feature |
| `uc` | Use case |
| `imp` | Improvement |

## Branch naming

Git ref rules forbid literal `[` and `]` in branch names (`git check-ref-format` rejects them). Use **parentheses** around the tag on the branch so it stays visually bracketed; keep **square brackets** on the to-do row, commit, and PR title.

```
<project-prefix>-<XXXX>-(<tag>)-<short-slug>
```

| Part | Rule |
|---|---|
| Prefix / ticket | Uppercase `<PROJECT-PREFIX>`, then `-`, then four-digit id |
| Tag | Nomenclature tag in **parentheses** on the branch (e.g. `(bug)`, `(be)`) — square brackets `[bug]` on commit/PR/to-do only |
| Slug | Lowercase kebab-case; same words as the PR/commit description |

Example: ticket `0194`, tag `bug`, description *tool choice plaintext reply* → branch `<project-prefix>-0194-(bug)-tool-choice-plaintext-reply`; commit/PR `<project-prefix>-0194-[bug] - tool choice plaintext reply`; to-do row `<project-prefix>-0194 [bug] - …`.

Slashes are allowed for grouping when needed (e.g. `<project-prefix>-0194-(be)-agent/tool-choice`).

## Workflow (ordered)

### 0. Session + branch gate (mandatory — new tab or first edit)

Run **before** clarify/plan/code when this Cursor chat tab has not yet created **its** branch:

```bash
git branch --show-current
git status
```

| Signal | Action |
|---|---|
| Current branch belongs to **another chat's work** | Stop editing on it; pull main; new ticket + new branch for **this** tab |
| Dirty paths you did not touch in **this** tab | Foreign — exclude from this PR unless user explicitly combines |
| About to edit any tracked file (product, `.cursor/`, ``, docs) | Branch must exist **first** |

Then continue with steps 0a–2 below.

### 0a. Pull main first (mandatory)

Before **every** new branch — and again before rebase/commit/push:

```bash
git checkout main
git pull origin main
```

### 1. Ticket in `to_do_plan.md` (mandatory)

Every branch maps to **one** row in `to_do_plan.md` § **List**. Two cases:

| Case | Action |
|---|---|
| **Ticket already exists** | Use its `<XXXX>` and `[<tag>]` for branch, commit, and PR. Do not invent a new id. |
| **No ticket yet** | Add a new row at the **top** of `# List`: `[ ] <project-prefix>-<XXXX> [<tag>] - <short description>`. Pick the next free four-digit id (next above the current highest). Tag from nomenclature below. |

**Live branch marker:** as soon as you create or checkout the feature branch and start work, change that row's prefix from `[ ]` to **`[LIVE]`**:

```
[LIVE] <project-prefix>-0194 [bug] - Fix tool_choice on two-phase plaintext reply
```

| When | To-do prefix |
|---|---|
| Branch created / work in progress | `[LIVE]` |
| PR merged | `[x]` (remove `[LIVE]`) |
| Branch abandoned or paused with no open PR | `[ ]` (remove `[LIVE]`) |

`[LIVE]` is **to-do plan only** — do not put it on the git branch name, commit subject, or PR title.

Branch, commit subject, PR title, and the to-do row must describe the **same work** (same id, tag, and words — kebab-case slug on the branch only).

### 2. Create branch (new ticket)

After step 0 and the ticket row above:

```bash
git checkout -b <project-prefix>-<XXXX>-(<tag>)-<short-slug>
```

Then set the matching to-do row to `[LIVE]` (step 1).

Do the implementation work on this branch. Leave edits **uncommitted**. **User commits** before push/PR (step 4 handback). Agent does **not** commit unless the user explicitly asks in this thread.

### 3. Stay rebased on main (agent-owned)

Remote `main` moves whenever another PR merges. **The agent** fetches and rebases — not the user.

```bash
git fetch origin
git rev-list --left-right --count origin/main...HEAD
# If origin/main is ahead, rebase:
git rebase origin/main
```

**Conflict policy:**

| Situation | Agent action |
|---|---|
| Mechanical / obvious (imports, formatting, same intent) | Resolve, `git add`, `git rebase --continue` |
| Semantic — both sides valid, product choice, unsure intent | **Stop.** List conflicted files and hunks; **ask the user**. Do not hand back until resolved. |
| Rebase error or dirty tree blocks rebase | `git stash push -u -m "handback-wip"` → rebase → `git stash pop`; resolve or ask user |
| Rebase error or unresolved state | Fix or ask user; do not hand back as merge-ready |

After a clean rebase: run scope gate (step 3 scope section) and optional targeted tests on conflict-touching paths.

Re-run fetch + rebase before **handback (step 4)** and again before **push (step 5)** if `origin/main` may have moved.

### 4. Handback — user reviews merge-ready base (user commits)

**Session audit:** every ticket — `.cursor/rules/agent-tasks-session-audit.mdc` (`command.md` + `lesson_learnt.md`). Depth/templates: `.cursor/skills/how-to-code/SKILL.md` § Task files.

**Agent prepares merge-ready base (user does not rebase; agent does not commit):**

```bash
git fetch origin
# If rebase blocked by dirty tree:
git stash push -u -m "handback-wip"
git rebase origin/main          # resolve or escalate conflicts per step 3
git stash pop                   # if stashed; resolve pop conflicts or ask user
git status
```

After stash/rebase, if everything sits in the index only because of `stash pop`, unstage before handback (`git restore --staged .`) unless the user asked to stage. Cursor **green / Staged** is not a commit.

Hand back — lead with **WIP left uncommitted — you commit**. User reviews rebased base plus any uncommitted session edits:

```bash
git fetch origin
git checkout '<project-prefix>-<XXXX>-(<tag>)-<short-slug>'
git status                              # expect Changes not staged / untracked — not a new commit on HEAD
git log --oneline origin/main..HEAD     # commits already on branch (often empty until user commits)
git diff origin/main...HEAD             # committed diff vs main
git diff                                # uncommitted session edits
git diff --cached                       # staged edits (if any)
```

**Handback must include:**

1. One-line lead: **WIP left uncommitted — you commit** (agent did not `git commit`).
2. Confirmation: rebased on `origin/main`, no pending rebase, no unresolved conflicts.
3. Session scope summary (user asks, ticket id, path list).
4. Diff summary (`--stat` for committed and uncommitted); note if work is only staged/unstaged.
5. Suggested commit subject: `<project-prefix>-[<tag>] - <description with spaces>` — **user runs commit**.
6. **Publish commands for the user** (agent does **not** run these):

```bash
git commit -m "<project-prefix>-[<tag>] - <description with spaces>"
git fetch origin && git rebase origin/main
git push -u origin HEAD
gh pr create --title "<project-prefix>-[<tag>] - <description with spaces>" --body "$(cat <<'EOF'
## Summary
- …

## Scope
- Session: …
- Ticket: <project-prefix>-<XXXX> [<tag>]
- Paths: …

## Test plan
- [ ] …
EOF
)"
```

**Forbidden for agents:** `git push`, `git push -u`, `gh pr create`, `gh pr edit` — including when the user says "open the PR", "create the PR", or "do it". Those phrases mean **hand back the commands above**, not run them.

In zsh, quote branch names that contain `()`.

### 5. User publishes (agent does not)

After handback, the **user** commits, pushes, and opens the PR using the commands from step 4. The agent does **not** re-run push or `gh` on the user's behalf.

If the user reports push/rebase conflicts, the agent may `git fetch` + `git rebase origin/main` locally again and hand back updated commands — still **no** agent push.

### 6. User merges

The **user** merges the PR on GitHub (squash or merge per team habit). Agents do **not** run `gh pr merge`.

Update the to-do row: `[LIVE]` → `[x]`.

This repo has no production CD path — local Compose only.

## PR description template

```markdown
## Summary
- <Primary change from this session>

## Scope
- Session: <user asks in this chat>
- Ticket: <project-prefix>-<XXXX> [<tag>]
- Paths: <areas touched>

## Test plan
- [ ] `make test` / `pytest …`
- [ ] `make e2e-test file=…` (when UI/BFF/cross-service)
- [ ] Manual steps if any
```

Add links to ticket rows in `to_do_plan.md` when the ticket is tracked there.

## Anti-patterns (reject)

| Do not | Do instead |
|---|---|
| Put other-session or pre-session dirty work in this PR | Session scope only; stash or separate branch |
| Start a new chat topic on an old session's branch without asking | New tab → branch + ticket **before first edit** |
| Assume checked-out branch is yours because `git status` is dirty | `git branch --show-current`; another tab may own that branch |
| Finish implementation on `main` without a branch | Branch + ticket before **any** repo edit (docs/harness included) |
| Skip branch because edits are `docs/` / `.cursor/` / `knowledge/` only | Product-code lint scope ≠ PR scope — branch anyway |
| Merge tab B harness/docs work into tab A's branch | New tab → new ticket + branch unless user combines PRs |
| Say "done" without checkout/diff commands | branch-and-pr step 4 same turn |
| Use a branded / wrong-case ticket prefix | Always uppercase `<PROJECT-PREFIX>` — same prefix as the to-do row |
| Skip ticket / `[LIVE]` row | Add row in `to_do_plan.md` |
| User said "open PR" / "create the PR" / "do it" | Handback with commit + push + `gh pr create` commands — **user** runs them |
| Agent runs `git push` or `gh pr create` | **Forbidden** — even after user approval or "open PR" |
| Commit without handback | Handback with checkout/diff commands (step 4) first |
| Live branch without `[LIVE]` on the to-do row | Set `[LIVE]` on the matching row when branching |
| Branch off stale `main` | Always `git pull origin main` first (step 0) |
| Merge `main` into feature branch | `git rebase origin/main` |
| Commit/push without user approval | Handback with checkout commands (step 4) |
| `gh pr merge` or merge via agent | User merges (step 6) |
| Push then rebase (force-push surprise) | Agent rebases before handback; user pushes once |
| Agent runs `git commit` | **Never** unless user explicitly asks; handback leaves WIP uncommitted (staged ≠ committed) |
| Hand back before rebasing | Agent rebases first; user sees rebased base |
| Ask user to run `git rebase` | Agent rebases; escalate semantic conflicts |
| Agent runs any `git push` | User pushes — agent hands back `git push -u origin HEAD` |

## Quick checklist

**Starting ticket (new Cursor chat tab)**
- [ ] `git branch --show-current` — not another session's branch
- [ ] `git status` — foreign dirty paths noted and excluded
- [ ] `git checkout main && git pull origin main`
- [ ] Ticket row in `to_do_plan.md` — reuse existing or add new at top of `# List`
- [ ] `git checkout -b <project-prefix>-(<tag>)-<slug>` (parentheses on branch — git forbids `[` `]` in ref names)
- [ ] To-do row prefix → `[LIVE]` for the active branch
- [ ] PR title / commit subject use `[tag]` and spaces in the description (no `[LIVE]` on commit/PR)

**During work**
- [ ] Rebase when `origin/main` has new commits

**Handback**
- [ ] Session audit updated — `.cursor/rules/agent-tasks-session-audit.mdc` (`command.md` + `lesson_learnt.md`)
- [ ] Agent rebased on `origin/main`; conflicts resolved or user consulted
- [ ] Session scope gate; only this thread's paths
- [ ] User given rebased diff commands + suggested commit message
- [ ] Agent did **not** commit or push
- [ ] Handback includes user publish commands (`commit`, `push -u`, `gh pr create`)

**User publishes (not agent)**
- [ ] User committed
- [ ] User ran `git push -u origin HEAD`
- [ ] User ran `gh pr create` (or updated existing PR)
