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

remove_flatpaks() {
    local apps=(
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

    echo "Removing selected Flatpak apps..."
    for app in "${apps[@]}"; do
        if flatpak list --app | grep -q "$app"; then
            echo "Uninstalling $app..."
            flatpak uninstall -y "$app" || {
                echo "Failed to uninstall $app, continuing..."
            }
        else
            echo "$app not installed, skipping..."
        fi
    done

    echo "Cleaning up unused Flatpak runtimes..."
    flatpak uninstall --unused -y || true
}

remove_gnome_software() {
    echo "Removing GNOME Software..."
    check_rpm_ostree

    if rpm -q gnome-software &>/dev/null || rpm -q gnome-software-rpm-ostree &>/dev/null; then
        echo "Found GNOME Software packages, removing..."
        if ! sudo rpm-ostree override remove gnome-software gnome-software-rpm-ostree; then
            echo "Failed to remove GNOME Software. Attempting cleanup..."
            sudo rpm-ostree cleanup -m
            echo "Please reboot and try again if the problem persists."
            exit 1
        fi
        if rpm -q gnome-software &>/dev/null || rpm -q gnome-software-rpm-ostree &>/dev/null; then
            echo "WARNING: GNOME Software packages still present. Removal may have failed."
            exit 1
        else
            echo "GNOME Software packages successfully removed."
        fi
    else
        echo "GNOME Software packages not found. Skipping removal."
    fi
}

echo "Starting application removal process..."

if command -v flatpak &> /dev/null; then
    remove_flatpaks
else
    echo "Flatpak is not installed. Skipping Flatpak-related tasks."
fi

if command -v rpm-ostree &> /dev/null; then
    remove_gnome_software
else
    echo "rpm-ostree is not installed or available. Skipping GNOME Software removal."
fi

echo "Application removal process complete."
