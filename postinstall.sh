#!/bin/bash

set -e

echo "Running post-installation checks..."

echo "Enabling and starting required services..."

systemctl enable unbound.service || {
    echo "Failed to enable unbound service, retrying..."
    sleep 2
    systemctl enable unbound.service
}


systemctl start unbound.service || {
    echo "Failed to start unbound service, retrying..."
    sleep 2
    systemctl start unbound.service
}

systemctl enable sshd.service || {
    echo "Failed to enable sshd service, retrying..."
    sleep 2
    systemctl enable sshd.service
}

systemctl start sshd.service || {
    echo "Failed to start sshd service, retrying..."
    sleep 2
    systemctl start sshd.service
}

echo "Verifying services..."
echo "Checking if services are enabled:"
systemctl is-enabled unbound.service
systemctl is-enabled sshd.service

echo "Checking if services are running:"
systemctl status unbound.service
systemctl status sshd.service




sudo bash remove_applications.sh
sudo bash install.sh

sleep 5

echo "Enabling required services..."
systemctl enable unbound.service || {
    echo "Failed to enable unbound service, retrying..."
    sleep 2
    systemctl enable unbound.service
}

systemctl enable sshd.service || {
    echo "Failed to enable sshd service, retrying..."
    sleep 2
    systemctl enable sshd.service
}

echo "Verifying services..."
systemctl is-enabled unbound.service
systemctl is-enabled sshd.service


echo "System will reboot in 10 seconds..."
SCRIPT_PATH="$0"
cleanup_and_reboot() {
    echo "Cleaning up..."
    rm -f "$SCRIPT_PATH"
    systemctl reboot
}
systemd-run --on-active=10 /bin/bash -c "rm -f $SCRIPT_PATH && systemctl reboot" || {
    echo "Fallback: Using sleep method"
    sleep 10
    cleanup_and_reboot
}