---
type: Reference
title: How to evaluate agents
description: Portable pointers for agent evaluation frameworks — AISI Inspect and Kaggle SAE zero-setup leaderboards.
tags: [agents, evaluation, benchmarks, inspect, kaggle]
timestamp: 2026-07-20T00:00:00Z
disclosure: on_demand
---

# How to evaluate agents
***

# What is this file about?
- Curated external frameworks and zero-setup exams for evaluating LLM agents.
- Companion notes: [/knowledge/continuous_evaluation.md](/knowledge/continuous_evaluation.md).
- In-repo LLM evaluation suites (when present): `.cursor/skills/how-to-llm-evaluation/SKILL.md`.
***

## AISI — AI Security Institute
- Open-source framework for large language model evaluations.
- Site: [Inspect](https://inspect.aisi.org.uk/)
***

## Kaggle Agent Exams (SAE) and zero-setup evaluation
- Problem: agent benchmarks historically needed heavy infrastructure to run.
- Shift: Kaggle Standardised Agent Exams (SAE) move toward "zero-setup" autonomous evaluation.
- How it works:
  - Lightweight API integration via a `SKILL.md` file.
  - The agent registers with Kaggle, fetches exam questions, and runs multi-step logic in its own sandbox.
  - Scores publish instantly to a live public leaderboard.
- What it tests: multi-hop reasoning and adversarial safety under pressure, with low setup friction.
***
