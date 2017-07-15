#!/bin/bash
set -eux #echo on

### SSH key-less login
rm -rf ~/.ssh
mkdir -p ~/.ssh
ssh-keygen -t rsa -b 2048 -N '' -f  ~/.ssh/id_rsa
cd ~/.ssh
cp id_rsa.pub authorized_keys
chmod 755 ~/.ssh
chmod 644 ~/.ssh/authorized_keys 
