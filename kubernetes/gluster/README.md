# Attach Gluster Volume to Container

These instructions can be used to provide a gluster volume to a container. Instruction attribution [here](https://github.com/kubernetes/kubernetes/tree/master/examples/volumes/glusterfs)

## Create endpoints

Write a spec file for the endpoints. Use the sample [glusterfs-endpoints.json](https://github.com/shuaib88/cluster_setup/blob/initialSetup/gluster_vol_examples/glusterfs-endpoints.json) as a guide

Ping each node and obtain the IP address. Your spec file should use the IPv4 format to declare each node. For example:

```
    {
      "addresses": [
        {
          "ip": "192.168.1.68"
        }
      ],
      "ports": [
        {
          "port": 9999
        }
      ]
    }
```

Create the endpoints
```
$ kubectl create -f glusterfs-endpoints.json
```
Verify that the endpoints are successfully created by running
```
$ kubectl get endpoints
NAME                ENDPOINTS                       
glusterfs-cluster   192.168.1.68:1,192.168.1.69:1   
```
Create a service for these endpoints so that they will be persistent. See [glusterfs-service.json](https://github.com/shuaib88/cluster_setup/blob/initialSetup/gluster_vol_examples/glusterfs-services.json) for details
```
$ kubectl create -f glusterfs-service.json
```

## Create a POD

The following volume spec in [glusterfs-pod.json](https://github.com/shuaib88/cluster_setup/blob/initialSetup/gluster_vol_examples/glusterfs-pod.json) illustrates a sample configuration.
```
  {
      "name": "glusterfsvol",
      "glusterfs": {
          "endpoints": "glusterfs-cluster",
          "path": "gv0",
          "readOnly": false
      }
  }
```
The parameters are explained as follows:
- **endpoints** the endpoints name we defined in our endpoints service. The pod will randomly pick one of the endpoints to mount.
- **path** is the Glusterfs volume name.
- **readOnly** is the boolean which sets the mountpoint as readOnly or readWrite.

Create a pod that has a container using Glusterfs volume
```
$ kubectl create -f glusterfs-pod.json
```

Verify the pod is running
```
$ kubectl get pods
NAME        READY     STATUS    RESTARTS   AGE
glusterfs   1/1       Running   0          7h

$ kubectl get pods glusterfs --template '{{.status.hostIP}}{{"\n"}}'
192.168.1.68
```

Check if the Glusterfs volume is mounted. ssh into host and run 'mount'
```
$ mount | grep gv0
192.168.1.68:gv0 on /var/lib/kubelet/pods/68c71672-5733-11e6-90eb-08002713a57e/volumes/kubernetes.io~glusterfs/glusterfsvol type fuse.glusterfs (rw,relatime,user_id=0,group_id=0,default_permissions,allow_other,max_read=131072)
```

You can also run `docker ps` on the host to see the actual container
