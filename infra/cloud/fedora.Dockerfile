FROM ausbruhn87/coder-base-fedora:latest

USER root

# Install Python for AWS CLI
RUN dnf update -y && \
    dnf install -y \
    python3.13 \
    python3-pip && \
    dnf clean all

# Install gcloud CLI
RUN tee /etc/yum.repos.d/google-cloud-sdk.repo << EOM
[google-cloud-cli]
name=Google Cloud CLI
baseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el9-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=0
gpgkey=https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOM

RUN dnf install -y google-cloud-cli && dnf clean all

# Install Azure CLI
RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc && \
    dnf install -y https://packages.microsoft.com/config/rhel/9/packages-microsoft-prod.rpm && \
    dnf install -y azure-cli && \
    dnf clean all

USER coder

# Install AWS CLI
RUN pip3 install --user --no-cache-dir awscli aws-shell boto3

# Add pip bin to PATH
ENV PATH="/home/coder/.local/bin:${PATH}"

WORKDIR /home/coder
