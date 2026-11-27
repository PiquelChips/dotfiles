# Search notes

Search lets a user find notes by title or body text, inspect a matching note, and distinguish no matches from an unavailable search.

## Sub-features

- `search-open` opens search from each supported browser entry point.
- `search-match` returns title and body matches without changing note data.
- `search-open-result` opens a result in the note editor.
- `search-empty` shows a complete empty state for a query with no matches.
- `search-clear` removes the query and restores the recent-notes view.
- `search-cli` returns the same matching notes from the terminal.

## How to get to it (user POV)

- Choose the `Search` button in the browser toolbar.
- Press `/` in the browser while focus is outside an editable field.
- Run `notes search <query>` in a terminal.

## Driving it with preview tools

Preconditions:

- Notes is healthy on port `4173`, open in a preview tab.
- The disposable data directory contains `Quarterly plan` with body text `Draft budget`.
- `scripts/doctor` reports the expected port and data directory.

- **Toolbar entry.** Choose the `Search` button. `preview_act` `click` on button `Search`. A dialog named `Search notes` appears with focus in its searchbox.
- **Keyboard entry.** Close the dialog, focus the page, and press `/`. `preview_act` `press` with key `/`. The same dialog appears and the page does not insert a slash.
- **Title match.** Type `quarterly`. `preview_act` `type` `quarterly` into searchbox `Search notes`, then `preview_wait_for` text `Quarterly plan`. The `Search results` list contains `Quarterly plan` and does not contain `Grocery list`.
- **Body match.** Replace the query with `budget`. `preview_act` `type` with `clear: true` `budget` into searchbox `Search notes`. The result `Quarterly plan` remains visible with a body-match excerpt.
- **Open result.** Choose `Quarterly plan`. `preview_act` `click` on link `Quarterly plan`. The dialog closes and the editor heading reads `Quarterly plan`.
- **Empty state.** Reopen search and enter `volcano`. `preview_act` `type` `volcano` into searchbox `Search notes`, then `preview_wait_for` text `No matching notes`.
- **Clear query.** Choose `Clear search`. `preview_act` `click` on button `Clear search`. The searchbox is empty and the `Recent notes` region replaces the result list.
- **CLI match.** Search from the terminal. Run `notes search "quarterly" --format json`. Exit code `0` and stdout contain one object whose title is `Quarterly plan`.
- **CLI miss.** Search for an absent value. Run `notes search "volcano" --format json`. Exit code `0` and stdout are `[]`.
- **Proof.** Capture the populated result state. Save the `preview_snapshot` accessibility tree to `artifacts/search/results.aria.txt`, and copy the screenshot from `preview_snapshot` with `save: true` to `artifacts/search/results.png`. Both artifacts identify Notes, the query, and `Quarterly plan`.

## Gotchas

- Pressing `/` while the editor or searchbox has focus inserts text instead of opening search.
- Results update after a short debounce. Wait for the results list or empty status with `preview_wait_for`, not a fixed sleep.
- Archived notes are excluded unless the user enables `Include archived`.
- The CLI defaults to human-readable output. Use `--format json` for stable assertions.
- Opening a result changes browser state. Reopen search before proving another query.
