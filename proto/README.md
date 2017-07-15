# Proto files

These source files produce the classes for the data objects. 

In order to compile the classes, navigate to the directory containing your .proto files and invoke protoc:
```
$ protoc --python_out=<destination_directory> <proto_filename>
```
