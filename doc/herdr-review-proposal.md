# Herdr -> changes -> Herdr

Research checked 2026-10-10. The first launcher is installed; checkpoint and
agent-only review remain a design proposal.

## CodeDiff versus Diffview.nvim

| Concern | CodeDiff | Original Diffview.nvim |
| --- | --- | --- |
| Diff display | Own native diff engine, changed-word highlighting, side-by-side and inline | Neovim's built-in diff mode with configurable layouts |
| Reviewing a changing checkout | Documents live repository synchronization | Documents index watching and manual refresh |
| History | Commit history, ranges, file and selected-line history | Detailed file history, commit filters and line evolution |
| Conflicts | Three-way merge UI | Three-way, four-way and other merge layouts |
| jj | Supported by the jj.nvim backend we already use | Also supported by jj.nvim |
| Maintenance | Latest main commit September 15, 2026 | Latest original main commit June 13, 2024 |

Keep CodeDiff for this setup: its inline view suits narrow Herdr panes and it is
already integrated with our jj mappings. Diffview's history interface is useful,
but adding it would duplicate the main review workflow. A dated last commit does
not by itself establish formal deprecation; the original repo is still public.

Sources: [CodeDiff docs](https://github.com/esmuellert/codediff.nvim),
[Diffview docs](https://github.com/sindrets/diffview.nvim),
[CodeDiff latest commit](https://github.com/esmuellert/codediff.nvim/commit/09d9ebef2cc5a5c04db7a349cd6c61bdf84ecc8e),
[Diffview latest commit](https://github.com/sindrets/diffview.nvim/commit/4516612fe98ff56ae0415a259ff6361a89419b0a).

## What is available now

Your Neovim commands are in [the shortcut guide](shortcuts.md). Use ,jd to open
the current jj change, ,jf for the current file and ,jm for the comparison with
main. For a specific revision, open ,jl, move to it and press D (Shift-d).
In a diff: ]c/[c, ]f/[f, t, gf, g? and q are the main review controls.

The upstream [herdr-nvim documentation](https://github.com/jtnovellis/herdr-nvim)
already describes these Herdr actions:

```sh
herdr plugin action invoke toggle --plugin herdr-nvim
herdr plugin action invoke open --plugin herdr-nvim
herdr plugin action invoke pick-file --plugin herdr-nvim
```

The first two show/focus the managed Neovim sidebar; the last opens its file
picker, prioritizing files touched in the agent session. Upstream suggests
prefix+e and prefix+f bindings, but these are not configured in David's current
Herdr keymap. His prefix is Ctrl-a. These commands are sidebar/file entrypoints,
not an existing one-command CodeDiff launcher. We currently use an ordinary
Neovim pane with watched reloads and Ctrl-h/j/k/l navigation.

herdr-nvim can queue code annotations and send them back to an agent. Its
documented transcript-based edit/reply support is Claude Code and pi. Repository
diffs remain useful for other agents, but touched-file lists and edit marks
should not be promised universally.

## Installed first version: open review and return

The local david.review plugin provides the "Review checkout changes / return
to agent" action, bound to Ctrl-a r. Resize mode moves to Ctrl-a Shift+z.

1. Capture the invoking pane and its actual checkout, agent and session.
2. Open or reuse a review editor for that source pane/checkout. Wide source
   panes split right, narrow ones down; below 100 editor columns use inline.
3. Compare current jj work with @-, or Git-only work with HEAD. Existing ,jm,
   ,jl and other Neovim mappings remain available for other review scopes.
4. Target questions and batch annotations at the invoking agent. gf opens the
   real file; ,aa queues, ,ap previews and ,aS submits on request. ,at explicitly
   retargets; a missing or replaced session blocks sending and keeps comments.
5. Ctrl-a r from review, ,ab or :HerdrReviewReturn focuses the recorded source
   pane. q closing CodeDiff also returns. The editor, unsaved edits and comments
   survive; reopening review reuses the editor and recreates a closed diff.

Sources live in the Herdr package's local-plugins/review directory and Neovim's
lua/config/herdr_review.lua. Startup activates the adapter only in its dedicated
review pane. No prompts are sent by opening or leaving review. Requiring .git
in the checkout excludes non-colocated jj workspaces in this first version.
Review shows checkout changes, including other agents and manual edits; it is
not an attribution mechanism. A file filter would not isolate individual authors.

## Later: a specific change or moment in time

A specific recorded jj revision can already be reviewed. A jj change ID names
a change that may be rewritten; a commit ID identifies a particular snapshot.
Use the latter when the review must remain reproducible.

For "since this agent started" or "up to 14:30", record checkpoints containing
the agent/session identity, checkout, timestamp, jj commit ID and operation ID.
Offer a picker for checkpoint-to-current or checkpoint-to-checkpoint review.
The time selects recorded checkpoints; it cannot reconstruct arbitrary unsaved
or never-snapshotted content. Accurate agent-only review also needs separate
checkouts or reliable edit provenance when agents share files.

Checkpoint capture, operation-history lookup and agent-only filtering are
explicitly deferred. The launcher does not create changes, commits or bookmarks.
Opening a jj review queries jj normally, snapshotting current working-copy edits
so the review reflects current work.
