FROM ghcr.io/ausbru87/coder-base-ubuntu:latest

USER root

# Install base dependencies and standard CLI tools
RUN apt-get update && \
    apt-get install -y --no-install-recommends --no-install-suggests \
    python3 \
    python3-pip \
    apt-transport-https \
    ca-certificates \
    gnupg \
    curl \
    wget \
    unzip \
    less \
    vim \
    nano \
    jq \
    groff && \
    rm -rf /var/lib/apt/lists/*

# ===== Cloud CLIs =====

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

# ===== Kubernetes & OpenShift =====

# Install kubectl
RUN ARCH=$(dpkg --print-architecture) && \
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/${ARCH}/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm kubectl && \
    kubectl version --client

# Install Helm
RUN ARCH=$(dpkg --print-architecture) && \
    HELM_VERSION=$(curl -s https://api.github.com/repos/helm/helm/releases/latest | grep tag_name | cut -d '"' -f 4) && \
    curl -LO "https://get.helm.sh/helm-${HELM_VERSION}-linux-${ARCH}.tar.gz" && \
    tar -zxvf "helm-${HELM_VERSION}-linux-${ARCH}.tar.gz" && \
    mv linux-${ARCH}/helm /usr/local/bin/helm && \
    rm -rf linux-${ARCH} "helm-${HELM_VERSION}-linux-${ARCH}.tar.gz" && \
    helm version

# Install k9s
RUN ARCH=$(dpkg --print-architecture) && \
    K9S_ARCH=$([ "$ARCH" = "amd64" ] && echo "amd64" || echo "arm64") && \
    wget -q https://github.com/derailed/k9s/releases/latest/download/k9s_Linux_${K9S_ARCH}.tar.gz && \
    tar -xzf k9s_Linux_${K9S_ARCH}.tar.gz -C /usr/local/bin k9s && \
    rm k9s_Linux_${K9S_ARCH}.tar.gz && \
    k9s version

# Install kubectx and kubens
RUN wget -q https://github.com/ahmetb/kubectx/releases/latest/download/kubectx -O /usr/local/bin/kubectx && \
    wget -q https://github.com/ahmetb/kubectx/releases/latest/download/kubens -O /usr/local/bin/kubens && \
    chmod +x /usr/local/bin/kubectx /usr/local/bin/kubens

# Install kustomize
RUN curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash && \
    mv kustomize /usr/local/bin/ && \
    kustomize version

# Install stern (log viewer)
RUN ARCH=$(dpkg --print-architecture) && \
    STERN_VERSION=$(curl -s https://api.github.com/repos/stern/stern/releases/latest | grep tag_name | cut -d '"' -f 4) && \
    wget -q https://github.com/stern/stern/releases/download/${STERN_VERSION}/stern_${STERN_VERSION#v}_linux_${ARCH}.tar.gz && \
    tar -xzf stern_${STERN_VERSION#v}_linux_${ARCH}.tar.gz && \
    mv stern /usr/local/bin/stern && \
    rm stern_${STERN_VERSION#v}_linux_${ARCH}.tar.gz && \
    chmod +x /usr/local/bin/stern

# Install OpenShift CLI (oc) - Temporarily disabled due to build issues
# TODO: Re-enable once we can debug the installation
# RUN ARCH=$(dpkg --print-architecture) && \
#     if [ "$ARCH" = "amd64" ]; then \
#         OC_ARCH="x86_64"; \
#     elif [ "$ARCH" = "arm64" ]; then \
#         OC_ARCH="arm64"; \
#     fi && \
#     OC_VERSION=$(curl -s https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/release.txt | grep 'Name:' | awk '{print $2}') && \
#     wget -q https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/openshift-client-linux-${OC_ARCH}.tar.gz && \
#     tar -xzf openshift-client-linux-${OC_ARCH}.tar.gz && \
#     mv oc /usr/local/bin/ && \
#     rm -f openshift-client-linux-${OC_ARCH}.tar.gz kubectl README.md && \
#     oc version --client

# Install OpenShift Installer - Temporarily disabled due to build issues
# TODO: Re-enable once we can debug the installation
# RUN ARCH=$(dpkg --print-architecture) && \
#     if [ "$ARCH" = "amd64" ]; then \
#         OC_ARCH="x86_64"; \
#     elif [ "$ARCH" = "arm64" ]; then \
#         OC_ARCH="arm64"; \
#     fi && \
#     wget -q https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/openshift-install-linux-${OC_ARCH}.tar.gz && \
#     tar -xzf openshift-install-linux-${OC_ARCH}.tar.gz && \
#     mv openshift-install /usr/local/bin/ && \
#     rm -f openshift-install-linux-${OC_ARCH}.tar.gz README.md && \
#     openshift-install version

# ===== Infrastructure as Code =====

# Install Terraform
RUN ARCH=$(dpkg --print-architecture) && \
    TERRAFORM_VERSION=$(curl -s https://api.github.com/repos/hashicorp/terraform/releases/latest | grep tag_name | cut -d '"' -f 4 | sed 's/v//') && \
    wget -q https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${ARCH}.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_${ARCH}.zip && \
    mv terraform /usr/local/bin/ && \
    rm terraform_${TERRAFORM_VERSION}_linux_${ARCH}.zip && \
    terraform version

# Install OpenTofu
RUN ARCH=$(dpkg --print-architecture) && \
    TOFU_VERSION=$(curl -s https://api.github.com/repos/opentofu/opentofu/releases/latest | grep tag_name | cut -d '"' -f 4 | sed 's/v//') && \
    wget -q https://github.com/opentofu/opentofu/releases/download/v${TOFU_VERSION}/tofu_${TOFU_VERSION}_linux_${ARCH}.zip && \
    unzip tofu_${TOFU_VERSION}_linux_${ARCH}.zip && \
    mv tofu /usr/local/bin/ && \
    rm tofu_${TOFU_VERSION}_linux_${ARCH}.zip && \
    tofu version

# Install Terragrunt
RUN ARCH=$(dpkg --print-architecture) && \
    wget -q https://github.com/gruntwork-io/terragrunt/releases/latest/download/terragrunt_linux_${ARCH} -O /usr/local/bin/terragrunt && \
    chmod +x /usr/local/bin/terragrunt && \
    terragrunt --version

# Install tflint
RUN curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash && \
    tflint --version

# Install tfsec
RUN ARCH=$(dpkg --print-architecture) && \
    wget -q https://github.com/aquasecurity/tfsec/releases/latest/download/tfsec-linux-${ARCH} -O /usr/local/bin/tfsec && \
    chmod +x /usr/local/bin/tfsec && \
    tfsec --version

# ===== Version Control & CI/CD =====

# Install GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | \
    gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg && \
    chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | \
    tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
    apt-get update && \
    apt-get install -y gh && \
    rm -rf /var/lib/apt/lists/* && \
    gh --version

USER coder

# Install additional AWS tools
RUN pip3 install --break-system-packages --user --no-cache-dir aws-shell boto3 && \
    echo 'alias aws-shell="aws-shell --region=${AWS_REGION:-us-east-1}"' >> ~/.bashrc

WORKDIR /home/coder
