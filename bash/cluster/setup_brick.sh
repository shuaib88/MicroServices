#!/bin/bash
set -eux #echo on

gluster peer probe node00.local

function createBrick {
    gluster volume create gv_$1 replica 2 master.local:/home/gfs/gv_$1 node00.local:/home/gfs/gv_$1 force
    gluster volume start gv_$1
}

createBrick feed
createBrick post
createBrick model
createBrick base3
