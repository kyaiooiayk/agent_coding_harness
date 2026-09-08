---
type: Reference
title: API
description: This file is a curated list of best-practices design rule related to APIs.
tags: [reference, api, types]
timestamp: 2026-07-12T00:00:00Z
---

# API
***

## What is this file about?
- This file is a curated list of best-practices design rule related to APIs.
***


## SOAP
- Envelope-based XML protocol for exchanging structured messages; common in enterprise and regulated systems that need strong typing, formal contracts (WSDL), and mature security profiles (WS-Security).
- Trade-offs: Rich standards and tooling for compliance-heavy integrations, but verbose payloads, heavier clients, and slower iteration than JSON-over-HTTP styles.
- Rule of thumb: SOAP when partners or regulators mandate it; prefer REST/gRPC for new greenfield APIs.
***

## REST
- Each URL represents a resource, and you use standard HTTP verbs (GET, POST, PUT, DELETE) to act on it. Simple and universal, but it often requires multiple requests to assemble related data.
- Trade-offs: Easy to learn, cache-friendly, and works with any HTTP client, but tends to over-fetch or under-fetch data, leading to chatty clients and version drift as endpoints proliferate.
- Rule of thumb: REST for public APIs and broad compatibility.
***

## GraphQL
- It was originally developed by Meta Platforms (then Facebook) in 2012 and released publicly in 2015.
- The client sends a query describing exactly the data shape it needs, and the server returns precisely that data through a single endpoint.
- Trade-offs: Eliminates over-fetching and lets frontends evolve independently, but shifts complexity to the server (resolvers, N+1 queries), complicates caching, and makes rate-limiting and query-cost analysis harder.
- Rule of thumb: GraphQL when clients need flexible, aggregated views
```GraphQL
{
  user(id: "1") {
    name
    email
  }
}
```
Response:
```JSON
{
  "data": {
    "user": {
      "name": "Alice",
      "email": "alice@example.com"
    }
  }
}
```
***

## gRPC
- Services communicate via strongly-typed method calls over HTTP/2 using compact binary (protobuf) encoding, making it ideal for fast, low-latency service-to-service communication with built-in streaming support.
- Trade-offs: Excellent performance and strict contracts via protobuf schemas, but the binary format isn't human-readable, browser support requires a proxy (gRPC-Web), and debugging is harder than with plain JSON over HTTP.
- Rule of thumb: gRPC for internal microservices where latency and throughput matter most.
***

## WebSockets
- Persistent full-duplex connection over a single TCP socket (usually upgraded from HTTP); both sides push messages without a new request per update.
- Trade-offs: Low-latency bidirectional streams for chat, live UIs, and collaborative apps, but connection lifecycle, fan-out, and reconnect/backpressure are harder to operate than request/response APIs.
- Rule of thumb: WebSockets when the client must receive continuous server push on an open session (not one-shot request/response).
***

## Webhooks
- Provider calls a subscriber HTTP endpoint when an event occurs (push notification of state change), instead of the subscriber polling.
- Trade-offs: Simple event-driven integration and near-real-time reactions, but delivery reliability (retries, idempotency, signature verification) and endpoint availability become the subscriber’s operational burden.
- Rule of thumb: Webhooks when another system should react to your events asynchronously without holding an open connection.
***

## API Exposure Types
- Public APIs
  - Open to external developers
  - Used for ecosystem growth
  - Usually authenticated
- Private APIs
  - Internal organizational use
  - Connect internal services and systems
  - Not publicly exposed
- Partner APIs
  - Shared with selected business partners
  - Controlled access
  - Common in B2B integrations
***

## How to map this AWS behaviour also locally?
- How do I mirror Public / Private / Partner APIs locally without AWS?
- The answer is: you don’t replicate AWS networking — you simulate the same boundaries using Docker networking + a local gateway layer.


| API Type        | Cloud (AWS)                     | Local (Docker Compose)                                | How you “copy” it locally                                                    |
| --------------- | ------------------------------- | ----------------------------------------------------- | ---------------------------------------------------------------------------- |
| **Public API**  | ALB (internet-facing)           | `localhost:8000` via gateway service                  | Expose a single “gateway” container (like Nginx or FastAPI BFF) on localhost |
| **Private API** | VPC-only ECS services           | Docker Compose internal network (`service_name:port`) | Services talk via container DNS names (no ports exposed to host)             |
| **Partner API** | ALB `/partner/*` or API Gateway | Separate route in local gateway (e.g. `/partner/*`)   | Add middleware in gateway that enforces API key checks                       |

- Simple mental model
- In Local
  - One building
  - All rooms connected via hallway (Docker network)
  - One front door (gateway service)
- In AWS
  - Same building
  - Hallway replaced by VPC networking
  - Front door becomes ALB

***

## Backend publication contract for Public vs Private
- Best practice: the backend must publish API visibility and authorization metadata per endpoint.
- Frontend should only render those metadata values. It must not infer security rules from tabs, route prefixes, or service names.

### Endpoint metadata fields to publish
- `exposure`: `public` or `private`
- `access_via`: `gateway` or `internal`
- `auth_mode`: `public`, `user_token`, `service_token`, or `admin_only`
- `auth_required`: boolean
- `allowed_roles`: list of roles when user-token auth applies
- `owner_service`: service that owns the endpoint
- `source`: `routes` or `openapi_fallback`

### Separation of concerns
- Exposure and authorization are separate dimensions.
- `public` does not mean no auth.
- `private` means network-private first; if a private endpoint is proxied through developer tooling, backend role checks are still required.

### Fail-safe defaults
- Missing metadata must default to secure values:
  - `exposure=private`
  - `access_via=internal`
  - `auth_mode=service_token`
  - `auth_required=true`
- Invalid enum values should fail the publisher path explicitly instead of silently downgrading policy.

### Service port semantics in observability UI
- `port` means host-published port from Docker bindings (for example `localhost:8000`).
- `internal_port` means container-only port on the Docker network (for example `http://analytics:8008`).
- If a service does not publish host bindings, UI should show internal port explicitly (for example `internal 8008`) instead of implying public host access.
- A service may show no port when neither host binding nor container port metadata is present.
  - Typical cause: host mapping removed in compose and container image does not declare an exposed port.
  - Required fix: declare the service container port in image metadata so observability can resolve `internal_port`.


***

## References
- [Guide to API-first](https://www.postman.com/api-first/)
***
