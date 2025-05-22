#!/bin/bash
set -e

echo "Creating directory for the monitoring script..."
sudo mkdir -p /opt/IP_blocker


echo "Copying blocking script..."
sudo cp resolve_and_block.sh /opt/IP_blocker/resolve_and_block.sh
sudo chmod +x /opt/IP_blocker/resolve_and_block.sh

echo "Setting up allowed_domains.txt file..."
if [ ! -f "allowed_domains.txt" ]; then
    echo "Creating empty allowed_domains.txt file..."
    touch allowed_domains.txt
fi

echo "Copying allowed_domains.txt file..."
sudo cp allowed_domains.txt /opt/IP_blocker/allowed_domains.txt



echo "Creating systemd service for resolve_and_block.sh..."
cat <<EOF | sudo tee /etc/systemd/system/resolve_and_block.service > /dev/null
[Unit]
Description=Resolve Allowed Domains and Block Unauthorized IPs

[Service]
ExecStart=/opt/IP_blocker/resolve_and_block.sh
Restart=on-failure
User=root

[Install]
WantedBy=multi-user.target
EOF

echo "Reloading systemd..."
sudo systemctl daemon-reload

echo "Enabling and starting the resolve_and_block.service..."
sudo systemctl enable resolve_and_block.service
sudo systemctl start resolve_and_block.service


echo "Setting permissions..."
sudo chmod 700 /opt/IP_blocker
sudo chmod 700 /opt/IP_blocker/resolve_and_block.sh
sudo chmod 600 /opt/IP_blocker/allowed_domains.txt
sudo chown root:root /opt/IP_blocker/resolve_and_block.sh
sudo chown root:root /opt/IP_blocker/allowed_domains.txt
sudo semanage fcontext -a -t bin_t "/opt/IP_blocker/resolve_and_block.sh"
sudo restorecon -v /opt/IP_blocker/resolve_and_block.sh

sudo semanage fcontext -a -t etc_t "/opt/IP_blocker/allowed_domains.txt"
sudo restorecon -v /opt/IP_blocker/allowed_domains.txt

sudo ausearch -c '(block.sh)' --raw | audit2allow -M my-blocksh
sudo semodule -X 300 -i my-blocksh.pp