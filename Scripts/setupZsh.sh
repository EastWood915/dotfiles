#!/bin/bash

FONTS_DIR="./Fonts"
ZSH_REQS_FILE="zshRequirements.txt"

# Install required system packages
echo "Installing required system packages..."
sudo sh ./installPackages.sh "$ZSH_REQS_FILE"
echo

# Install fonts
echo "Installing fonts..."
if [ -d "$FONTS_DIR" ]; then
    for font in "$FONTS_DIR"/*; do
        if [ -f "$font" ]; then
            font_name=$(basename "$font")
            # Check if the font is already installed
            if fc-list | grep -i "$font_name" > /dev/null; then
                echo "Font already installed: $font_name"
            else
                # Copy the font to the user's fonts directory
                cp "$font" /usr/share/fonts
                echo "Installed font: $font_name"
            fi
        fi
    done
    
    echo "Font installation complete."
    echo
fi

# Run GNU Stow to symlink dotfiles
echo "Setting up symlinks to dotfiles..."
cd ..
stow .
echo

# Change default shell to ZSH
echo "Changing default shell to ZSH..."
chsh -s "$(which zsh)" "$USER"
echo

echo "Setup completed. Logout to apply changes."
