FROM ausbruhn87/coder-base-ubi9:latest

USER root

# Install Terraform
RUN wget -q https://releases.hashicorp.com/terraform/1.10.3/terraform_1.10.3_linux_amd64.zip && \
    unzip terraform_1.10.3_linux_amd64.zip && \
    mv terraform /usr/local/bin/ && \
    rm terraform_1.10.3_linux_amd64.zip

# Install OpenTofu
RUN wget -q https://github.com/opentofu/opentofu/releases/download/v1.8.8/tofu_1.8.8_linux_amd64.zip && \
    unzip tofu_1.8.8_linux_amd64.zip && \
    mv tofu /usr/local/bin/ && \
    rm tofu_1.8.8_linux_amd64.zip

# Install Terragrunt
RUN wget -q https://github.com/gruntwork-io/terragrunt/releases/latest/download/terragrunt_linux_amd64 -O /usr/local/bin/terragrunt && \
    chmod +x /usr/local/bin/terragrunt

# Install tflint
RUN curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash

# Install tfsec
RUN wget -q https://github.com/aquasecurity/tfsec/releases/latest/download/tfsec-linux-amd64 -O /usr/local/bin/tfsec && \
    chmod +x /usr/local/bin/tfsec

USER coder

WORKDIR /home/coder
