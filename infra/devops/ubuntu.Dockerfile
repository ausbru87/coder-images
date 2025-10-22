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
RUN curl -sL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
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

# Install Kubernetes tools (kubectl, helm, k9s, kubectx/kubens, kustomize, stern)
RUN set -ex && \
    # kubectl
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm kubectl && \
    kubectl version --client && \
    # helm
    HELM_VERSION=$(curl -s https://api.github.com/repos/helm/helm/releases/latest | grep tag_name | cut -d '"' -f 4) && \
    curl -LO "https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz" && \
    tar -zxvf "helm-${HELM_VERSION}-linux-amd64.tar.gz" && \
    mv linux-amd64/helm /usr/local/bin/helm && \
    rm -rf linux-amd64 "helm-${HELM_VERSION}-linux-amd64.tar.gz" && \
    helm version && \
    # k9s
    wget -q https://github.com/derailed/k9s/releases/latest/download/k9s_Linux_amd64.tar.gz && \
    tar -xzf k9s_Linux_amd64.tar.gz -C /usr/local/bin k9s && \
    rm k9s_Linux_amd64.tar.gz && \
    k9s version && \
    # kubectx and kubens
    wget -q https://github.com/ahmetb/kubectx/releases/latest/download/kubectx -O /usr/local/bin/kubectx && \
    wget -q https://github.com/ahmetb/kubectx/releases/latest/download/kubens -O /usr/local/bin/kubens && \
    chmod +x /usr/local/bin/kubectx /usr/local/bin/kubens && \
    # kustomize
    curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash && \
    mv kustomize /usr/local/bin/ && \
    kustomize version && \
    # stern
    STERN_VERSION=$(curl -s https://api.github.com/repos/stern/stern/releases/latest | grep tag_name | cut -d '"' -f 4) && \
    wget -q https://github.com/stern/stern/releases/download/${STERN_VERSION}/stern_${STERN_VERSION#v}_linux_amd64.tar.gz && \
    tar -xzf stern_${STERN_VERSION#v}_linux_amd64.tar.gz && \
    mv stern /usr/local/bin/stern && \
    rm stern_${STERN_VERSION#v}_linux_amd64.tar.gz && \
    chmod +x /usr/local/bin/stern && \
    stern --version

# Install OpenShift tools (oc and openshift-install)
RUN set -ex && \
    # OpenShift CLI (oc)
    curl -LO https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-linux.tar.gz && \
    tar -xzf openshift-client-linux.tar.gz && \
    mv oc /usr/local/bin/ && \
    rm -rf openshift-client-linux.tar.gz kubectl README.md && \
    oc version --client && \
    # OpenShift Installer
    curl -LO https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-install-linux.tar.gz && \
    tar -xzf openshift-install-linux.tar.gz && \
    mv openshift-install /usr/local/bin/ && \
    rm -rf openshift-install-linux.tar.gz && \
    openshift-install version

# Install Terraform and related tools (terraform, tflint, tfsec)
ARG TERRAFORM_VERSION="1.7.5"
ARG TERRAFORM_PLATFORM="linux_amd64"

RUN set -ex && \
    # Terraform
    curl -LO "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_${TERRAFORM_PLATFORM}.zip" && \
    unzip "terraform_${TERRAFORM_VERSION}_${TERRAFORM_PLATFORM}.zip" && \
    mv terraform /usr/local/bin/ && \
    rm "terraform_${TERRAFORM_VERSION}_${TERRAFORM_PLATFORM}.zip" && \
    terraform version && \
    # tflint
    curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash && \
    tflint --version && \
    # tfsec
    wget -q https://github.com/aquasecurity/tfsec/releases/latest/download/tfsec-linux-amd64 -O /usr/local/bin/tfsec && \
    chmod +x /usr/local/bin/tfsec && \
    tfsec --version

# ===== Version Control & CI/CD =====

# Install GitHub CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | \
    gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg && \
    chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | \
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
