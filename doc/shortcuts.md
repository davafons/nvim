# Your Vim field guide

Open with ,h or :VimShortcuts, or ? on the homepage. Search this guide with /word,
then n/N for matches. Press q to return to your previous tab. Normal mode unless
a row says otherwise. Leader = comma. Ctrl-w s means Ctrl-w, then s; commas and
letters are separate keypresses. Capital letters matter.

## Learn in this order

1. Find code: ,tt / ,tg, gd / gr / K, Ctrl-o to return.
2. Review agent work: ,jd, ]c / [c, ]f / [f, gf, ,aa / ,ap / ,aS.
3. Edit with a sentence: operator + motion or text object. Repeat with a count or .
4. Use registers, the jumplist, marks and macros instead of repeated manual work.

The editing grammar is the most useful thing to learn. d deletes, c changes,
y copies, and v selects. Combine them with iw (inner word), ip (inner paragraph),
i" (inside quotes), af (a function), or a motion such as $ (end of line).
For example: ciw changes a word; di" deletes the text inside quotes; yaf copies
a function; 3dd deletes three lines; . repeats your last change. Operators also
work with /search followed by Enter. Practice on a scratch file.

## Files, projects and buffers

| Keys / command | What it does |
| --- | --- |
| ,e | Toggle nvim-tree; your only global tree shortcut |
| ,tt | Find files in the current file's nearest jj/Git project |
| ,tg | Search text in that project |
| ,tb | Find open buffers |
| ,tr | Find recently opened files, across projects |
| ,tp | Choose a recent project, change directory and open its file picker |
| ,ts / ,tS | Find file / workspace symbols, when an LSP is attached |
| Ctrl-^ | Alternate between the current and previous buffer (often Ctrl-6) |
| :bnext / :bprevious | Next / previous buffer |
| :buffer name | Switch to a buffer; Tab completes names |
| ,bd | Delete the current buffer; confirm if it has unsaved changes |
| :edit path | Open a file; Tab completes the path |
| :pwd | Show the current working directory |

File/text search uses the current regular file's repository root without changing
your working directory. In an empty or special buffer it uses the current
directory's root; outside a repository it falls back to the current directory.
Nested Git repositories take precedence over an enclosing jj repository.

In fzf-lua, type to filter; Up/Down move, Enter opens, Esc cancels. Ctrl-j/k and
Ctrl-n/p are also picker controls. In nvim-tree, Enter/o opens, a creates,
r renames, d deletes (with confirmation), R refreshes, and ? opens tree help.

## Movement, search and returning

| Keys | What it does |
| --- | --- |
| h / j / k / l | Left / down / up / right; j/k follow displayed wrapped lines |
| w / b / e | Next word / previous word / end of word |
| W / B / E | Same, with whitespace-separated words |
| 0 / ^ / $ | Start of line / first nonblank / end of line |
| f{char} / F{char} | Find character forward / backward on the line |
| t{char} / T{char} | Move just before that character forward / backward |
| ; / , | Repeat / reverse the character search (comma also starts your leader) |
| gg / G / 42G | Top / bottom / line 42 |
| { / } | Previous / next paragraph |
| % | Matching bracket or other match supported by the filetype |
| Ctrl-d / Ctrl-u | Half a screen down / up |
| Ctrl-f / Ctrl-b | A screen down / up |
| zz / zt / zb | Put the cursor line in the center / top / bottom of the window |
| /text then Enter | Search forward; ?text searches backward |
| n / N | Next / previous search match |
| * / # | Search forward / backward for the word under the cursor |
| ,Space | Clear search highlighting |
| Ctrl-o / Ctrl-i | Older / newer position in the jumplist |
| ma then 'a | Set mark a, then return to its line; backtick-a returns to its column |
| mA then 'A | A capital mark can take you to another file |

## Reading code with LSP and Treesitter

| Keys | What it does |
| --- | --- |
| K | Hover documentation |
| gd / gD | Definition / declaration |
| gi / go / gr | Implementation / type definition / references |
| gs | Signature help |
| F2 / F4 | Rename symbol / code actions |
| ,df | Show diagnostics for this line |
| ,xx / ,xX | Project / current-buffer diagnostic list |
| ,xq | Quickfix list in Trouble |
| ]m / [m | Next / previous function start |
| ]M / [M | Next / previous function end |
| ]] / [[ | Next / previous class start |
| af / if | Outer / inner function text object, after an operator or in visual mode |
| ac / ic | Outer / inner class text object |
| aa / ia | Outer / inner parameter text object |
| zo / zc / za | Open / close / toggle the fold under the cursor |
| zR / zM | Open / close all folds |

LSP keys appear only in attached buffers. Treesitter text objects require a
language parser with the relevant queries. Function/class selections use whole
lines. Diagnostics and code actions follow the project's tools and rules.

## Review changes: jj and CodeDiff

CodeDiff shows the old and new versions of code, with changed lines and words
highlighted. Your jj mappings translate jj revisions into Git-backed diffs.
They show repository changes; they do not attribute every hunk to one agent.

| Keys / command | What it does |
| --- | --- |
| ,jd | Review the current jj change, @, against its parent |
| ,jf | Compare the current file with the jj parent, @- |
| ,jm | Compare current work with main (direct comparison, not a merge-base calculation) |
| ,jl / ,js | jj change log / status |
| D in the jj log | Open the diff for the revision under the cursor (Shift-d) |
| :Jdiff REV | Compare the current file with a particular jj revision or change ID |
| :CodeDiff | Open the live repository status/diff view |
| :CodeDiff --inline | Start a repository review in an inline view |
| :CodeDiff BASE TARGET | Compare two Git commit IDs or refs; jj change IDs need the jj interface |
| :CodeDiff history | Browse Git commit history; this is not jj's operation log |
| :CodeDiff history % | Browse history for the current file |
| :CodeDiff file before.txt after.txt | Compare two files without version control |
| ]c / [c | Next / previous hunk inside a CodeDiff view |
| ]f / [f | Next / previous changed file inside a CodeDiff view |
| t | Toggle side-by-side / inline inside CodeDiff |
| ih | Hunk text object inside CodeDiff, e.g. vih selects a hunk |
| gf | Open the real file in the previous Neovim tab to inspect or annotate it |
| ,b | Toggle CodeDiff's changed-file panel inside a CodeDiff view |
| g? | Show the active CodeDiff keybindings |
| q | Close the CodeDiff tab |

Side-by-side is the default; inline fits narrow Herdr panes. These reviews need
a Git-backed repository. Git staging, discard and transfer shortcuts are
disabled in your config. Use jj in the shell for version-control changes.
In particular, use your checked jj push alias when publishing.

## Herdr: code to agent and back

In Herdr, Ctrl-a then r opens a checkout review beside the invoking pane.
Press it again from the review pane to return. The editor keeps your files,
unsaved edits and comments. Narrow review panes start inline; t changes layout.
This feature needs the local david.review Herdr plugin and .git in the checkout.

| Keys / command | What it does |
| --- | --- |
| Ctrl-h / Ctrl-j / Ctrl-k / Ctrl-l | Navigate Neovim splits, then adjacent Herdr panes, in normal mode |
| ,at | Choose the agent for questions and review comments |
| ,ab / :HerdrReviewReturn | Return to the source pane from a managed checkout review |
| :HerdrReviewOpen | Reopen current checkout changes in that review editor |
| ,ac | Compose a question about the current line or visual selection |
| ,ar | Compose a follow-up for that agent |
| ,aa | Queue a review comment on the current line or visual selection |
| ,al | List queued comments and jump to their locations |
| ,ap | Preview the combined review prompt before sending |
| ,aS | Send queued comments to the selected agent; this submits the prompt |
| ]r / [r | Next / previous agent edit tracked by herdr-nvim |
| ,ak | Mark the tracked edit reviewed; this clears its review mark |
| :HerdrPickFile | Pick a file mentioned or touched by agents |
| :HerdrClear | Clear queued annotations |
| :checkhealth herdr-nvim | Check the companion binary and Herdr integration |

Review loop: ,jd -> ]c and ]f -> gf on a suspicious change -> ,aa -> ,ap -> ,aS.
Use ,ac for a question about one place. Questions and comments keep focus here;
Ctrl-h/j/k/l lets you return to the agent pane when it is adjacent. Normal-mode
navigation does not replace completion or terminal-mode controls.

