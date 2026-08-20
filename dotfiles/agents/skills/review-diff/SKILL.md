---
name: review-diff
description: >
  Review, organize, stage, validate, fix, and commit uncommitted repository
  changes one logical category at a time. Use when the user asks to review a
  diff, inspect staged work, move through review categories, implement review
  findings, or commit reviewed changes.
---

1. Inspect changes, group them into behavioral categories, and announce the order.
2. Stage only the current category.
3. Explain what the category is & what haa changed, review the changes, report your findings, and return control.
4. Wait for the user's verdict:
   - If fixes are requested, make only those fixes, validate, restage, re-review, and pause again.
   - If accepted, get explicit commit approval, verify only that category is staged, commit it, and report the hash.
5. Move to the next category only after the current category is committed.
6. Preserve unrelated changes. Never stage or commit unrelated files.

