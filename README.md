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
