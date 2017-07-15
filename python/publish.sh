#!/bin/bash
set -eux #exit,expand-missing-var,print-commands

docker build -t ncllc_deployment .
docker tag ncllc_deployment master.local:5000/ncllc_deployment
docker push master.local:5000/ncllc_deployment

