---
type: Reference
title: Database Field Design
description: Practical guidance for modeling source-of-truth facts, derived fields, historical snapshots, and performance caches.
tags: [database, schema-design, data-modeling, source-of-truth, performance]
timestamp: 2026-07-17T00:00:00Z
disclosure: on_demand
---

# Database Field Design Knowledge Base

*A practical reference for designing database schemas with a focus on source-of-truth modeling, derived fields, and performance tradeoffs.*

## Core Philosophy

> **Store facts. Derive knowledge. Materialize only when necessary.**

A database should primarily store **business facts** rather than every possible calculation that can be made from those facts.

Facts represent things that happened.

Derived values represent interpretations of those facts.

The default assumption should always be:

- Store immutable business facts.
- Compute derived values when querying.
- Materialize (store) derived values only when there is a clear reason.

## Source of Truth

Every piece of information should have **one authoritative source**.

Bad:

```text
users
------
birth_date
age
```

Now there are two sources of truth.

Good:

```text
users
------
birth_date
```

Age is:

```text
today - birth_date
```

If a stored field can always be reconstructed from other stored fields, it is not the source of truth.

## Types of Fields

### 1. Primary Facts

These represent events or properties that actually exist.

Examples:

- User name
- Date of birth
- Order date
- Quantity purchased
- Unit price
- Country of residence

Characteristics:

- Cannot be reconstructed
- Represent business reality
- Usually entered by users or external systems

Always store.

### 2. Derived Fields

Computed from existing information.

Examples:

```text
age
full_name
order_total
profit
discount_percentage
average_rating
```

Characteristics:

- Can always be recomputed
- May change as source data changes
- Often used for presentation or reporting

Default recommendation: do **not** store.

### 3. Snapshot Fields

Sometimes a value is technically derived but represents historical truth.

Current product:

```text
Product
-------
price = 120
```

Customer purchases today. The invoice should contain:

```text
InvoiceItem
-----------
product_name
unit_price
tax_rate
```

Even though those values come from `Product`, invoices should never change when products change.

Store snapshots when the business contract requires historical values to remain unchanged.

### 4. Cached Fields

Sometimes a derived value is stored purely for performance.

Example:

```text
Orders
------
total_amount
```

where:

```text
total_amount =
SUM(order_items.quantity * unit_price)
```

The stored value is a cache.

It is **not** the source of truth.

If deleted, it can be rebuilt.

## Decision Framework

Whenever adding a new column, ask:

### Question 1

Is this a business fact?

If yes, store it.

### Question 2

Can this always be computed from other fields?

If yes, do not store it by default.

### Question 3

Would deleting this field permanently lose information?

If yes, store it.

If no, compute it.

### Question 4

Is computing it expensive?

If yes, consider materializing it.

Otherwise, compute it on demand.

### Question 5

Does it need to remain historically accurate?

If yes, store a snapshot.

## When to Compute at Query Time

Prefer query-time calculation whenever it is:

- Simple
- Cheap
- Always current
- Used infrequently

Examples:

```text
age
```

```text
first_name + last_name
```

```text
subtotal + tax
```

```text
remaining_inventory =
stock_received - stock_sold
```

Advantages:

- Always correct
- No duplicated data
- No synchronization problems
- Easier maintenance

Disadvantages:

- More CPU usage
- Slower queries on very large datasets

## When to Store Derived Values

Store only if one or more of the following are true.

### Performance

The calculation is expensive.

For example, a dashboard may compute metrics over 100 million rows. Instead of running:

```sql
COUNT(...)
SUM(...)
GROUP BY ...
```

on every request, store:

```text
daily_metrics
-------------
date
active_users
revenue
```

and refresh periodically.

### Historical Records

Examples include:

- Invoices
- Receipts
- Accounting records
- Tax reports
- Audit logs
- Medical records

Store values that must remain unchanged as historical snapshots.

### Search Performance

If users constantly filter on an expensive calculation, instead of:

```sql
WHERE complicated_expression(...)
```

store:

```text
customer_segment
```

and update it through a defined synchronization process.

### External Integration

Sometimes another system expects a value to exist physically. Store it if required.

## Anti-Patterns

### Storing Age

Bad:

```text
age
```

Good:

```text
birth_date
```

### Storing Full Name

Avoid storing:

```text
full_name
```

when:

```text
first_name
last_name
```

already exist, unless formatting matters, a legal requirement applies, or the value comes from imported legacy data.

### Duplicating Totals

Bad:

```text
Orders
------
total
```

without keeping it synchronized.

If totals are stored, there must be a defined update strategy.

### Multiple Sources of Truth

Never allow:

```text
inventory

AND

inventory_count

AND

available_inventory
```

to all be editable.

Choose one authoritative source.

## Materialization Strategies

### Strategy 1: Always Compute

```text
Database
    |
    v
SQL Query
    |
    v
Result
```

Pros:

- Correct
- Simple

Cons:

- Slower

### Strategy 2: Precompute

```text
Source Data
      |
      v
Aggregation Job
      |
      v
Summary Table
```

Pros:

- Fast reads

Cons:

- More storage
- Synchronization complexity

### Strategy 3: Materialized Views

Some databases support materialized views.

Advantages:

- Database-managed materialization
- Faster reads
- Clear separation between source and cache

Refresh behavior depends on the database and must be configured or invoked explicitly.

Useful for reporting.

## Cache vs Source of Truth

Always distinguish between these concepts.

`Order Items` are the source of truth.

`Order Total` is a cache.

If the cache disappears, rebuild it.

If the source disappears, data is lost.

## Synchronization Rules

Whenever storing derived values, define:

- Who updates them?
- When are they updated?
- Can they become stale?
- Can they be rebuilt?
- What happens if synchronization fails?

Never introduce cached fields without an update strategy.

## Practical Decision Matrix

| Question | Yes | No |
|-----------|-----|----|
| Is it a business fact? | Store | Continue |
| Can it be derived? | Compute | Store |
| Is computation expensive? | Consider caching | Compute |
| Must history be preserved? | Store snapshot | Continue |
| Is it queried constantly? | Consider materializing | Compute |
| Would deleting it lose information? | Store | Compute |

## Examples

### User

Store:

```text
id
birth_date
first_name
last_name
```

Compute:

```text
age
full_name
```

### Order

Store:

```text
quantity
unit_price
```

Compute:

```text
line_total
```

Possibly cache:

```text
order_total
```

if performance requires it.

### Invoice

Store:

```text
product_name
unit_price
tax_rate
subtotal
total
```

These are historical snapshots.

### Analytics

Store raw events:

```text
page_views
clicks
purchases
```

Materialize:

```text
daily_active_users
weekly_revenue
conversion_rate
```

## Golden Rules

1. Facts are stored.
2. Calculations are derived.
3. History is snapshotted.
4. Performance justifies caching.
5. Every cached field must have one source of truth.
6. Every stored derived field must have a synchronization strategy.
7. If a field can be deleted and regenerated, it is a cache, not the source of truth.
8. Optimize for correctness first, performance second.
9. Normalize first; denormalize intentionally and only when justified.
10. Treat schema changes as long-term decisions because they are costly to reverse once data is in production.

## Mental Model

Think of a database like accounting.

Facts are journal entries.

Derived values are reports.

You never edit reports.

You edit facts.

Reports are regenerated from facts whenever possible.

## Related

- Project enforceable data ownership and lifecycle rules (when present): `<describe your data invariants docs here>` (e.g. [/docs/data_invariants.md](/docs/data_invariants.md))
