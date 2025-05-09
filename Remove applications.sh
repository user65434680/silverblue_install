#!/bin/bash
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
    org.gnome.TextEditor
    org.gnome.Weather
    org.gnome.DiskUsageAnalyzer
    org.gnome.Clocks
    org.gnome.Fonts
    org.gnome.Sushi
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

remove_gnome_software() {
    echo "Removing GNOME Software..."
    sudo rpm-ostree override remove gnome-software gnome-software-rpm-ostree
}
remove_toolbox() {
    echo "Removing Toolbox..."
    sudo rpm-ostree override remove toolbox
}
remove_flatpaks
remove_gnome_software
remove_toolbox

echo "Rebooting system to apply changes..."
systemctl reboot
