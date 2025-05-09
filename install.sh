#!/bin/bash
echo "Updating the system..."
sudo rpm-ostree update
echo "Installing packages..."
sudo rpm-ostree install \
  unbound \
  openssh-server \
  inotify-tools \
  iptables \
  ipset \
  jq \
  bind-utils \
  net-tools \
  audit \
  libpcap-devel \
  libusb1-devel \
  libnetfilter_queue-devel \
  ruby \
  bettercap

echo "Rebooting is required to apply changes. The system will reboot now..."
sleep 5
sudo reboot
