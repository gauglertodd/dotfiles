#!/bin/bash

# need pip/git/curl
sudo apt install -y python-pip
sudo apt install -y git
sudo apt install -y curl

# i only slightly care about vim
sudo apt install -y vim
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +qall
sudo update-alternatives --install /usr/bin/editor editor /usr/bin/vim 100
sudo apt-get install -y build-essential cmake
sudo apt-get install -y python-dev python3-dev
cd ~/vim/bundle/YouCompleteMe
./install.py --clang-completer
cd -

# installing virtualenv/wrapper
echo "Installing virtualenv"
sudo pip install virtualenv
sudo pip install virtualenvwrapper

# installing docker
# https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-16-04
echo "Installing docker"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" -y
sudo apt-get update
sudo apt-get install -y docker-ce

# installing pgadmin
echo "Installing pgadmin"
sudo apt-get install -y postgresql-9.3
sudo apt-get install -y pgadmin3

# installing emacs v25
echo "Installing Emacs"
sudo add-apt-repository ppa:kelleyk/emacs
sudo apt-get update
sudo apt-get install -y emacs25
emacs --script dotfiles/.emacs.d/install.el

# pulling/moving dotfiles locally
echo "Making temp dir, pulling dotfiles from git"
cd ~/Desktop
mkdir temp && cd temp
git clone https://github.com/gauglertodd/dotfiles
echo "Moving dotfiles around"
cd dotfiles && cp -r . ~/

# general pip installs for python stuff
echo "General pip installs for python development"
sudo pip install yapf
sudo pip install jedi
sudo pip install pep8
sudo pip install pyflakes

# make all the magic happen.
source ~/.bashrc

# in the case that you want to manually change the default terminal colors, change these hex codes.
echo "Setting up the terminal"
# https://unix.stackexchange.com/questions/296699/how-to-export-import-ubuntu-16-04-terminal-color-scheme
# https://wiki.gnome.org/Apps/Terminal/FAQ#How_can_I_change_a_profile_setting_from_the_command_line.3F
profile=$(gsettings get org.gnome.Terminal.ProfilesList default)
profile=${profile:1:-1} # remove leading and trailing single quotes

gsettings set \
          org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${profile}/ \
          use-theme-colors false

gsettings set \
          org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${profile}/ \
          background-color "#091242"

gsettings set \
          org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${profile}/ \
          scrollback-unlimited true

gsettings set \
          org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:${profile}/ \
          foreground-color "#28ee28"

# map capslock to control
setxkbmap -option caps:ctrl_modifier

# setting up the windows-like snap settings
sudo apt install compizconfig-settings-manager
