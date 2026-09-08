---
type: Reference
title: Backends For Frontends (BFF)
description: This file is a curated list of best-practices design rule related to Backends For Frontends.
tags: [reference, bff]
timestamp: 2026-07-12T00:00:00Z
---

# Backends For Frontends (BFF)
***

# What is this file about?
- This file is a curated list of best-practices design rule related to Backends For Frontends.
***

## Motivation
- Your mobile app needs small, fast payloads. Your desktop website wants rich, nested data. Your IoT device sends telemetry every second. Forcing all three to use the same API guarantees a bad experience for everyone. The Backend for Frontend (BFF) pattern solves this by creating purpose-built APIs for each client type — a mobile BFF, a web BFF, an IoT BFF — each optimised for its specific consumer. 
- The goal of BFF is not to remove decisions, but to move them from business logic into a controlled, replaceable presentation layer.
***

## BFF and API Gateway: How They Work Together
- In most real systems, an API gateway sits in front of your BFFs. The gateway handles cross-cutting infrastructure concerns — authentication checks, rate limiting, request routing, and observability — and then routes requests to the appropriate BFF.
- The gateway does not contain business logic. The BFF does. The gateway is infrastructure. The BFF is application.
***

## BFF and GraphQL: A Layered Decision
- GraphQL and BFF are not competing patterns; they solve different problems at different layers.
- GraphQL defines how clients query data. BFF defines where client-specific orchestration and control live. A BFF can expose GraphQL, REST, or gRPC to its client, and independently choose how it talks to downstream services. The protocol is an implementation detail. The boundary is the design decision.
***

## When to use which option?
- IoT = minimal bandwidth
- Mobile = battery-friendly + compact
- Web = full fidelity
***

## Investigation conclusion
- We are monetarely parking this for now. The reason for this is that for each api we need to decide which capability we need to expose and this could potentially mean 3 paths for each api. Of course I could in theory allow all for simplicity but I am parking this for now.
- As an action we can take now to prepare the work for the future, we can start to introduce in the session_id the client_device which could be mobile, web or iot.

## References
- [Millions of Requests Per Hour: SoundCloud’s Microservices Evolution](https://blog.bytebytego.com/p/millions-of-requests-per-hour-soundclouds?utm_source=publication-search)
- [Backend for Frontend (BFF) Pattern Explained: Architecture, Benefits, Trade-offs, and When to Use It](https://stackandsystem.com/series/microservices/backend-for-frontend-pattern)
***