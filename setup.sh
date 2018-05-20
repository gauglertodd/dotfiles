#!/bin/bash

# we gonna need brew up in this
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# need pip/git/curl
sudo apt install -y python-pip
sudo apt install -y git
sudo apt install -y curl

# installing virtualenv/wrapper
echo "Installing virtualenv"
pip install virtualenv
pip install virtualenvwrapper

# general pip installs for python stuff
echo "General pip installs for python development"
sudo pip install yapf
sudo pip install jedi
sudo pip install pep8
sudo pip install pyflakes

# pulling/moving dotfiles locally
echo "Making temp dir, pulling dotfiles from git"
cd ~/
mkdir dotfiles && cd temp
git clone -b osx https://github.com/gauglertodd/dotfiles
echo "Symlinking dotfiles, fingers crossed"
ln -sfn ~/dotfiles/* ~/

# i only slightly care about vim
brew install vim
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

# make all the magic happen.
source ~/.bashrc
