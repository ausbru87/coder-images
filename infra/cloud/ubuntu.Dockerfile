FROM ausbruhn87/coder-base-ubuntu:latest

USER root

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends --no-install-suggests \
    python3 \
    python3-pip \
    apt-transport-https \
    ca-certificates \
    gnupg \
    curl \
    unzip \
    less \
    groff && \
    rm -rf /var/lib/apt/lists/*

# Install AWS CLI v2
RUN ARCH=$(dpkg --print-architecture) && \
    if [ "$ARCH" = "amd64" ]; then \
        curl -sL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"; \
    elif [ "$ARCH" = "arm64" ]; then \
        curl -sL "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"; \
    fi && \
    unzip -q awscliv2.zip && \
    ./aws/install && \
    rm -rf aws awscliv2.zip && \
    aws --version

# Install gcloud CLI
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | \
    tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl -sL https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
    gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg && \
    apt-get update && \
    apt-get install -y google-cloud-cli && \
    rm -rf /var/lib/apt/lists/* && \
    gcloud --version

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash && \
    az --version

USER coder

# Install additional AWS tools
RUN pip3 install --break-system-packages --user --no-cache-dir aws-shell boto3 && \
    echo 'alias aws-shell="aws-shell --region=${AWS_REGION:-us-east-1}"' >> ~/.bashrc

WORKDIR /home/coder
