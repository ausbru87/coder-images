FROM ghcr.io/ausbru87/coder-base-ubi9:latest

USER root

# Install Python 3.12 and development tools
RUN dnf install -y \
    python3.12 \
    python3.12-devel \
    python3.12-pip \
    gcc \
    gcc-c++ \
    make \
    openssl-devel \
    libffi-devel && \
    dnf clean all

USER coder

# Set up Python environment
ENV PATH="/home/coder/.local/bin:${PATH}"
ENV PYTHONUNBUFFERED=1
ENV PIP_BREAK_SYSTEM_PACKAGES=1

# Upgrade pip and install common development tools
RUN python3.12 -m pip install --user --upgrade pip setuptools wheel && \
    python3.12 -m pip install --user \
    black \
    flake8 \
    pylint \
    mypy \
    pytest \
    pytest-cov \
    ipython \
    requests \
    python-lsp-server[all]

WORKDIR /home/coder
