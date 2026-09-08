---
type: Reference
title: Observability
description: ---
tags: [reference, observability]
timestamp: 2026-07-12T00:00:00Z
---

# Observability

---

# What is this file about?

- This file is a curated list of best-practices for observability.

---

## One event three views

- An event is a single thing that happens in your system at a specific point in time.
- Logs, metrics, and traces are three ways of looking at this same event.

---

## Logs

- A log captures the event as a detailed record.
- Logs are useful when you need the full context of a specific event.
- Question answered: What happened?

Example:

```json
{
  "service": "payments",
  "endpoint": "/checkout",
  "user_id": 4127,
  "status": 500,
  "latency_ms": 380
}
```

---

## Metrics

- Instead of storing every detail, metrics summarize events as numbers.
- A metric counts or aggregates many events
- Metrics are useful for spotting trends and triggering alerts.
- Question answered: How frequently is this happening, and is it getting worse?

---

## Traces:

- A trace records how the event moved through the system.
- The trace shows the path taken by the request and how much time was spent in each step.
- Question answered: Where in the system did the problem occur?

Example:

```
API Gateway
    ↓
Auth Service
    ↓
Payment Service
    ↓
Database
```

---

## Cardinality explosion

- Metrics combine labels (e.g., `status_code`, `endpoint`, `region`) to create separate time series for every unique combination.
- As more dimensions are added—especially high-cardinality ones like `user_id`—the number of time series grows exponentially (millions or billions).
- This leads to high storage costs, slower queries, and memory strain, so high-cardinality fields should be avoided in metrics and instead used in logs or traces.

---

## **Correlation ID Journey**

- In distributed systems, a single request passes through multiple services (API gateway → auth → payment → database).
- A shared `trace_id` (correlation ID) is attached to the request and propagated across all services.
- This allows engineers to connect logs, metrics, and traces from different services into one end-to-end view of the same request.

---

## **Head Sampling vs Tail Sampling**

- Head sampling decides whether to keep a trace **before** the request runs; tail sampling decides **after** the request completes.
- Head sampling is cheaper and simpler but may miss slow or failed requests since it doesn’t know the outcome.
- Tail sampling is more expensive and complex but retains the most valuable traces (errors, latency spikes), giving better debugging insight.

---

## **Symptom vs Cause Alerting**

- Symptom alerting focuses on user-facing issues (e.g., “checkout latency > 1s”), while cause alerting focuses on internal components (e.g., database slowdown).
- A single symptom can have many possible causes (DB, cache, network, retries), so cause-based alerts often miss real user impact.
- Best practice: alert on symptoms first, then use metrics, traces, and logs to identify the underlying cause.

---

## References

- [Observability for Beginners: Logs, Metrics, Traces, and Everything Around Them](https://blog.bytebytego.com/p/observability-for-beginners-logs?img=https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fefd64dd9-b0a6-4fc8-8e27-2a929a3b5eef_2650x3068.png&open=false)

---

