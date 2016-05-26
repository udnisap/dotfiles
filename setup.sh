#!/bin/sh

PWD=`pwd`
# setup symlinks
ln -s $PWD/vim/.vimrc ~/.vimrc
ln -s $PWD/tmux/.tmux.conf ~/.tmux.conf 
ln -s $PWD/git/.gitconfig ~/.gitconfig 
