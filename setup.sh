#!/bin/bash
# Install
# apt-get install git ack-grep -y

PWD=`pwd`
platform='unknown'
unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
   platform='linux'
elif [[ "$unamestr" == 'FreeBSD' ]]; then
   platform='freebsd'
fi


# Optional bootstrap: download + unzip dotfiles from a URL passed as $1.
# Skipped on normal runs (the repo is already cloned).
if [ -n "$1" ]; then
  TMPFILE=`mktemp`
  wget "$1" -O $TMPFILE
  unzip -d $PWD $TMPFILE
  rm $TMPFILE
fi


# setup symlinks

confirm () {
    # call with a prompt string or use a default
    read -r -p "${1:-Are you sure? [Y/n]}? " response
    response=${response:-'Y'}
    case $response in
        [yY])
            true
            ;;
        *)
            false
            ;;
    esac
}

# link SRC TARGET: symlink SRC -> TARGET. If TARGET is an existing real
# file/dir (not already a symlink), back it up to TARGET.bak first. Existing
# symlinks are repointed in place, so re-running is idempotent.
link () {
    local src="$1" tgt="$2"
    if [ -e "$tgt" ] && [ ! -L "$tgt" ]; then
        mv "$tgt" "$tgt.bak" && echo "backed up $tgt -> $tgt.bak"
    fi
    ln -sfn "$src" "$tgt" && echo "linked $tgt -> $src"
}

# LazyVim bootstraps lazy.nvim and all plugins on first launch of nvim,
# so no manual plugin install step is required.
confirm "Symlink nvim (LazyVim)" && mkdir -p ~/.config && link $PWD/nvim ~/.config/nvim
confirm "Symlink tmux" && link $PWD/tmux/.tmux.conf ~/.tmux.conf
confirm "Symlink git" && link $PWD/git/.gitconfig ~/.gitconfig
confirm "Symlink zsh" && link $PWD/zsh/.zshrc ~/.zshrc

# Claude Code user config (~/.claude). Runtime data (projects, jobs, sessions,
# caches, history) is intentionally NOT tracked — only hand-authored config.
if confirm "Symlink Claude Code config"; then
    mkdir -p ~/.claude ~/.claude/commands ~/.claude/scripts
    link $PWD/claude/settings.json ~/.claude/settings.json
    link $PWD/claude/CLAUDE.md ~/.claude/CLAUDE.md
    link $PWD/claude/statusline-command.sh ~/.claude/statusline-command.sh
    link $PWD/claude/circleback-daily-sync.sh ~/.claude/circleback-daily-sync.sh
    link $PWD/claude/commands/tmux-split.md ~/.claude/commands/tmux-split.md
    link $PWD/claude/scripts/tmux-split.sh ~/.claude/scripts/tmux-split.sh
    # tmux-split moved from a skill to a command; drop the stale skill symlink.
    [ -L ~/.claude/skills/tmux-split ] && rm -f ~/.claude/skills/tmux-split
fi
