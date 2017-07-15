Dockerized IQFeed client
=======================

Details
-------

This image runs an IQFeed client (version 5.2.3.0) using Ubuntu 16.04 and wine.

It exposes IQFeed ports 5009 and 9100 as 5010 and 9101 correspondingly. Port change is because IQFeed listens on localhost and proxy embeded into container translates those ports to 5010 and 9101.

Image accepts following environment variables:

* LOGIN - IQFeed account login (not the one for http://iqfeed.net site, by for IQFeed client)
* PASSWORD - IQFeed account password
* APP_NAME - application name that is passed to the IQFeed server (if you don't have one, or don't know it, it will still work with IQFEED_DEMO app name)
* APP_VERSION - application version that is passed to IQFeed (defaults to 1.0.0.0)

Building docker image
---------------------

If you want to build your own image, probably with modification, follow the steps below.

I recommend doing it on Ubuntu 14.04 machine so that it is similar to what is within container and Wine application installed on host machine will work well within container. You can set up one in 5 minutes using, for example, http://digitalocean.com.

Idea and Makefile are borrowed from https://github.com/macdice/iqfeed-debian.

1. Prepare base ubuntu image with pre-reqs

```
apt-get update
apt-get upgrade
apt-get install -y software-properties-common
apt-get update
add-apt-repository -y ppa:ubuntu-wine/ppa
apt-get -y install wine1.8 git docker.io vim
```

2. If need be, please install a X based client. Connect to host with the -X option `ssh -X user@ubuntuvm` and continue below.  

3. Run `make fetch` in this folder to download IQFeed Client installation file. You can change IQFeed Client version at the top of Makefile.

4. Launch GUI (launches automatically in step 6 if using XQuartz)

5. Run `make install`. Don't change default settings

6. Run `make launch`. Enter your username and password, check "Save Login And Password" and "Automatically Connect" checkboxes

7. You can exit GUI now

8. Edit iqfeed.conf and enter your desired iqfeed version and product name

9. Install docker, if you haven't before: `curl -sSL https://get.docker.io/ubuntu/ | sudo sh`

10. In the current folder, run `docker build -t ncllc/iqfeed .`

11. Your image is ready and named `iqfeed`

12. You can run it now: `docker run -p 5010:5009 -p 9101:9100 -e APP_NAME=REZA_KAMALY_1619 -e APP_VERSION=Options1.1 -e LOGIN=login -e PASSWORD=password iqfeed`

Running Container on a Different Machine
----------------------------------------

For transferring images without using docker registry: 

Build and export the image 

1. `docker build -t ncllc/iqfeed .`

2. `docker save ncllc/iqfeed > /desired-path-to-file/ncllc_iqfeed.tar`

3. navigate to your desired path on target machine and run `rsync -avz --partial --progress machinelogin@hostname:/tmp/ncllc_iqfeed.tar .` 

Load the image and run the container

4. `docker load < /path-to-file/ncllc_iqfeed.tar` 

5. Image should appear in registry `docker images`

6. `docker run -d --name feed -p 5009:5010 -p 9100:9101 -e APP_NAME=REZA_KAMALY_1619 -e APP_VERSION=Options1.1 -e LOGIN=login -e PASSWORD=password ncllc/iqfeed`. 

7. Listen on the correct port `telnet localhost 9100`.

Usage
-----

```
docker run -e LOGIN=<your iqfeed login> -e PASSWORD=<your iqfeed password> -p 5009:5010 -p 9100:9101 ncllc/iqfeed
```

You should see out put like this:
```
Connecting to port  9300
Disconnected. Reconnecting in 1 second.
Connecting to port  9300
Disconnected. Reconnecting in 1 second.
fixme:thread:GetThreadPreferredUILanguages 52, 0x32fac4, 0x32fb34 0x32facc
fixme:heap:HeapSetInformation (nil) 1 (nil) 0
fixme:thread:GetThreadPreferredUILanguages 52, 0x32f880, 0x32f8f0 0x32f888
```

That's totally ok.

Wait until you start seeing log lines that have word "Connected" in them. They should look like this:

```
S,STATS,66.112.148.223,60002,500,0,1,0,5,0,Aug 20 2:42PM,Aug 20 2:42PM,Connected,5.1.1.0,416828,0.55,0.02,0.03,3.94,0.11,0.18,
```

Here you go, now you should be able to connect to ports 5009 or 9100 to the current machine as if you're connecting to an IQFeed client.

If you don't start seeing "Connected" lines in about 1 minute, then you probably entered login or password incorrectly. Unfortunately, IQFeed doesn't say anything about it, just doesn't connect.


