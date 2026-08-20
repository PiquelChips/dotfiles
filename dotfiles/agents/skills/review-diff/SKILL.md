---
name: review-diff
description: >
  Review, organize, stage, validate, fix, and commit uncommitted repository
  changes one logical category at a time. Use when the user asks to review a
  diff, inspect staged work, move through review categories, implement review
  findings, or commit reviewed changes.
---

# Review Diff

Review uncommitted changes as a sequence of small, user-controlled categories.
Keep code review, implementation, and committing as separate decisions.

## Establish the repository state

1. Confirm the repository root and read applicable project instructions.
2. Inspect:

   - `git status --short`
   - `git diff`
   - `git diff --cached`
   - relevant untracked files

3. Treat both the index and working tree as in scope. Do not rely on
   `git diff` alone.
4. Preserve unrelated user changes. Never use broad staging such as
   `git add .` or `git commit -a`.
5. Identify any changes that are already staged and avoid silently unstaging
   them.
6. If the scope is ambiguous, explain the discovered changes and choose narrow,
   behavior-based categories.

## Categorize the changes

Group changes by coherent behavior rather than simply by filename. For each
category, identify:

- the behavior being changed;
- the files and hunks involved;
- dependencies on other categories;
- the recommended review order.

Keep each category independently understandable whenever possible.

Before reviewing a category, stage only that category using targeted path or hunk
staging. Then verify the index with:

- `git diff --cached --stat`
- `git diff --cached --check`
- `git diff --cached`

If the index contains unrelated staged changes that cannot be safely separated,
stop and explain the problem before committing anything.

## Review the staged category

Read the surrounding implementation, relevant tests, and any code called by the
changed paths. Review the staged patch against `HEAD`, not just its formatting.

Check for:

- incorrect behavior or order-dependent behavior;
- side effects that occur before validation;
- error handling and loss of diagnostic context;
- cancellation, retry, concurrency, and lifecycle issues;
- security, ownership, isolation, and data-loss risks;
- compatibility and migration problems;
- missing or misleading tests;
- documentation or generated-artifact drift;
- bad code practices & style.

Trace important calls far enough to understand their real effects. For example,
a function named “resolve” may also pull, mutate, or persist data.

Report findings before committing. For every actionable finding, include:

1. Severity: blocking, important, or minor.
2. Location: file and line.
3. Problem: what is wrong.
4. Impact: what can happen.
5. Evidence: the code path, test result, or minimal reproduction.
6. Recommendation: the smallest practical correction.

Distinguish confirmed defects from questions or residual risks. Do not report
style preferences as bugs. If no actionable findings exist, say so explicitly
and mention meaningful residual risks.

Also report:

- what the category changes;
- what validation was run;
- whether the category is staged;
- whether it is committed.

Do not modify code or commit during review unless the user asks.

## Implement an accepted finding

When the user asks to implement a recommendation:

1. Make the smallest focused change.
2. Add or update a focused regression test when the behavior warrants one.
3. Run targeted tests first.
4. Run project-required validation when practical.
5. Re-stage the complete category.
6. Re-review the resulting staged diff.
7. Explain what the resulting diff actually does in plain language.

Use the cycle:

`stage → review → report → implement → test → restage → re-review`

If the user dismisses a finding, record it as an accepted risk and do not
re-raise it unless new evidence changes the assessment.

## Commit and advance

Commit only when the user says to commit, move on, or otherwise clearly gives
approval.

Before committing:

1. Confirm the staged diff contains only the reviewed category.
2. Run `git diff --cached --check`.
3. Use the repository’s commit-message convention.
4. Commit only the current category.
5. Verify the commit with `git status --short` and `git show --stat --oneline HEAD`.

Report the commit hash and message. Then inspect the remaining changes, select
the next category, stage it, and repeat the review process.

Never commit later categories without separate user approval.
