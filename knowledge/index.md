# General reference

Portable tech notes — not project-specific contracts. Project truth: [/docs/index.md](/docs/index.md). Human routing table: [README.md](/knowledge/README.md).

# Design principles

* [SOLID principles](/knowledge/SOLID_principles.md) — Single-responsibility, open/closed, Liskov, interface segregation, dependency inversion for modular code.
* [DRY](/knowledge/DRY_principles.md) — DRY stands for “Don’t Repeat Yourself.” It means each piece of knowledge or logic should exist in one place only.
* [CRUD](/knowledge/CRUD_principles.md) — CRUD stands for Create, Read, Update, Delete — the four basic operations on persistent resources.
* [Requirements](/knowledge/requirements.md) — Functional vs non-functional requirements and quality attributes for system design (availability, scalability, durability, security, cost).

# Architecture and APIs

* [Architecture](/knowledge/architecture.md) — API Gateway is concern with authentication & authorization, Rate limiting, throttling
* [System design](/knowledge/system_design.md) — Contrastive checklist of architecture choices — storage, caching, load balancing, async processing, CAP, reliability, CDNs, APIs, search, and observability.
* [Backends For Frontends (BFF)](/knowledge/bff.md) — This file is a curated list of best-practices design rule related to Backends For Frontends.
* [API-first paradigm](/knowledge/api_first_paradigm.md) — Define HTTP contracts and schemas before implementation; enables parallel development and TDD.
* [API](/knowledge/api_types.md) — This file is a curated list of best-practices design rule related to APIs.
* [API load testing](/knowledge/api_load_test.md) — Best-practice order and targets for API baseline, load, and stress tests, plus CI/CD integration notes.
* [API security](/knowledge/api_security.md) — This file is a curated list of best-practices design rule related to API security best practices
* [Service architecture anti-patterns](/knowledge/anti-patterns_service_architecture.md) — Common microservice architecture anti-patterns (boundaries, chatty calls, shared DB, large payloads) and how to avoid them.
* [Microservices (architecture style)](/knowledge/microservice_vs_worker.md) — A microservice is a *small, independently deployable application* that:
* [What is this?](/knowledge/c4_model_software_diagram.md) — 1. Context 2. Container 3. Component 4. Code

# Agents, MCP, and orchestration

