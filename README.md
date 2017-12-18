# Nexus Docker

This is a packaged version of the latest Nexus builds in docker format

## Pre-built containers, ready to run!

I have pushed containers built for several version up to docker hub that
you can just download and run.

To use it, create a directory called `nexus-data` (the name can
be whatever you want).  This will be used to store data from your container
so that the files are persistent.  You will also add a `nexus.conf` file to
it for providing configuration to the daemon.

```bash
# Create the nexus.conf for mounting:
mkdir -p nexus-data/.Nexus
echo "rpcuser=rpcserver" > nexus-data/.Nexus/nexus.conf
echo "rpcpassword=$(uuidgen | base64 | sed -e 's/=//g')" >> nexus-data/.Nexus/nexus.conf

# Run the container, mounting in your config file
docker run -v "$(pwd)/Nexus:/home/docker/.Nexus" freedomben/nexus:0.2.3.1
```

## Building from scratch

To build a version of the nexus binary, run the following.  You should
replace the version with the one you are trying to build:

```bash
docker build -t freedomben/nexus:0.2.3.1 .
```
