#!/bin/bash
set -e

check_rpm_ostree() {
    if rpm-ostree status | grep -q "Transaction"; then
        echo "RPM-OSTree is busy with another operation. Attempting to cancel..."
        sudo rpm-ostree cancel
        sleep 5
        if rpm-ostree status | grep -q "Transaction"; then
            echo "ERROR: Could not cancel existing transaction. Please reboot and try again."
            exit 1
        fi
    fi
}

check_rpm_ostree

echo "Updating the system..."
sudo rpm-ostree update || {
    echo "Update failed, attempting cleanup..."
    sudo rpm-ostree cleanup -m
    exit 1
}

echo "Installing packages..."
for package in unbound inotify-tools net-tools libpcap-devel libusb1-devel ruby; do
    echo "Installing $package..."
    sudo rpm-ostree install $package || {
        echo "Failed to install $package, attempting cleanup..."
        sudo rpm-ostree cleanup -m
        exit 1
    }
done


sleep 10

sudo systemctl enable unbound sshd

echo "Installation complete. A reboot is required."
sleep 5
