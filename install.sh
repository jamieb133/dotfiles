#!/bin/bash

dotfiles_dir="$HOME/dotfiles"
backup_dir="$HOME/dotfiles_backups/$(date +%Y%m%d_%H%M%S)"

# Create a backup directory
mkdir -p "$backup_dir"

# List of files/directories to symlink (relative to dotfiles_dir)
files=(
    ".zshrc"
    ".tmux.conf"
    ".tmux"
    ".config"
)

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

