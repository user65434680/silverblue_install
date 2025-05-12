#!/bin/bash

set -e

check_file() {
    if [ ! -f "$1" ]; then
        echo "Error: Required file $1 not found"
        exit 1
    fi
}

check_file "remove_applications.sh"
check_file "install.sh"
check_file "add_current_user_to_toolbox.sh"

echo "Starting Fedora Silverblue setup..."

echo "Step 1: Making scripts executable..."
chmod +x remove_applications.sh install.sh add_current_user_to_toolbox.sh

echo "Step 2: Removing unnecessary applications..."
sudo bash remove_applications.sh

echo "Step 3: Updating system..."
sudo rpm-ostree update

echo "Step 4: Installing new packages..."
sudo bash install.sh

echo "Step 5: Configuring toolbox permissions..."
sudo bash add_current_user_to_toolbox.sh

echo "All steps completed. System will reboot in 10 seconds..."
sleep 10
sudo systemctl reboot