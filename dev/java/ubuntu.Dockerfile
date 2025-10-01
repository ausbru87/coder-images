FROM ausbruhn87/coder-base-ubuntu:latest

USER root

# Install Java 21 (LTS), Maven, and Gradle
RUN apt-get update && \
    apt-get install -y --no-install-recommends --no-install-suggests \
    openjdk-21-jdk \
    maven && \
    rm -rf /var/lib/apt/lists/*

# Install Gradle
RUN wget -q https://services.gradle.org/distributions/gradle-8.11.1-bin.zip && \
    unzip -q gradle-8.11.1-bin.zip -d /opt && \
    rm gradle-8.11.1-bin.zip && \
    ln -s /opt/gradle-8.11.1/bin/gradle /usr/local/bin/gradle

USER root

# Set Java environment variables dynamically based on architecture
RUN ARCH=$(dpkg --print-architecture) && \
    ln -sf /usr/lib/jvm/java-21-openjdk-${ARCH} /usr/lib/jvm/java-21-openjdk

USER coder

# Set Java environment variables
ENV JAVA_HOME=/usr/lib/jvm/java-21-openjdk
ENV PATH="${JAVA_HOME}/bin:${PATH}"

WORKDIR /home/coder
