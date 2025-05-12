#!/bin/bash
if ! grep -q "toolbox-users" /etc/group; then
    echo "Creating 'toolbox-users' group..."
    sudo groupadd toolbox-users
else
    echo "'toolbox-users' group already exists."
fi

current_user=$(whoami)
echo "Adding the current user ($current_user) to 'toolbox-users' group..."
if ! id -nG "$current_user" | grep -qw "toolbox-users"; then
    sudo usermod -aG toolbox-users $current_user
else
    echo "$current_user is already in the 'toolbox-users' group."
fi
tools=("/usr/bin/toolbox" "/usr/bin/flatpak" "/usr/bin/podman" "/usr/bin/rpm-ostree")
for tool in "${tools[@]}"; do
    if [ -f "$tool" ]; then
        echo "Changing group ownership and setting permissions for $tool..."
        sudo chgrp toolbox-users "$tool"
        sudo chmod 750 "$tool"
    fi
done
echo "Verifying permissions for /usr/bin/toolbox..."
ls -l /usr/bin/toolbox
echo "This script will now delete itself..."
rm -- "$0"
