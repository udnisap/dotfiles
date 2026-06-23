#!/bin/bash
# Circleback daily meeting-note sync for the Cut+Dry Obsidian vault.
# Runs Claude Code headless to import the last 2 days of meetings into
# Circleback/YYYY-MM-DD/ per .cursor/rules/circleback-meeting-sync.mdc,
# then auto-commits any new notes locally (no push).
#
# Scheduled by ~/Library/LaunchAgents/com.cutanddry.circleback-sync.plist (daily 18:00 local).
set -uo pipefail

# launchd runs with a minimal environment — set PATH explicitly so both
# `claude` (~/.local/bin) and `circleback` (/opt/homebrew/bin) resolve.
export PATH="/Users/udnisap/.local/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

VAULT="/Users/udnisap/Documents/Notes/CD"
LOG_DIR="/Users/udnisap/.claude/logs"
mkdir -p "$LOG_DIR"

cd "$VAULT" || { echo "$(date) vault not found: $VAULT" >> "$LOG_DIR/circleback-sync.err"; exit 1; }

echo "===== $(date) starting circleback sync =====" >> "$LOG_DIR/circleback-sync.log"

PROMPT='Sync Circleback meetings from the last 2 days into the Circleback/YYYY-MM-DD/ folders, following the format and rules in .cursor/rules/circleback-meeting-sync.mdc exactly. Use the circleback CLI (circleback meetings search --last 2 --json, paginating until empty; circleback meetings read <id> --json; circleback transcripts read <id> --json). Do NOT overwrite notes that already exist (skip meetings already synced). Skip notetaker/recorder bots. Wikilink attendees who have a note under People/ (match by filename without .md). Only write the note files — do NOT run any git commands.'

# Run headless with a SCOPED allowlist (not --dangerously-skip-permissions):
# only the circleback CLI and read/write file tools are permitted. The script
# — not Claude — performs the git commit below, so git is intentionally omitted.
# Any tool outside this list is denied (in -p mode, denied tools fail silently
# rather than prompting), keeping the unattended run inside tight guardrails.
claude -p "$PROMPT" \
  --model sonnet \
  --permission-mode acceptEdits \
  --allowedTools "Bash(circleback:*)" Read Write Edit Glob Grep \
  >> "$LOG_DIR/circleback-sync.log" 2>> "$LOG_DIR/circleback-sync.err"

# Auto-commit any new/changed Circleback notes (local only, no push).
if [ -n "$(git status --porcelain Circleback)" ]; then
  git add Circleback
  git commit -m "Circleback daily sync $(date +%m/%d/%y)" >> "$LOG_DIR/circleback-sync.log" 2>&1
  echo "$(date) committed new Circleback notes" >> "$LOG_DIR/circleback-sync.log"
else
  echo "$(date) no new Circleback notes to commit" >> "$LOG_DIR/circleback-sync.log"
fi
