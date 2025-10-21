FROM ghcr.io/ausbru87/coder-base-ubi9:latest

USER root

# Install base dependencies and standard CLI tools
RUN dnf update -y && \
    dnf install -y \
    python3 \
    python3-pip \
    unzip \
    less \
    vim \
    nano \
    jq \
    tar \
    gzip && \
    dnf clean all

# ===== Cloud CLIs =====

# Install AWS CLI v2
RUN ARCH=$(uname -m) && \
    if [ "$ARCH" = "x86_64" ]; then \
        curl -sL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"; \
    elif [ "$ARCH" = "aarch64" ]; then \
        curl -sL "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"; \
    fi && \
    unzip -q awscliv2.zip && \
    ./aws/install && \
    rm -rf aws awscliv2.zip && \
    aws --version

# Install gcloud CLI
RUN ARCH=$(uname -m) && \
    tee /etc/yum.repos.d/google-cloud-sdk.repo << EOM
[google-cloud-cli]
name=Google Cloud CLI
baseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el9-${ARCH}
enabled=1
gpgcheck=1
repo_gpgcheck=0
gpgkey=https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOM

RUN dnf install -y google-cloud-cli && \
    dnf clean all && \
    gcloud --version

# Install Azure CLI
RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc && \
    dnf install -y https://packages.microsoft.com/config/rhel/9/packages-microsoft-prod.rpm && \
    dnf install -y azure-cli && \
    dnf clean all && \
    az --version

# ===== Kubernetes & OpenShift =====

# Install kubectl
RUN ARCH=$(uname -m) && \
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/${ARCH}/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm kubectl && \
    kubectl version --client

# Install Helm
RUN ARCH=$(uname -m) && \
    HELM_VERSION=$(curl -s https://api.github.com/repos/helm/helm/releases/latest | grep tag_name | cut -d '"' -f 4) && \
    curl -LO "https://get.helm.sh/helm-${HELM_VERSION}-linux-${ARCH}.tar.gz" && \
    tar -zxvf "helm-${HELM_VERSION}-linux-${ARCH}.tar.gz" && \
    mv linux-${ARCH}/helm /usr/local/bin/helm && \
    rm -rf linux-${ARCH} "helm-${HELM_VERSION}-linux-${ARCH}.tar.gz" && \
    helm version

# Install k9s
RUN ARCH=$(uname -m) && \
    K9S_ARCH=$([ "$ARCH" = "x86_64" ] && echo "amd64" || echo "arm64") && \
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
RUN ARCH=$(uname -m) && \
    STERN_VERSION=$(curl -s https://api.github.com/repos/stern/stern/releases/latest | grep tag_name | cut -d '"' -f 4) && \
    wget -q https://github.com/stern/stern/releases/download/${STERN_VERSION}/stern_${STERN_VERSION#v}_linux_${ARCH}.tar.gz && \
    tar -xzf stern_${STERN_VERSION#v}_linux_${ARCH}.tar.gz && \
    mv stern /usr/local/bin/stern && \
    rm stern_${STERN_VERSION#v}_linux_${ARCH}.tar.gz && \
    chmod +x /usr/local/bin/stern

# Install OpenShift CLI (oc)
RUN ARCH=$(uname -m) && \
    if [ "$ARCH" = "x86_64" ]; then \
        OC_ARCH="x86_64"; \
    elif [ "$ARCH" = "aarch64" ]; then \
        OC_ARCH="arm64"; \
    fi && \
    OC_VERSION=$(curl -s https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/release.txt | grep 'Name:' | awk '{print $2}') && \
    wget -q https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/openshift-client-linux-${OC_ARCH}.tar.gz && \
    tar -xzf openshift-client-linux-${OC_ARCH}.tar.gz && \
    mv oc /usr/local/bin/ && \
    rm openshift-client-linux-${OC_ARCH}.tar.gz kubectl README.md && \
    oc version --client

# Install OpenShift Installer
RUN ARCH=$(uname -m) && \
    if [ "$ARCH" = "x86_64" ]; then \
        OC_ARCH="x86_64"; \
    elif [ "$ARCH" = "aarch64" ]; then \
        OC_ARCH="arm64"; \
    fi && \
    wget -q https://mirror.openshift.com/pub/openshift-v4/clients/ocp/stable/openshift-install-linux-${OC_ARCH}.tar.gz && \
    tar -xzf openshift-install-linux-${OC_ARCH}.tar.gz && \
    mv openshift-install /usr/local/bin/ && \
    rm openshift-install-linux-${OC_ARCH}.tar.gz README.md && \
    openshift-install version

# ===== Infrastructure as Code =====

# Install Terraform
RUN ARCH=$(uname -m) && \
    TERRAFORM_VERSION=$(curl -s https://api.github.com/repos/hashicorp/terraform/releases/latest | grep tag_name | cut -d '"' -f 4 | sed 's/v//') && \
    wget -q https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${ARCH}.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_${ARCH}.zip && \
    mv terraform /usr/local/bin/ && \
    rm terraform_${TERRAFORM_VERSION}_linux_${ARCH}.zip && \
    terraform version

# Install OpenTofu
RUN ARCH=$(uname -m) && \
    TOFU_VERSION=$(curl -s https://api.github.com/repos/opentofu/opentofu/releases/latest | grep tag_name | cut -d '"' -f 4 | sed 's/v//') && \
    wget -q https://github.com/opentofu/opentofu/releases/download/v${TOFU_VERSION}/tofu_${TOFU_VERSION}_linux_${ARCH}.zip && \
    unzip tofu_${TOFU_VERSION}_linux_${ARCH}.zip && \
    mv tofu /usr/local/bin/ && \
    rm tofu_${TOFU_VERSION}_linux_${ARCH}.zip && \
    tofu version

# Install Terragrunt
RUN ARCH=$(uname -m) && \
    wget -q https://github.com/gruntwork-io/terragrunt/releases/latest/download/terragrunt_linux_${ARCH} -O /usr/local/bin/terragrunt && \
    chmod +x /usr/local/bin/terragrunt && \
    terragrunt --version

# Install tflint
RUN curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash && \
    tflint --version

# Install tfsec
RUN ARCH=$(uname -m) && \
    wget -q https://github.com/aquasecurity/tfsec/releases/latest/download/tfsec-linux-${ARCH} -O /usr/local/bin/tfsec && \
    chmod +x /usr/local/bin/tfsec && \
    tfsec --version

# ===== Version Control & CI/CD =====

# Install GitHub CLI
RUN dnf install -y 'dnf-command(config-manager)' && \
    dnf config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo && \
    dnf install -y gh && \
    dnf clean all && \
    gh --version

USER coder

# Install additional AWS tools
RUN pip3 install --user --no-cache-dir aws-shell boto3 && \
    echo 'alias aws-shell="aws-shell --region=${AWS_REGION:-us-east-1}"' >> ~/.bashrc

WORKDIR /home/coder
