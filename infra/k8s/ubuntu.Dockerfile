FROM ghcr.io/ausbru87/coder-images/coder-base-ubuntu:latest

USER root

# Set architecture variables
RUN ARCH=$(dpkg --print-architecture) && \
    if [ "$ARCH" = "amd64" ]; then \
        echo "export K8S_ARCH=amd64" >> /etc/profile.d/arch.sh && \
        echo "export K9S_ARCH=amd64" >> /etc/profile.d/arch.sh && \
        echo "export STERN_ARCH=amd64" >> /etc/profile.d/arch.sh; \
    elif [ "$ARCH" = "arm64" ]; then \
        echo "export K8S_ARCH=arm64" >> /etc/profile.d/arch.sh && \
        echo "export K9S_ARCH=arm64" >> /etc/profile.d/arch.sh && \
        echo "export STERN_ARCH=arm64" >> /etc/profile.d/arch.sh; \
    fi

# Install kubectl
RUN ARCH=$(dpkg --print-architecture) && \
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/${ARCH}/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm kubectl

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
    rm k9s_Linux_${K9S_ARCH}.tar.gz

# Install kubectx and kubens
RUN wget -q https://github.com/ahmetb/kubectx/releases/latest/download/kubectx -O /usr/local/bin/kubectx && \
    wget -q https://github.com/ahmetb/kubectx/releases/latest/download/kubens -O /usr/local/bin/kubens && \
    chmod +x /usr/local/bin/kubectx /usr/local/bin/kubens

# Install kustomize
RUN curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash && \
    mv kustomize /usr/local/bin/

# Install stern (log viewer)
RUN ARCH=$(dpkg --print-architecture) && \
    wget -q https://github.com/stern/stern/releases/latest/download/stern_linux_${ARCH} -O /usr/local/bin/stern && \
    chmod +x /usr/local/bin/stern

USER coder

WORKDIR /home/coder
