#!/bin/bash

# Function to install packages using the appropriate package manager
install_packages() {
    local package_manager=$1
    shift
    local packages=("$@")

    case $package_manager in
        apt)
            echo "Installing packages using apt..."
            sudo apt update
            sudo apt install -y "${packages[@]}"
            ;;
        dnf)
            echo "Installing packages using dnf..."
            sudo dnf install -y "${packages[@]}"
            ;;
        yum)
            echo "Installing packages using yum..."
            sudo yum install -y "${packages[@]}"
            ;;
        pacman)
            echo "Installing packages using pacman..."
            sudo pacman -Syu --noconfirm "${packages[@]}"
            ;;
        *)
            echo "Unsupported package manager: $package_manager"
            exit 1
            ;;
    esac
}

# Check if a requirements file is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <path_to_requirements.txt>"
    exit 1
fi

REQUIREMENTS_FILE=$1

# Detect Linux distribution and set the package manager
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
else
    echo "Cannot detect Linux distribution."
    exit 1
fi

# Determine the package manager
case $DISTRO in
    ubuntu|debian)
        PACKAGE_MANAGER="apt"
        ;;
    fedora)
        PACKAGE_MANAGER="dnf"
        ;;
    centos|rhel)
        PACKAGE_MANAGER="yum"
        ;;
    arch)
        PACKAGE_MANAGER="pacman"
        ;;
    *)
        echo "Unsupported distribution: $DISTRO"
        exit 1
        ;;
esac

# Read packages from the provided requirements file
if [ -f "$REQUIREMENTS_FILE" ]; then
    mapfile -t packages < "$REQUIREMENTS_FILE"
    install_packages "$PACKAGE_MANAGER" "${packages[@]}"
else
    echo "Requirements file not found: $REQUIREMENTS_FILE"
    exit 1
fi

echo "All packages installed successfully."
