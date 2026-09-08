---
type: Reference
title: System design
description: Contrastive checklist of architecture choices — storage, caching, load balancing, async processing, CAP, reliability, CDNs, APIs, search, and observability.
tags: [reference, architecture, system-design]
timestamp: 2026-08-29T00:00:00Z
disclosure: on_demand
---

How to use this list? This list serves as a reminder for the architect. It most cosists of contrastive options that mimics the choice each designer needs to take when it comes to define the architecture.

1. Scalable Data Storage
• Relational vs. NoSQL: Know when to use SQL vs. NoSQL databases.
• Partitioning: Vertical and horizontal partitioning (sharding). Understand trade-offs.
• Indexing: Covering indexes, primary vs. secondary indexes.
• Consistency Models: Strong, eventual, causal.

2. Caching
• Client-side vs. Server-side Cache: Understand where caching should happen.
• Caching Strategies: Write-through, write-back, write-around.
• Distributed Cache: Redis, Memcached.
• Cache Eviction Policies: LRU, LFU, etc.

3. Load Balancing
• Horizontal Scaling: Why and how to horizontally scale services.
• Load Balancing Techniques: Round-robin, consistent hashing.
• Reverse Proxy: Understand how to use Nginx, HAProxy.

4. Asynchronous Processing
• Message Brokers: Kafka, RabbitMQ. When to use queues vs. streams.
• Event-Driven Architecture: Benefits of decoupling and event sourcing.
• Task Queues: For delayed jobs or retries.

5. Database Read and Write Scaling
• Read Scaling: Master replication, read replicas.
• Write Scaling: Challenges with partitioning for writes, leader-election.
• CAP Theorem: Consistency, Availability, or Partition tolerance may be compromised.

6. Distributed Systems Concepts
• Consensus Algorithms: Paxos, Raft.
• Conflict Resolution: Last Write Wins, CRDTs, vector clocks for data reconciliation.

𝟳. Reliability and Failover
• Redundancy: Active-passive vs. active-active configurations.
• Health Checks.
• Retries and Circuit Breakers: How to protect systems from cascading failures.

𝟴. CDNs (Content Delivery Networks)
• Static Content Delivery: Why use a CDN, how does it work?
• Caching at the Edge: How CDNs improve latency for end users.

9. API Design and Rate Management
• REST vs. GraphQL: Difference and practical use-cases for each.
• Pagination and Filtering: Strategies for efficiently fetching data.
• API Versioning: Best practices for evolving APIs.
• Throttle Requests: Why rate limiting is essential, algorithms like token bucket, leaky bucket.

10. Search Systems
• Indexing: Building and maintaining indexes for fast search.
• Full-Text Search Engines: ElasticSearch, Azure AI Search.
• Ranking and Relevance: Basic understanding of how scoring works.

11. Monitoring, Observability and Security
• Metrics Collection: Prometheus, Grafana.
• Distributed Tracing: OpenTelemetry, Sentry.
• Centralized Logging.
• Authentication and Authorization: OAuth, JWT.
• Encryption: Data in transit vs. data at rest.
