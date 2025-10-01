FROM ubuntu:24.04

SHELL ["/bin/bash", "-c"]
ENV DEBIAN_FRONTEND=noninteractive

# Install essential packages only
RUN apt-get update && \
    apt-get install -y --no-install-recommends --no-install-suggests \
    ca-certificates \
    curl \
    wget \
    git \
    sudo \
    vim \
    man-db \
    unzip \
    locales \
    gnupg2 && \
    rm -rf /var/lib/apt/lists/*

# Generate locale
RUN locale-gen en_US.UTF-8

# Set locale
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# Remove ubuntu user and add user coder
RUN userdel -r ubuntu && \
    useradd coder \
    --create-home \
    --shell=/bin/bash \
    --uid=1000 \
    --user-group && \
    echo "coder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd

USER coder