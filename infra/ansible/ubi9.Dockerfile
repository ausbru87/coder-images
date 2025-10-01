FROM ausbruhn87/coder-base-ubi9:latest

USER root

# Install Python and dependencies
RUN dnf update -y && \
    dnf install -y \
    python3.12 \
    python3-pip \
    openssh-clients && \
    dnf clean all

USER coder

# Install Ansible and tools
RUN pip3 install --user --no-cache-dir \
    ansible \
    ansible-core \
    ansible-lint \
    molecule \
    yamllint \
    jmespath \
    netaddr \
    dnspython

# Add pip bin to PATH
ENV PATH="/home/coder/.local/bin:${PATH}"

WORKDIR /home/coder
