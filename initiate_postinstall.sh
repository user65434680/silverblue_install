#!/bin/bash
set -e

SCRIPT_PATH="/usr/local/bin/postinstall.sh"
SERVICE_PATH="/etc/systemd/system/postinstall.service"
echo "Copying postinstall script..."
sudo cp postinstall.sh "$SCRIPT_PATH"
sudo chmod +x "$SCRIPT_PATH"
echo "Creating systemd service..."
cat << EOF | sudo tee "$SERVICE_PATH"
[Unit]
Description=One-time post-installation setup
After=network.target

[Service]
Type=oneshot
ExecStart=$SCRIPT_PATH
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

echo "Enabling one-time service..."
sudo systemctl enable postinstall.service

sudo mkdir -p /usr/local/share/postinstall
echo "Setup complete. The post-install script will run on next boot."