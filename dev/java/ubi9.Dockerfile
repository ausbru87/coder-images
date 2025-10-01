FROM ausbruhn87/coder-base-ubi9:latest

USER root

# Install Java 21 (LTS), Maven, and Gradle
RUN dnf update -y && \
    dnf install -y \
    java-21-openjdk \
    java-21-openjdk-devel \
    maven && \
    dnf clean all

# Install Gradle
RUN wget -q https://services.gradle.org/distributions/gradle-8.11.1-bin.zip && \
    unzip -q gradle-8.11.1-bin.zip -d /opt && \
    rm gradle-8.11.1-bin.zip && \
    ln -s /opt/gradle-8.11.1/bin/gradle /usr/local/bin/gradle

USER coder

# Set Java environment variables
ENV JAVA_HOME=/usr/lib/jvm/java-21-openjdk
ENV PATH="${JAVA_HOME}/bin:${PATH}"

WORKDIR /home/coder
