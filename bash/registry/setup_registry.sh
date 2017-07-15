#!/bin/bash
set -eux #echo on

dnf install -y httpd-tools docker-distribution


mkdir -p /certs/master.local
openssl req \
 -newkey rsa:4096 -nodes -sha256 -keyout /certs/master.local/domain.key \
 -x509 -days 500 -out /certs/master.local/domain.crt -subj "/C=US/ST=MI/L=Ann Arbor/O=NCLLC/OU=IT Department/CN=master.local"

mkdir -p /etc/docker/certs.d/master.local:5000/
cp /certs/master.local/domain.crt /etc/docker/certs.d/master.local:5000/ca.crt

mkdir -p /home/docker/registry/data/

cat <<EOT >> /etc/docker-distribution/registry/config.yml
version: 0.1
storage:
  filesystem:
    rootdirectory: /home/docker/registry/data/
  delete:
    enabled: true
http:
  addr: master.local:5000
  host: https://master.local:5000
  tls:
      certificate: /certs/master.local/domain.crt
      key: /certs/master.local/domain.key
auth:
  htpasswd:
    realm: basic-realm
    path: /home/docker/registry/passwd
EOT

cat <<EOT >> /etc/pki/tls/openssl.conf
[ alternate_names ]
DNS.1        = master.local
IP.1 = 192.168.1.83
IP.2 = 127.0.0.1
IP.3 = 13::17

[ v3_ca ]
subjectAltName      = @alternate_names
keyUsage = digitalSignature, keyEncipherment

[ CA_default ]
copy_extensions = copy
EOT

firewall-cmd --zone=FedoraServer --add-port=5000/tcp --permanent
firewall-cmd --reload

systemctl enable docker-distribution.service
systemctl start docker-distribution.service

