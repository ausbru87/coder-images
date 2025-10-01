FROM ghcr.io/ausbru87/coder-images/coder-base-ubi9:latest

USER root

# Install build dependencies for Rust
RUN dnf update -y && \
    dnf install -y \
    gcc \
    gcc-c++ \
    make \
    openssl-devel \
    pkgconfig && \
    dnf clean all

USER coder

# Install Rust via rustup
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain stable

# Set Rust environment variables
ENV PATH="/home/coder/.cargo/bin:${PATH}"

# Install common Rust tools
RUN . "$HOME/.cargo/env" && \
    rustup component add rust-analyzer rustfmt clippy && \
    cargo install cargo-watch cargo-edit cargo-outdated

WORKDIR /home/coder
