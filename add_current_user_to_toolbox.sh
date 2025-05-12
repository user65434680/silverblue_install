#!/bin/bash
echo "Creating 'toolbox-users' group if not already present..."
sudo groupadd toolbox-users
current_user=$(whoami)
echo "Adding the current user ($current_user) to 'toolbox-users' group..."
sudo usermod -aG toolbox-users $current_user
echo "Changing group ownership of /usr/bin/toolbox to 'toolbox-users'..."
sudo chgrp toolbox-users /usr/bin/toolbox
echo "Setting permissions to allow only 'toolbox-users' group to run Toolbox..."
sudo chmod 750 /usr/bin/toolbox
echo "Verifying permissions for /usr/bin/toolbox..."
ls -l /usr/bin/toolbox
echo "This script will now delete itself..."
rm -- "$0"
