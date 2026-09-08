---
type: Reference
title: What is this?
description: 1. Context 2. Container 3. Component 4. Code
tags: [reference, model, software, diagram]
timestamp: 2026-07-12T00:00:00Z
---

The **C4 Model** is a simple way to **draw and explain software architecture**.

**Agents:** project-specific C4 scoping gates (when present) live in `docs/c4_scoping.md`. This file is the general reference.

## What is this?
1. **Context**
2. **Container**
3. **Component**
4. **Code**
- The idea is that different audiences need different levels of detail.
- Describe the system at progressively deeper levels—Context → Container → Component → Code—using simple diagrams rather than one huge architecture chart.
***

## Mental model
* what the system does (Context)
* what applications exist (Container)
* where new functionality belongs (Component)
* what code to modify (Code)
***

## 1. Context Diagram (big picture)

Shows:

* Your system
* The people who use it
* Other systems it interacts with

Example: Online Shop

```text
Customer
    |
    v
Online Shop System
    |
    +---- Payment Provider
    |
    +---- Email Service
```

This is for:

* managers
* stakeholders
* new team members

It answers:

> "What is this system and what does it talk to?"

---

## 2. Container Diagram

A "container" is an application or data store, not necessarily Docker.

Examples:

* Web application
* API
* Database
* Mobile app

Example:

```text
Customer
    |
    v
Web App
    |
    v
REST API
    |
    +---- PostgreSQL
    |
    +---- Redis
```

This answers:

> "What are the major pieces of the system?"

For many projects, this is the most useful diagram.

---

## 3. Component Diagram

Now zoom into one container.

Suppose we zoom into the API:

```text
REST API
 |
 +-- Auth Component
 |
 +-- Product Component
 |
 +-- Order Component
 |
 +-- Payment Component
```

This answers:

> "How is this application internally organised?"

Useful for developers.

---

## 4. Code Diagram

The most detailed level.

Example:

```text
OrderService
    |
    +-- OrderRepository
    |
    +-- PaymentGateway
```

Or actual class diagrams.

Many teams skip this level because the code itself often serves as the source of truth.
***