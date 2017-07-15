#!/bin/bash
set -eux #echo on

## Install packages
dnf update
dnf upgrade -y
dnf install -y git python-netaddr avahi avahi-tools vim docker-engine ntpdate tmux tree openvpn mosh

## Configure
### Ntp
systemctl enable ntpdate.service

### Docker
systemctl enable docker.service
groupadd docker
usermod -aG docker ncllc

### Avahi
systemctl enable avahi-daemon.service
firewall-cmd --permanent --add-service=mdns

### mosh
firewall-cmd --zone=FedoraServer --add-port=60001/udp --permanent

cd ../user
./mojo.sh
