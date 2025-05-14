#!/bin/bash
# post install rerun
# some commands may not work on the first run so this reruns them and checks for potential missed applications or errors.
sudo bash remove_applications.sh

sudo bash install.sh

sudo systemctl enable unbound
sudo systemctl enable sshd

sleep 10

sudo systemctl reboot