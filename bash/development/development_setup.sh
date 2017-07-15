#!/bin/bash
set -eux #echo on

## Install packages
dnf update
dnf upgrade -y
dnf groupinstall -y "Development Tools"
dnf install -y autoconf automake wget libtool clang redhat-rpm-config python-devel swig cmake glog-devel gflags-devel

## Configure
### Protobuf
rm -rf /tmp/protobuf
mkdir -p /tmp/protobuf
cd /tmp/protobuf
wget https://github.com/google/protobuf/archive/v3.1.0.tar.gz
tar -xvzf v3.1.0.tar.gz
cd protobuf-3.1.0/
#### C++ build & install
./autogen.sh
./configure
make -j32
make install
#### Python build & install
cd python
python setup.py build --cpp_implementation
python setup.py install --cpp_implementation


### python packages
pip install holidays numpy spyne ssdb twisted
