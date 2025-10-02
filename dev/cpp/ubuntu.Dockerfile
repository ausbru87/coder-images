FROM ghcr.io/ausbru87/coder-base-ubuntu:latest

USER root

# Install C++ development tools and libraries
RUN apt-get update && \
    apt-get install -y --no-install-recommends --no-install-suggests \
    build-essential \
    cmake \
    ninja-build \
    gdb \
    clang \
    clang-format \
    clang-tidy \
    lldb \
    valgrind \
    ccache \
    pkg-config \
    clangd && \
    rm -rf /var/lib/apt/lists/*

USER coder

# Set up environment for C++
ENV CC=gcc
ENV CXX=g++

WORKDIR /home/coder
