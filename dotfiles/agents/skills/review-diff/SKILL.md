---
name: review-diff
description: >
  Review, organize, stage, validate, fix, and commit uncommitted repository
  changes one logical category at a time. Use when the user asks to review a
  diff, inspect staged work, move through review categories, implement review
  findings, or commit reviewed changes.
---

Review repository changes in small, behaviorally coherent categories. Keep
categorization, review, implementation, validation, and committing as separate
decisions.

## Non-negotiable rule

Never treat the entire staged diff as one category merely because it is staged.

“Staged” describes Git index state. A category describes related behavior.
A staged patch may contain several independent categories and must still be
split logically for review.

Do not begin detailed review, run broad validation, modify files, or report
findings for the entire patch until categories and their review order have been
identified.

## Workflow

### 1. Read instructions and inventory changes

Read repository instructions first. Then inspect:

- `git status --short`
- staged and unstaged file lists and statistics;
- staged and unstaged diffs;
- relevant untracked files;
- surrounding code, tests, and generated artifacts as needed.

A full diff may be used for inventory, but it is not evidence that the patch is
one review category.

Preserve unrelated user changes, existing staged changes, and untracked files.

### 2. Categorize before reviewing

Group changes by behavior or change intent, not merely by directory or staging
state.

For every category, explicitly record:

- category name;
- behavior it changes;
- exact files or hunks included;
- dependencies on other categories;
- review order;
- focused validation to run.

Categories should be as disjoint as practical. If one file contains multiple
behaviors, split by hunk when safe. If it cannot be split safely, assign the
file to the category that owns the behavior and explain the boundary.

Tests should normally stay with the behavior they verify. Documentation and
generated artifacts should be reviewed with their source behavior, then checked
again after generation.

Announce the category list and review order before reviewing the first category.

### 3. Select one category

For an unstaged category, stage only its targeted paths or hunks. Never use:

- `git add .`
- `git add -A`
- `git commit -a`

For changes that are already staged:

- do not unstage or reset unrelated user changes automatically;
- do not assume the whole index is one category;
- review the selected category with path- or hunk-scoped commands;
- state clearly that other categories remain staged.

If category boundaries cannot be isolated by paths or hunks without altering
unrelated staged work, stop and ask before changing the index.

For a path-isolated staged category, verify only that category:

```text
git diff --cached --stat -- <category paths>
git diff --cached --check -- <category paths>
git diff --cached -- <category paths>
```

If the category also has unstaged changes, inspect the complete category against
`HEAD`:

```text
git diff --stat -- <category paths>
git diff --check -- <category paths>
git diff HEAD -- <category paths>
```

Do not use an unscoped staged diff as the category review when other categories
are present.

### 4. Review the category

Review the selected category against `HEAD`, including surrounding code,
important callees, tests, and relevant configuration.

Check:

- behavior and edge cases;
- validation order and bypasses;
- error propagation and context;
- concurrency, retries, cleanup, and lifecycle behavior;
- security, authorization, and data-loss risks;
- compatibility and public API changes;
- tests and missing regression coverage;
- documentation and generated artifacts;
- code style and repository conventions.

Distinguish confirmed defects from questions, tradeoffs, and residual risks.

### 5. Report before changing anything

For the selected category, report:

- category name and exact scope;
- dependency and review-order context;
- validation performed and its result;
- staging and commit status;
- actionable findings.

Each finding must include:

- severity;
- file and line or symbol;
- impact;
- concrete evidence;
- smallest practical fix.

If there are no findings, say so explicitly.

Do not modify files or commit while merely reviewing unless the user asks for
that action.

### 6. Fix findings only when requested

When asked to fix a finding:

1. make the smallest focused change;
2. add or update a focused test when warranted;
3. run targeted validation and repository-required validation;
4. restage only the affected category or hunks;
5. re-review the complete category from `HEAD`.

Do not re-raise a finding the user explicitly accepts as a risk unless new
evidence changes the assessment.

### 7. Commit only with explicit approval

Before each commit, require separate user approval.

Confirm that the index contains only the approved category. If unrelated
categories are staged and cannot be safely separated, do not commit them
implicitly.

Then run:

```text
git diff --cached --stat
git diff --cached --check
git diff --cached
```

Follow repository commit conventions. After committing, verify:

```text
git status --short
git show --stat --oneline HEAD
```

Report the commit hash and message, then continue to the next category only
after preserving the same category-by-category workflow.

## Required outcome

A completed review must make clear:

- what the categories were;
- why they were ordered that way;
- which category was reviewed;
- what validation ran;
- what findings remain;
- whether files or staging were changed;
- whether a commit was made.
