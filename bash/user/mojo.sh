#!/bin/bash
set -eux #echo on

### Setup environment for editing
git config --global credential.helper "cache --timeout=3600"
rm -rf  ~/projects/environment_mojo_linux
mkdir -p ~/projects/
cd ~/projects
git clone https://github.com/zefyrr/environment_mojo_linux
cd environment_mojo_linux
./setupEnv.sh
