#!/bin/bash
# Open a tmux split (or window) in the current working directory, so the user
# can code in tmux right next to Claude Code.
#
# Usage: tmux-split.sh [orientation]
#   (default) | right | horizontal | -h  -> side-by-side split
#   down | vertical | below | -v         -> stacked split
#   window | new-window | -w             -> new window
#
# Works both inside a tmux pane ($TMUX set) and from a detached process such as
# a Claude Code background job ($TMUX empty): in the latter case it detects the
# server via `tmux ls` and targets the active pane of the attached session's
# active window (a session-only -t resolves to the wrong window).

set -euo pipefail

case "${1:-}" in
  ""|right|horizontal|-h)      split=(split-window -d -h) ;;
  down|vertical|below|-v)      split=(split-window -d -v) ;;
  window|new-window|-w)        split=(new-window -d) ;;
  *) echo "Unknown orientation: $1 (use right|down|window)" >&2; exit 2 ;;
esac

dir="$(pwd)"

if [ -n "${TMUX:-}" ]; then
  # Inside a tmux pane: act on the current pane directly.
  tmux "${split[@]}" -c "$dir"
  echo "Opened tmux pane in: $dir"
elif tmux ls >/dev/null 2>&1; then
  # No $TMUX (e.g. background job): find the attached session, else the first.
  sess="$(tmux ls -F '#{session_name} #{session_attached}' 2>/dev/null \
    | awk '$2>0 {print $1; exit}')"
  [ -z "$sess" ] && sess="$(tmux ls -F '#{session_name}' 2>/dev/null | head -1)"
  # Target the ACTIVE pane of the ACTIVE window — where the user is looking.
  pane="$(tmux list-panes -s -t "$sess" \
    -f '#{&&:#{window_active},#{pane_active}}' -F '#{pane_id}' 2>/dev/null | head -1)"
  tmux "${split[@]}" -c "$dir" -t "$pane"
  echo "Opened tmux pane in: $dir (session $sess, next to $pane)"
else
  echo "No tmux server running — start Claude Code inside tmux to use this." >&2
  exit 1
fi
