FROM ausbruhn87/coder-base-ubuntu:latest

USER root

# Install Python and pip
RUN apt-get update && \
    apt-get install -y --no-install-recommends --no-install-suggests \
    python3.12 \
    python3-pip \
    python3.12-venv \
    sshpass \
    openssh-client && \
    rm -rf /var/lib/apt/lists/*

USER coder

# Install Ansible and tools
RUN pip3 install --break-system-packages --user --no-cache-dir \
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
