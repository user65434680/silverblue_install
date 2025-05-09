#!/bin/bash

sudo rpm-ostree update -y

sudo rpm-ostree install unbound openssh-server inotify-tools iptables ipset jq dnsutils net-tools auditd build-essential libpcap-dev libusb1-devel libnetfilter-queue-devel ruby bettercap

sudo systemctl enable --now unbound
sudo systemctl enable --now sshd
sudo systemctl enable --now auditd

sudo systemctl enable --now netfilter-persistent

reboot
