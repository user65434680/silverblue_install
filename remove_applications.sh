#!/bin/bash
# This script removes unnecessary software from a Fedora Silverblue system.
# It specifically targets Flatpak applications and GNOME Software.


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

if ! command -v flatpak &> /dev/null; then
    echo "Flatpak is not installed. Skipping Flatpak-related tasks."
else
    apps=(
        org.gnome.Calculator
        org.gnome.Calendar
        org.gnome.Characters
        org.gnome.Connections
        org.gnome.Contacts
        org.gnome.Evince
        org.gnome.Extensions
        org.gnome.Logs
        org.gnome.Maps
        org.gnome.Snapshot
        org.gnome.Weather
        org.fedoraproject.MediaWriter
    )

    remove_flatpaks() {
        echo "Removing selected Flatpak apps..."
        for app in "${apps[@]}"; do
            echo "Uninstalling $app..."
            flatpak uninstall -y "$app"
        done
        echo "Cleaning up unused Flatpak runtimes..."
        flatpak uninstall --unused -y
    }

    remove_flatpaks
fi

if ! command -v rpm-ostree &> /dev/null; then
    echo "rpm-ostree is not installed or available. Skipping GNOME Software removal."
else
    remove_gnome_software() {
        echo "Removing GNOME Software..."
        sudo rpm-ostree override remove gnome-software gnome-software-rpm-ostree
    }

    remove_gnome_software
fi

