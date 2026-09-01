# dotfiles

Personal machine configuration, symlinked into place by `setup.sh`.

## What's here

| Path | Symlinks to | Purpose |
|------|-------------|---------|
| `nvim/` | `~/.config/nvim` | Neovim config (LazyVim); plugins bootstrap on first launch |
| `tmux/.tmux.conf` | `~/.tmux.conf` | tmux config |
| `git/.gitconfig` | `~/.gitconfig` | git config + aliases |
| `zsh/.zshrc` | `~/.zshrc` | zsh / oh-my-zsh config |
| `iterm/com.googlecode.iterm2.plist` | — | iTerm2 preferences (import via iTerm settings) |
| `ctags/.ctags` | `~/.ctags` | ctags config |
| `helpers/` | — | git helper scripts referenced by `.gitconfig` aliases |
| `claude/settings.json` | `~/.claude/settings.json` | Claude Code global settings (model, theme, status line) |
| `claude/statusline-command.sh` | `~/.claude/statusline-command.sh` | Claude Code status line script (dir, branch, model, ctx) |
| `claude/circleback-daily-sync.sh` | `~/.claude/circleback-daily-sync.sh` | Headless Claude job that syncs Circleback meeting notes |
| `claude/skills/tmux-split` | `~/.claude/skills/tmux-split` | Claude Code skill: `/tmux-split` opens a tmux pane in the active worktree |
| `features/` | — | Longer write-ups of the shell/Claude helpers ([index](#features)) |

## Install

```
bash <(curl -s https://raw.githubusercontent.com/udnisap/dotfiles/master/setup.sh)
```

`setup.sh` prompts before creating each symlink. See [install.md](install.md)
for prerequisites (Homebrew, Neovim, tmux, nvm, etc.).

## Neovim (LazyVim)

The `nvim/` directory is a [LazyVim](https://www.lazyvim.org/) setup. On the
first `nvim` launch, lazy.nvim installs all plugins pinned in
`nvim/lazy-lock.json`, and Mason installs the configured tools (`stylua`,
`shfmt`, `tree-sitter` CLI). No manual install step is required.

## Claude Code

The `claude/` directory holds hand-authored Claude Code config that lives under
`~/.claude`. Runtime data (`projects/`, `jobs/`, `sessions/`, `telemetry/`,
caches, `history.jsonl`, etc.) is intentionally **not** tracked.

- **`/tmux-split` skill** — run `/tmux-split` from Claude Code (inside tmux) to
  open a split pane `cd`'d into the directory Claude is currently working in
  (its active git worktree), so you can code in tmux alongside it. Say "down" or
  "vertical" for a stacked split instead of side-by-side.
- **status line** — `statusline-command.sh` renders dir, git branch, model, and
  remaining context; wired up via `settings.json`.

## Features

Longer write-ups for things that need more than a table row live in
[`features/`](features/):

| Doc | What it covers |
|---|---|
| [`cs-ch-aliases.md`](features/cs-ch-aliases.md) | `cs` / `ch` — say what you want in plain English, get a shell command, confirm before it runs. Includes the Handy dictation workflow. |

## Shell helpers (`zsh/.zshrc`)

- **`cc`** — fetches latest remote refs, then opens the Claude agents picker.
- **`cs` / `ch`** — ask Claude in plain English for a *single shell command*,
  then confirm before it runs. Nothing executes until you press a key. See
  [`features/cs-ch-aliases.md`](features/cs-ch-aliases.md) for the full write-up.

  ```
  $ cs list the folder localhost:3000 is running on

    lsof -i :3000 -t | xargs -I{} lsof -p {} | awk '$4=="cwd" {print $NF}'

  Run? [Y/e/x/n]
  ```
