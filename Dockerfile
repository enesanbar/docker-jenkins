FROM jenkins
MAINTAINER Enes Anbar <enesanbar@gmail.com>

# Suppress apt installation warnings
ENV DEBIAN_FRONTEND=noninteractive

# Change to root user
USER root

# Create Docker Group with GID
# Set to 497 by default, which is the group ID used by AWS Linux ECS Instance
# Set default value of 497 if DOCKER_GID set to blank string by Docker Compose
RUN groupadd -g ${DOCKER_GID:-497} docker

# Used to control Docker and Docker Compose versions installed
# NOTE: As of February 2016, AWS Linux ECS only supports Docker 1.9.1
ARG DOCKER_GID
# ARG DOCKER_ENGINE
ARG DOCKER_COMPOSE

# Install base packages
RUN apt-get update -y && \
    apt-get install apt-transport-https ca-certificates software-properties-common curl build-essential libssl-dev libffi-dev \
    python-dev python-setuptools gcc make -y && easy_install pip

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu trusty stable" && \
    apt-get update -y && \
    apt-get install docker-ce -y && \
    usermod -aG docker jenkins && \
    usermod -aG users jenkins

# Install Docker Compose
RUN pip install docker-compose==${DOCKER_COMPOSE:-1.13.0}