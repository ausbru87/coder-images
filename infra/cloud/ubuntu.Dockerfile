FROM ausbruhn87/coder-base-ubuntu:latest

USER root

# Install Python for AWS CLI
RUN apt-get update && \
    apt-get install -y --no-install-recommends --no-install-suggests \
    python3.12 \
    python3-pip \
    python3.12-venv \
    apt-transport-https \
    ca-certificates \
    gnupg && \
    rm -rf /var/lib/apt/lists/*

# Install gcloud CLI
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | \
    tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
    gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg && \
    apt-get update && \
    apt-get install -y google-cloud-cli && \
    rm -rf /var/lib/apt/lists/*

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

USER coder

# Install AWS CLI
RUN pip3 install --break-system-packages --user --no-cache-dir awscli aws-shell boto3

# Add pip bin to PATH
ENV PATH="/home/coder/.local/bin:${PATH}"

WORKDIR /home/coder
