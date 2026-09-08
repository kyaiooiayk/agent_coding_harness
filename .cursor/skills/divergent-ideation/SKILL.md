---
name: divergent-ideation
description: >-
  Parallel divergent ideation via isolated Cursor Task branches under different
  cognitive frames (regulator, biology, speedrunner, 10-year-old, $0 budget),
  then score, cluster, prune traps, and deepen top survivors. Use on
  /divergent-ideation, "divergent ideation", brainstorm/ideate intents, or
  open-ended design, architecture, naming, API/SDK surface, and fuzzy-debugging
  decisions. Skip for syntax, lookups, bugs with known root cause, or closed
  phrasing ("quick", "standard", "canonical", "textbook"). Full pre-flight gate
  is in the skill body.
license: MIT
---

# Divergent ideation

Stop picking the textbook answer. The first three answers the model would
give are the answers a senior engineer would give in thirty seconds.
Correct. Forgettable. The interesting answers live past number three, in
the awkward middle nobody walks into. This skill makes the model walk
there.

One-sentence test: *If a junior would Google it and find the answer, answer
directly. If a senior would say "hm, let me think about this differently for
a minute" — run this skill.*

## When to use

- Architecture & design (storage, sharding, auth model, queues, retries)
- API / SDK / CLI surface design
- Fuzzy debugging — hypothesis *classes* you have not considered
- Migration & refactor planning
- Naming — functions, products, services, env vars
- Code-review widening — what else could go wrong
- Strategy / positioning — anywhere you'd say *"give me a few ways to…"*
- Agent loops at decision points where premature convergence is costly

## When not to use

- Lookup questions; single-correct-answer problems
- Bug fixes with a known root cause
- Inner-loop / per-keystroke / tight-latency asks
- Closed phrasing: "quick", "standard", "canonical", "textbook", "just", "one-line"

## Pre-flight (run before Phase 1)

Expensive: default ≈ **5 diverge + 3 deepen** Cursor `Task` calls (parent
scores/clusters). Do not pay that when a direct answer is better.

**Step 1. Explicit invocation.** If the user typed `/divergent-ideation`,
asked for "divergent ideation", "use the divergent-ideation skill", or
"run divergent ideation on this" → **skip Steps 2–3, go to Phase 1**.

**Step 2. Self-judge** (only if Step 1 did not match). Abort unless **all**
are yes:

1. **Open-ended?** Multiple viable answers, not one canonical answer.
2. **High-stakes?** Cost of the obvious answer being wrong is real
   (architecture, public API, product naming, fuzzy bugs, schema). Side
   project at 11pm = no.
3. **Open phrasing?** User avoided the closed words listed above.

**Step 3. On abort:** answer directly. Optionally append: *"If you want a
wider exploration under parallel cognitive frames with explicit trap
detection, run `/divergent-ideation <your problem>`."*

## Cursor mechanics (mandatory)

| Step | How |
|---|---|
| Diverge | Spawn **5 parallel** `Task` calls in **one** assistant turn (`subagent_type: generalPurpose`). Do **not** serialize. |
| Isolation | Each Task gets **only** problem P, user context, one frame vantage, and the diverge instruction. **Never** pass another branch's output into a diverge Task. |
| Score + cluster | **Parent** does this after all diverge Tasks return (parent already holds the full pool). |
| Deepen | Spawn **3 parallel** `Task` calls (`generalPurpose`), one idea each. |
| Do not use | `best-of-n-runner` (git worktrees — wrong tool). Do not fake parallelism by writing five frames sequentially in one context. |

List every diverge/deepen Task under the handback **Used** → **agents:** block.

## The loop

Two strict phases. Mixing them kills idea quality — the critic strangles
the generator.

### Phase 1 — Diverge (no critic)

1. Pick **5** frames from the table below. Code-shaped: 4 tagged `code` or
   `design` + 1 `wild`. Product/strategy: mix tags. Vary picks across
   re-runs of the same problem.
2. Spawn 5 parallel Tasks. Each prompt must include this instruction
   verbatim after the frame vantage:

   > You are in DIVERGENT mode. You are a generator, not a critic.
   > Generate 6 short distinct ideas under this frame. Each idea is one
   > phrase or one sentence. Do not evaluate. Do not rank. Do not hedge.
   > The first three obvious answers everyone would give are banned.
   > Push past them into the awkward middle.
   > Output a JSON array only. No prose before or after.
   > `[{"text": "...", "rationale": "..."}, ...]`

