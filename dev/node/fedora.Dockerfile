FROM ausbruhn87/coder-base-fedora:latest

USER root

# Install Node.js 22.x
RUN curl -fsSL https://rpm.nodesource.com/setup_22.x | bash - && \
    dnf install -y nodejs && \
    dnf clean all

USER coder

# Install common global packages
RUN npm install -g \
    typescript \
    ts-node \
    @types/node \
    eslint \
    prettier \
    pnpm \
    yarn

WORKDIR /home/coder
