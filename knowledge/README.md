# Knowledge

**Knowledge:** it is a folder where general knowledge is stored.

Portable tech notes and design patterns — **not** project-specific contracts. For project truth (invariants, runbooks, APIs), use `docs/` and service READMEs first.

**OKF navigation (agents):** [index.md](./index.md) — read-only map; **frontmatter only** on existing files. Rule: `.cursor/rules/okf.mdc`. SOP: `.cursor/skills/how-to-okf/SKILL.md`.

**Ownership:** **Humans** create `knowledge/*.md` concepts. **Agents** must not create, delete, rename, or edit body prose here — only add or refresh OKF frontmatter on files humans added. New agent-written documentation goes in `docs/` or the owning service README.

**How agents use this folder:** read on demand when the task touches a topic below. Do not preload the whole tree. Enforceable invariants belong in `docs/` or `.cursor/rules/`, not new `knowledge/` files.

## Read when

| If you are… | Read |
|---|---|
| Clarifying functional vs non-functional requirements / NFRs | `requirements.md` |
| Structuring services, layers, or request flow | `architecture.md`, `bff.md`, `api_first_paradigm.md` |
| Choosing storage, cache, LB, async, CAP, CDN, search, or observability tradeoffs | `system_design.md` |
| Microservice boundaries, coupling, or split decisions | `anti-patterns_service_architecture.md` |
| Choosing or documenting API style | `api_types.md` |
| API load / stress / baseline performance testing | `api_load_test.md` |
| Securing OAuth 2.0 or OpenID Connect flows | `oauth_2_0_protocol.md` |
| Resource lifecycle (create / read / update / delete) | `CRUD_principles.md` |
| AuthN / AuthZ design | `authentication_and_authorization.md` |
| Refactoring for cohesion / duplication | `SOLID_principles.md`, `DRY_principles.md` |
| Distributed failures, retries, consistency | `failures_in_distributed_system.md` |
| Concurrency / threading | `multithreading_design_patterns.md` |
| Performance trade-offs (latency vs throughput) | `latency_throughput_bandwidth.md` |
| Observability design | `observability.md` |
| Feature flags | `feature_flag.md` |
| Compliance constraints | `compliance.md` |
| Terraform / IaC patterns | `terraform.md` |
| Deploy / release strategy | `deployment_strategy.md`, `gitops.md` |
| 12-factor app constraints | `12_factor_app.md` |
| C4 or architecture diagrams | `c4_model_software_diagram.md` (agent scoping gates: `docs/c4_scoping.md`) |
| Sharding / chunking tradeoffs (meaning vs scale) | `sharding.md` |
| Data / ETL layering | `medallion_architecture_etl.md` |
| Learning or applying dbt (ELT transforms) | `dbt.md` (operator runbook: `docs/dbt.md`) |
| Designing database fields, facts, snapshots, and caches | `database_field_design.md` |
| Agent loop, tools, memory, guardrails | `agent.md`, `agent_harness.md`, `agent_memory.md`, `agent_guardrails.md` |
| Context window vs durable memory | `agent_memory.md` |
| Whether to split work into a sub-agent vs a tool | `subagents.md` |
| Agent-to-agent interoperability (A2A vs MCP) | `A2A.md` |
| MCP tool design | `MCP.md` |
| Authoring agent tools (contracts, tasks not APIs, errors) | `tools.md` |
| Agent primitives (skills, subagents, plugins, MCP, graph) | `agent_primitives.md` |
| Cursor skills vs product/runtime skills (when your repo has both) | `docs/skills_terminology.md` (or `<describe your skills docs here>`) |
| Agent permissions / boundaries | `permission_rules_for_agent.md` |
| Learning security progression (systems → cloud → AI/agents → attacks → proof) | `fundamental_of_security.md` |
| Agentic AI security / guardrails (prompt injection, privilege, tool validation) | `agent_security_guardrails.md` |
| Securing the full agent harness (sandbox, data, model, runtime, IAM, observability, governance) | `agent_security_7_pillars.md` |
| LangGraph / workflow orchestration | `language_to_graph.md` |
| LLM API integration patterns | `llm_api_connections.md` |
| How LLMs are trained (pretrain / SFT / preference) | `how_llm_are_trained.md` |
| Agent evals | `continuous_evaluation.md`, `how_to_evaluate_agent.md` |
| Agent context disclosure (project tiers) | `docs/agent_context_disclosure.md` |
| SDLC / lifecycle | `software_lifecycle.md` |
| General engineering heuristics | `software_engineering_rules.md` |
| Choosing mocks vs stubs vs fakes | `mock_vs_stub_testing.md`, `avoid_mock_testing.md` |
| Writing or reviewing unit tests | `mock_vs_stub_testing.md`, `avoid_mock_testing.md`, `docs/testing_strategy.md` § Mocks stubs and fakes, `.cursor/rules/test-doubles.mdc`, `.cursor/skills/how-to-code/SKILL.md` |
| Local email testing (SMTP catcher, UI, API) | `mailpit.md` (Compose/E2E: `docs/local_dev_docker.md` § Local SMTP) |

## Promoting to project docs

When a `knowledge/` idea becomes a **hard rule for this repo** (invariant, deploy step, API contract), copy the minimum into **`docs/`** (agent may write) or a `.cursor/rules/*.mdc` file — keep `knowledge/` as human-owned rationale. Do not add new `knowledge/` files for enforcement.
