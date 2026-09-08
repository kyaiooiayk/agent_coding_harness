---
name: grill-me
description: >-
  Extracts what the user actually wants (underspecified asks) and stress-tests
  plans until every decision-tree branch is resolved — one question at a time
  with a guess attached. Use when an ask is underspecified ("build me X" without
  who/why/success), when the user invokes ("interview me", "grill me", "are we
  sure?", "stress-test my thinking", "poke holes in this", "what am I missing"),
  before a big commit/deploy/launch sanity check, or when you catch yourself
  silently filling in ambiguous requirements before any plan, spec, or code.
license: MIT
---

# Grill Me

What people ask for and what they actually want are often different. What a plan
says and what it quietly assumes are also different. This skill closes both gaps
**before** wrong work gets expensive — one question at a time, with your best
guess attached.

Two modes, one process:

| Mode | When | Deliverable |
|------|------|-------------|
| **Intent** | Underspecified ask; no plan/spec/code yet | Confirmed statement of intent (explicit yes) |
| **Grill** | Plan, RFC, design, or proposal exists | Decision tree walked; open threads listed |

Pick **Intent** when you cannot yet write the desired outcome in one sentence.
Pick **Grill** when there is already a plan to challenge. If both apply, finish
Intent first — grilling a plan that solves the wrong problem wastes the session.

## When to use

- The ask is missing at least one of: **who**, **why**, **success**, binding **constraint**
- The request is conventional rather than specific ("build me X", "make it faster")
- You're tempted to start with assumptions you haven't surfaced
- Two reasonable values are in tension and the user hasn't said which wins
- The user shares a plan/RFC/design and wants it challenged
- Explicit invoke: "interview me", "grill me", "ask me hard questions",
  "what am I missing", "before we start, are we sure?", "stress-test my thinking",
  "poke holes in this"
- Before a big commit / deploy / launch sanity check

## When NOT to use

- Unambiguous, self-contained asks ("rename this variable", "fix this typo")
- User explicitly asked for speed over verification
- Pure information requests ("how does X work?")
- Mechanical operations (renames, formats, file moves)
- Non-interactive contexts (CI, `/loop`, autonomous loops) — flag underspec as a
  blocker; do not invent answers
- You already have ≥95% confidence (see stop condition) and an explicit yes on the restate

## Shared process

### 1. Hypothesize, with a confidence number

Before asking anything, state your current best read in **one sentence**, plus an
honest confidence (0–100%):

```
HYPOTHESIS: <one sentence — what they actually want, or the load-bearing claim in the plan>
CONFIDENCE: ~30% — missing: <what's still unresolved>
```

Below ~70%, the reason line is mandatory. If you cannot predict their reaction to
the next three questions you'd ask, the number is too high.

**Grill mode:** read the plan once without interrupting, then hypothesize the
most load-bearing assumption — not a summary of the whole doc.

### 2. Ask one question at a time, each with a guess

```
Q: <one focused question>
GUESS: <your hypothesis for the answer + why>
```

Wait for the answer before the next question.

**Why one at a time:** batches let the user pick the easy question; later
questions often depend on earlier answers; careful thinking energy is finite.

**Why attach a guess:** reacting to a wrong guess is faster than generating from
scratch; it commits you to something you can be visibly wrong about. Mitigate
sycophancy by being willing to be wrong, and occasionally guess in a direction
you expect them to push back on.

If the question can be answered by reading the codebase, **read the codebase** —
don't make the user look up what you can grep.

### 3. Listen for "want vs. should want"

Dangerous answers sound like thoughtful answers:

- Best-practice talk without specifics ("scalable", "clean architecture")
- Deferral to convention ("the way most apps do it")
- "I should probably…", "I think I'm supposed to…", "good engineering says…"
- Buzzwords as goals ("modern", "robust") instead of outcomes

Probe with:

> *If you didn't have to justify this to anyone, what would you actually want?*

### 4. Track open threads

If the user defers, add it to a running **Open** list and circle back before you stop.

### 5. Restate, then require an explicit yes

When confidence is high, write back a tight restate the user can confirm line by
line. **Out of scope is non-negotiable** — half of misalignment is silent
disagreement about what is *not* being built.

**Not yes:** "whatever you think", "sounds good", "sure, let's go", silence then
"okay let's start". Re-ask with two concrete options, or "Anything you'd refine?"

If they correct you, fold it in and restate. Loop until an explicit **yes**.

### 6. The 95% confidence stop

Done when you can answer yes to:

> *Can I predict the user's reaction to the next three questions I would ask?*

If yes → produce the mode deliverable and stop interviewing.
If several rounds later you still cannot predict → stop grinding:

> I've asked N questions and still can't predict your reactions. Something
> foundational is missing. Want to step back?

## Intent mode (pre-plan)

Close the gap between the conventional ask and the real want **before** any plan,
spec, or code.

**Restate shape:**

```
Here's what I now think you want:

- Outcome:      <one line>
- User:         <who benefits>
- Why now:      <what changed>
- Success:      <how we know it worked>
- Constraint:   <binding limit>
- Out of scope: <what we are explicitly not doing>

Yes / no / refine?
```

**Deliverable:** that restate plus an explicit yes. Plans and task lists are
downstream (`how-to-plan`, five-phase Phase 2→3). If the user wants the intent to
persist across sessions, offer to capture it in the ticket/plan — only if they confirm.

## Grill mode (post-plan)

Walk the user's decision tree until nothing load-bearing is unresolved. The point
is not to *agree* with the plan — it is to surface assumptions they are making
without realizing it.

**Walk depth-first:**

1. Pick the most load-bearing assumption.
2. Resolve every branch under it before moving to the next.
3. Don't context-switch between unrelated decisions.

**Question patterns that work:**

- "What happens if \<assumption\> is wrong?"
- "Who is the first person to notice this is broken? How long after?"
- "What's the dumbest version we could ship in a day? Why isn't that good enough?"
- "When you say \<vague word\> — do you mean A, B, or C?"
- "Walk me through the worst-case rollback. How bad is it?"

**Restate / session output:**

```markdown
## Resolved
- <decision>: <what we locked> (was assuming: …)

## Open at end of session
- …

## Still load-bearing if wrong
- …
```

Require an explicit yes that the tree is complete enough to proceed (or that the
listed Open items are accepted deferrals).

## Interaction with this repo’s harness

- **`clarify-before-acting`**: default batched interview on new messages. This
  skill is the **deep** path — one-at-a-time when Intent/Grill triggers fire or
  Phase 2 needs real stress-testing. Prefer this skill over batching when the
  user invoked grill/interview or confidence is low on a non-trivial ask.
- **Five-phase Phase 2**: use this skill for deep grilling; batched `AskQuestion`
  only when choices are already enumerable.
- **`skeptical-expert`**: same stance — challenge premises with evidence; do not
  cheerlead.
- **`how-to-plan` / CreatePlan**: downstream of **Intent** (confirmed intent first)
  and after **Grill** has closed or explicitly deferred open branches.
- Do **not** produce a full plan, spec, or task list mid-interview before the
  explicit yes on the restate.

## Don't

- Don't ask three or more questions in one message
- Don't ask a question without your guess attached
- Don't cheerlead ("Great plan!" is the opposite of the job)
- Don't ask what you can answer by reading the repo
- Don't accept "whatever you think" as a terminal answer
- Don't stop early because the plan "seems fine"
- Don't treat "sounds good" / silence as confirmation
- Don't skip **Out of scope** on an Intent restate
- Don't save a persisted intent/ticket note before the user confirms

## Common rationalizations

| Rationalization | Reality |
|---|---|
| "The ask is clear enough" | If you can't write the outcome in one sentence, run Step 1 first |
| "Asking wastes their time" | 4–6 targeted questions ≪ building the wrong thing |
| "I'll figure it out as I build" | Discovery during implementation is rework |
| "They said whatever you think" | Delegation ≠ decision — offer two concrete options |
| "Several options help them choose" | Options widen search before intent is known; questions narrow it |
| "Attaching a guess leads them" | Leading is the point; the risk is sycophancy, not leading |
| "We've talked enough" | Predict the next three reactions — or you don't get it yet |

## Verification

- [ ] Hypothesis + confidence stated in the first turn; below ~70% has a reason
- [ ] One question at a time, each with a guess
- [ ] Codebase consulted when the answer was in the repo
- [ ] "What would you actually want?" probe when answers were sophistication/convention-signaling
- [ ] Mode deliverable written back (Intent restate **or** Grill resolved/open)
- [ ] Explicit yes (not "whatever" / "sounds good" / silence)
- [ ] At stop, next-three-questions prediction holds — or a foundational gap was named
- [ ] Downstream plan/code framed from confirmed intent or grilled decisions, not the original underspecified ask
