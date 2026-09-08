---
type: Reference
title: API load testing
description: Best-practice order and targets for API baseline, load, and stress tests, plus CI/CD integration notes.
tags: [reference, api, load-test, performance, stress-test, ci-cd]
timestamp: 2026-07-25T00:00:00Z
---

# API
***

## What is this file about?
- This file is a curated list of best-practices design rule related to API load tests.
***

## Orders matters
- Start with baseline tests -> proves it works correctly
- Then load tests -> proves it can sustain the usage load
- Then stress tests -> helps you find the platform limit
---

## Load vs. stree tests
- **Load testing** validates behavior under expected peak traffic.
- **Stress testing** pushes beyond capacity to find breaking points and observe failure modes.
---

## Latency
- The time it take to receved a complet reply.
---

## How do you choose performance test targets? 
- Define targets based on SLAs (Service Level Agreement), business requirements, and historical baseline data.
- Common targets: p95 response time < 500ms, error rate < 0.1%, throughput matching peak traffic projections
---

## How to integrate this in CI/CD
- Add lightweight performance regression tests to your pipeline that complete in under 5 minutes, comparing key metrics against established baselines and failing builds on regressions.
- The challenge is that for distributed architecture running on cloud this test can be run faithfully only after you deploy.
--- 

## Referencesg
- [API Performance Testing: Metrics and Tools](https://yrkan.com/blog/api-performance-testing/?utm_source=chatgpt.com)
---