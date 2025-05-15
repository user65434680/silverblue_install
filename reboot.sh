#!/bin/bash

echo "System will reboot in 40 seconds..."
systemd-run --on-active=40 systemctl reboot