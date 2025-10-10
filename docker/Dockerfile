# Current Version 0.0.2

FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
  ca-certificates curl wget unzip git openjdk-17-jdk procps \
  apt-transport-https gnupg2 lsb-release xz-utils zip build-essential libc6 jq bash \
  && rm -rf /var/lib/apt/lists/*

# Install Node.js LTS and yarn
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
  && apt-get update && apt-get install -y nodejs \
  && npm install -g yarn@latest eas-cli@latest

# Set up Android SDK
ARG ANDROID_SDK_ROOT=/opt/android-sdk
ARG ANDROID_CMDLINE_TOOLS_ZIP=commandlinetools-linux-8512546_latest.zip

RUN mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools ${ANDROID_SDK_ROOT}/licenses && \
  curl -fSL https://dl.google.com/android/repository/${ANDROID_CMDLINE_TOOLS_ZIP} -o /tmp/${ANDROID_CMDLINE_TOOLS_ZIP} && \
  unzip /tmp/${ANDROID_CMDLINE_TOOLS_ZIP} -d /tmp/cmdline-tools-temp && \
  mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools/latest && \
  mv /tmp/cmdline-tools-temp/cmdline-tools/* ${ANDROID_SDK_ROOT}/cmdline-tools/latest/ && \
  rm -rf /tmp/${ANDROID_CMDLINE_TOOLS_ZIP} /tmp/cmdline-tools-temp

ENV ANDROID_SDK_ROOT=${ANDROID_SDK_ROOT}
ENV ANDROID_HOME=${ANDROID_SDK_ROOT}
ENV PATH=${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools:${ANDROID_SDK_ROOT}/emulator:$PATH
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64

RUN mkdir -p ${ANDROID_SDK_ROOT}/licenses \
  && echo "8933bad161af4178b5d56f8a50cf6e57" > ${ANDROID_SDK_ROOT}/licenses/android-sdk-license \
  && yes | sdkmanager --sdk_root=${ANDROID_SDK_ROOT} --install "platform-tools" "platforms;android-35" "build-tools;35.0.0"

# Create /github/workspace so GitHub Actions mounted repo path exists
RUN mkdir -p /github/workspace

# Add non-root user and set ownership of Android SDK
ARG USERNAME=expo-rn-runner
RUN useradd -m -s /bin/bash $USERNAME && \
  chown -R $USERNAME:$USERNAME ${ANDROID_SDK_ROOT}

# Create root user
USER root

# Set working directory inside container to /github/workspace to align with GitHub Actions mount
WORKDIR /github/workspace

ENV PATH=${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools:${ANDROID_SDK_ROOT}/emulator:/home/${USERNAME}/.yarn/bin:${PATH}

# No ENTRYPOINT: let orchestrator/ci manage the process
