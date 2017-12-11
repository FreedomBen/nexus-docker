FROM ubuntu:16.04
MAINTAINER Benjamin Porter

ARG NEXUS_VERSION=0.2.3.1
ENV DOCKER_HOME /home/docker

## Create a 'docker' user
RUN addgroup --gid 9999 docker \
 && adduser --uid 9999 --gid 9999 --disabled-password --gecos "Docker User" docker \
 && usermod -L docker

## APT setup
## Upgrade all packages
## Install common tools
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get upgrade -y \
 && apt-get install -y --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    software-properties-common \
    language-pack-en \
    locales \
    git \
    unzip \
    wget \
 && apt-get install -y --no-install-recommends \
    build-essential \
    libboost-all-dev \
    libdb-dev \
    libdb++-dev \
    libssl-dev \
    libminiupnpc-dev \
    libqrencode-dev \
    qt4-qmake libqt4-dev \
    lib32z1-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/

## Ensure UTF-8 locale
RUN locale-gen en_US.UTF-8
ENV LANG       en_US.UTF-8
ENV LC_ALL     en_US.UTF-8
RUN dpkg-reconfigure locales

## Build and install Nexus
ADD https://github.com/Nexusoft/Nexus/archive/${NEXUS_VERSION}.tar.gz /root/
RUN cd /root \
 && tar xzvf ${NEXUS_VERSION}.tar.gz \
 && cd Nexus-${NEXUS_VERSION} \
 && make -j $(( $(nproc --all) - 1)) -f makefile.unix \
 && mv nexus /usr/local/bin/

# Switch to the 'docker' user
USER docker

# Download current bootstrap db
WORKDIR $DOCKER_HOME
RUN wget http://nexusearth.com/bootstrap/LLD-Database/recent.zip \
 && unzip recent.zip \
 && rm recent.zip

CMD /usr/local/bin/nexus
