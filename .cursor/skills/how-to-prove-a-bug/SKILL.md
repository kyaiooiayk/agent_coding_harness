---
name: how-to-prove-a-bug
description: >-
  Encode a bug as a failing test before claiming root cause — repro, red test,
  diagnose, fix, green; hand back with Bug proof block pointing the user to the
  harness test. Use on bug reports, root-cause claims, and before any bug-fix
  product edit.
---

# How to prove a bug (<describe your app here>)

Read when diagnosing a bug, claiming root cause, or fixing a failure. Bound by hotline `.cursor/rules/harness-hotline.mdc`, depth `.cursor/rules/prove-bug-with-test.mdc`, `.cursor/rules/fix-root-cause.mdc`, `.cursor/rules/tdd.mdc`.

**User trust rule:** they only believe root cause when they can see a **failing test** that proves the bug exists. Your job is to write that test, run it red, fix, run green, and **point them to the test** in handback.

## Workflow

1. **Symptom** — one sentence: test name, log line, or user-visible behaviour. Do not name root cause yet.

2. **Reproduce** — run the failing path (pytest, Vitest, curl, UI). Confirm the symptom exists. User narrative alone is not enough.

   **If you cannot reproduce on demand** — do not claim root cause. Narrow the class of flake, then retry:
   - **Timing** — timestamps around the suspect path; concurrency / `make test parallel=true` (see `docs/testing_strategy.md` § Tests Flaky in CI). Do **not** treat `sleep` as a fix (`.cursor/rules/fix-root-cause.mdc`).
   - **Environment** — local vs CI vs cloud (`how-to-fix-cloud-deployment`); versions; empty vs populated data.
   - **Shared state** — test isolation, singletons, caches, fixed temp paths; run the failing file alone.
   - **Still intermittent** — log a stable error signature, document observed conditions, and stop short of "proven" until a red harness test exists.

   **Regression with a known-good SHA** (optional): `git bisect` against a deterministic scoped test command — not step 1 of every bug.

3. **Reduce** — shrink to the minimal failing case before encoding: smallest input and closest unit boundary that still fails for the **same reason**. Drop unrelated setup that obscures the invariant.

4. **Encode** — add or extend a test **closest to the bug**:
   - Python: `microservices/<svc>/tests/`, `api/tests/`, `shared_packages/<pkg>/tests/`
   - Frontend: `frontend/tests/`
   - Cross-service / tab / BFF: unit at lowest honest boundary; E2E when `docs/testing_strategy.md` triggers apply
   - Assert **output, state, or HTTP body** — not call order alone (`.cursor/rules/test-doubles.mdc`)

5. **Red** — run the scoped test; it must **fail for the same reason** as the bug. Capture assertion message or traceback. If it passes, you have not proven the bug — revise the test or the hypothesis.

6. **Diagnose (verified only after red)** — symptom → hypothesis → invariant → fix site (owner that writes state). Tell the user: "Verified by `<path>::<test_name>` failing with …"

7. **Fix** — minimal product-code diff; no symptom-only patches (`.cursor/rules/fix-root-cause.mdc`).

8. **Green** — same test passes; run `make test-agent-stop` before handback (`.cursor/rules/agent-test-gate.mdc`).

9. **Handback** — include **Bug proof** block from `prove-bug-with-test.mdc`; **link the test path** so the user can open it. The test **stays in the repo** — permanent harness, same PR.

## When proof is missing

Stop and tell the user explicitly:

> I don't have proof yet — no failing test encodes this bug. Next step: add `<proposed test path>` that asserts `<invariant>`, run it red, then fix.

Do not hand back "root cause is X" or ship product-code edits until step 5 succeeds (unless user explicitly requested test-after).

## Bug proof block (copy to handback)

```markdown
## Bug proof
- **Test:** `<path>::<test_name>`
- **Fails before fix:** <assertion or error>
- **Proves:** <invariant violated>
- **Harness:** permanent — included in this PR
```

## Pick the test layer

| Bug surface | Start here |
|---|---|
| Pure function / module logic | Unit test on real module |
| Service handler / store write | pytest on owning microservice |
| React state / hook | Vitest on real module or component harness |
| BFF + DB + UI visible wrong data | Unit at owner if possible; E2E when strategy requires |
| Cloud-only | Local repro or `make test parallel=true remote=true`; still encode invariant in harness when feasible |

## Anti-patterns

- Claim root cause before red test
- Remove repro test after fix
- Weaken assertion to green without fixing product code
- `toHaveBeenCalledWith` / `mock.assert_called()` as sole proof of user-visible bugs

Full bug order: `.cursor/skills/how-to-code/SKILL.md` § Bug fix order.
