#!/bin/bash
set -e

sleep 10

echo "Running post-installation checks..."

echo "Enabling and starting required services..."

sudo systemctl enable unbound.service &>/dev/null || {
    echo "Failed to enable unbound service, retrying..."
    sleep 2
    sudo systemctl enable unbound.service &>/dev/null
}

sudo systemctl start unbound.service &>/dev/null || {
    echo "Failed to start unbound service, retrying..."
    sleep 2
    sudo systemctl start unbound.service &>/dev/null
}

sudo systemctl enable sshd.service &>/dev/null || {
    echo "Failed to enable sshd service, retrying..."
    sleep 2
    sudo systemctl enable sshd.service &>/dev/null
}

sudo systemctl start sshd.service &>/dev/null || {
    echo "Failed to start sshd service, retrying..."
    sleep 2
    sudo systemctl start sshd.service &>/dev/null
}

echo "Verifying services..."
echo "Checking services status:"
echo -n "unbound service: "
sudo systemctl is-enabled unbound.service &>/dev/null && echo -n "enabled, " || echo -n "disabled, "
sudo systemctl is-active unbound.service &>/dev/null && echo "running" || echo "not running"

echo -n "sshd service: "
sudo systemctl is-enabled sshd.service &>/dev/null && echo -n "enabled, " || echo -n "disabled, "
sudo systemctl is-active sshd.service &>/dev/null && echo "running" || echo "not running"

echo "Cleaning up post-install files..."
sudo systemctl disable postinstall.service &>/dev/null
sudo rm -f "/etc/systemd/system/postinstall.service"
sudo rm -f "/usr/local/bin/postinstall.sh"
sudo rm -f "/usr/local/bin/reboot.sh"
sudo rm -f "/usr/local/bin/remove_applications.sh"
sudo rm -f "/usr/local/bin/install.sh"
sudo systemctl daemon-reload