---
name: correct
description: >-
  Find the mistakes agents keep repeating in a repository and make each one
  impossible: architecture first, then types, then a lint or check whose error
  names the fix, then a test, and docs last. Use when the user says "correct".
---

# Correct

The user keeps correcting agents in this repository for the same mistakes.
Change the repository so the next agent can't make them.

Assume every contributor is an agent that sees only the files it opened,
copies the nearest example, and takes the shortest path that compiles. Design
the repository so a change that looks right from one file is right for the
whole repository.

## Find the mistake classes

Read the record:

- the user's corrections in T3 Code threads: `t3_thread_search` with the
  repository's project as `projectId`, then `t3_thread_read` on the hits;
- recent commits and reverts;
- PR review comments;
- agent instruction files, and comments that explain workarounds.

Group the mistakes into classes. A class counts once it has happened twice.

## Fix each class at the highest level that works

Repositories that use `sourceorigin-standard` (piqueld, sourceorigin,
DirkEngine and the standard itself) already have this ladder in their
`AGENTS.md` and the `standard` skill. Follow theirs, exceptions included. A
rule that belongs in every repository is an issue in `sourceorigin-dev/standard`,
not a local check.

Elsewhere:

1. **Eliminate it with architecture.** Give each piece of state one owner and
   each task one supported way. Hide internals so the wrong import fails.
   Replace hand-synced lists with one source of truth. Delete old ways and
   dead code an agent would copy.
2. **Enforce it with types so the bad state can't be written.** If bad code
   still compiles, add a lint or CI check whose error names the file, type,
   or function to use instead. If the pattern is already common, fail only
   when a change adds more.
3. **Test the behavior.** Fix or delete any test that still passes when the
   behavior it checks breaks, or that fails when only the internals change.
4. **Write docs or agent rules last, only for judgment calls.** Nothing fails
   when an agent skips them.

## Fix and prove

Fix the most frequent classes now, one commit each. Prove each new check fails
on a real past mistake. Run the same command locally and in CI. Exceptions go
on the offending line with a reason, an expiry date, and the user's approval.
File the classes you leave as issues where the repository's `AGENTS.md` says
issues live.

## Keep the rule table

Keep a table in the repository's `AGENTS.md` that pairs each rule with what
enforces it. Keep it short: the standard caps `AGENTS.md` at 150 lines. When
the user corrects you, fix the mistake and add the rule. If the rule was
already there and nothing enforces it, that's a repeat: fix it at the highest
level in the same change. Drop a rule once its mistake can't happen.

## Reply

Each class with its evidence, the level you picked, and why a higher level
didn't work.
