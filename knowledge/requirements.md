---
type: Reference
title: Requirements
description: Functional vs non-functional requirements and quality attributes for system design (availability, scalability, durability, security, cost).
tags: [reference, requirements, system-design, nfr]
timestamp: 2026-07-24T00:00:00Z
disclosure: on_demand
---

# Requirements
---

## What is it?
- A curated list of tips about requirements.
---

## Motivation
- Imagine you're in a system design interview, and the interviewer asks you to "design a messaging system." The first thing that might come to your mind is brainstorming a technical solution: Should I use Kafka? Load balancers may help? How many servers do I need?
- Even in real-world software development, requirements aren't always laid out in front of you. Product managers set broad goals, stakeholders have different interests, and users often have trouble describing exactly what they need. Learning how to deal with ambiguity is an essential skill for engineers.
----

## Functional Requirements: What the System Does
- Define the features and capabilities the system must provide.
- Describe user-facing behaviors, business logic, inputs, outputs, and workflows.
---

## Non-Functional Requirements: How the System Behaves
- Define the quality attributes and operational characteristics of the system.
- Specify constraints such as performance, reliability, security, and maintainability.
---

## Availability and Reliability
- **Availability:** How often the system is operational and accessible (e.g., 99.9% uptime).
- **Reliability:** The system's ability to operate correctly without failures over time.
---

## Scalability and Performance
- **Scalability:** Ability to handle increased load by adding resources or distributing work.
- **Performance:** How quickly the system responds, including latency, throughput, and resource efficiency.
---

## Durability and Consistency
- **Durability:** Ensures committed data is not lost, even after crashes or power failures.
- **Consistency:** Ensures data remains accurate and predictable across reads, writes, and replicas.
---

## Maintainability
- Make the system easy to understand, modify, test, and extend over time.
- Reduce operational overhead through good architecture, documentation, and observability.
---

## Security
- Protect systems and data from unauthorized access, misuse, and attacks.
- Cover authentication, authorization, encryption, auditing, and compliance requirements.
---

## Cost Optimization
- Balance performance and reliability with infrastructure and operational costs.
- Design for efficient resource utilization and avoid unnecessary overprovisioning.
---


## References
- https://newsletter.francofernando.com/p/requirements-the-foundation-of-good
---