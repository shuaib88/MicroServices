# MicroServices
Micro-Services Architecture for an ETL data pipeline 

The following codebase outlines the architecture of an ETL data pipeline and themicroservices architecture that implements it. 

The pod specs and diagram of the system are included, however the actual code base, schema for data structures, are propietary and not included. 

## Target System Architecure
The entire system runs on Linux-Fedora24, data replication is implemented using Gluster File System that maintain two data bricks on each node of the system. 

The cluster consists of a single master which host the Kubernetes critical services, and any number of nodes which can be scaled horizontally to decrease processing time.

## MicroService Architecture
Implemented using Kubernetes Pods and Services which create a reliable consistent point of contact for pods to interact without hardcoded IP addresses needed. 

Replication controllers were not included, although they would have increased resilience of the system by starting pods that went down. 

The diagram explains the ETL architecture, but in short: Market data was accessed via query of an 3rd party API. The pod running this service did so in a simulated Ubuntu environment running a windows emulator. 

