#SETUP

## Private Registry

These instructions detail setting up a private registry, in order to pull and push images locally instead of using docker's public repository hub.

Kubernetes requires private registry to have basic HTTP authentication support

Attributions: [skeleton of instructions](http://www.ibm.com/developerworks/library/l-docker-private-reg/index.html), [enabling IP SANS](https://github.com/docker/distribution/issues/948)

Update setup_registry.sh line 37 with IP addresses of all the nodes you'd like to access the private registry
```
[ alternate_names ]
DNS.1        = master.local
IP.1 = 192.168.1.83
IP.2 = 127.0.0.1
IP.3 = 13::17
```
Run the setup script:
```
$ su
$ cd /tmp
$ git clone https://github.com/ncllc/ncllc_external
$ cd ncllc_external/bash/registry
$ ./setup_registry.sh
```

Install password utilities and create registry login credentials (this example uses registry_user as the username):
```
$ htpasswd -Bc /home/docker/registry/passwd registry_user
```

Add the certs and keys to docker registry
```
$ REGISTRY_HTTP_TLS_CERTIFICATE=/certs/master.local/domain.crt REGISTRY_HTTP_TLS_KEY=/certs/master.local/domain.key
```

Launch the registry
```
$ registry serve /etc/docker-distribution/registry/config.yml
```

Copy the certificates to all docker hosts, for example node00.local:

From node00.local
```
$ mkdir -p /etc/docker/certs.d/master.local:5000/
```

From master.local
```
$ scp /certs/master.local/domain.crt node00.local:/etc/docker/certs.d/master.local:5000/ca.crt
```

Attempt to login from node00
```
$ docker login master.local:5000
```

## Kubernetes access

Create an image pull secret to provide kuberentes pods wtih login credentials for the registry.

From master.local
```
kubectl create secret docker-registry ncllcregistrykey --docker-server=master.local:5000 --docker-username=<registry_username> --docker-password=<password> --docker-email=<email>
```
