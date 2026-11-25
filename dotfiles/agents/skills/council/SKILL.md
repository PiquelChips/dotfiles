---
name: council
description: Trigger this if the user says 'council'.
---

# Council

Before an audit, address outstanding PR comments, fix known issues, and run
relevant checks. Give council the updated implementation; do not defer known
fixes until reviews return. If the user wants to discard the implementation
and explore new ideas, skip fixes to code being replaced.

Bring in three delegates to help with the user's request, usually for review
or feedback: GPT 6.1 Sol, Claude Opus 5.5, and Claude Fable 5.2, all at high
reasoning effort. If the user names other council members, use those.

Call `orchestrator_capabilities` to resolve the model IDs, then start one
`delegate_task` per member in parallel. If a member is unavailable, report it
instead of substituting.

Give each delegate the request and relevant context. For review or feedback,
delegates never push, comment, or edit your checkout. Collect their responses
and summarize the useful findings, disagreements, and recommended next steps.

Do not wait idle. When a result arrives, verify its findings at once and
decide what to fix while the other delegates run. Code-review delegates work
in their own worktrees, so you may fix findings meanwhile. Otherwise, do not
edit files while a delegate still reviews the same checkout. If the user's
instructions mark a delegate as non-blocking, do not wait for it; treat a
late result as feedback and do not record its score.

For a code review, agents do all of the verification; none of it falls to
the user. Start each delegate with `isolation: "worktree"` at the head under
review, so it can write and run repro tests without touching your checkout.
The worktree starts from your commit, so commit the implementation first, or
give the delegate the diff to apply. Add this to each brief:

> Prove each finding with a run against the real code in your worktree: a
> failing test, a repro script, or a command. Report the exact command, the
> output it printed, and the output the intent requires. Mark a finding you
> could not prove `unverified`.

Rerun each proven finding's command before fixing it. Prove or disprove each
unverified finding yourself, or send it back to the delegate that raised it.
Never hand one to the user to judge. Drop disproved findings, with the reason
in the summary.

For a code review, ask each delegate for a score out of 10.
Count each full review pass as one round.
A fresh review after fixes starts a new round.

If the work ends in a pull request, put the results in the PR description.
Put this section before the `[!NOTE]` attribution at the end (see `file-pr`):

```markdown
## Council review

Rounds: 2

| Delegate | Round 1 | Round 2 |
| --- | --- | --- |
| GPT 6.1 Sol | 8/10 | 10/10 |
| Claude Opus 5.5 | 7/10 | 9/10 |
| Claude Fable 5.2 | 7/10 | 9/10 |
```

If a delegate gives no score, write `no score`. Do not invent one.
If the PR is open, edit the description. Do not post a comment for this.
If there is no PR, put the same results in the final reply only.

If you agree with their recommendations, make the changes and request a fresh
review after. Continue this process until all delegates are satisfied with the
outcome.

Do not let repeated reviews result in scope creep. It is your job to fight to
keep scope limited.
