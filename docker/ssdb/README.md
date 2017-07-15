# SSDB Dockerfile
Dockerfile for building ssdb containers.
SSDB is based on leveldb, and is used as a sorted-string table and queuing service.


## Build and Test
Be sure to use included Dockerfile with nothing else in directory
```
$ docker build -t ssdb .
```

Run the container
```
$ docker run -d --name ssdb -p 8880:8888 ssdb
```

Telnet to access ssdb
```
$ telnet localhost 8880
```

Test to see if the server is up.
Type in these codes(with an empty line at the end):
```
3
get
3
key

```

## install python client for ssdb 
```
$ pip install --upgrade pip
$ pip install --upgrade ssdb
```
