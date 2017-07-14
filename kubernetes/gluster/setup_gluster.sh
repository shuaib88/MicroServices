kubectl delete endpoints glusterfs-cluster
kubectl delete service glusterfs-cluster

kubectl create -f glusterfs-endpoints.json
kubectl create -f glusterfs-service.json