### Phase 2 — Focus (critic on)

1. **Score.** Each idea: novelty / viability / fit on 0–10. Flag traps
   (hidden cost, false economy, will not scale, premature abstraction)
   with a one-line reason.
2. **Cluster.** 3–6 clusters by *underlying angle*, not surface keywords.
   Label angles (e.g. "remove the server", "cache-shaped", "batched-window").
3. **Deepen top 3.** Rank by `0.35×novelty + 0.40×viability + 0.25×fit`,
   exclude traps, take top 3. Each deepen Task:

   > You are in FOCUS mode. Take one promising idea and connect dots.
   > Sketch how it would actually work in 4 to 8 sentences. Name the
   > load-bearing risk. Name the first concrete step a coder would take.
   > Then generate 3 to 5 sub-ideas that branch off (variations,
   > combinations with other domains, things this unlocks).
   > Output JSON only.

## Frames

Pick 5 per run.

| Frame | Vantage prompt | Tags |
|---|---|---|
| **hardware engineer** | You think in latency, memory layout, and physical constraints. Re-ask this as a hardware/firmware problem. What does the bus topology, cache, timing budget tell you? | code, wild |
| **regulator** | You audit systems for compliance and failure modes. What must be provable, traceable, or refusable here? | design, general |
| **10-year-old** | You are a curious 10 year old who has never seen software. Describe naive but unencumbered approaches. Ignore convention. | general, wild |
| **competitor trying to break it** | You are a hostile competitor or attacker. Generate approaches that exploit, fail, or sabotage the obvious solution. Then invert into ideas. | code, design |
| **biology** | Transplant a mechanism from biology (immune systems, neural plasticity, cell signaling, evolution, gut flora). Force-fit it onto this engineering problem. | code, wild |
| **logistics** | Steal mechanisms from logistics: queues, batching, just-in-time, hub-and-spoke, returns, last-mile. Apply them literally. | code, design |
| **game design** | Approach this as a game designer. What are the loops, rewards, friction, save-states, speedrun tricks? Treat the user as a player. | design, general |
| **markets** | Treat the problem as a market. Buyers, sellers, market-makers. What does an auction, a futures contract, a clearing house look like here? | design, wild |
| **inversion** | Ask the OPPOSITE question. If goal is X, brainstorm how to guarantee NOT X. Then negate each answer back. | code, design, general |
| **extreme: $0 budget, 1 hour** | No money, no team, one hour. What is the crudest version that still does the load-bearing thing? | code, general |
| **extreme: infinite budget, 10 years** | Infinite compute, infinite engineers, a decade. What is the maximalist version? | design, wild |
| **remove the load-bearing assumption** | Name the thing everyone treats as fixed (framework, database, request-response model, network). Imagine it is gone. What is possible? | code, design, wild |
| **speedrunner** | You are a speedrunner. Find glitches, skips, out-of-bounds tricks, frame-perfect shortcuts. What is the abusive-but-legal path? | code, wild |
| **ant colony** | No central planner. Many dumb agents, local rules, pheromone trails. How does the problem solve itself emergently? | code, wild |
| **3am on-call** | You are the on-call engineer woken at 3am when this breaks. What design would let you not get paged? | code, design |

## Output shape

Do not collapse into a wall of prose. Structure is the point.

1. **Brief.** 1–2 lines: problem + any reframe.
2. **Wide set.** Full pool by cluster. Each idea one short phrase + score
   chips `[N7 V8 F9]`.
3. **Converge.** 2–4 idea shortlist with why; mark the non-obvious-but-
   viable pick with ★. List traps separately (one-line reason each).
4. **Focus.** The 3 deepened branches: sketch, load-bearing risk, first
   concrete step, child ideas.
5. **Provocation.** One wildcard question/idea if nothing landed.

## Anti-patterns

- **Convergence disguised as divergence** — ten variations of one assumption
  is decoration, not breadth.
- **Weird-for-weird's-sake with no converge** — always cluster and shortlist.
- **Walls of equally-weighted prose** — structure is half the value.
- **Refusing to commit** — after diverge, take a real position (★ pick).
- **Skipping isolation** — sequential frames in one context is not this
  skill; use parallel isolated `Task` calls.

## Calibration

- Default **5 frames × 6 ideas**. Quick naming: 3×4. High-stakes product:
  5×8. Stop when new candidates only repeat existing shapes.
- Serious strategy: flag wild cards clearly. Open play: let it run loose.
