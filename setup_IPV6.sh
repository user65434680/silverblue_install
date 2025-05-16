#!/bin/bash

SCRIPT_PATH="/opt/restore_rules/drop_IPV6.sh"
SERVICE_PATH="/etc/systemd/system/drop-ipv6.service"

if [[ "$EUID" -ne 0 ]]; then
  echo "Please run this script as root or with sudo."
  exit 1
fi
mkdir -p /opt/restore_rules
sudo cp drop_IPV6.sh "$SCRIPT_PATH"

if [[ -f "$SCRIPT_PATH" ]]; then
  chmod +x "$SCRIPT_PATH"
  echo "Made $SCRIPT_PATH executable."
else
  echo "Error: Script $SCRIPT_PATH does not exist."
  exit 1
fi

cat <<EOF > "$SERVICE_PATH"
[Unit]
Description=Restore IPv6 DROP Rules
After=network-online.target sshd.service unbound.service multi-user.target
Wants=network-online.target sshd.service unbound.service
RequiresMountsFor=/opt/restore_rules /etc/systemd/system

[Service]
Type=oneshot
ExecStart=/opt/restore_rules/drop_IPV6.sh
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

echo "Created systemd service file at $SERVICE_PATH."

sudo chown root:root "$SERVICE_PATH"

systemctl daemon-reexec
systemctl daemon-reload
systemctl enable drop-ipv6.service

echo "Service enabled to run on boot: drop-ipv6.service"
