#!/bin/bash
#A startup script to enable gluster volumes and other services
set -eux #echo on

# startup gluster
service glusterd start

function startBricks {
    yes | gluster volume stop gv_$1
    gluster volume start gv_$1
}

startBricks feed
startBricks post
#startBricks model
#startBricks base3

#start up registry
registry serve /etc/docker-distribution/registry/config.yml

# if node is not ready, move those /var/docker/network/files
#kubectl get nodes | grep master | awk '{print $2}' | grep 'NotReady' &> /dev/null
#if [ $? == 0 ]
#  then
#    mv /var/lib/docker/network/files /var/lib/docker/network/files_backup
#fi

# if pods stuck in pending, restart kube-scheduler
#kubectl get pods | grep Pending &> /dev/null
#if [ $? == 0 ]
#  then
#    service kube-scheduler restart 
#fi

# cleanup
# docker rmi $(docker images -q --filter "dangling=true")
