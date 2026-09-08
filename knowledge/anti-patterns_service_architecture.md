---
type: Reference
title: Service architecture anti-patterns
description: Common microservice architecture anti-patterns (boundaries, chatty calls, shared DB, large payloads) and how to avoid them.
tags: [reference, anti, patterns, service, api, payloads]
timestamp: 2026-07-25T00:00:00Z
---

# Service architecture anti-patterns

---

# What is this file about?

- Seven common microservice architecture anti-patterns and how to avoid them.
- Use when splitting services, drawing boundaries, designing inter-service calls, assigning data ownership, or shaping HTTP/API response size.

---

## Splitting early (premature microservices)

- **What it means:** Breaking a monolith into many services before understanding the business domain.
- **Why it's a problem:**
  - Requirements are still evolving.
  - Service boundaries are based on guesses rather than business capabilities.
  - Refactoring distributed services later is much more expensive than refactoring a monolith.
- **Symptoms:**
  - Many small services with frequent API changes.
  - Teams constantly moving functionality between services.
- **Better approach:**
  - Start with a **modular monolith**.
  - Split services only when business boundaries become clear or scaling needs justify it.
- **Key takeaway:** Delay decomposition until domain knowledge matures, even though the cost of change increases over time.

---

## Wrong boundaries

- **What it means:** Dividing services by technical layers or arbitrary modules instead of business capabilities.
- **Why it's a problem:**
  - A single feature requires changes across multiple services.
  - High coupling between teams.
  - More deployments and coordination.
- **Example:** Separate User, Payment, and Notification services when a checkout feature constantly crosses those boundaries.
- **Better approach:**
  - Design services around **business capabilities** (Domain-Driven Design bounded contexts).
  - Aim for one business capability, one service.
- **Key takeaway:** Good service boundaries minimize cross-service collaboration for a single business feature.

---

## Conway's Law

- **What it means:** System architecture naturally mirrors the communication structure of the organization.
- **Why it's a problem:**
  - Shared ownership often creates shared services that become bottlenecks.
  - Multiple teams changing the same service slows development.
- **Symptoms:**
  - Large shared service owned by everyone.
  - Frequent merge conflicts and coordination meetings.
- **Better approach:**
  - Align teams with service ownership.
  - One team should own one service (or one bounded context).
  - Apply the inverse Conway maneuver by organizing teams around the architecture you want.
- **Key takeaway:** Team structure influences software architecture as much as technical decisions.

---

## Chatty services

- **What it means:** Completing one user intent requires many fine-grained synchronous round trips — either service-to-service hops or client-to-API calls that could have been one aggregate response.
- **Why it's a problem:**
  - Increased latency.
  - More network overhead.
  - Higher chance of cascading failures.
- **Symptoms:**
  - One user request results in dozens of API calls.
  - High p99 latency despite fast individual services.
- **Example (chatty API):** Multiple client round trips for one profile view — bad vs aggregated:

  ```http
  # Bad: multiple round trips
  GET /api/users/123
  GET /api/users/123/orders
  GET /api/users/123/preferences

  # Good: aggregated endpoint
  GET /api/users/123/complete-profile
  ```

- **Better approach:**
  - Return richer responses (or a dedicated aggregate/read-model endpoint).
  - Use asynchronous messaging where appropriate.
  - Cache frequently requested data.
  - Aggregate requests through an API gateway or BFF.
- **Key takeaway:** Fewer, more meaningful service interactions usually outperform many fine-grained calls.
- **Important nuance:** Aggregation fights *chatty* APIs; unbounded aggregates fight *large payloads* (see below). Prefer intentional composition, not “return everything.”

---

## Long call chains

- **What it means:** A request passes through many services sequentially.
- **Why it's a problem:**
  - Latency accumulates with every hop.
  - Availability decreases because every service must succeed.
  - Troubleshooting becomes difficult.
- **Example:** A → B → C → D → E — if each service is 99.9% available, overall availability drops to approximately 99.5%.
- **Symptoms:**
  - Slow end-to-end requests.
  - Cascading failures.
  - Complex distributed tracing.
- **Better approach:**
  - Reduce dependency depth.
  - Use asynchronous workflows.
  - Apply resilience patterns such as timeouts, retries, and circuit breakers.
- **Key takeaway:** Every additional network hop increases both latency and failure probability.

---

## Shared database

- **What it means:** Multiple services directly read and write the same database.
- **Why it's a problem:**
  - Tight coupling.
  - Independent deployments become difficult.
  - Schema changes affect multiple services.
  - No clear ownership of data.
- **Symptoms:**
  - Services modifying each other's tables.
  - Database changes requiring coordination across teams.
- **Better approach:**
  - Each service owns its own database.
  - Share information through APIs or events instead of direct database access.
  - Accept eventual consistency where appropriate.
- **Important nuance:** A shared database is a common transitional architecture and can be pragmatic for small systems or migrations. It is an anti-pattern primarily when the goal is independent, scalable microservices.

---

## Large payloads

- **What it means:** APIs return oversized or unbounded response bodies (full resource graphs, every column, or entire collections) when callers need only a slice of the data.
- **Why it's a problem:**
  - High bandwidth and serialization cost on every hop.
  - Worse latency under load, especially on mobile or WAN clients.
  - Memory pressure on gateways, BFFs, and clients that buffer the full body.
- **Symptoms:**
  - List or detail endpoints that grow without a page size or field set.
  - Clients discarding most of the JSON they receive.
  - Spikes in response size correlated with p99 latency.
- **Better approach:**
  - **Field filtering** — let callers request only needed attributes:
    `GET /api/users?fields=id,name,email`
  - **Pagination** — bound collection size:
    `GET /api/users?page=1&limit=20`
  - **Compression** — negotiate compressed transfer when payloads remain large:
    `Accept-Encoding: gzip, deflate, br`
- **Key takeaway:** Prefer small, intentional payloads; compression helps transfer size, but filtering and pagination fix the root cause of over-fetching.

---

## Common theme

All seven anti-patterns stem from the same underlying issue: **avoid unnecessary coupling.**

- Split services only when there is a clear business need.
- Define boundaries around business capabilities.
- Align team ownership with service ownership.
- Minimize synchronous communication.
- Keep request paths short.
- Ensure each service owns its own data.
- Keep API responses bounded (fields, pages) instead of shipping everything by default.

Following these principles leads to systems that are easier to develop, deploy, scale, and maintain.

---

## References

- [ByteByteGo — Cloud Native Anti-Patterns](https://bytebytego.com/guides/cloud-native-anti-patterns/)
- [ByteByteGo — Is Microservice Architecture the Silver Bullet?](https://bytebytego.com/guides/is-microservice-architecture-the-silver-bullet/)
- [ByteByteGo — Software Architecture](https://bytebytego.com/guides/software-architecture/)
- [Conway's Law is not a warning — it's a prediction you can use to design better systems](https://www.reddit.com/r/softwarearchitecture/comments/1sk7ucw/conways_law_is_not_a_warning_its_a_prediction_you/)
- [Top Service-to-Service Communication Patterns](https://blog.bytebytego.com/p/top-service-to-service-communication)
- [ByteByteGo — Resiliency Patterns](https://bytebytego.com/guides/resiliency-patterns/)
- [Data Sharing Between Microservices](https://blog.bytebytego.com/p/data-sharing-between-microservices)

---
