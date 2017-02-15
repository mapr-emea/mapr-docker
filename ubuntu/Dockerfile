FROM ubuntu:trusty

MAINTAINER "Carsten Hufe" <chufe@mapr.com>
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -qq update -y --force-yes
RUN apt-get -qq install -y --force-yes \
    python-setuptools \
    wget \
    curl \
    vim \
    git \
    openssh-server \
    sshpass \
	dos2unix \
	lsb-core \
	openjdk-7-jdk \
    rpcbind \
    jq

RUN echo BOOT >> /DOCKER_STATE
