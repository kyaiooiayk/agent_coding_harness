---
type: Reference
title: Agent security guardrails
description: Seven guardrail patterns for agentic AI systems — least privilege, human in the loop, output guardrails, privilege separation, prompt isolation, tool validation, input sanitization.
tags: [reference, agent, security, guardrails]
timestamp: 2026-07-14T00:00:00Z
---

# Agent security guardrails
***

# What is this file about?
- Seven guardrail patterns that protect agentic AI systems from prompt injection and unsafe tool use, each framed as failure mode -> mitigation -> trade-offs.
- For the five-stage **request pipeline** (when screening / verification / validation run), see [Agent guardrails](/knowledge/agent_guardrails.md) — keep pattern catalogue and pipeline as separate files.
***

## 1. Least privilege
- Failure mode: the AI gets access to tools it does not need.
- Mitigation: give the AI only the minimum tools and permissions the task requires; disable every unnecessary tool.
- Pros: limits damage from prompt injection; prevents unauthorized actions.
- Cons: requires careful permission management; agents need new permissions as tasks change.
***

## 2. Human in the loop
- Failure mode: the AI performs a sensitive action without user approval.
- Mitigation: the AI proposes an action, a human reviews it, and the action only runs after approval.
- Pros: prevents real-world attacks; protects sensitive operations.
- Cons: slows down workflows; adds user friction.
***

## 3. Output guardrails
- Failure mode: the AI generates harmful, unsafe, or sensitive output.
- Mitigation: inspect every response before release; apply policy checks, schema validation, classifiers, and filters to block unsafe outputs.
- Pros: prevents data leaks; blocks harmful responses.
- Cons: does not stop prompt injection itself; complex attacks can bypass simple filters.
***

## 4. Privilege separation
- Failure mode: the same AI reads untrusted data and performs privileged actions.
- Mitigation: separate components by privilege; keep privileged tools away from components that process untrusted input, and give each component only the permissions it needs.
- Pros: prevents privilege escalation; reduces attack surface.
- Cons: makes the system more complex; requires coordination between components.
***

## 5. Prompt isolation
- Failure mode: the AI treats untrusted content as trusted instructions.
- Mitigation: clearly separate trusted prompts from untrusted content — wrap external content with tags such as `<UNTRUSTED>...</UNTRUSTED>` and treat it as data, not instructions.
- Pros: reduces indirect prompt injection; works well with RAG systems.
- Cons: does not guarantee protection; depends on the model respecting the boundary.
***

## 6. Tool validation
- Failure mode: a prompt injection tricks the AI into calling tools with unsafe parameters.
- Mitigation: validate every tool call before execution — check permissions, parameters, schemas, and business rules; reject unauthorized requests.
- Pros: prevents unsafe tool execution; blocks invalid API calls.
- Cons: requires validation logic for every tool; adds engineering effort.
***

## 7. Input sanitization
- Failure mode: attackers hide malicious instructions inside user input or external content.
- Mitigation: inspect and normalize incoming content — detect, normalize, or remove suspicious input, and validate the expected input format.
- Pros: blocks many simple attacks; reduces malicious input reaching the model.
- Cons: cannot stop every attack; sophisticated injections may still pass.
***

## Refernces
- https://www.linkedin.com/posts/nk-systemdesign-one_7-ways-to-prevent-prompt-injection-explained-share-7480602311229247488-MKHA/?utm_source=share&utm_medium=member_ios&rcm=ACoAAAtIwEUBArru5MCyINlM3N6qdprHeyov2Cw
***
