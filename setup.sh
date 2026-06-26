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


TMPFILE=`mktemp`
PWD=`pwd`
wget "$1" -O $TMPFILE
unzip -d $PWD $TMPFILE
rm $TMPFILE


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

# LazyVim bootstraps lazy.nvim and all plugins on first launch of nvim,
# so no manual plugin install step is required.
confirm "Symlink nvim (LazyVim)" && mkdir -p ~/.config && ln -s $PWD/nvim ~/.config/nvim
confirm "Symlink tmux" && ln -s $PWD/tmux/.tmux.conf ~/.tmux.conf
confirm "Symlink git" && ln -s $PWD/git/.gitconfig ~/.gitconfig
confirm "Symlink zsh" && ln -s $PWD/zsh/.zshrc ~/.zshrc

# Claude Code user config (~/.claude). Runtime data (projects, jobs, sessions,
# caches, history) is intentionally NOT tracked — only hand-authored config.
if confirm "Symlink Claude Code config"; then
    mkdir -p ~/.claude ~/.claude/skills
    ln -s $PWD/claude/settings.json ~/.claude/settings.json
    ln -s $PWD/claude/CLAUDE.md ~/.claude/CLAUDE.md
    ln -s $PWD/claude/statusline-command.sh ~/.claude/statusline-command.sh
    ln -s $PWD/claude/circleback-daily-sync.sh ~/.claude/circleback-daily-sync.sh
    ln -s $PWD/claude/skills/tmux-split ~/.claude/skills/tmux-split
fi


