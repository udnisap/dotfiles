#!/usr/bin/env bash
# session-status.sh — report what every active `claude agents` session is doing
# and what input it needs to unblock.
#
# Data sources:
#   - `claude agents --json`        → active sessions (blocked + working)
#   - `claude agents --json --all`  → all sessions, for summary counts
#   - ~/.claude/projects/<escaped-cwd>/<sessionId>.jsonl → persisted transcript,
#     from which we pull the first user prompt (the task) and the last assistant
#     text (what the session is waiting on).
#
# Usage: session-status.sh [--json]
#   --json   emit one JSON object per active session (for programmatic use)
set -euo pipefail

MODE="text"
[ "${1:-}" = "--json" ] && MODE="json"

command -v claude >/dev/null || { echo "claude CLI not found on PATH" >&2; exit 1; }
command -v jq >/dev/null     || { echo "jq not found on PATH" >&2; exit 1; }

PROJECTS="$HOME/.claude/projects"
NOW=$(date +%s)

active=$(claude agents --json 2>/dev/null || echo '[]')
all=$(claude agents --json --all 2>/dev/null || echo '[]')

# ---- transcript helpers -------------------------------------------------------

# Resolve a session's transcript file from its cwd + sessionId.
transcript_path() {
  local cwd="$1" sid="$2" esc tf
  esc=$(printf '%s' "$cwd" | sed 's#[/.]#-#g')
  tf="$PROJECTS/$esc/$sid.jsonl"
  if [ -f "$tf" ]; then printf '%s' "$tf"; return 0; fi
  tf=$(find "$PROJECTS" -name "$sid.jsonl" 2>/dev/null | head -1)
  printf '%s' "$tf"
}

# Collapse whitespace and truncate to $2 chars.
clean() { tr '\n\t' '  ' | sed 's/  */ /g; s/^ *//; s/ *$//' | cut -c "1-${1:-220}"; }

# First user text message in a transcript = the original task.
first_user_text() {
  local tf="$1"
  [ -n "$tf" ] && [ -f "$tf" ] || { printf '(transcript not found)'; return; }
  head -n 120 "$tf" | jq -rs '
    [ .[] | select(.message.role=="user") | .message.content
      | if type=="array" then ([.[] | select(.type=="text") | .text] | join(" "))
        elif type=="string" then . else "" end ]
    | map(select(. != "" and (startswith("<") | not)))
    | first // "(no user text)"' 2>/dev/null || printf '(unreadable)'
}

# Last assistant text message = what the session is waiting on / last said.
last_assistant_text() {
  local tf="$1"
  [ -n "$tf" ] && [ -f "$tf" ] || { printf '(transcript not found)'; return; }
  tail -n 400 "$tf" | jq -rs '
    [ .[] | select(.message.role=="assistant") | .message.content
      | if type=="array" then ([.[] | select(.type=="text") | .text] | join(" "))
        elif type=="string" then . else "" end ]
    | map(select(. != ""))
    | last // "(no assistant text)"' 2>/dev/null || printf '(unreadable)'
}

# ---- summary (all sessions) ---------------------------------------------------

total=$(printf '%s' "$all" | jq 'length')
done_n=$(printf '%s' "$all"   | jq '[.[]|select(.state=="done")]|length')
failed_n=$(printf '%s' "$all" | jq '[.[]|select(.state=="failed")]|length')
blocked_n=$(printf '%s' "$all"| jq '[.[]|select(.state=="blocked")]|length')
working_n=$(printf '%s' "$all"| jq '[.[]|select(.state=="working")]|length')

comma() { printf "%'d" "$1"; }  # locale grouping, e.g. 1,234
pct() { awk -v b="$1" -v t="$2" 'BEGIN{ if(t==0){print "0.0"} else {printf "%.1f", 100*b/t} }'; }

if [ "$MODE" = "text" ]; then
  echo "=============================================================="
  echo " Claude session status — $(date '+%m/%d/%y %H:%M')"
  echo "=============================================================="
  printf ' Total: %s   |   working: %s   blocked: %s   done: %s   failed: %s\n' \
    "$(comma "$total")" "$(comma "$working_n")" "$(comma "$blocked_n")" \
    "$(comma "$done_n")" "$(comma "$failed_n")"
  printf ' Blocked (needs input): %s of %s active (%s%%)\n' \
    "$(comma "$blocked_n")" "$(comma "$((blocked_n + working_n))")" \
    "$(pct "$blocked_n" "$((blocked_n + working_n))")"
  echo
fi

# ---- per-session detail (active only, oldest first) ---------------------------

json_out="[]"

while IFS=$'\t' read -r id sid cwd name state started; do
  [ -n "${id:-}" ] || continue
  started_s=$(( started / 1000 ))
  date_fmt=$(date -r "$started_s" '+%m/%d/%y' 2>/dev/null || echo '??/??/??')
  age_days=$(( (NOW - started_s) / 86400 ))
  repo=$(basename "$cwd")

  tf=$(transcript_path "$cwd" "$sid")
  task=$(first_user_text "$tf" | clean 200)
  waiting=$(last_assistant_text "$tf" | clean 400)

  if [ "$MODE" = "text" ]; then
    printf '● %s  [%s]  %s · %s · %sd old (%s)\n' \
      "$name" "$state" "$id" "$repo" "$age_days" "$date_fmt"
    printf '    task    : %s\n' "$task"
    printf '    waiting : %s\n' "$waiting"
    printf '    resume  : claude attach %s      stop: claude stop %s\n\n' "$id" "$id"
  else
    obj=$(jq -n \
      --arg id "$id" --arg sid "$sid" --arg cwd "$cwd" --arg repo "$repo" \
      --arg name "$name" --arg state "$state" --arg date "$date_fmt" \
      --argjson age "$age_days" --arg task "$task" --arg waiting "$waiting" \
      '{id:$id,sessionId:$sid,cwd:$cwd,repo:$repo,name:$name,state:$state,startDate:$date,ageDays:$age,task:$task,waitingOn:$waiting}')
    json_out=$(printf '%s' "$json_out" | jq --argjson o "$obj" '. + [$o]')
  fi
done < <(printf '%s' "$active" | jq -r 'sort_by(.startedAt)[] | [.id,.sessionId,.cwd,.name,.state,.startedAt] | @tsv')

[ "$MODE" = "json" ] && printf '%s\n' "$json_out"
exit 0
