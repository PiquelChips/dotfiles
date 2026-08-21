The most important thing you should remember when architecting software
and writing code is simplicity. Keep everything as simple as possible.
Don’t add complexity just because it looks architecturally impressive.

Also, when I ask you to build something, make sure it works. If you are
unable to confirm that it works please tell me. Don't tell me "it's all good"
just for me to test in & get a 500 or something.

#### Coding Preferences

**General**:

- Avoid code duplication, even with tiny functions.
- Keep things simple.
- Avoid random independent functions. If a function could be a method on a struct, it should be.
- Writing too much code makes code unclear & hard to maintain. For example, if every endpoint needs the same check, have the check run before the endpoint (like in middleware).
- Comments are a great way to clarify functionality & how code is used. Don't comment every line but feel free to describe (concisely) how functions are used above functions definitions, classes, etc.
- Keep comments & documentation up to date when you make changes.
- Rust is my preferred language.

**Rust**:

- Make full use of the type system. It is extremely powerful. Express as much of the logic in types as possible.
- Use macros where appropriate, notably for repetitive boilerplate.
- Prefer compile time validation over runtime checks.
- The compiler is your friend, work with it. Not against it.
- Only use `#[allow(...)]` syntax if absolutely necessary. Make sure to document why.
- Errors should be propagated as appropriate. Do not discard error detail. Having context & detail for
  every error makes debugging & testing a lot easier. Use thiserror & anyhow to their full potential.

**Testing**:

Tests are good! Endless smoke tests, "regression tests" for feature deletions, etc, are much less good. Tests should be focused.

When choosing the tech stack for a project, make sure to use the `tech-stack` skill.

Also, don't just run tests every time you make a change, it's a waste of time.
Only run code that you have changed.

#### Pull Requests

- Make sure titles follow conventions from the repo. They should be simple and easy to understand. Conventional commit styles in projects that use them, i.e. "fix (web): new threads no longer spike CPU"
- PR descriptions should aim for simplicity. Open with a minimal, clear description of the problem. Follow up with how you solved it.
- Rebase onto latest main before opening. Stale branches conflict and waste a review round.
- Add a blurb to the end of the PR description/comments about what model and harness is writing/making the changes.

- Review bots are helpful, even if they are not always right.
- Verify every bot finding against the source before changing code.
- If a review bot leaves feedback you believe is not worth addressing, reply and resolve the comment.
