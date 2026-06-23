---
name: tmux-split
description: Open a new tmux split pane cd'd into Claude Code's current working directory (the active worktree), so the user can quickly code in tmux alongside Claude. Use when the user asks to open a pane/terminal/shell in the dir Claude is working in, or to "code in tmux".
---

# tmux-split

Open a tmux split pane in the directory Claude Code is currently working in (its
cwd — typically the active git worktree), so the user can code in tmux right next
to Claude.

## What to do

1. Determine the split orientation from the user's request:
   - default / "right" / "horizontal" → side-by-side (`-h`)
   - "down" / "vertical" / "below" → stacked (`-v`)
   - if they ask for a new window instead of a split, use `new-window`.
2. Run the command below (adjust `SPLIT` to `-h` or `-v`, or swap in
   `new-window`). It opens the pane in Claude's current working directory and
   keeps focus in the Claude pane so the session isn't interrupted.

```bash
if [ -z "$TMUX" ]; then
  echo "Not inside a tmux session — start Claude Code inside tmux to use this." >&2
  exit 1
fi
dir="$(pwd)"
# SPLIT: -h = side-by-side, -v = stacked. -d keeps focus on the Claude pane.
tmux split-window -d -h -c "$dir"
echo "Opened tmux split pane in: $dir"
```

3. Report which directory the new pane opened in.

## Notes

- The pane inherits Claude Code's cwd via `pwd`, so it lands in whatever
  worktree Claude is operating in — no need to look the path up separately.
- Drop the `-d` flag if the user wants focus to move to the new pane.
