#Cluster Setup
This guide is for setting up a kubernetes enabled cluster that is enabled with glusterfs

## Base OS

Start with fedora 24, download from here

https://www.mirrorservice.org/sites/dl.fedoraproject.org/pub/fedora/linux/releases/24/Server/x86_64/iso/Fedora-Server-netinst-x86_64-24-1.2.iso

Create root & userspace accounts. Name the host as gateway.local

## Post Installation Steps

After installation is complete. Update system with prereqs using the following commands under root

    $ su
    $ cd /tmp
    $ dnf install -y git
    $ git clone https://github.com/ncllc/ncllc_external
    $ cd ncllc_external/bash/cluster/
    $ ./base_install.sh
    $ exit

Run the userspace setup after

    $ cd /tmp/ncllc_external/bash/user/
    $ ./keyless.sh
    $ ./mojo.sh

## Node setup
### Clone installation
### Rename hosts
On each node `vim /etc/hostname` and change the hostname entry to `master.local` and `node00.local` for the master and worker nodes respectively. Look up and note IP addresses for master and node00. `vim /etc/hosts` on both master and node00 and add two lines:
```
<ip_address> master.local
<ip_address> node00.local
```

Reboot and check if master and worker are reachable from each other:

From master
```
$ ping node00.local
```
From node00.local
```
$ ping master.local
```

### Kubernetes
Clone kubernetes-contrib on master  
Follow guide here - https://github.com/kubernetes/contrib/blob/master/ansible/README.md

    $ git clone https://github.com/kubernetes/contrib
    $ cd contrib/ansible

Edit  

    $ vim inventory/inventory
with

    [masters]
    master.local

    [etcd]
    master.local

    [nodes]
    master.local
    node00.local

Edit

    $ vim inventory/group_vars/all.yml
replace line 17 with:

    ansible_ssh_user: root

from master  `ssh master.local` and `ssh node00.local` in order to add keys for these hosts automatically into ~/.ssh/known_hosts. Ansible uses this to login to the nodes and configure them.

Run deployment

    $ cd scripts
    $ ./deploy-cluster.sh


### GlusterFS

#### Set up bricks and replication

from master
```
    $ ./setup_brick.sh
```

#### Enable kubernetes to access gluster volumes

from master
```
    $ cd ../../kubernetes/gluster
    $ vim glusterfs-endpoints
```
update the IP addresses on line 11 and 23 with those of your nodes.

```
    $ ./setup_gluster.sh
```

