#!/bin/bash
set -eux #echo on

## Install packages
dnf update
dnf upgrade -y
dnf install -y git python-netaddr avahi avahi-tools vim docker-engine glusterfs-server ntpdate ansible tmux tree httpd-tools

## Configure
### Ntp
systemctl enable ntpdate.service

### Docker
systemctl enable docker
groupadd docker
usermod -aG docker ncllc

### Avahi
systemctl enable avahi-daemon.service
firewall-cmd --permanent --add-service=mdns

### GlusterFS
firewall-cmd --permanent --add-service=glusterfs
systemctl enable glusterd.service
mkdir -p /home/gfs/gv_feed
mkdir -p /home/gfs/gv_post
mkdir -p /home/gfs/gv_model
mkdir -p /home/gfs/gv_base3


cd ../user
./keyless.sh
./mojo.sh
