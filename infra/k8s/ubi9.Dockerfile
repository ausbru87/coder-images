FROM ausbruhn87/coder-base-ubi9:latest

USER root

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm kubectl

# Install Helm
RUN curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Install k9s
RUN wget -q https://github.com/derailed/k9s/releases/latest/download/k9s_Linux_amd64.tar.gz && \
    tar -xzf k9s_Linux_amd64.tar.gz -C /usr/local/bin k9s && \
    rm k9s_Linux_amd64.tar.gz

# Install kubectx and kubens
RUN wget -q https://github.com/ahmetb/kubectx/releases/latest/download/kubectx -O /usr/local/bin/kubectx && \
    wget -q https://github.com/ahmetb/kubectx/releases/latest/download/kubens -O /usr/local/bin/kubens && \
    chmod +x /usr/local/bin/kubectx /usr/local/bin/kubens

# Install kustomize
RUN curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash && \
    mv kustomize /usr/local/bin/

# Install stern (log viewer)
RUN wget -q https://github.com/stern/stern/releases/latest/download/stern_linux_amd64 -O /usr/local/bin/stern && \
    chmod +x /usr/local/bin/stern

USER coder

WORKDIR /home/coder
