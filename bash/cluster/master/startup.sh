#!/bin/bash
set -eux #echo on

systemctl restart glusterd.service
systemctl restart docker-distribution.service


