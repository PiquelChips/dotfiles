The most important thing you should remember when architecting software
and writing code is simplicity. Keep everything as simple as possible.
Don’t add complexity just because it looks architecturally impressive.
Be ambitious.

#### Scope: do what was asked, nothing more

**Scope creep is the most common way an agent's work goes wrong. Watch for
it at every step and push back on it, including when a reviewer or your own
curiosity suggests it.**

- **One task, one change.** Do the task you were given. A pull request is one
  change and holds nothing else.
- **No drive-by changes.** No refactors, renames, reformatting, dependency
  bumps, "while I'm here" fixes or extra features the task didn't ask for.
- **Found something else?** Say so in your report, or file an issue. Don't fix
  it in this change.
- **Review findings outside the change are follow-ups.** Reviewers, council
  included, report only defects in the change and regressions it causes. A
  finding about code the change doesn't touch goes to an issue, not into the
  PR.
- **Ask before widening.** If doing the task well really needs a wider change,
  stop and ask me first, and say why.
- **Check before handing back.** Reread your diff. Every hunk must be needed
  for the task; remove any that isn't.
- **Be ambitious inside the scope.** Finish the task completely and well.
  Ambition is never a reason to widen it.

#### Coding Preferences

**General**:

- Avoid code duplication, even with tiny functions.
- Keep things simple.
- Avoid random independent functions. If a function could be a method on a
  struct, it should be.
- Writing too much code makes code unclear & hard to maintain. For example,
  if every endpoint needs the same check, have the check run before the
  endpoint (like in middleware).
- Comments are a great way to clarify functionality & how code is used.
  Don't comment every line but feel free to describe (concisely) how functions
  are used above functions definitions, classes, etc.
- Keep comments & documentation up to date when you make changes.
- Keep code style & conventions consistent with already existing code.
- Rust is my preferred language.
- Do not leave "Co-authored by" notes in PR and commit descriptions.
- Make sure to use the `frontend-design` skill whenever touching anything to
  do with UI.

**Rust**:

- Make full use of the type system. It is extremely powerful. Express as much
  of the logic in types as possible.
- Use macros where appropriate, notably for repetitive boilerplate.
- Prefer compile time validation over runtime checks.
- The compiler is your friend, work with it. Not against it.
- Only use `#[allow(...)]` syntax if absolutely necessary. Make sure to document why.
- Errors should be propagated as appropriate. Do not discard error detail. Having context & detail for
  every error makes debugging & testing a lot easier. Use thiserror & anyhow to their full potential.

**Testing**:

Tests are good! Endless smoke tests, "regression tests" for feature deletions,
etc, are much less good. Tests should be focused.

When choosing the tech stack for a project, make sure to use the `tech-stack` skill.

Also, don't just run tests every time you make a change, it's a waste of time.
Only run code that you have changed.

#### Issues

piqueld and infra track issues in Linear (`sourceorigin` workspace, `PQD`
team) through the Linear MCP server: new issues go to Triage with a Type label,
and PRs say `Fixes PQD-123`. Other projects still use GitHub issues until they
move.

#### Pull Requests

Use the `file-pr`, `babysit-pr` & `leaving-pr-comments` skills for PR work.
