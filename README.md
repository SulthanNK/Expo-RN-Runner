# Expo RN Runner

![Docker](https://img.shields.io/badge/Built_with_docker-blue?style=flat&logo=docker&link=https%3A%2F%2Fwww.docker.com)
![Docker Image Size (tag)](https://img.shields.io/docker/image-size/sulthannk/expo-rn-runner/0.0.1?style=flat&logo=docker&label=Image%20Size)
![Ubuntu](https://img.shields.io/badge/Ubuntu-22.04-orange?style=flat&logo=ubuntu&link=https%3A%2F%2Freleases.ubuntu.com%2Fjammy)
[![Apache License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)

A compact Docker image and helper scripts to test React Native / Expo Android CI/CD pipelines locally — no full Android toolchain installation required.

## Learn More

I wrote a detailed article explaining the motivation behind this project and how to test React Native CI/CD pipelines locally using Docker and the `act` CLI.

📖 [Test React Native GitHub Actions Locally](https://sulthannk.hashnode.dev/test-react-native-github-actions-locally)

---

## Table of Contents

- [Why This Exists](#why-this-exists)
- [Prerequisites](#prerequisites)
- [How to Use This Image](#how-to-use-this-image)
- [Example CI Workflow](#example-ci-workflow)
- [Image Contents](#image-contents)
- [Build Locally](#build-locally)
- [Customization](#customization)
- [License](#license)

---

## Why This Exists

Setting up a full Android toolchain (JDK, SDK, build-tools, Node, Yarn, EAS CLI) consistently across machines and CI runners is tedious and error-prone. This image packages everything into a single reproducible environment so you can:

- Run Gradle / Yarn tasks in CI without pre-installing any SDKs on the runner.
- Reproduce CI builds exactly on your local machine before pushing.
- Test GitHub Actions workflows locally using the [`act`](https://github.com/nektos/act) CLI.

---

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/) installed and running.
- _(Optional)_ [`act`](https://github.com/nektos/act) CLI if you want to run GitHub Actions workflows locally.

---

## How to Use This Image

This image is published to both **Docker Hub** and **GitHub Container Registry (GHCR)**. Replace the tag with the version you need (examples below use `0.0.1`).

### Docker Hub

```bash
# Pull
docker pull sulthannk/expo-rn-runner:0.0.1

# Run a shell (mounts current directory into /workspace)
docker run --rm -it -v "$(pwd):/workspace" -w /workspace sulthannk/expo-rn-runner:0.0.1 bash
```

### GitHub Container Registry (GHCR) — Public

```bash
# Pull
docker pull ghcr.io/sulthannk/expo-rn-runner:0.0.1

# Run a shell
docker run --rm -it -v "$(pwd):/workspace" -w /workspace ghcr.io/sulthannk/expo-rn-runner:0.0.1 bash
```

### GitHub Container Registry (GHCR) — Private

```bash
# Authenticate with a GitHub PAT (read:packages scope required)
echo "$GHCR_TOKEN" | docker login ghcr.io -u YOUR_GITHUB_USERNAME --password-stdin

# Then pull
docker pull ghcr.io/sulthannk/expo-rn-runner:0.0.1
```

> **CI tip:** In GitHub Actions use `docker/login-action` with `GITHUB_TOKEN` to authenticate against GHCR automatically — no manual token handling needed.

---

## Example CI Workflow

Here is a minimal GitHub Actions workflow that uses this image to build an Expo Android app:

```yaml
name: Build Android

on:
  push:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    container:
      image: sulthannk/expo-rn-runner:0.0.1

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Install dependencies
        run: yarn install --frozen-lockfile

      - name: Build Android (local Gradle)
        run: cd android && ./gradlew assembleRelease

      # Or use EAS Build
      # - name: EAS Build
      #   run: eas build --platform android --profile production --non-interactive
      #   env:
      #     EXPO_TOKEN: ${{ secrets.EXPO_TOKEN }}
```

> To run this workflow locally before pushing, use [`act`](https://github.com/nektos/act):
>
> ```bash
> act push --container-architecture linux/amd64
> ```

---

## Image Contents

| Component             | Name                       | Version                          | Verify                                                    |
| --------------------- | -------------------------- | -------------------------------- | --------------------------------------------------------- |
| Base OS               | Ubuntu                     | 22.04                            | `docker run --rm IMAGE lsb_release -a`                    |
| Java                  | OpenJDK                    | 17 (openjdk-17-jdk)              | `docker run --rm IMAGE java -version`                     |
| Node.js               | Node.js                    | 22.x                             | `docker run --rm IMAGE node -v`                           |
| Package Manager       | Yarn                       | latest (global)                  | `docker run --rm IMAGE yarn -v`                           |
| Expo CLI              | EAS CLI                    | latest (global)                  | `docker run --rm IMAGE eas --version`                     |
| Android cmdline tools | Android command-line tools | 8512546                          | `docker run --rm IMAGE sdkmanager --version`              |
| Android SDK root      | `ANDROID_SDK_ROOT`         | `/opt/android-sdk`               | `docker run --rm IMAGE bash -lc 'echo $ANDROID_SDK_ROOT'` |
| Platform tools        | `adb`, `fastboot`          | via sdkmanager                   | `docker run --rm IMAGE adb --version`                     |
| Android Platform      | android-35                 | 35                               | `docker run --rm IMAGE sdkmanager --list`                 |
| Build tools           | Android build-tools        | 35.0.0                           | `ls ${ANDROID_SDK_ROOT}/build-tools/`                     |
| System utilities      | apt packages               | curl, wget, unzip, git, jq, etc. | `docker run --rm IMAGE dpkg -l <package>`                 |
| Non-root user         | `expo-rn-runner`           | —                                | `docker run --rm IMAGE id expo-rn-runner`                 |

> Node.js, Yarn, and EAS CLI use `latest` at build time, so exact patch versions depend on when the image was built.

---

## Build Locally

1. Clone the repository:

```bash
git clone https://github.com/SulthanNK/Expo-RN-Runner.git
cd Expo-RN-Runner/docker
```

2. Build the image:

```bash
./build-image.sh
```

3. Run a container and open a shell:

```bash
docker run --rm -it -v "$(pwd):/workspace" -w /workspace sulthannk/expo-rn-runner:0.0.1 bash
```

---

## Customization

To change Node/Java versions or Android SDK packages, edit the `Dockerfile` or pass build args to `docker build`. For example:

```bash
docker build --build-arg NODE_VERSION=20 -t my-custom-runner .
```

---

## License

This project is licensed under the **Apache License 2.0**. See the [LICENSE](LICENSE) file for details.

Copyright © 2026 [Sulthan Mohaideen](https://github.com/SulthanNK)

---

> Built with ❤️ by [SulthanNK](https://github.com/SulthanNK) — simple, fast, and repeatable Android builds for React Native / Expo. 🧪🚀
