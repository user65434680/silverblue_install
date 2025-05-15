#!/bin/bash
# post install rerun
# some commands may not work on the first run so this reruns them and checks for potential missed applications or errors.
sudo bash remove_applications.sh

sudo bash install.sh

sudo systemctl enable unbound
sudo systemctl enable sshd

echo "System will reboot in 10 seconds..."
SCRIPT_PATH="$0"
cleanup_and_reboot() {
    echo "Cleaning up..."
    rm -f "$SCRIPT_PATH"
    systemctl reboot
}
systemd-run --on-active=10 /bin/bash -c "rm -f $SCRIPT_PATH && systemctl reboot" || {
    echo "Fallback: Using sleep method"
    sleep 10
    cleanup_and_reboot
}