FROM fedora:42

SHELL ["/bin/bash", "-c"]

# Install essential packages only
RUN dnf update -y && \
    dnf install -y \
    wget \
    git \
    sudo \
    vim \
    man-db \
    unzip \
    glibc-langpack-en && \
    dnf clean all

# Set locale
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

# Add user coder
RUN useradd coder \
    --create-home \
    --shell=/bin/bash \
    --uid=1000 \
    --user-group && \
    echo "coder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd

USER coder