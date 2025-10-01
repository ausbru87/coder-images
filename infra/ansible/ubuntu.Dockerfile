FROM ghcr.io/ausbru87/coder-images/coder-base-ubuntu:latest

USER root

# Install Ansible and dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends --no-install-suggests \
    ansible \
    ansible-lint \
    python3-jmespath \
    python3-netaddr \
    python3-paramiko \
    python3-passlib \
    python3-cryptography \
    sshpass \
    openssh-client && \
    rm -rf /var/lib/apt/lists/*

USER coder

# Set working directory
WORKDIR /home/coder

# Verify installation
RUN ansible --version && ansible-lint --version
