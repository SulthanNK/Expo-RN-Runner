#!/usr/bin/env bash
set -euo pipefail

IMAGE_NAME=sulthannk/expo-rn-runner:0.0.1
DOCKERFILE_DIR="$(dirname "$0")"

echo "Building ${IMAGE_NAME}..."
docker build -t "${IMAGE_NAME}" -f "${DOCKERFILE_DIR}/Dockerfile" "${DOCKERFILE_DIR}"
echo "Built ${IMAGE_NAME}"
