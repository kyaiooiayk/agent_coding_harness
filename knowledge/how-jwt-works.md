---
type: Reference
title: How JWT (JSON Web Token) Works
description: JWT (JSON Web Token) is a mechanism for securely transferring information between a client and a server.
tags: [reference, how, jwt, works]
timestamp: 2026-07-12T00:00:00Z
---

# How JWT (JSON Web Token) Works

## Overview

JWT (JSON Web Token) is a mechanism for securely transferring information between a client and a server.

It is commonly used for:

- Authentication
- Authorization
- Stateless API security
- Communication between distributed services

The main idea:

> Instead of storing user session information on the server, the server gives the client a signed token containing identity information. The client sends this token with future requests, and the server verifies it.

JWT allows servers to remain stateless because the server does not need to store session data for every user.

---

# The Problem JWT Solves

## HTTP Is Stateless

HTTP requests do not remember previous interactions.

Example:

```

Request 1:
User logs in

Request 2:
User requests profile data

```

The server does not automatically know:

- Who the user is
- Whether they already logged in
- What permissions they have

The application needs a way to maintain identity across requests.

---

# Traditional Session-Based Authentication

A common approach is server-side sessions.

## Flow

```

User
|
| username + password
|
v

Server

Creates session

|
|
v

Session Database

```

The server stores:

```

Session ID -> User information

```

The client receives:

```

session_id=abc123

```

For every request:

```

Client
|
| session_id
|
v

Server

Looks up session database

```

---

# Problems With Sessions at Scale

## Problem 1: Multiple Servers

Imagine the application grows.

Architecture:

```

```

```
      Load Balancer

      /        \
     /          \

Server A      Server B
```

```

```

A user may:

1. Login on Server A
2. Later send requests to Server B

Server B does not know the user's session.

---

# Solution: Shared Session Store

The servers can share session information.

Example:

```

```

```
  Load Balancer

  /          \
```

 Server A     Server B

```
  \          /

  Session Database
```

```

```

This works, but introduces:

- Additional infrastructure
- Database dependency
- Session synchronization problems
- Potential single point of failure

JWT solves this by moving session information to the client.

---

# Authentication vs Authorization

These concepts are different.

## Authentication

Answers:

> Who are you?

Example:

```

Username + Password

↓

User identity verified

```

---

## Authorization

Answers:

> What are you allowed to access?

Example:

```

User:

Can access:

* Profile

Cannot access:

* Admin dashboard

```

JWT is commonly used after authentication to provide authorization information.

---

# What Is JWT?

JWT stands for:

```

JSON Web Token

```

A JWT is a digitally signed token containing claims.

A token looks like:

```

xxxxx.yyyyy.zzzzz

```

It contains three sections:

```

Header.Payload.Signature

```

---

# JWT Structure

## 1. Header

The header describes the token.

Example:

```json
{
  "alg": "HS256",
  "typ": "JWT"
}
```

Contains:

- Token type
- Signing algorithm

Examples:

```
HS256
RS256
```

---

# 2. Payload

The payload contains claims.

Example:

```json
{
  "userId": 123,
  "role": "admin",
  "exp": 1710000000
}
```

Claims can contain:

- User ID
- Roles
- Permissions
- Expiration time
- Metadata

Important:

The payload is encoded, not encrypted.

Anyone holding the JWT can decode it.

Do not store secrets inside JWT payloads.

---

# 3. Signature

The signature proves the token has not been modified.

Conceptually:

```
signature =
hash(
    header +
    payload +
    secret key
)
```

Example:

```
Header.Payload.Signature
```

The server creates the signature using a secret key.

Later, when receiving the JWT, the server recreates the signature.

If the signatures match:

```
Token is valid
```

If they differ:

```
Token was modified
```

---

# JWT Authentication Flow

## Step 1: User Login

The user sends credentials.

Example:

```
POST /login

{
  "username": "alice",
  "password": "password123"
}
```

---

## Step 2: Server Verifies User

The server checks:

- Username
- Password
- Account status

---

## Step 3: Server Creates JWT

The server generates:

```
Header

+

Payload

+

Signature
```

Example:

```json
{
  "userId":123,
  "role":"user",
  "exp":1710000000
}
```

