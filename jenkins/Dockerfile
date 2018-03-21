FROM jenkins/jenkins:2.112

MAINTAINER Enes Anbar <enesanbar@gmail.com>

# Suppress apt installation warnings
ENV DEBIAN_FRONTEND=noninteractive

# Change to root user
USER root

# Used to control Docker and Docker Compose versions installed
# NOTE: As of February 2016, AWS Linux ECS only supports Docker 1.9.1
ARG DOCKER_GID
# ARG DOCKER_ENGINE
ARG DOCKER_COMPOSE

# Create Docker Group with GID
# Set to 497 by default, which is the group ID used by AWS Linux ECS Instance
# Set default value of 497 if DOCKER_GID set to blank string by Docker Compose
RUN groupadd -g ${DOCKER_GID:-497} docker

# Install base packages
RUN apt-get update -y && \
    apt-get install -y apt-transport-https ca-certificates software-properties-common curl \
    build-essential libssl-dev libffi-dev python-dev python-setuptools gcc make && \
    easy_install pip

# Install Docker Engine
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable" && \
    apt-get -y update && \
    apt-get install -y docker-ce && \
    usermod -aG docker jenkins

# Install Docker Compose
RUN pip install docker-compose

# Change to jenkins user
USER jenkins

# Add Jenkins plugins
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt