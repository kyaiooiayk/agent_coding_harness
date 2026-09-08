---
type: Reference
title: Mocks vs stubs in tests
description: Stubs return predetermined data for state verification; mocks verify collaborator interactions — default to stubs/fakes for queries, mocks for commands. Project enforcement (when present) — .cursor/rules/test-doubles.mdc, docs/testing_strategy.md § Mocks stubs and fakes; Vitest — .cursor/rules/frontend-test-mocking.mdc.
tags: [testing, mocks, stubs, tdd]
timestamp: 2026-07-12T00:00:00Z
---

# Mocks vs. Stubs
***

## Stubs
- A stub provides answers. In it you replace a dependency with something that returns predetermined data so the test can exercise your code.
* a mock verifies interactions. In it you replace a dependency with something that also checks how it was used (which methods were called, with what arguments, and sometimes in what order).
***

### The mental model to remember
* Am I checking the result? → Use a stub/fake.
* Am I checking the conversation between objects? → Use a mock.
***

## Some history
* Classical testing: Use real objects when possible and verify the final state or output.
* Mockist testing: Use mocks to verify collaborations and behavior between objects.
- Fowler doesn't declare one universally superior; he explains the trade-offs. Mock-heavy tests can be very focused and drive design, but they can also become tightly coupled to implementation details. State-based tests are often more resilient to refactoring.
***

## A sticky rule for your LLM agent
- Use stubs (or fakes) for queries. Use mocks for commands.
- Verify outputs by default; verify interactions only when the interaction itself is the behavior that matters.
- That's the sentence I'd keep on a sticky note:
- Default to state verification. Reach for mocks only when the correctness of the code depends on which collaborator was called and how it was called.
***

## References
- [Mocks Aren't Stub](https://martinfowler.com/articles/mocksArentStubs.html)
***