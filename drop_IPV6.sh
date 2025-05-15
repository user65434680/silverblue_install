#!/bin/bash

if [[ "$EUID" -ne 0 ]]; then
  echo "Please run as root or with sudo."
  exit 1
fi

ip6tables -P INPUT DROP
ip6tables -P FORWARD DROP
ip6tables -P OUTPUT DROP

echo "IPv6 default policies set to DROP."
