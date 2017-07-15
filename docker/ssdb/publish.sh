#!/bin/bash
set -eux #echo on

docker build -t ncllc_ssdb .
docker tag ncllc_ssdb master.local:5000/ncllc_ssdb
docker push master.local:5000/ncllc_ssdb

