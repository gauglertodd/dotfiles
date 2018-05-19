#!/bin/bash

# we gonna need brew up in this
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# need pip/git/curl
sudo apt install -y python-pip
sudo apt install -y git
sudo apt install -y curl

# i only slightly care about vim
brew install vim
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall

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
git clone https://github.com/gauglertodd/dotfiles
echo "Moving dotfiles around"

# general installs for js-beautify
sudo apt-get install -y npm
sudo npm -g install js-beautify
sudo apt-get install -y nodejs-legacy

# make all the magic happen.
source ~/.bashrc
