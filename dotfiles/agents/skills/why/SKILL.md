---
name: why
description: >-
  Explain why something is built the way it is, from the record: design
  rationale, why we picked X, regressions, postmortems, data-backed
  thresholds. Returns a cited read on decisions and tradeoffs. Use for
  questions about past decisions, such as "why was this built this way?" or
  "why did we pick X?". Not for why code fails or behaves as it does now:
  debug that instead.
---

# Why

Answer from the record, not the code: read the commits and PR discussions that
introduced the target and each later change, and other sources if the trail is
thin. In a repository whose issues live in Linear, read the issues those PRs
name (`Fixes PQD-123`, `Part of PQD-123`) and their comments too.

Cite what the authors wrote, mark your own inferences as inferences, and say
what the record does not answer.
