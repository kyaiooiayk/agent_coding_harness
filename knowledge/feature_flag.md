---
type: Reference
title: Feature flag
description: This file is a curated list of best-practices related to feature flag.
tags: [reference, feature, flag]
timestamp: 2026-07-12T00:00:00Z
---

# Feature flag
***

# What is this file about?
- This file is a curated list of best-practices related to feature flag.
***

## Feature flag vs. rollback
- Feature toggles are a better safety net than rollbacks.
- When something breaks in production, reaching for a toggle to switch a feature off enables you to “stop the bleeding” and then calmly diagnose an issue. Rolling back a feature flag is less nerve-jangling than scrambling to force a redeployment in the middle of the night!
***

## Things to watch out for
- One problem with feature flags is that they’re addictive. 
- On the other hand, the ease with which feature flags are added can create a hygiene crisis if they’re continuously added, but not removed. 
- Treat feature-toggle cleanups like a form of gardening and “weed” rolled-out toggles from the codebase.
***

## References
- [CI/CD with Robert Erez](https://newsletter.pragmaticengineer.com/p/cicd-with-robert-erez?utm_source=post-email-title&publication_id=458709&post_id=202192974&utm_campaign=email-post-title&isFreemail=true&token=eyJ1c2VyX2lkIjo3ODk2MzkzOSwicG9zdF9pZCI6MjAyMTkyOTc0LCJpYXQiOjE3ODE3MTQ4MjksImV4cCI6MTc4NDMwNjgyOSwiaXNzIjoicHViLTQ1ODcwOSIsInN1YiI6InBvc3QtcmVhY3Rpb24ifQ.SQt3CC_7Rnc_qRHZiAQcxRKo-nceJhSOwA1m8RBT_2M&r=1b0gyr&triedRedirect=true&utm_medium=email)
***