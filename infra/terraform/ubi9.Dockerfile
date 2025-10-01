FROM ghcr.io/ausbru87/coder-images/coder-base-ubi9:latest

USER root

# Install Terraform
RUN ARCH=$(uname -m) && \
    TF_ARCH=$([ "$ARCH" = "x86_64" ] && echo "amd64" || echo "arm64") && \
    wget -q https://releases.hashicorp.com/terraform/1.10.3/terraform_1.10.3_linux_${TF_ARCH}.zip && \
    unzip terraform_1.10.3_linux_${TF_ARCH}.zip && \
    mv terraform /usr/local/bin/ && \
    rm terraform_1.10.3_linux_${TF_ARCH}.zip

# Install OpenTofu
RUN ARCH=$(uname -m) && \
    TF_ARCH=$([ "$ARCH" = "x86_64" ] && echo "amd64" || echo "arm64") && \
    wget -q https://github.com/opentofu/opentofu/releases/download/v1.8.8/tofu_1.8.8_linux_${TF_ARCH}.zip && \
    unzip tofu_1.8.8_linux_${TF_ARCH}.zip && \
    mv tofu /usr/local/bin/ && \
    rm tofu_1.8.8_linux_${TF_ARCH}.zip

# Install Terragrunt
RUN ARCH=$(uname -m) && \
    TG_ARCH=$([ "$ARCH" = "x86_64" ] && echo "amd64" || echo "arm64") && \
    wget -q https://github.com/gruntwork-io/terragrunt/releases/latest/download/terragrunt_linux_${TG_ARCH} -O /usr/local/bin/terragrunt && \
    chmod +x /usr/local/bin/terragrunt

# Install tflint
RUN curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash

# Install tfsec
RUN ARCH=$(uname -m) && \
    TFSEC_ARCH=$([ "$ARCH" = "x86_64" ] && echo "amd64" || echo "arm64") && \
    wget -q https://github.com/aquasecurity/tfsec/releases/latest/download/tfsec-linux-${TFSEC_ARCH} -O /usr/local/bin/tfsec && \
    chmod +x /usr/local/bin/tfsec

USER coder

WORKDIR /home/coder
