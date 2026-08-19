---
name: review-diff
description: >
    Help the user review a bunch of uncommitted changes.
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
