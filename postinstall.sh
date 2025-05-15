#!/bin/bash

set -e

echo "Running post-installation checks..."

echo "Enabling and starting required services..."


systemctl enable unbound.service &>/dev/null || {
    echo "Failed to enable unbound service, retrying..."
    sleep 2
    systemctl enable unbound.service &>/dev/null
}

systemctl start unbound.service &>/dev/null || {
    echo "Failed to start unbound service, retrying..."
    sleep 2
    systemctl start unbound.service &>/dev/null
}

systemctl enable sshd.service &>/dev/null || {
    echo "Failed to enable sshd service, retrying..."
    sleep 2
    systemctl enable sshd.service &>/dev/null
}

systemctl start sshd.service &>/dev/null || {
    echo "Failed to start sshd service, retrying..."
    sleep 2
    systemctl start sshd.service &>/dev/null
}

echo "Verifying services..."
echo "Checking services status:"
echo -n "unbound service: "
systemctl is-enabled unbound.service &>/dev/null && echo -n "enabled, " || echo -n "disabled, "
systemctl is-active unbound.service &>/dev/null && echo "running" || echo "not running"

echo -n "sshd service: "
systemctl is-enabled sshd.service &>/dev/null && echo -n "enabled, " || echo -n "disabled, "
systemctl is-active sshd.service &>/dev/null && echo "running" || echo "not running"

sudo bash reboot.sh

if [ -f "/usr/local/bin/reboot.sh" ]; then
    echo "Removing reboot script..."
    rm -f "/usr/local/bin/reboot.sh"
fi