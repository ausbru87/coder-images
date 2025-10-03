FROM codercom/enterprise-base

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

# Generate locale
RUN locale-gen en_US.UTF-8

# Set locale
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

USER coder