In a managed review, questions and comments target the invoking agent. A missing
agent or changed reported session refuses sending and preserves comments; ,at explicitly
selects the current/new target. Closing CodeDiff with q also returns to the source
pane. The editor survives; Ctrl-a r reuses it.

Tracked edits depend on supported agent transcripts. The pinned herdr-nvim docs
list Claude Code and pi for transcript-based replies/edits; do not assume Codex
or shell edits will create ]r marks. CodeDiff still shows repository changes.
Marking an edit reviewed is different from recording it in jj. Agent-only
attribution and historical checkpoints remain deferred.

## Editing without fighting Vim

| Keys | What it does |
| --- | --- |
| i / a / I / A | Insert before / after cursor, first nonblank / end of line |
| o / O | Open a line below / above and enter insert mode |
| Esc / Ctrl-[ | Return to normal mode; Ctrl-C keeps its native behavior |
| ciw / caw | Change inner word / word including surrounding whitespace |
| ci" / ci( / ci{ | Change inside quotes / parentheses / braces |
| di" / dip / daf | Delete inside quotes / paragraph / a function |
| dt{char} / d$ | Delete up to a character / to end of line |
| dd / yy / cc | Delete / copy / change the current line |
| 3dd / 3yy | Delete / copy three lines |
| p / P | Paste after / before; ordinary copies use Vim registers |
| . | Repeat the last change; a count can change its scope |
| u / Ctrl-r | Undo / redo |
| g- / g+ | Earlier / later state across undo branches |
| v / V / Ctrl-v | Character / line / block selection |
| gv | Reselect the last visual selection |
| > / < in visual mode | Indent / unindent the selection |
| >> / << / == | Indent / unindent / reindent a line; = uses the language indent rules |
| J | Join the next line with this one |
| gcc / gc | Comment a line / comment a selection or motion |
| sa{motion}{surround} | Add a surround: saiw" puts quotes around a word |
| sd{surround} | Delete a surround: sd" removes surrounding quotes |
| sr{old}{new} | Replace a surround: sr"' changes double quotes to single quotes |

Automatic bracket/quote pairing and HTML/Vue/Svelte closing tags work in insert
mode. Saving is explicit; textwidth can wrap newly typed text in some contexts,
while screen wrapping itself does not alter existing file content.

## Registers, macros and substitutions

| Keys / command | What it does |
| --- | --- |
| ,y{motion} / ,y in visual mode | Copy a motion / selection to the system clipboard |
| ,Y | Copy the line to the system clipboard |
| ,p in visual mode | Replace the selection while preserving your yank register |
| "0p | Paste the last yank even after deleting other text |
| "ayy / "ap | Copy a line to register a / paste from it |
| "_d{motion} | Delete without changing your useful registers |
| :registers | Inspect registers |
| qa ... q | Record keys into macro a; q stops recording |
| @a / @@ / 5@a | Run macro a / repeat the last macro / run it five times |
| :%s/old/new/gc | Replace through the file, confirming each occurrence |
| Visual selection then :s/old/new/gc | Replace only selected lines, with confirmation |
| :cnext / :cprevious | Navigate quickfix results |

Start a macro from a repeatable position, make one complete edit, and move to
the next target before ending it. Try it once before using a large count.

## Splits, saving and sessions

| Keys / command | What it does |
| --- | --- |
| Ctrl-w s / Ctrl-w v | Create a horizontal / vertical split |
| Ctrl-w h/j/k/l | Native movement between Neovim windows |
| Ctrl-w Ctrl-h/j/k/l | Move the window itself left / down / up / right |
| Ctrl-w = | Balance split sizes |
| Ctrl-arrow keys | Resize a split by two columns or rows |
| Ctrl-w c / Ctrl-w o | Close this window / keep only this window |
| gt / gT | Next / previous Neovim tab |
| :write / :wall | Save the current file / all modified files |
| :quit / :qall | Close this window / quit Neovim; confirm unsaved changes |
| :wq | Save and close this window |
| :q! | Discard unsaved changes when the buffer is abandoned; use deliberately |
| ,qs / ,qS | Restore this directory's session / choose a saved session |
| ,ql / ,qd | Restore the last session / stop session saving |

Sessions restore only when requested. They are keyed by the working directory;
choose the project with ,tp first if needed. Persistent undo keeps 10,000 levels.

## Rails, completion, tools and help

| Keys / command | What it does |
| --- | --- |
| ,ra / ,rr | Rails alternate / related file (:A / :R) |
| ,rm / ,rc / ,rv | Start model / controller / view lookup; type the name and Enter |
| Ctrl-Space in insert mode | Show completion or its documentation |
| Up / Down in a completion menu | Select an item; nothing is preselected |
| Enter with an item selected | Accept the completion; otherwise insert a newline |
| Ctrl-e in insert mode | Cancel completion |
| Tab / Shift-Tab in a snippet | Next / previous snippet placeholder |
| ,cf / ,cl | Format explicitly / run extra linters |
| :ConformInfo | Inspect formatters for this buffer |
| :checkhealth vim.lsp | Inspect LSP status |
| :Mason / :InstallTools | Manage language servers / install selected formatting-linting tools |
| :Lazy | Inspect plugins and their pinned versions |
| ,mp | Toggle in-editor Markdown rendering |
| ]t / [t / ,tT | Next TODO / previous TODO / find TODOs |
| ,xt | TODO results in Trouble |
| ,? | Which-key: bindings for the current buffer |
| Comma then pause | Which-key: discover your leader groups |
| :help motion / :help text-objects | Learn the native movement / text-object grammar |
| :help user-manual / :Tutor | Native Vim manual / interactive practice |
| :verbose nmap KEY | See who defined a normal-mode mapping; :imap for insert mode |

Formatting follows repository tooling. No save-time formatting or LSP fallback;
in particular, Nadeshiko's Vue formatting stays disabled by its Biome config.
Tests, debugger workflows and agent execution belong in Herdr.
