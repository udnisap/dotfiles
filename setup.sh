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

# Claude Code user config (~/.claude). Only settings.json is tracked here;
# runtime data (projects, jobs, sessions, etc.) stays local and untracked.
confirm "Symlink Claude Code config" && mkdir -p ~/.claude && ln -s $PWD/claude/settings.json ~/.claude/settings.json


