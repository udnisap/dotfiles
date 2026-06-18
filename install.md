
# Install Iterm
https://www.iterm2.com/downloads.html

# Install homebrew
http://brew.sh/

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Homebrew packages
brew install neovim
brew install wget tmux nvm npm

# Neovim config (LazyVim)
# The nvim/ dir in this repo is a LazyVim setup. setup.sh symlinks it to
# ~/.config/nvim; lazy.nvim bootstraps all plugins on first `nvim` launch.

# NVM setup
source $(brew --prefix nvm)/nvm.sh


