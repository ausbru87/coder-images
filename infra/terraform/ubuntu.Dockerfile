FROM ghcr.io/ausbru87/coder-images/coder-base-ubuntu:latest

USER root

# Install Terraform
RUN ARCH=$(dpkg --print-architecture) && \
    wget -q https://releases.hashicorp.com/terraform/1.10.3/terraform_1.10.3_linux_${ARCH}.zip && \
    unzip terraform_1.10.3_linux_${ARCH}.zip && \
    mv terraform /usr/local/bin/ && \
    rm terraform_1.10.3_linux_${ARCH}.zip

# Install OpenTofu
RUN ARCH=$(dpkg --print-architecture) && \
    wget -q https://github.com/opentofu/opentofu/releases/download/v1.8.8/tofu_1.8.8_linux_${ARCH}.zip && \
    unzip tofu_1.8.8_linux_${ARCH}.zip && \
    mv tofu /usr/local/bin/ && \
    rm tofu_1.8.8_linux_${ARCH}.zip

# Install Terragrunt
RUN ARCH=$(dpkg --print-architecture) && \
    wget -q https://github.com/gruntwork-io/terragrunt/releases/latest/download/terragrunt_linux_${ARCH} -O /usr/local/bin/terragrunt && \
    chmod +x /usr/local/bin/terragrunt

# Install tflint
RUN curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash

# Install tfsec
RUN ARCH=$(dpkg --print-architecture) && \
    wget -q https://github.com/aquasecurity/tfsec/releases/latest/download/tfsec-linux-${ARCH} -O /usr/local/bin/tfsec && \
    chmod +x /usr/local/bin/tfsec

USER coder

WORKDIR /home/coder
