---
type: Reference
title: Deployment strategies
description: Description: Shut down the old version, deploy the new version everywhere, then bring the system back online.
tags: [reference, deployment, strategy]
timestamp: 2026-07-12T00:00:00Z
---

# Deployment strategies
***

## Big-Bang Deployment
- Description: Shut down the old version, deploy the new version everywhere, then bring the system back online.
- Why choose it? Simplicity and low cost when downtime is acceptable.
***

## Rolling Deployment
- Description: Gradually replace old instances with new ones while the application continues serving traffic.
- Why choose it? Near-zero downtime without requiring duplicate infrastructure, making it the default choice for many web services and Kubernetes deployments.
***

## Blue-Green Deployment
- Description: Maintain two identical environments and switch all traffic from the old environment to the new one when ready.
- Why choose it? Instant rollback and safer major releases where availability is critical.
***

## Canary Deployment
- Description: Route a small percentage of users to the new version first, then gradually increase traffic if metrics remain healthy.
- Why choose it? Detect production issues early while limiting the impact to a small subset of users.
***

## Feature Flags
- Description: Deploy new code to production but keep it disabled until a configuration flag enables it.
- Why choose it? Separate deployment from release, enabling instant rollbacks, A/B testing, and gradual feature exposure.
***

## Dark Launch (Shadow Deployment)
- Description: Send real production traffic to new code in parallel while users continue receiving responses from the existing system.
- Why choose it? Validate performance and correctness under real-world load without affecting users.
***

## Rule of Thumb
- Small app, downtime acceptable → Big-Bang
- Most web services → Rolling
- Need fastest rollback → Blue-Green
- High-traffic production systems → Canary
- Feature experimentation → Feature Flags
- Major rewrites or ML/model migrations → Dark Launch
***

## References
 -[Deployment strategies](https://blog.bytebytego.com/p/must-know-deployment-strategies-from?img=https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2F5e15c3c2-bc34-4a4a-a698-0372c5c9f238_2484x3068.png&open=false)
 ***