---
type: Reference
title: Architecture
description: API Gateway is concern with authentication & authorization, Rate limiting, throttling
tags: [reference, architecture]
timestamp: 2026-07-12T00:00:00Z
---

# Architecture
***

# The Path of a Request: A Tour of Modern Web Architecture

| Layer              | What Problem It Solves                           | Restaurant Analogy                       | AWS Service                                           |
| ------------------ | ------------------------------------------------ | ---------------------------------------- | ----------------------------------------------------- |
| **Browser**        | User interface that sends requests               | Customer placing an order                | **None** (user's Chrome, Safari, Firefox, etc.)       |
| **DNS**            | Finds the server's IP address                    | Looking up the restaurant address        | Amazon Route 53                                       |
| **CDN**            | Delivers content from a nearby location          | Pre-made drinks/snacks near the entrance | Amazon CloudFront                                     |
| **Load Balancer**  | Distributes traffic across servers               | Host assigning customers to tables       | Elastic Load Balancing (ALB/NLB)                      |
| **API Gateway**    | Central entry point for APIs                     | Reception desk taking and routing orders | Amazon API Gateway                                    |
| **Authentication** | Verifies user identity                           | Showing membership card or reservation   | Amazon Cognito                                        |
| **Service Mesh**   | Manages service-to-service communication         | Managers coordinating kitchen staff      | AWS App Mesh                                          |
| **Sidecar**        | Handles networking, retries, mTLS, observability | Assistant working beside each chef       | **None** (typically Envoy sidecar running in ECS/EKS) |
| **Microservice**   | Implements business logic                        | Specialized kitchen station              | AWS Lambda, Amazon ECS, or Amazon EKS                 |
| **Cache**          | Speeds up data retrieval                         | Ready-made dishes waiting to serve       | Amazon ElastiCache                                    |
| **Database**       | Permanent data storage                           | Pantry, refrigerator, recipe books       | Amazon RDS, Amazon DynamoDB                           |
***


## API Gateway vs. BFF
- API Gateway is concern with authentication & authorization, Rate limiting, throttling
- BFF: Adapts backend APIs to UI needs
- They can be combined, and adopting one does not prevent using the other.
***

## References
- [The Path of a Request: A Tour of Modern Web Architecture
](https://blog.bytebytego.com/p/the-path-of-a-request-a-tour-of-modern?img=https%3A%2F%2Fsubstack-post-media.s3.amazonaws.com%2Fpublic%2Fimages%2Fd486fdf8-79de-429b-b453-67a3af15caed_2250x2624.png&open=false)
***