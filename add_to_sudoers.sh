#!/bin/bash
if [ -z "$1" ]; then
    echo "Error: Please provide a username as argument"
    echo "Usage: $0 <username>"
    exit 1
fi
USERNAME="$1"
if ! id "$USERNAME" &>/dev/null; then
    echo "Error: User $USERNAME does not exist"
    exit 1
fi

LINE="$USERNAME ALL=(ALL) NOPASSWD:ALL"

if sudo grep -qF "$LINE" /etc/sudoers; then
    echo "User $USERNAME is already in the sudoers file with NOPASSWD."
else
    echo "$LINE" | sudo EDITOR="tee -a" visudo
    echo "User $USERNAME added to sudoers with NOPASSWD."
fi