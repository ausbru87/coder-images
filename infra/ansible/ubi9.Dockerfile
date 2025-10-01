FROM ausbruhn87/coder-base-ubi9:latest

USER root

# Enable EPEL repository for Ansible packages
RUN dnf install -y \
    https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm && \
    dnf update -y

# Install Ansible and dependencies
RUN dnf install -y \
    ansible \
    ansible-lint \
    python3-jmespath \
    python3-netaddr \
    python3-paramiko \
    python3-passlib \
    python3-cryptography \
    openssh-clients && \
    dnf clean all

USER coder

# Set working directory
WORKDIR /home/coder

# Verify installation
RUN ansible --version && ansible-lint --version
