The pod specs in this directory contain details for pods used for obtaining stock data, creating an ssdb database, persisting data in a gluster volume, and fetching/processing that stock data.

All pod specs in this directory pull fromthe private registry created in /project/docker/private_registry/README.md

### Execute alternate container command

By default kubernetes will execute the CMD and ENTRYPOINT defined in the Dockerfile for an image. To override this use the fields "command" and "args" to specify the command you'd like to execute along with the arguments you'd like to pass the command. 

This snippet from fetch_data_isolated.yaml for example:

```
    7 spec:
    8   containers:
    9     - name: fetchdataiso
   10       image: 192.168.1.68:5000/fetch_data
   11       command: ["python"]
   12       args: ["feed/fetch_data.py"]
``` 

### Create Image Pull Secret

In order for kubernetes pods to use the private registry, registry login credentials must be provided in the pod spec. This is accomplished through [Image Pull Secrets](http://kubernetes.io/docs/user-guide/images/#specifying-imagepullsecrets-on-a-pod)
Create the secret by replacing the uppercase letters with the credentials you login details
for your registry.
```
$ kubectl create secret docker-registry myregistrykey --docker-server=DOCKER_REGISTRY_SERVER --docker-username=DOCKER_USER --docker-password=DOCKER_PASSWORD --docker-email=DOCKER_EMAIL
```
You can view the secret
```
$ kubectl get secret
```
 
Use your secret by adding to pod spec, nested below the spec heading. For example:
```
   1 kind: Pod
   2 apiVersion: v1
   3 metadata:
   4   name: fetchdataiso
   5   labels:
   6     name: fetchdataiso
   7 spec:
   8   containers:
   9     - name: fetchdataiso
  10       image: 192.168.1.68:5000/fetch_data
  11   imagePullSecrets:
  12     - name: myregistrykey
 ```

### Attach a Gluster Volume to SSDB

These instructions show how an SSDB pod can use a gluster volume for persistent storage. Use the files in /project/kubernetes/ssdb.

Before beginning these steps run the create endpoints and service for gluster from the "Attach Gluster Volume to Container"  section below. 

#### Create Service

Create ssdb service, endpoints are not necesary to declare seperately.
```
$ kubectl create -f ssdb_service.yaml
```

Verify service is running
```
$ kubectl get services
```

#### Create Pod
Create ssdb pod with correct image, containers, volumeMounts.
```
kubectl create -f ssdb_with_glustervolume.yaml
```

Snippet from /project/Kubernetes/ssdb/ssdb_with_glustervol.yaml: 
```
  7 spec:
  8   containers:
  9     - name: ssdb
 10       image: 192.168.1.68:5000/ssdb
 11       ports:
 12         - hostPort: 8880
 13           containerPort: 8888
 14       volumeMounts:
 15         - mountPath: /var/lib/ssdb
 16           name: glusterfsvol
 17   volumes:
 18     - name: glusterfsvol
 19       glusterfs:
 20         endpoints: glusterfs-cluster
 21         path: gv0
 22         readOnly: false
```
'mountPath' refers to the desired directory you would like to persist and be pre-populated with any data on the gluster volume.  
'path' refers to the name of the gluster volume previously defined. 

Verify data is peristing by adding to data to the ssdb server, querying ssdb for information. Deleting and re-creating them pod and the querying ssdb to check if the information persisted. 




