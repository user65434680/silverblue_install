#!/bin/bash

echo "Starting Fedora Silverblue setup..."

echo "Step 1: Making scripts executable..."
chmod +x *.sh

echo "Step 2: Removing unnecessary applications..."
sudo bash remove_applications.sh

echo "Step 3: Installing new packages..."
sudo bash install.sh

echo "Step 4: Configuring toolbox permissions..."
sudo bash add_current_user_to_toolbox.sh

echo "Step 5: Create students group"
sudo bash create_student_group.sh

echo "Step 6: add to sudoers"
sudo bash add_to_sudoers.sh

echo "Step 7: scan network"
sudo bash echo_ip_range.sh

echo "Step 8: Apply network config"
sudo bash network.sh

echo "Step 9: Setting up restore rules"
sudo bash setup_IPV6.sh

echo "Step 10: Setting up IP blocking"
sudo bash IP_tables_install.sh

echo "Step 11: Setting up post install"
sudo bash initiate_postinstall.sh

echo "Step 12: Removing unnecessary applications again..."
sudo bash remove_applications.sh

sleep 20

sudo systemctl reboot 