#!/bin/bash

dotfiles_dir="$HOME/dotfiles"
backup_dir="$HOME/dotfiles_backups/$(date +%Y%m%d_%H%M%S)"
OS=$(uname -s)

# Create a backup directory
mkdir -p "$backup_dir"

# List of files/directories to symlink (relative to dotfiles_dir)
files=(
    ".zshrc"
    ".tmux.conf"
    ".tmux"
    ".oh-my-zsh"
    ".config/nvim"
    ".config/alacritty"
)

# Install packages
if [ "$OS" = "Linux" ]; then
    sh apt_install_packages.sh
    
    # Need a newer version of neovim that that provided by apt-get at the mo
    echo "Manually downloading/extracting neovim v0.11.1"
    wget https://github.com/neovim/neovim/releases/download/v0.11.1/nvim-linux-x86_64.appimage
    chmod u+x nvim-linux-x86_64.appimage
    mkdir -p ~/.local/bin/
    mv nvim-linux-x86_64.appimage ~/.local/bin/nvim
elif [ "$OS" = "Darwin" ]; then
    brew bundle
else 
    echo "ERROR! Unknown system type -- $OS"
    exit 1
fi

# Install go packages
go install golang.org/x/tools/gopls@latest
go install github.com/air-verse/air@latest

for file in "${files[@]}"; do
    source_path="$dotfiles_dir/$file"
    target_path="$HOME/$file"

    # Check if the target file/directory exists in the home directory
    if [ -e "$target_path" ]; then
        echo "Backing up existing $target_path to $backup_dir"
        mv "$target_path" "$backup_dir/"
    fi

    # Create the symbolic link
    echo "Creating symlink for $file"
    ln -s "$source_path" "$target_path"
done

echo "Dotfiles symlinking complete."
echo "Existing files were backed up to $backup_dir"

