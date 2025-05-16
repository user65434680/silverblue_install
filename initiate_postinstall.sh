#!/bin/bash
set -e

SCRIPT_PATH="/usr/local/bin/postinstall.sh"
SERVICE_PATH="/etc/systemd/system/postinstall.service"

echo "Copying and setting up scripts..."
for script in postinstall.sh remove_applications.sh install.sh; do
    sudo cp "$script" "/usr/local/bin/$script"
    sudo chmod +x "/usr/local/bin/$script"
done

echo "Creating systemd service..."
cat << EOF | sudo tee "$SERVICE_PATH"
[Unit]
Description=One-time post-installation setup
After=network-online.target sshd.service unbound.service multi-user.target
Wants=network-online.target sshd.service unbound.service
RequiresMountsFor=/usr/local/bin /etc/systemd/system

[Service]
Type=oneshot
ExecStart=/usr/local/bin/postinstall.sh
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

sudo chmod 644 "$SERVICE_PATH"

echo "Reloading systemd and enabling service..."
sudo systemctl daemon-reload
sudo systemctl enable postinstall.service

sudo mkdir -p /usr/local/share/postinstall

echo "Setup complete. The post-install script will run on next boot."
echo "Setting permissions..."
sudo chmod 700 /usr/local/bin/postinstall.sh
sudo chown root:root /usr/local/bin/postinstall.sh
sudo chcon -t bin_t /usr/local/bin/postinstall.sh
sudo semanage fcontext -a -t bin_t /usr/local/bin/postinstall.sh
sudo restorecon -v /usr/local/bin/postinstall.sh