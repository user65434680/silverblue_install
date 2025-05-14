#!/bin/bash

USER=${SUDO_USER:-$(whoami)}
LINE="$USER ALL=(ALL) NOPASSWD:ALL"
if sudo grep -qF "$LINE" /etc/sudoers; then
    echo "User $USER is already in the sudoers file with NOPASSWD."
else
    echo "$LINE" | sudo EDITOR="tee -a" visudo
    echo "User $USER added to sudoers with NOPASSWD."
fi
