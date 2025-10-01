FROM ghcr.io/ausbru87/coder-base-ubi9:latest

USER root

# Install Python and development tools
RUN dnf update -y && \
    dnf install -y \
    python3.12 \
    python3.12-devel \
    python3-pip \
    gcc \
    gcc-c++ \
    make && \
    dnf clean all

USER coder

# Set up Python environment
ENV PYTHONUNBUFFERED=1
ENV PIP_NO_CACHE_DIR=1
ENV PIP_DISABLE_PIP_VERSION_CHECK=1

# Install core scientific Python packages
RUN pip3 install --upgrade pip setuptools wheel && \
    pip3 install \
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