* [Agent](/knowledge/agent.md) — This file is a curated list of best-practices design rule related to agents.
* [Agent memory](/knowledge/agent_memory.md) — Memory is what the system stores across runs; context is what the model sees right now — a distinction that matters when building agents.
* [Agent harness](/knowledge/agent_harness.md) — An agent operating in the wild cannot be ephemeral.
* [Harness engineering](/knowledge/harness_engineering.md) — Reliability is a property of the model–harness–environment system — guides (feedforward) and sensors (feedback), computational vs inferential checks, and harnessability.
* [Agent guardrails](/knowledge/agent_guardrails.md) — Five-stage request pipeline for agent systems — input screening, context verification, response generation, output validation, and operational controls.
* [Subagents](/knowledge/subagents.md) — Decision criteria for when to create a sub-agent versus a tool — expertise, tools, lifecycle, and prompt size.
* [Agent2Agent (A2A) Protocol](/knowledge/A2A.md) — Open Agent2Agent protocol — client vs remote agents, Agent Cards, Tasks, artifacts, message parts, JSON-RPC/SSE; complements MCP (agent-to-tool).
* [MCP tool design](/knowledge/MCP.md) — Model Context Protocol — atomic, intent-centric tools; agent selects intent, MCP executes.
* [Agent tool design](/knowledge/tools.md) — Portable principles for defining agent tools — contracts, task-centric actions, schema validation, and error messages the model can act on.
* [Agent primitives — skills, subagents, plugins, MCP, graph](/knowledge/agent_primitives.md) — Portable framing for agent building blocks — when to use skills, subagents, plugins, MCP tools, CLIs, graph orchestration, and AGENTS.md as a router.
* [Permission rules for agents](/knowledge/permission_rules_for_agent.md) — plan: The model drafts a plan. Nothing executes until the user approves.
* [Agent security guardrails](/knowledge/agent_security_guardrails.md) — Seven guardrail patterns for agentic AI systems — least privilege, human in the loop, output guardrails, privilege separation, prompt isolation, tool validation, input sanitization.
* [7-Pillar Agent Security Architecture](/knowledge/agent_security_7_pillars.md) — Framework for securing agentic AI systems — infrastructure, data, model, runtime, IAM, observability, and governance around the model harness.
* [Language To Graph](/knowledge/language_to_graph.md) — Portable notes on representing workflows as graphs (JSON schema first; property graph when traversal-heavy).
* [References](/knowledge/loop_engineering.md) — https://drive.google.com/file/d/1u9tPJ2OqiFsZ6tBQXlHoz0ql4H9T3K2c/view
* [References](/knowledge/continuous_evaluation.md) — [evals-skills](https://github.com/hamelsmu/evals-skills/tree/main)
* [How to evaluate agents](/knowledge/how_to_evaluate_agent.md) — Portable pointers for agent evaluation frameworks — AISI Inspect and Kaggle SAE zero-setup leaderboards.

# Reliability, performance, and ops patterns

* [Failure Modes in Distributed Systems — Summary + Best Practices](/knowledge/failures_in_distributed_system.md) — Network links can fail, become slow, or split the system into isolated groups where nodes cannot communicate reliably.
* [Multithreading Design Patterns](/knowledge/multithreading_design_patterns.md) — Multithreading enables a single program or process to execute multiple tasks concurrently. Each task is a thread. Think of threads as lightweight units of execution that share the resources of the...
* [Latency vs Throughput vs Bandwidth](/knowledge/latency_throughput_bandwidth.md) — This file explain briefly when to use Latency vs Throughput vs Bandwidth
* [Observability](/knowledge/observability.md) — ---
* [Feature flag](/knowledge/feature_flag.md) — This file is a curated list of best-practices related to feature flag.
* [Sharding](/knowledge/sharding.md) — A curated list of tips about sharding.
* [12-Factor App](/knowledge/12_factor_app.md) — The “12-Factor App” is a set of best practices for building modern, scalable, cloud-native applications. It was created by engineers at Heroku and is widely used as a guideline for designing...
* [Terraform](/knowledge/terraform.md) — Terraform is best at managing infrastructure topology.
* [Deployment strategies](/knowledge/deployment_strategy.md) — Description: Shut down the old version, deploy the new version everywhere, then bring the system back online.
* [Gitops](/knowledge/gitops.md) — This file is a curated list of best-practices about gitops.
* [How Docker Containers Work: Internal Architecture and Runtime Explained](/knowledge/docker.md) — Docker containers solve the problem:

# LLM and data

* [HTTP Connection Heat](/knowledge/llm_api_connections.md) — Long-lived service processes (agent worker, LLM microservice) hold an internal HTTP connection pool via the vendor SDK (groq, openai, deepgram). After several minutes of no traffic the API server...
* [Medallion Architecture for ETL Pipelines](/knowledge/medallion_architecture_etl.md) — The Medallion Architecture is a data design pattern commonly used in modern data lake and analytics platforms to organize data in progressive layers of refinement. It structures data pipelines...
* [dbt (data build tool)](/knowledge/dbt.md) — Beginner reading path for dbt (the T in ELT) and how it fits common store shapes (Postgres sources vs Neo4j, Redis, object storage).
* [Database Field Design](/knowledge/database_field_design.md) — Practical guidance for modeling source-of-truth facts, derived fields, historical snapshots, and performance caches.
* [How JWT (JSON Web Token) Works](/knowledge/how-jwt-works.md) — JWT (JSON Web Token) is a mechanism for securely transferring information between a client and a server.

# Security and compliance

* [Fundamentals of security](/knowledge/fundamental_of_security.md) — Phased security learning path — systems, AppSec, cloud, AI/agents, attacks, defense, and hands-on proof.
* [Authentication & authorization](/knowledge/authentication_and_authorization.md) — Authentication: Verifies who you are (e.g., login with password, OAuth token, biometric check).
* [OAuth 2.0 protocol security cheatsheet](/knowledge/oauth_2_0_protocol.md) — Current security practices for OAuth 2.0 and OpenID Connect, including PKCE, sender-constrained tokens, token restriction, and deprecated grants.
* [Compliance](/knowledge/compliance.md) — Portable reminders for privacy, auditability, certifications, and AI governance (fill project-specific obligations in `docs/`).

# Engineering practice

* [Software lifecycle](/knowledge/software_lifecycle.md) — Development QA = Quality Assurnace Staging
* [Rules of Software Engineering:](/knowledge/software_engineering_rules.md) — 0. You WILL regret complexity when on-call
* [The Modern AI Ecosystem – Tools](/knowledge/AI_tool_stack.md) — OpenAI GPT Anthropic Claude Google Gemini
* [Mocks vs stubs in tests](/knowledge/mock_vs_stub_testing.md) — Stubs return predetermined data for state verification; mocks verify collaborator interactions — default to stubs/fakes for queries, mocks for commands. Project enforcement (when present) — .cursor/rules/test-doubles.mdc, docs/testing_strategy.md § Mocks stubs and fakes; Vitest — .cursor/rules/frontend-test-mocking.mdc.
* [Increase test fidelity by avoiding mocks](/knowledge/avoid_mock_testing.md) — Prefer real implementations, then fakes, then mocks — higher fidelity tests catch more bugs; mocks are the last resort for hard-to-trigger paths. Project enforcement (when present) — .cursor/rules/test-doubles.mdc, docs/testing_strategy.md § Mocks stubs and fakes; Vitest — .cursor/rules/frontend-test-mocking.mdc.
* [Mailpit (email testing)](/knowledge/mailpit.md) — How Mailpit works as a local SMTP catcher with web UI and REST API for developer email testing — not a real mail relay.

# Project cross-links (fill for your app)

* [Test doubles (how much to mock)](/docs/testing_strategy.md) — Rules `.cursor/rules/test-doubles.mdc`, `.cursor/rules/frontend-test-mocking.mdc`; workflow `.cursor/skills/how-to-code/SKILL.md`, `.cursor/skills/how-to-review/SKILL.md`, `.cursor/skills/how-to-plan/SKILL.md`
