#!/bin/bash
set -x #echo on

BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

COMMAND_OUTPUT=( $(kubectl get pods  | grep iqfeed-pod) )

if [ "${#COMMAND_OUTPUT}" -ge 1 ]; then
  kubectl delete pod ${COMMAND_OUTPUT[0]}
  while [ "${#COMMAND_OUTPUT}" -ge 1 ]
  do
    COMMAND_OUTPUT=( $(kubectl get pod iqfeed-pod) )
    echo 'Waiting for pod to terminate'
    sleep 10
  done
fi

kubectl create -f $BASE_DIR/iqfeed_pod.yaml
kubectl create -f $BASE_DIR/iqfeed_svc.yaml
