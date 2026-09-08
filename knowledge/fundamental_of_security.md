---
type: Reference
title: Fundamentals of security
description: Phased security learning path — systems, AppSec, cloud, AI/agents, attacks, defense, and hands-on proof.
tags: [reference, security, agents, learning-path]
timestamp: 2026-08-29T00:00:00Z
disclosure: on_demand
---


How to use this list? This list serves as a reminder for the architect. It most cosists of contrastive options that mimics the choice each designer needs to take when it comes to define the architecture.

→ PHASE 1: Learn how systems work

Linux → processes, permissions, files, shell
Networking → TCP/IP, ports, DNS, firewalls
Web → HTTP, cookies, sessions, TLS
Coding → Python, Git, basic APIs

Goal: Understand the system before trying to secure it.

→ PHASE 2: Build security fundamentals

Authentication vs Authorization
IAM + Least Privilege
OWASP Top 10
API Security
Secrets Management
Threat Modeling
Logging + Incident Response

Goal: Stop memorizing vulnerabilities. Understand how trust gets broken.

→ PHASE 3: Learn cloud security

AWS/Azure/GCP basics
VPCs + Security Groups
S3/Object Storage
Cloud IAM
Containers + Docker
CI/CD Security
Cloud Logging

Goal: Understand where identity, data, and workloads meet.

→ PHASE 4: Understand modern AI systems

LLMs + Context Windows
Embeddings
RAG
Vector Databases
Tool Calling
Agents
Memory
MCP

You cannot secure an agent if you do not understand how it decides what to do.

→ PHASE 5: Learn AI-specific attacks

Prompt Injection
Indirect Prompt Injection
Data Leakage
RAG Poisoning
Memory Poisoning
Insecure Output Handling
Model/Agent Supply Chain Risk

Goal: Learn how untrusted data becomes trusted behavior.

→ PHASE 6: Go deep on Agentic AI Security

Agent Identity
Tool Permissions
Sandboxing
Network Egress Controls
Short-lived Credentials
Human Approval Gates
MCP Security
Agent-to-Agent Trust
Data Exfiltration Paths
Kill Switches

This is where traditional AppSec starts meeting autonomous systems.

→ PHASE 7: Learn how to test AI systems

AI Red Teaming
Adversarial Evals
Tool-call Tracing
Permission Testing
Attack Simulations
Security Regression Tests
Agent Observability

Do not only ask, "Did the model answer safely?"

Ask, "What can this model actually do?"

→ PHASE 8: Build something vulnerable, then secure it

Build a RAG app.
Add an agent.
Give it tools.
Threat model it.
Attack it.
Fix it.
Document everything.

That project will teach you more than another 20 hours of AI security videos.

Follow the progression:

Systems → Security → Cloud → AI → Agents → Attacks → Defense → Proof



https://www.linkedin.com/posts/saedf_this-is-one-of-the-best-times-to-get-into-activity-7499062518372278272-WOLe?utm_source=share&utm_medium=member_desktop&rcm=ACoAAAtIwEUBArru5MCyINlM3N6qdprHeyov2Cw