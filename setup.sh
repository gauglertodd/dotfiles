#!/bin/bash

# check for pip: 
sudo apt install -y python-pip
sudo apt install -y git 
sudo apt install -y vim

# installing virtualenv/wrapper
echo "Installing virtualenv"
sudo pip install virtualenv
sudo pip install virtualenvwrapper

# installing docker
# https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-16-04
echo "Installing docker"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y docker-ce

# installing pgadmin
echo "Installing pgadmin"p
sudo apt-get install -y postgresql-9.3
sudo apt-get install -y pgadmin3

# installing emacs v25
echo "Installing Emacs"
sudo add-apt-repository ppa:kelleyk/emacs
sudo apt-get update
sudo apt-get install -y emacs25

# pulling/moving dotfiles locally
echo "Making temp dir, pulling dotfiles from git"
cd ~/Desktop
mkdir temp && cd temp
git clone https://github.com/gauglertodd/dotfiles
echo "Moving dotfiles around"

# general pip installs for python stuff
echo "General pip installs for python development"
pip install yapf

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
