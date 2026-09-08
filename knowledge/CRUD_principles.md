---
type: Reference
title: CRUD
description: CRUD stands for Create, Read, Update, Delete — the four basic operations on persistent resources.
tags: [reference, crud, principles]
timestamp: 2026-07-12T00:00:00Z
---

# CRUD
***

## What is it?
- CRUD stands for **Create**, **Read**, **Update**, **Delete** — the four basic operations on persistent resources.
- In HTTP APIs, each operation maps to a verb and URL pattern on a **noun** (the resource): collection (`/sessions`) or instance (`/sessions/{id}`).
- CRUD is the default shape for REST-style resource APIs; it keeps contracts predictable for clients, tests, and parallel development.
***

## HTTP mapping

| Operation | Typical verb | URL | Semantics |
|---|---|---|---|
| Create | `POST` | collection (`/resources`) | Server assigns id unless contract says otherwise |
| Read (one) | `GET` | instance (`/resources/{id}`) | Returns resource or 404 |
| Read (many) | `GET` | collection (`/resources`) | List/filter; pagination when large |
| Update (full) | `PUT` | instance (`/resources/{id}`) | Replace; id in path must match body if present |
| Update (partial) | `PATCH` | instance (`/resources/{id}`) | Merge fields; missing fields unchanged |
| Delete | `DELETE` | instance (`/resources/{id}`) | Remove; 404 if already gone (unless contract says idempotent no-op) |

Pick one update style per resource (`PUT` vs `PATCH`) and document it in the service README.
***

## Why it matters
- Gives every resource a clear lifecycle: born (create), observed (read), changed (update), removed (delete).
- One owner per resource type enforces consistency — callers do not reach around the owning service to mutate its store.
- Aligns with API-first: define create/read/update/delete contracts before UI or internal callers depend on them.
***

## Rules of thumb
- **Explicit id on write** — caller supplies id on update/delete → lookup must exist; missing → hard 404, not silent create or fallback.
- **Create semantics** — auto-create only when the endpoint contract declares create and the id is omitted; never resurrect hard-deleted resources without an audited restore flow.
- **Single writer** — the owning microservice enforces invariants on create/update/delete; other services call its API, not its database.
- **Idempotency** — `DELETE` and `PUT` are often idempotent; `POST` usually is not unless the contract documents idempotency keys.
- **Derived state** — do not fix inconsistent stores on `GET`; keep create/update/delete paths correct so reads stay honest.
***

## How it relates to SOLID and DRY
- **SOLID** — one service/module owns one resource's CRUD; extend via new types or adapters, not giant switch statements.
- **DRY** — shared validation, serialization, and error shapes live once (e.g. `shared_packages/`), not duplicated per route.
- **API-first** — CRUD routes and schemas are the contract; implementation and UI follow.
***

## References
- [REST — Wikipedia](https://en.wikipedia.org/wiki/REST)
- [HTTP request methods — MDN](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Methods)
***
