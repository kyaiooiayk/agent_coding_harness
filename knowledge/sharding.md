---
type: Reference
title: Sharding
description: A curated list of tips about sharding.
tags: [reference, sharding]
timestamp: 2026-07-12T00:00:00Z
---

# Sharding
***

## What is it?
- A curated list of tips about sharding.
***

## What is shard?
***

## It is a tradeoff
- A shard is an unit at which we want to trade off between locality and distribution.
- You have to balance Semantic coherence (meaning) vs. Operational efficiency (scaling, indexing, speed)
***

## Rule of thumb to chose
- What is the smallest unit that still preserves meaning? So “semantic (meaning) shard” is not fixed — it’s task-dependent.
- This means whenever the answe is "it depends" then we are in a position where we are in need to build a dynamc system.
- Shard at the level where you stop needing cross-references most of the time.
***

## Structure-aware splitting
- We can split where structure already implies meaning boundaries:
    - Markdown headers
    - HTML tags
    - code blocks
    - PDF structure (when available)
***
