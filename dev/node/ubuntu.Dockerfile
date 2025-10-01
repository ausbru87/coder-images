FROM ausbruhn87/coder-base-ubuntu:latest

USER root

# Install Node.js 22.x LTS
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

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
