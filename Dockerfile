FROM ubuntu:16.04
MAINTAINER Benjamin Porter

ARG NEXUS_VERSION=0.2.3.1
ENV DOCKER_HOME /home/docker
ENV QT_GRAPHICSSYSTEM native

## Create a 'docker' user
RUN addgroup --gid 1000 docker \
 && adduser --uid 1000 --gid 1000 --disabled-password --gecos "Docker User" docker \
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

## Build and install nexus/nexus-qt
WORKDIR /root
ADD https://github.com/Nexusoft/Nexus/archive/${NEXUS_VERSION}.tar.gz /root/
RUN tar xzvf ${NEXUS_VERSION}.tar.gz \
 && cd Nexus-${NEXUS_VERSION} \
 && make -j $(( $(nproc --all) - 1)) -f makefile.unix \
 && mv nexus /usr/local/bin/ \
 && qmake-qt4 nexus-qt.pro "RELEASE=1" "USE_UPNP=1" "USE_LLD=1" \
 && make -j $(( $(nproc --all) - 1)) \
 && mv nexus-qt /usr/local/bin/

# Switch to the 'docker' user
USER docker
WORKDIR $DOCKER_HOME

# Download current bootstrap db
#RUN wget http://nexusearth.com/bootstrap/LLD-Database/recent.zip \
# && unzip recent.zip \
# && rm recent.zip

CMD /usr/local/bin/nexus
