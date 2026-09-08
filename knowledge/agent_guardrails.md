---
type: Reference
title: Agent guardrails
description: Five-stage request pipeline for agent systems — input screening, context verification, response generation, output validation, and operational controls.
tags: [reference, agent, guardrails, pipeline]
timestamp: 2026-08-17T00:00:00Z
disclosure: on_demand
---

# Agent guardrails
***

# What is this file about?
- A layered **request lifecycle** for agent systems: screen input, verify context, generate over that context only, validate output, then apply operational controls.
- This is the **pipeline shape** (when each check runs). For the seven **security patterns** (least privilege, prompt isolation, tool validation, …), see [Agent security guardrails](/knowledge/agent_security_guardrails.md) — do not merge the two files.
***

## 1. Input screening
- Purpose: stop unsafe or out-of-policy user text before it reaches the model.
- Checks: prompt-injection signals, sensitive-data leaks in the request, and off-scope topics.
- Failure behaviour: return a fixed fallback message; do not call the LLM.
***

## 2. Context verification
- Purpose: ensure retrieval / memory / tool results attached to the turn are allowed and trustworthy before generation.
- Checks: source allowlists, ACL / tenancy on retrieved chunks, freshness or provenance where required, and stripping or quarantining untrusted instructions inside retrieved content.
- Failure behaviour: drop or replace bad context, or fall back without that context — never silently treat unverified material as trusted system instructions.
***

## 3. Response generation
- Purpose: the LLM reasons only over **verified** context plus trusted system prompts.
- Checks: the generation step itself does not re-open raw unscreened user text or unverified retrieval as elevated instructions.
- Failure behaviour: empty or truncated generation is handled by the next stage (output validation), not by inventing context.
***

## 4. Output validation
- Purpose: every candidate reply is checked before it leaves the system.
- Checks: groundedness against verified context, required format / schema, and safety / policy classifiers.
- Failure behaviour: retry generation up to two times with the same constraints; after that, return a safe fallback.
***

## 5. Operational controls
- Purpose: a final layer for cost, risk, and accountability after (or around) the answer path.
- Checks: rate and budget limits, structured logging of every call, and routing of low-confidence or high-risk actions to humans.
- Failure behaviour: hard-stop when limits are exceeded; do not ship the action or reply when escalation is required.
***

## Related
- [Agent security guardrails](/knowledge/agent_security_guardrails.md) — pattern catalogue (failure mode → mitigation → trade-offs), not this pipeline.
- [Agent harness](/knowledge/agent_harness.md) — runtime loop, tools, sandbox, and budget caps that host these stages.
***

## References
- https://www.linkedin.com/posts/alexxubyte_systemdesign-coding-interviewtips-activity-7492606950233255936-XLz6?utm_source=share&utm_medium=member_desktop&rcm=ACoAAAtIwEUBArru5MCyINlM3N6qdprHeyov2Cw
***
