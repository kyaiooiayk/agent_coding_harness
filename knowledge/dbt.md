---
type: Reference
title: dbt (data build tool)
description: Beginner reading path for dbt (the T in ELT) and how it fits common store shapes (Postgres sources vs Neo4j, Redis, object storage).
tags: [reference, dbt, elt, analytics, data]
timestamp: 2026-07-17T00:00:00Z
disclosure: on_demand
---

# dbt (data build tool)

Portable primer for analytics engineers and agents. Project operator runbook
(Make targets, CI, mart schema — when present): [/docs/dbt.md](/docs/dbt.md). Related pattern:
[/knowledge/medallion_architecture_etl.md](/knowledge/medallion_architecture_etl.md).

## What dbt is

**dbt is the “T” (Transform) in ELT** — data is loaded into a warehouse (or
warehouse-shaped database) first, then dbt transforms it with SQL. It is closer
to **software engineering for analytics** than to a generic ETL GUI: models,
materializations, dependency graphs, tests, docs, and Git workflows.

If you already know application programming, a useful analogy is: **dbt is a
framework for maintainable data-transformation code, where SQL is the language.**

## Suggested reading order

1. **Beginner-friendly:** [dbt explained — dbt Labs](https://www.getdbt.com/blog/dbt-explained)
   (about 20–30 minutes). Companies have messy data; they need consistent,
   trusted datasets; dbt helps teams build and maintain those datasets with
   SQL models, tests, documentation, and version control.
2. **Architecture depth:** [What, exactly, is dbt? — dbt Labs](https://www.getdbt.com/blog/what-exactly-is-dbt).
   Why teams moved from ETL toward ELT, where dbt sits in a stack, and concepts
   such as models, materializations, and dependencies.
3. **Hands-on:** [What is dbt? A Hands-On Introduction for Data Engineers — DataCamp](https://www.datacamp.com/tutorial/what-is-dbt).
   Project structure, models, SQL transforms, warehouse workflows, common patterns.

Mental model:

> SQL creates the transformation. dbt makes that SQL behave like a professional
> software project — with tests, documentation, dependencies, and deployment
> workflows.

Tiny practice path:

```text
CSV / operational tables
   ↓
Postgres (or BigQuery / Snowflake)
   ↓
dbt models
   ↓
Customer / product analytics table
   ↓
Dashboard
```

## Example store matrix (how dbt fits) — fill for your app

| Store | dbt treatment | Rationale |
|---|---|---|
| `<SQL warehouse / OLTP DB>` — schemas `<list your schemas>` | **Sources + staging + marts** in `dbt/` (when used) | Relational, stable, queryable; natural dbt sources |
| `<analytics mart schema>` | **dbt materialization target only** | dbt owns objects inside; not an OLTP write path |
| `<graph store>` (e.g. Neo4j) | Inventory only — not a dbt source | Graph engine, not SQL warehouse-shaped |
| `<cache / streams>` (e.g. Redis) | Inventory only — not a dbt source | Ephemeral; warehouse/DB remains source of truth |
| `<object storage>` (e.g. S3) | Inventory only — not a dbt source | Object blobs, not tabular relations |
| Terraform remote state | Not product data | Infra control plane, not analytics |

**Invariant:** dbt is an **interpretation layer**. Runtime services must not read
analytics marts for product behaviour unless `docs/` explicitly allows it.
See `<describe your data invariants docs here>` and [/docs/dbt.md](/docs/dbt.md) when present.

## When agents should open this file

Open when adding or reviewing dbt models, discussing ELT/medallion layering for
`<describe your app here>`, or deciding whether a store belongs in `sources.yml`. For Make/CI
commands, prefer [/docs/dbt.md](/docs/dbt.md) when present.
