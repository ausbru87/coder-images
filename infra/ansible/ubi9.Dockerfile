FROM ghcr.io/ausbru87/coder-base-ubi9:latest

USER root

# Install Python and dependencies
RUN dnf install -y \
    python3 \
    python3-pip \
    openssh-clients \
    sshpass && \
    dnf clean all

# Install Ansible and Python packages via pip
RUN pip3 install --no-cache-dir \
    ansible \
    ansible-lint \
    jmespath \
    netaddr \
    paramiko \
    passlib

USER coder

# Set working directory
WORKDIR /home/coder
