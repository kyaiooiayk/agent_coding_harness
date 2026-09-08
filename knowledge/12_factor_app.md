---
type: Reference
title: 12-Factor App
description: The “12-Factor App” is a set of best practices for building modern, scalable, cloud-native applications. It was created by engineers at Heroku and is widely used as a guideline for designing...
tags: [reference, factor, app]
timestamp: 2026-07-12T00:00:00Z
---

# 12-Factor App
***

## What is it?
- The “12-Factor App” is a set of **best practices for building modern, scalable, cloud-native applications**. It was created by engineers at Heroku and is widely used as a guideline for designing backend services (especially SaaS apps) that run reliably in cloud environments.

The idea is: instead of building apps that depend on a specific server setup, you design them to be **portable, scalable, and easy to deploy anywhere**.

Here are the **12 factors** in simple terms:

## 1. Codebase
- One codebase per app, tracked in version control (like Git), but can be deployed to multiple environments (dev, staging, prod).
***

## 2. Dependencies
- Explicitly declare and isolate dependencies (e.g., using npm, pip, Maven). No “it works on my machine” hidden installs.
***

## 3. Config
- Store configuration (API keys, DB URLs) in environment variables—not in code.
***

## 4. Backing Services
- Treat external services (databases, queues, caches) as attachable resources. You should be able to swap them easily.
***

## 5. Build, Release, Run
Strict separation:
* Build = compile code
* Release = combine build + config
* Run = execute the app
***

## 6. Processes
- Run the app as stateless processes. Any state should go in external services (like databases).
***

## 7. Port Binding
- The app should be self-contained and expose itself via a port (e.g., a web server), not rely on external web servers like Apache/Nginx being preconfigured.
***

## 8. Concurrency
- Scale by running multiple processes (horizontal scaling), not by making one big machine stronger.
***

## 9. Disposability
- Processes should start fast and shut down gracefully. This helps with scaling and failures.
***

## 10. Dev/Prod Parity
- Keep development, staging, and production environments as similar as possible to avoid surprises.
***

## 11. Logs
- Treat logs as event streams. Don’t store log files in the app—send them to logging systems (like Datadog, ELK, etc.).
***

## 12. Admin Processes
- Run one-off tasks (database migrations, scripts) in the same environment as the main app.
***


## References
- [the tweleve-factor app](https://www.12factor.net)
***