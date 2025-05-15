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