#!/usr/bin/env bash
set -euo pipefail

IMAGE_NAME=sulthannk/expo-rn-ci-runner:latest
DOCKERFILE_DIR="$(dirname "$0")"

echo "Building ${IMAGE_NAME}..."
docker build -t "${IMAGE_NAME}" -f "${DOCKERFILE_DIR}/Dockerfile" "${DOCKERFILE_DIR}"
echo "Built ${IMAGE_NAME}"
