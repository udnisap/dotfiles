#!/bin/sh
input=$(cat)

# Resolve display directory: show project name when inside a Cursor worktree
cwd=$(echo "$input" | jq -r '.cwd')
worktree_root="$HOME/.cursor/worktrees"
worktree_name=""
case "$cwd" in
  "$worktree_root"/*)
    rel="${cwd#$worktree_root/}"
    display_dir="${rel%%/*}"
    ;;
  */.claude/worktrees/*)
    # Claude Code worktree: show <project> and the worktree name separately
    rel="${cwd#*/.claude/worktrees/}"
    worktree_name="${rel%%/*}"
    project_path="${cwd%%/.claude/worktrees/*}"
    display_dir=$(basename "$project_path")
    ;;
  *)
    display_dir=$(basename "$cwd")
    ;;
esac

# Git branch (skip optional locks to avoid blocking)
git_branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null)

# Full working directory (collapse home to ~)
pwd_display="${cwd/#$HOME/~}"

# Model display name
model=$(echo "$input" | jq -r '.model.display_name')

# Context fill % (how full the window is = 100 - remaining)
remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')

# Build the status line
printf '\033[1;36m%s\033[0m' "$display_dir"

if [ -n "$worktree_name" ]; then
  printf ' \033[35m⌥ %s\033[0m' "$worktree_name"
fi

if [ -n "$git_branch" ]; then
  printf ' \033[33m(%s)\033[0m' "$git_branch"
fi

printf ' \033[2m%s\033[0m' "$pwd_display"

printf ' \033[2m%s\033[0m' "$model"

if [ -n "$remaining" ]; then
  fill=$(awk "BEGIN { printf \"%.1f\", 100 - $remaining }")
  printf ' \033[2mctx: %s%%\033[0m' "$fill"
fi
