---
type: Reference
title: SOLID principles
description: Single-responsibility, open/closed, Liskov, interface segregation, dependency inversion for modular code.
tags: [design, refactoring, architecture]
timestamp: 2026-07-11T00:00:00Z
---

# SOLID
***

## What is it?
- SOLID is about structuring code so it stays flexible, modular, and easy to change as systems grow.
***

## S — Single Responsibility Principle
- A class/module should do one thing only.
- If it has multiple reasons to change, it’s doing too much.
- Example: A “UserService” shouldn’t both validate users and send emails and write to the database.
*** 

## O — Open/Closed Principle
- Code should be open for extension, but closed for modification.
- You should be able to add new behavior without rewriting existing logic.
- Example: Add a new model type via a new class, not by editing a giant if/else block everywhere.
***

## L — Liskov Substitution Principle
- Subclasses should be fully substitutable for their parent class without breaking behavior.
- Example: If “Bird” has a fly() method, a Penguin subclass shouldn’t break expectations by not being able to fly (unless you redesign the abstraction).
***

## I — Interface Segregation Principle
- Don’t force classes to implement methods they don’t need.
- Prefer small, focused interfaces over large “fat” ones.
- Example: Instead of one huge Worker interface with work(), eat(), sleep(), split into smaller ones.
***

## D — Dependency Inversion Principle
- High-level modules shouldn’t depend on low-level modules — both should depend on abstractions.
- Example: Your business logic shouldn’t depend directly on a PostgreSQL client — it should depend on a database interface.
***