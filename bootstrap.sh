#!/bin/bash

# ONLY RUN THIS ONCE VIA CURL TO INSTALL BREW STUFF AND CLONE THE REPO

# Do this within the HOME directory
cd $HOME

if command -v brew &> /dev/null
then
    echo "Homebrew is installed."
    brew --version
else
    echo "Homebrew is not installed, installing now."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Download the list of package dependencies and install them
curl -O https://raw.githubusercontent.com/jamieb133/dotfiles/refs/heads/main/Brewfile
brew bundle
rm Brewfile

# Set git username and email
python3 git_user.py

# Download and install the stuff
git clone git@github.com:jamieb133/dotfiles.git
cd dotfiles
git submodule update --init
sh install.sh

