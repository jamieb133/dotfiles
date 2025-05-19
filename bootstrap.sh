#!/bin/bash

# ONLY RUN THIS ONCE VIA CURL TO INSTALL BREW STUFF AND CLONE THE REPO

# Do this within the HOME directory
cd $HOME

if [ "$OS" = "Linux" ]; then
    echo "Installing python and git on Linux"
    apt install python3 git
elif [ "$OS" = "Darwin" ]; then
    if command -v brew &> /dev/null
    then
        echo "Homebrew is installed."
        brew --version
    else
        echo "Homebrew is not installed, installing now."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    echo "Installing python and git on MacOS"
    brew install python3 git
else 
    echo "ERROR! Unknown system type -- $OS"
    exit 1
fi

# Set git username and email
python3 git_user.py

# Download and install the stuff
git clone git@github.com:jamieb133/dotfiles.git
cd dotfiles
git submodule update --init
bash install.sh

