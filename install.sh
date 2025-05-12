#!/bin/bash
echo "Updating the system..."
sudo rpm-ostree update
echo "Installing packages..."
sudo rpm-ostree install \
  unbound \
  inotify-tools \
  net-tools \
  libpcap-devel \
  libusb1-devel \
  ruby \
  bettercap

sleep 5
