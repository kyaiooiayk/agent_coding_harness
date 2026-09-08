---
type: Reference
title: Increase test fidelity by avoiding mocks
description: Prefer real implementations, then fakes, then mocks — higher fidelity tests catch more bugs; mocks are the last resort for hard-to-trigger paths. Project enforcement (when present) — .cursor/rules/test-doubles.mdc, docs/testing_strategy.md § Mocks stubs and fakes; Vitest — .cursor/rules/frontend-test-mocking.mdc.
tags: [testing, mocks, fakes, fidelity, tdd]
timestamp: 2026-07-12T00:00:00Z
---

# Increase Test Fidelity By Avoiding Mocks
***

## North star
- Replacing your code’s dependencies with mocks can make unit tests easier to write and faster to run. However, among other problems, using mocks can lead to tests that are less effective at catching bugs.
- The fidelity of a test refers to how closely the behavior of the test resembles the behavior of the production code. A test with higher fidelity gives you higher confidence that your code will work properly. 
***

## Guidelines
- Try to use the real implementation. This provides the most fidelity, because the code in the implementation will be executed in the test. There may be tradeoffs when using a real implementation: they can be slow, non-deterministic, or difficult to instantiate (e.g., it connects to an external server). Use your judgment to decide if a real implementation is the right choice.
- Use a fake if you can’t use the real implementation. A fake is a lightweight implementation of an API that behaves similarly to the real implementation, e.g., an in-memory database. A fake ensures a test has high fidelity, but takes effort to write and maintain; e.g., it needs its own tests to ensure that it conforms to the behavior of the real implementation. Typically, the owner of the real implementation creates and maintains the fake. 
- Use a mock if you can’t use the real implementation or a fake. A mock reduces fidelity, since it doesn’t execute any of the actual implementation of a dependency; its behavior is specified inline in a test (a technique known as stubbing), so it may diverge from the behavior of the real implementation. Mocks provide a basic level of confidence that your code works properly, and can be especially useful when testing a code path that is hard to trigger (e.g., an error condition such as a timeout).
- Most tests should be small: they must run in a single process and must not wait on a system or event outside of their process. Increasing the fidelity of a small test is often a good choice if the test stays within these constraints. A healthy test suite also includes medium and large tests, which have higher fidelity since they can use heavyweight dependencies that aren’t feasible to use in small tests, e.g., dependencies that increase execution times or call other processes.
***

## References
- [Increase Test Fidelity By Avoiding Mocks](https://testing.googleblog.com/2024/02/increase-test-fidelity-by-avoiding-mocks.html)
***