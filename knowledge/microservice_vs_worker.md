---
type: Reference
title: Microservices (architecture style)
description: A microservice is a *small, independently deployable application* that:
tags: [reference, microservice, worker]
timestamp: 2026-07-12T00:00:00Z
---

At a high level, **microservices** and **workers** are both ways of splitting up a system, but they exist at different *levels of architecture and responsibility*.

---

## Microservices (architecture style)

A **microservice** is a *small, independently deployable application* that:

* Owns a specific **business capability** (e.g., payments, user profiles, notifications)
* Exposes an **API** (HTTP/gRPC/etc.)
* Has its own **data and logic**
* Can be **deployed and scaled independently**
* Often part of a larger system of many services

### Key idea:

> Microservices are about **how you structure a system into business-focused components**

### Example:

* `user-service` → manages users
* `order-service` → handles orders
* `billing-service` → processes payments

Each runs as its own service and communicates with others via APIs or events.

---

## Worker (role / component pattern)

A **worker** is typically a *process or service that does background jobs*. It:

* Consumes tasks from a **queue** (e.g., Redis, RabbitMQ, SQS)
* Performs **asynchronous work**
* Usually does **not expose an external API**
* Often stateless and horizontally scalable

### Key idea:

> Workers are about **how work is executed (usually asynchronously)**

### Example tasks:

* Sending emails
* Processing images
* Generating PDFs
* Handling video encoding
* Running scheduled jobs

A worker might do something like:

> “Take job from queue → process it → store result → exit”

---

## Core difference

| Aspect            | Microservice                      | Worker                                   |
| ----------------- | --------------------------------- | ---------------------------------------- |
| Purpose           | Business capability               | Background task execution                |
| Interface         | Usually API (HTTP/gRPC/events)    | Usually queue-based (consumes jobs)      |
| Interaction style | Request/response or event-driven  | Asynchronous job processing              |
| Deployment        | Independent service               | Often part of a service or separate pool |
| State             | May own database and domain logic | Usually stateless                        |
| Visibility        | External-facing or internal API   | Internal-only                            |

---

## Relationship between them

They are not mutually exclusive.

A **microservice can have workers**.

Example:

* `notification-service` (microservice)

  * API: “send notification”
  * Worker: actually sends emails/SMS from a queue

So:

* Microservice = *boundary of a domain/system component*
* Worker = *execution model inside or across services*

---

## Simple mental model

* **Microservice = “what the system does”**
* **Worker = “how some of the work gets done in the background”**

---

If you want, I can also explain how this compares to monoliths with background jobs, or where “event-driven services” fit in (that’s where it gets interesting).
