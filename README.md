# Nexus Docker

This is a packaged version of the latest Nexus builds in docker format

## Pre-built containers, ready to run!

I have pushed containers built for several version up to docker hub that
you can just download and run.

```bash
docker run -v /:/ freedomben/nexus:0.2.3.1
```

## Building from scratch

To build a version of the nexus binary, run the following.  You should
replace the version with the one you are trying to build:

```bash
docker build -t freedomben/nexus:0.2.3.1 .
```
