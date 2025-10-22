FROM redhat/ubi9:9.6

SHELL ["/bin/bash", "-c"]

# Install essential packages only
RUN dnf update -y && \
    dnf install -y --skip-broken \
    curl \
    ca-certificates \
    wget \
    git \
    sudo \
    vim \
    man \
    unzip && \
    dnf clean all

# Install glibc-langpack-en for proper locale support
RUN dnf install -y glibc-langpack-en && dnf clean all

# Set locale
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# Fix /etc/bashrc unbound variable issue for scripts using 'set -u'
# UBI9's /etc/bashrc references BASHRCSOURCED without checking if it's set
# This causes failures in scripts that use 'set -u' (exit on unbound variables)
RUN sed -i '12s/.*/if [ -z "${BASHRCSOURCED:-}" ]; then BASHRCSOURCED=Y; fi/' /etc/bashrc || \
    echo 'BASHRCSOURCED=${BASHRCSOURCED:-Y}' >> /etc/bashrc

# Add user coder
RUN useradd coder \
    --create-home \
    --shell=/bin/bash \
    --uid=1000 \
    --user-group && \
    echo "coder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd

USER coder

