---
name: review-diff
description: >
  Review, organize, stage, validate, fix, and commit uncommitted repository
  changes one logical category at a time. Use when the user asks to review a
  diff, inspect staged work, move through review categories, implement review
  findings, or commit reviewed changes.
---

# Review Diff

Look through all the changes the user wants to review.
Categorize the diff into individual changes (there can be one or more).

For each category, stage the changes & review them.
Tell the user what the changes are about & what the issues you found are.
The review findings should be given to the user before committing.
The issues can safely be ignored if the user ignores or dismisses them.

When the user tells you that they're done, or wants to move on, commit the staged
changes & do the same with the next category of changes.
