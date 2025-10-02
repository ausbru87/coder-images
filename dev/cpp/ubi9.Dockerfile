FROM ghcr.io/ausbru87/coder-base-ubi9:latest

USER root

# Enable EPEL and CodeReady Builder repos for additional packages
RUN dnf install -y \
    https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm && \
    dnf config-manager --set-enabled crb && \
    dnf clean all

# Install C++ development tools and libraries
RUN dnf install -y \
    gcc-c++ \
    make \
    cmake \
    ninja-build \
    gdb \
    clang \
    clang-tools-extra \
    lldb \
    valgrind \
    pkgconfig && \
    dnf clean all

USER coder

# Set up environment for C++
ENV CC=gcc
ENV CXX=g++

WORKDIR /home/coder
