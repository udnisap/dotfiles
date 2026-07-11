---
name: session-status
description: Report the status of all active `claude agents` background sessions — what each is working on and what input it needs to unblock — and optionally stop stale ones. Use when the user asks "what are my sessions/agents doing", "what's blocked", "which sessions need input", "status of my claude agents", or wants to triage the FleetView backlog.
---

# session-status

Give the user a consolidated readout of every active `claude agents` (FleetView)
background session: what each one was doing and, crucially, **what input it needs
to move forward**. FleetView sessions are peers with no cross-session control, so
this is a reporting/triage tool, not an orchestrator.

## What to do

1. Run the helper script (it reads each session's transcript, so it may take a few
   seconds when there are many sessions):

   ```bash
   ~/.claude/skills/session-status/session-status.sh
   ```

   Prefer `--json` if you want to sort/filter/group the data yourself before
   presenting:

   ```bash
   ~/.claude/skills/session-status/session-status.sh --json
   ```

   The script derives its data from `claude agents --json` (active sessions) plus
   each session's persisted transcript under `~/.claude/projects/`. `claude logs`
   is deliberately **not** used — it only works while a session's process is still
   alive and returns raw ANSI, so it's unreliable here.

2. Present a scannable report, **oldest first**:
   - Lead with the summary line: total, and counts of working / blocked / done /
     failed, plus the blocked share as a one-decimal percentage.
   - One block per active session: **name · id · repo · age (start date)**, then a
     one-line **task** and a one-line **waiting on**.
   - Call out the stalest sessions (largest age) and any that look truly stuck.
   - Note when a "blocked" session's last message is actually a completed result
     (contains `result:`) or an error (e.g. "API Error", "Connection closed") —
     these are parked/finished, not waiting on a real decision, and are safe
     candidates to stop.

3. **Formatting** (org rules): dates as `MM/DD/YY`, thousands separators in
   numbers, percentages to one decimal place.

## Offer to act

After the report, offer to help clear the backlog — but **never run a mutating
command without explicit confirmation**:

- **Stop** sessions the user no longer wants: `claude stop <id>` (the conversation
  is kept and can be resumed later). Confirm which ids first; only then run.
- **Resume** a session: print `claude attach <id>` for the user to run in their
  own terminal. `attach` is interactive and cannot run inside this session.

Suggest concrete cleanup (e.g. "these 6 finished sessions are still marked
blocked — stop them?") rather than asking open-endedly.

## Notes

- `session-status.sh --json` emits one object per active session
  (`id, sessionId, cwd, repo, name, state, startDate, ageDays, task, waitingOn`)
  for programmatic use.
- The "waiting on" text is the session's **last assistant message**; "task" is its
  **first user message**. Both are truncated — attach to the session for full
  context.
