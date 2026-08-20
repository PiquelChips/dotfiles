---
name: review-diff
description: >
  Review, organize, stage, validate, fix, and commit uncommitted repository
  changes one logical category at a time. Use when the user asks to review a
  diff, inspect staged work, move through review categories, implement review
  findings, or commit reviewed changes.
---

# Review Diff

Review uncommitted changes in small, user-controlled categories. Keep review,
implementation, and committing as separate decisions.

1. Read repository instructions and inspect `git status --short`, staged and
   unstaged diffs, and relevant untracked files.
2. Group changes by behavior, noting dependencies and review order. Preserve
   unrelated work and existing staged changes.
3. Stage one category with targeted paths or hunks. Never use `git add .` or
   `git commit -a`. Verify it with:

   - `git diff --cached --stat`
   - `git diff --cached --check`
   - `git diff --cached`

   Stop if unrelated staged changes cannot be safely separated.

4. Review the staged patch against `HEAD`, including surrounding code, tests,
   and important callees. Check behavior, validation order, error context,
   concurrency and lifecycle issues, security and data-loss risks,
   compatibility, tests, documentation, code style, and generated artifacts.

5. Report before modifying or committing:

   - what the category changes;
   - validation performed;
   - staging and commit status;
   - actionable findings with severity, location, impact, evidence, and the
     smallest practical fix.

Distinguish defects from questions and residual risks.
If there are no findings, say so.

When asked to fix a finding, make the smallest focused change, add a focused
test when warranted, run targeted and project-required validation, then restage
and re-review the complete category. Do not re-raise findings the user accepts
as risks unless new evidence appears.

Commit only with clear user approval. Confirm the index contains only the
reviewed category, run `git diff --cached --check`, follow repository commit
conventions, and verify the result with `git status --short` and
`git show --stat --oneline HEAD`.

Report the commit hash and message, then stage and review the next category.
Require separate approval before each commit.
