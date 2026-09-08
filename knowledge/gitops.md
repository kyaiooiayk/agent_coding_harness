---
type: Reference
title: Gitops
description: This file is a curated list of best-practices about gitops.
tags: [reference, gitops]
timestamp: 2026-07-12T00:00:00Z
---

# Gitops
***

# What is this file about?
- This file is a curated list of best-practices about gitops.
***

## GitOps isn’t actually about Git
- It's a bit like saying: "Object-oriented programming isn't actually about classes." Most OOP languages use classes, but the core ideas are things like encapsulation, abstraction, and polymorphism.
- Similarly: GitOps isn't fundamentally about Git; Git is just the most popular tool used to satisfy the GitOps principles.
- Git is an implementation detail. The real essence of GitOps is declarative desired state, versioned configuration, pull-based deployment, and continuous reconciliation.
***

## The 4 pillars
1) declarative
2) versioned and immutable
3) pulled, not pushed
4) continuously reconciled
***

## Declarative
- Instead of telling a system *how* to do something, you describe the *desired end state*.

**Imperative approach:**

```bash
kubectl create deployment web --image=nginx
kubectl scale deployment web --replicas=3
```

You're issuing commands one by one.

**Declarative approach:**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web
spec:
  replicas: 3
```

You declare: "I want 3 replicas of this deployment."

A controller figures out how to make reality match that description.
***


## Versioned and Immutable

The desired state should be stored somewhere that:

* keeps history
* allows rollback
* records who changed what
* treats changes as new versions rather than editing live systems

Git is great for this, which is why most GitOps implementations use it.

But you could also use:

* a versioned object store
* a database with audit history
* a configuration management system

-The principle is **versioned state**, not specifically **Git**.
***

## Pulled, Not Pushed

This is one of the biggest GitOps ideas.

**Traditional deployment:**

```text
CI/CD pipeline
      |
      v
Production cluster
```

The pipeline pushes changes into production.

**GitOps deployment:**

```text
Git/Config Source
        ^
        |
   Agent in cluster
```

The cluster runs an agent (for example, Argo CD or Flux) that continuously checks the source of truth and pulls changes.

Benefits:

* fewer inbound credentials
* simpler security model
* production decides when to accept changes

The important principle is **the runtime environment fetches desired state itself**.

It doesn't have to pull from Git. It could pull from a database, API, or artifact repository.

---

## Continuously Reconciled

- This is the most important pillar.
- The system constantly asks:

> "Does reality match the desired state?"

- If not, it fixes the difference.

Example:

Desired state:

```yaml
replicas: 3
```

Actual state:

```yaml
replicas: 2
```

- A reconciliation loop notices the drift and restores 3 replicas.
- This happens continuously, not just during deployments.
- Again, Git isn't required. The controller only needs a source of truth to compare against.
***

## References
- [CI/CD with Robert Erez](https://newsletter.pragmaticengineer.com/p/cicd-with-robert-erez?utm_source=post-email-title&publication_id=458709&post_id=202192974&utm_campaign=email-post-title&isFreemail=true&token=eyJ1c2VyX2lkIjo3ODk2MzkzOSwicG9zdF9pZCI6MjAyMTkyOTc0LCJpYXQiOjE3ODE3MTQ4MjksImV4cCI6MTc4NDMwNjgyOSwiaXNzIjoicHViLTQ1ODcwOSIsInN1YiI6InBvc3QtcmVhY3Rpb24ifQ.SQt3CC_7Rnc_qRHZiAQcxRKo-nceJhSOwA1m8RBT_2M&r=1b0gyr&triedRedirect=true&utm_medium=email)
***