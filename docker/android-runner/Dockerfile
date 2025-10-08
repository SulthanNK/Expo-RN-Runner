# Use Ubuntu 22.04 LTS base
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ARG ANDROID_SDK_ROOT=/opt/android-sdk
ARG ANDROID_CMDLINE_TOOLS_ZIP=commandlinetools-linux-8512546_latest.zip
ARG NODE_VERSION=22.x
ARG JAVA_VERSION=17

RUN apt-get update && apt-get install -y --no-install-recommends \
  ca-certificates curl wget unzip git openjdk-${JAVA_VERSION}-jdk procps \
  apt-transport-https gnupg2 lsb-release xz-utils zip jq sudo build-essential libc6 \
  && rm -rf /var/lib/apt/lists/*

# Install Node.js LTS and yarn
RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION} | bash - \
  && apt-get update && apt-get install -y nodejs \
  && npm install -g yarn@latest

# Install eas-cli globally
RUN npm install -g eas-cli@latest

# Install jq using sudo apt-get
RUN sudo apt-get update && sudo apt-get install -y jq

# Create SDK directories
RUN mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools && \
  mkdir -p ${ANDROID_SDK_ROOT}/licenses

WORKDIR /tmp

# Download Android command line tools
RUN curl -fSL https://dl.google.com/android/repository/${ANDROID_CMDLINE_TOOLS_ZIP} -o /tmp/${ANDROID_CMDLINE_TOOLS_ZIP} \
  && unzip /tmp/${ANDROID_CMDLINE_TOOLS_ZIP} -d /tmp/cmdline-tools-temp \
  && mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools/latest \
  && mv /tmp/cmdline-tools-temp/cmdline-tools/* ${ANDROID_SDK_ROOT}/cmdline-tools/latest/ \
  && rm -rf /tmp/${ANDROID_CMDLINE_TOOLS_ZIP} /tmp/cmdline-tools-temp

ENV ANDROID_SDK_ROOT=${ANDROID_SDK_ROOT}
ENV ANDROID_HOME=${ANDROID_SDK_ROOT}
ENV PATH=${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools:${ANDROID_SDK_ROOT}/emulator:${PATH}
ENV JAVA_HOME=/usr/lib/jvm/java-${JAVA_VERSION}-openjdk-amd64

# Accept licenses
RUN mkdir -p ${ANDROID_SDK_ROOT}/licenses \
  && echo "8933bad161af4178b5d56f8a50cf6e57" > ${ANDROID_SDK_ROOT}/licenses/android-sdk-license

# Install SDK packages
RUN yes | sdkmanager --sdk_root=${ANDROID_SDK_ROOT} --install "platform-tools" "platforms;android-33" "build-tools;33.0.2" "platforms;android-31" "emulator"

# Remove caches
RUN rm -rf /var/cache/apt/*

# Prepare cache directory with write permission
RUN mkdir -p /opt/hostedtoolcache/node && chmod -R 777 /opt/hostedtoolcache

# Install basic utilities
RUN apt-get update && apt-get install -y bash

# Create non-root user
ARG USERNAME=expo-rn-runner
RUN useradd -m -s /bin/bash $USERNAME
USER $USERNAME
WORKDIR /home/$USERNAME

# Update PATH and env for user
ENV ANDROID_SDK_ROOT=${ANDROID_SDK_ROOT}
ENV ANDROID_HOME=${ANDROID_SDK_ROOT}
ENV PATH=${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools:${ANDROID_SDK_ROOT}/emulator:/home/${USERNAME}/.yarn/bin:${PATH}
ENV JAVA_HOME=/usr/lib/jvm/java-${JAVA_VERSION}-openjdk-amd64

ENTRYPOINT ["tail", "-f", "/dev/null"]
