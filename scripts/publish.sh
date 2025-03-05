#!/bin/bash

# Error handling
set -e
trap 'echo "Error: Script failed on line $LINENO"' ERR

# Repository details
REPO_NAME="CursorFig1"
REPO_DESC="Cross-platform configuration and automation tools for development environment setup"
VISIBILITY="public"

# Check if gh CLI is installed
if ! command -v gh &> /dev/null; then
    echo "GitHub CLI not found. Installing..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install gh
    elif [[ -f /etc/debian_version ]]; then
        curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
        sudo apt update
        sudo apt install gh
    elif [[ -f /etc/arch-release ]]; then
        sudo pacman -S github-cli
    fi
fi

# Check if logged in to GitHub
if ! gh auth status &> /dev/null; then
    echo "Please login to GitHub..."
    gh auth login
fi

# Create repository
echo "Creating repository $REPO_NAME..."
gh repo create "$REPO_NAME" --description "$REPO_DESC" --$VISIBILITY

# Initialize git if not already initialized
if [ ! -d .git ]; then
    git init
    git add .
    git commit -m "Initial commit: Project setup with configurations"
fi

# Add remote and push
git remote add origin "https://github.com/$(gh api user -q .login)/$REPO_NAME.git"
git branch -M main
git push -u origin main

echo "Repository successfully created and code pushed!"
echo "Visit: https://github.com/$(gh api user -q .login)/$REPO_NAME"
