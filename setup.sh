#!/bin/bash

# we gonna need brew up in this
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# installing virtualenv/wrapper
echo "Installing virtualenv"
pip install virtualenv
pip install virtualenvwrapper

# general pip installs for python stuff
echo "General pip installs for python development"
pip install yapf
pip install jedi
pip install pep8
pip install pyflakes

# pulling/moving dotfiles locally
echo "Making temp dir, pulling dotfiles from git"
cd ~/
mkdir dotfiles && cd temp
git clone -b osx https://github.com/gauglertodd/dotfiles
echo "Symlinking dotfiles, fingers crossed"
ln -sfn ~/dotfiles/dotfiles/.* ~/
ln -sf ~/dotfiles/dotfiles/.emacs.d/* ~/.emacs.d/

# i only slightly care about vim
brew install vim
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

# clang formatter
brew install clang-format

# make all the magic happen.
source ~/.bashrc
