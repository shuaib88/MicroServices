#!/bin/bash
set -eux #echo on

docker build -t ncllc_deployment .
docker tag ncllc_deployment master.local:5000/ncllc_deployment
docker push master.local:5000/ncllc_deployment