---

## Step 4: Server Sends Token

Response:

```json
{
  "token":
  "eyJhbGciOiJIUzI1..."
}
```

The client stores the token.

Common storage:

- HTTP-only cookies
- Secure browser storage

---

## Step 5: Client Sends JWT With Requests

Future requests include:

```
Authorization: Bearer <token>
```

Example:

```
GET /profile

Authorization:
Bearer eyJhbGciOiJIUzI1...
```

---

## Step 6: Server Validates JWT

The server checks:

1. Token format
2. Signature
3. Expiration time
4. Permissions

If valid:

```
Allow request
```

If invalid:

```
Reject request
```

---

# JWT Makes Servers Stateless

Traditional sessions:

```
Server

+
Session Database

+
Session ID
```

JWT:

```
Client

+
JWT Token

+
Server Verification
```

The server does not need to remember every user's session.

---

# JWT in Distributed Systems

JWT works well in microservice architectures.

Example:

```
              User

               |
               |
              JWT

               |
     --------------------

     API Gateway

        |
 ---------------------

 Service A

 Service B

 Service C
```

Each service can independently verify the token.

Benefits:

- No shared session database
- Easier horizontal scaling
- Better service independence

---

# JWT Security Considerations

## 1. Always Use HTTPS

JWTs are credentials.

If stolen:

```
Attacker
   |
   |
 Uses stolen JWT
   |
   v
 Server
```

HTTPS prevents network interception.

---

# 2. Set Token Expiration

JWTs should expire.

Example:

```json
{
  "exp":1710000000
}
```

Short expiration reduces damage from stolen tokens.

---

# 3. Use Minimum Permissions

Avoid putting excessive permissions inside tokens.

Bad:

```json
{
  "role":"super_admin"
}
```

Better:

```json
{
  "role":"user"
}
```

Follow the principle:

```
Minimum required access
```

---

# 4. Token Revocation Problem

A major JWT limitation:

Once issued, a JWT is valid until expiration.

Example:

```
User logs out

JWT still exists

JWT remains valid
```

Possible solutions:

- Short expiration times
- Token deny lists
- Refresh tokens
- Server-side validation for sensitive operations

---

# JWT vs Session Authentication


| Feature         | JWT        | Session      |
| --------------- | ---------- | ------------ |
| Server storage  | No         | Yes          |
| Scaling         | Easier     | More complex |
| Revocation      | Harder     | Easier       |
| Token size      | Larger     | Smaller      |
| Database lookup | Usually no | Usually yes  |
| Stateless       | Yes        | No           |


---

# JWT Mental Model

Think of JWT as a building access badge.

Traditional session:

```
Security desk keeps a list:

Badge 123 → Alice
Badge 456 → Bob
```

JWT:

```
Badge contains:

Alice
Permissions
Expiration

+
Security signature
```

The security guard checks the badge itself.

No need to call the database every time.

---

# Key Concepts Summary


| Concept        | Meaning                  |
| -------------- | ------------------------ |
| JWT            | Signed JSON token        |
| Header         | Token metadata           |
| Payload        | Claims/data              |
| Signature      | Integrity verification   |
| Authentication | Proving identity         |
| Authorization  | Checking permissions     |
| Stateless      | Server stores no session |
| Claims         | Information inside token |
| Expiration     | Token lifetime           |


---

# Final Understanding

JWT works by replacing server-side session storage with a signed token.

The complete flow:

```
User Login

↓

Server verifies identity

↓

Server creates JWT

↓

Client stores JWT

↓

Client sends JWT with requests

↓

Server verifies signature

↓

Access granted
```

JWT is popular because it makes authentication easier to scale across distributed systems and microservices.

However, JWT is not automatically secure. Proper handling requires:

- HTTPS
- Short expiration times
- Secure storage
- Correct permission design

```

This version is optimized for an agent because it preserves:
- definitions
- relationships
- workflows
- architecture diagrams
- security trade-offs
- terminology mappings

## References
- https://newsletter.systemdesign.one/p/how-jwt-works?utm_source=chatgpt.com "How JWT Works ✨ - by Neo Kim - The System Design Newsletter"
***
```

