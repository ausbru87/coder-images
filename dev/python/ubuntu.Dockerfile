FROM ghcr.io/ausbru87/coder-base-ubuntu:latest

USER root

# Install Python 3.12 and development tools
RUN apt-get update && \
    apt-get install -y --no-install-recommends --no-install-suggests \
    python3.12 \
    python3.12-dev \
    python3.12-venv \
    python3-pip \
    python3-setuptools \
    python3-wheel \
    build-essential \
    libssl-dev \
    libffi-dev && \
    rm -rf /var/lib/apt/lists/*

USER coder

# Set up Python environment
ENV PATH="/home/coder/.local/bin:${PATH}"
ENV PYTHONUNBUFFERED=1

# Upgrade pip and install common development tools
RUN python3 -m pip install --user --upgrade pip setuptools wheel && \
    python3 -m pip install --user \
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
