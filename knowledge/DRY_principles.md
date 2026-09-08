---
type: Reference
title: DRY
description: DRY stands for “Don’t Repeat Yourself.” It means each piece of knowledge or logic should exist in one place only.
tags: [reference, dry, principles]
timestamp: 2026-07-12T00:00:00Z
---

# DRY
***

## What is it?
- DRY stands for “Don’t Repeat Yourself.”
- It means each piece of knowledge or logic should exist in one place only.
- When duplication appears, it creates more places to update and more chances for inconsistency.
***

## Why it matters
- Repeated code or concepts make changes harder and bugs more likely.
- If the same logic is duplicated, updating one copy but not the others breaks behavior.
- DRY helps keep the system maintainable and reduces technical debt.
***

## How to apply it
- Extract repeated logic into a shared function, module, or abstraction.
- Use constants or configuration instead of repeating literal values.
- Prefer reusable components over copy-pasting similar code.
***

## Example
- If two routes validate input the same way, move that validation to one helper.
- If multiple components use the same formatting rules, centralize them.
- Example: A “calculateTax()” function should be used everywhere instead of re-implementing tax math in multiple files.
***

## References
- [Don't repeat yourself](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself)
***