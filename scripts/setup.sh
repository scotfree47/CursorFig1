#!/bin/bash

# Cross-platform setup script for Unix-based systems
# This script sets up the development environment and configurations

# Error handling
set -e
trap 'echo "Error: Script failed on line $LINENO"' ERR

# Detect OS
OS="$(uname -s)"
case "${OS}" in
    Linux*)
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            OS_NAME=$ID
        else
            OS_NAME="linux"
        fi
        ;;
    Darwin*)
        OS_NAME="macos"
        ;;
    *)
        echo "Unsupported operating system"
        exit 1
        ;;
esac

echo "Detected OS: $OS_NAME"

# Create necessary directories
mkdir -p ~/.cursor/config
mkdir -p ~/.vscode/extensions

# Install required packages based on OS
case "$OS_NAME" in
    "macos")
        # Check for Homebrew
        if ! command -v brew &> /dev/null; then
            echo "Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi

        # Install packages
        brew install \
            node \
            git \
            aws-cli \
            python3
        ;;
    "ubuntu"|"debian")
        # Update package list
        sudo apt-get update

        # Install packages
        sudo apt-get install -y \
            nodejs \
            npm \
            git \
            python3 \
            python3-pip \
            awscli
        ;;
    "fedora"|"rhel")
        sudo dnf install -y \
            nodejs \
            npm \
            git \
            python3 \
            python3-pip \
            awscli
        ;;
    "arch")
        sudo pacman -Syu --noconfirm \
            nodejs \
            npm \
            git \
            python \
            python-pip \
            aws-cli
        ;;
esac

# Install global npm packages
npm install -g typescript @typescript-eslint/parser @typescript-eslint/eslint-plugin

# Copy configurations
echo "Copying configurations..."
cp -r config/$OS_NAME/* ~/.cursor/config/
cp -r .vscode/* ~/.vscode/

# Set correct permissions
chmod -R 644 ~/.cursor/config/*
chmod 755 ~/.cursor ~/.cursor/config

echo "Setup complete for $OS_NAME"
echo "Please restart your IDE for changes to take effect"
