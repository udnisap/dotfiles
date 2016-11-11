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

function installVimBinaryPackages {
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  
}
confirm "Install Vim Binary Addons" && installVimBinaryPackages
confirm "Symlink vim" && ln -s $PWD/vim/.vimrc ~/.vimrc
confirm "Symlink tmux" && ln -s $PWD/tmux/.tmux.conf ~/.tmux.conf 
confirm "Symlink git" && ln -s $PWD/git/.gitconfig ~/.gitconfig 


