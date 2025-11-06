#!/bin/bash

##########################################################################
# Line Endings Fix Script for WSL
##########################################################################
# This script fixes Windows line endings (CRLF) in the setup script
# Run this in WSL if you encounter "$'\r': command not found" errors
##########################################################################

echo "=========================================="
echo "Fixing Line Endings for WSL"
echo "=========================================="

# Check if dos2unix is installed
if ! command -v dos2unix &> /dev/null; then
    echo "Installing dos2unix..."
    sudo apt-get update && sudo apt-get install -y dos2unix
fi

# Fix line endings in the setup script
if [ -f "setup-wsl-zsh.sh" ]; then
    echo "Fixing line endings in setup-wsl-zsh.sh..."
    dos2unix setup-wsl-zsh.sh
    chmod +x setup-wsl-zsh.sh
    echo "✓ Line endings fixed!"
    echo ""
    echo "You can now run: ./setup-wsl-zsh.sh"
else
    echo "Error: setup-wsl-zsh.sh not found in current directory"
    echo "Please cd to the directory containing the script first"
    exit 1
fi
