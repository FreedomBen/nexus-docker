# Nexus Docker

This is a packaged version of the latest Nexus builds in docker format.

To use this, you'll need [docker](https://docs.docker.com/engine/installation/) installed.

## Install Docker

You will need docker installed in order to build/run the image (I know, this is
technically not true because [rkt](https://coreos.com/rkt/) can run docker
containers, but that's out of scope for this tutorial).

You can install the official versions for
[Mac](https://docs.docker.com/docker-for-mac/install/) and
[Windows](https://docs.docker.com/docker-for-windows/install/).

Linux you can probably just install it from the repos:

```bash
# Fedora
sudo dnf install docker

# Ubuntu
sudo apt install docker.io
```

Sometimes ubuntu tends to ship an older version, but you can
[use the PPAs](https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/)
To get a fresher one.


## Pre-built containers, ready to run!

I have pushed containers built for several version up to
[docker hub](https://hub.docker.com/r/freedomben/nexus/) that
you can just download and run.

To use it, create a directory called `Nexus` (the name can
be whatever you want).  This will be used to store data from your container
so that the files are persistent.  You will also add a `nexus.conf` file to
it for providing configuration to the daemon.

```bash
# Create the nexus.conf for mounting:
mkdir -p Nexus
echo "rpcuser=rpcserver" > Nexus/nexus.conf
echo "rpcpassword=$(uuidgen | base64 | sed -e 's/=//g')" >> Nexus/nexus.conf

# Run the container, mounting in your config file
docker run -v "$(pwd)/Nexus:/home/docker/.Nexus" freedomben/nexus:0.2.3.1
```

## Building from scratch

To build an image for the nexus binary, run the following.  You should
replace the version below with the one you are trying to build:

```bash
docker build -t freedomben/nexus:0.2.3.1 .
```

