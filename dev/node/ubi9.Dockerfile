FROM ausbruhn87/coder-base-ubi9:latest

USER root

# Install Node.js 22.x
RUN curl -fsSL https://rpm.nodesource.com/setup_22.x | bash - && \
    dnf install -y nodejs && \
    dnf clean all

# Configure npm for global installs without requiring root
RUN mkdir -p /home/coder/.npm-global && \
    npm config set prefix '/home/coder/.npm-global'

# Add npm global bin to PATH
ENV PATH=/home/coder/.npm-global/bin:$PATH

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
