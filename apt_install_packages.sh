#!/bin/bash

PACKAGE_FILE="apt_packages.list"

if [ ! -f "$PACKAGE_FILE" ]; then
  echo "Error: Package file '$PACKAGE_FILE' not found."
  exit 1
fi

echo "Updating package list..."
sudo apt update

echo "Installing packages from '$PACKAGE_FILE'..."
while IFS= read -r package; do
  if [ -n "$package" ]; then # Ensure line is not empty
    echo "Installing $package..."
    sudo apt install -y "$package"
  fi
done < "$PACKAGE_FILE"

echo "Package installation complete."
