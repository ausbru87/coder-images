FROM ghcr.io/ausbru87/coder-base-ubuntu:latest

USER root

# Install Go 1.23
RUN ARCH=$(dpkg --print-architecture) && \
    if [ "$ARCH" = "amd64" ]; then GOARCH="amd64"; elif [ "$ARCH" = "arm64" ]; then GOARCH="arm64"; fi && \
    wget -q https://go.dev/dl/go1.23.4.linux-${GOARCH}.tar.gz && \
    tar -C /usr/local -xzf go1.23.4.linux-${GOARCH}.tar.gz && \
    rm go1.23.4.linux-${GOARCH}.tar.gz

USER coder

# Set Go environment variables
ENV PATH="/usr/local/go/bin:${PATH}"
ENV GOPATH="/home/coder/go"
ENV PATH="${GOPATH}/bin:${PATH}"

# Install common Go tools
RUN go install golang.org/x/tools/gopls@latest && \
    go install github.com/go-delve/delve/cmd/dlv@latest && \
    go install honnef.co/go/tools/cmd/staticcheck@latest && \
    go install golang.org/x/tools/cmd/goimports@latest

WORKDIR /home/coder
