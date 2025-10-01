FROM ghcr.io/ausbru87/coder-base-ubuntu:latest

USER root

# Install Python and development tools
RUN apt-get update && \
    apt-get install -y --no-install-recommends --no-install-suggests \
    python3.12 \
    python3.12-dev \
    python3-pip \
    python3.12-venv \
    build-essential && \
    rm -rf /var/lib/apt/lists/*

USER coder

# Set up Python environment
ENV PYTHONUNBUFFERED=1
ENV PIP_NO_CACHE_DIR=1
ENV PIP_DISABLE_PIP_VERSION_CHECK=1

# Install core scientific Python packages
RUN pip3 install --break-system-packages --upgrade pip setuptools wheel && \
    pip3 install --break-system-packages \
    numpy \
    pandas \
    scipy \
    matplotlib \
    seaborn \
    plotly \
    jupyter \
    jupyterlab \
    ipython \
    notebook \
    polars \
    pyarrow

WORKDIR /home/coder
