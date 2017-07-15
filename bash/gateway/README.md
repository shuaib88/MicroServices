#Gateway Setup

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
    $ cd ncllc_external/bash/gateway/
    $ ./gateway_install.sh
    $ exit
    
Run the userspace setup after

    $ cd /tmp/ncllc_external/bash/user/
    $ ./keyless.sh
    $ ./mojo.sh

## Disable password for ssh

Copy over ssh key for keyless login and test authentication.

Next disable host ssh password prompt by editing 

    $ vim /etc/ssh/sshd_config
to reflect

    PasswordAuthentication no

Reboot the system


## Openvpn setup

Copy over credentials into /etc/openvpn
To start the servvice:

    $ su
    $ systemctl enable openvpn@client.service
    $ reboot
