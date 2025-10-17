# Expo RN Runner 

![Docker](https://img.shields.io/badge/Built_with_docker-blue?style=flat&logo=docker&link=https%3A%2F%2Fwww.docker.com)
![Docker Image Size (tag)](https://img.shields.io/docker/image-size/sulthannk/expo-rn-runner/0.0.1?style=flat&logo=docker&label=Image%20Size)
![Ubuntu](https://img.shields.io/badge/Ubuntu-22.04-orange?style=flat&logo=ubuntu&link=https%3A%2F%2Freleases.ubuntu.com%2Fjammy)
[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

A compact Docker image and helper scripts for test your React Native / Expo CI/CD pipelines for Android apps in locally.

## Why this repo exists

- Reproducible Android build environment for CI pipelines.
- Fast local testing when you don't want to install the full Android toolchain.

## How to use this image

This image is published to both Docker Hub and GitHub Container Registry (GHCR). Replace the tag with the version you want (example uses `0.0.1`).

### From Docker Hub (public)

```bash
# Pull from Docker Hub
docker pull sulthannk/expo-rn-runner:0.0.1

# Run a shell (mount current dir into /workspace)
docker run --rm -it -v "$(pwd):/workspace" -w /workspace sulthannk/expo-rn-runner:0.0.1 bash
```

### From GitHub Container Registry (GHCR)

Public GHCR (if image is public):

```bash
# Pull from GHCR
docker pull ghcr.io/SulthanNK/expo-rn-runner:0.0.1

# Run a shell
docker run --rm -it -v "$(pwd):/workspace" -w /workspace ghcr.io/SulthanNK/expo-rn-runner:0.0.1 bash
```

Private GHCR (requires authentication)

```bash
# Authenticate using a GitHub Personal Access Token (PAT) with `read:packages` scope
echo "$GHCR_TOKEN" | docker login ghcr.io -u YOUR_GITHUB_USERNAME --password-stdin

# Then pull
docker pull ghcr.io/SulthanNK/expo-rn-runner:0.0.1
```

> CI note: In GitHub Actions prefer `docker/login-action` with `GITHUB_TOKEN` to authenticate and pull private GHCR images automatically.

## Image contents

| Components            | Name                       | Version                                                        | How to check                                                                                              |
| --------------------- | -------------------------- | -------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------- |
| base os               | Ubuntu                     | 22.04                                                          | `docker run --rm IMAGE lsb_release -a` or check `FROM` in `docker/Dockerfile`                             |
| java                  | OpenJDK                    | 17 (openjdk-17-jdk)                                            | `docker run --rm IMAGE java -version`                                                                     |
| node                  | Node.js                    | 22.x (NodeSource setup_22.x)                                   | `docker run --rm IMAGE node -v`                                                                           |
| yarn                  | Yarn (npm)                 | `yarn@latest` (installed globally)                             | `docker run --rm IMAGE yarn -v`                                                                           |
| eas-cli               | EAS CLI                    | `eas-cli@latest` (installed globally)                          | `docker run --rm IMAGE eas --version`                                                                     |
| android cmdline tools | Android command-line tools | archive: `commandlinetools-linux-8512546_latest.zip` (8512546) | list files in `/opt/android-sdk/cmdline-tools/latest` or run `docker run --rm IMAGE sdkmanager --version` |
| android sdk root      | ANDROID_SDK_ROOT           | `/opt/android-sdk`                                             | `docker run --rm IMAGE bash -lc 'echo $ANDROID_SDK_ROOT'`                                                 |
| platform-tools        | Android platform-tools     | installed (sdkmanager at build time)                           | `docker run --rm IMAGE adb --version` or `sdkmanager --list`                                              |
| android platform      | Android platform           | android-35                                                     | `docker run --rm IMAGE sdkmanager --list`                                                                 |
| build-tools           | Android build-tools        | 35.0.0                                                         | check `${ANDROID_SDK_ROOT}/build-tools/35.0.0` or `sdkmanager --list`                                     |
| apt packages          | system utilities           | curl, wget, unzip, git, jq, build-essential, etc.              | `docker run --rm IMAGE dpkg -l curl` (replace package name as needed)                                     |
| non-root user         | user                       | `expo-rn-runner`                                               | `docker run --rm IMAGE id expo-rn-runner`                                                                 |
| image tag (script)    | Docker image tag           | `sulthannk/expo-rn-runner:0.0.1` (build script)                | check `docker/build-image.sh` or your published registry tag                                              |

#### Notes:

- Some components use `latest` or external setup scripts (Node 22.x, yarn@latest, eas-cli@latest), so exact sub-versions are determined at build time.
- The Android command-line tools version is inferred from the archive name `commandlinetools-linux-8512546_latest.zip` (=> 8512546).

## Want to build the image locally?

1. Clone this repo:

```bash
git clone https://github.com/SulthanNK/Expo-RN-Runner.git
```

```bash
cd docker
```

2. To Build the image (Git Bash / WSL on Windows):

```bash
./build-image.sh
```

3. Run a container & open a shell:

```bash
docker run --rm -it -v "$(pwd):/workspace" -w /workspace your/image:tag bash
```

## Use cases why I made this

- CI runner image: mount your repo in CI and run Gradle / yarn scripts.
- Local: use to reproduce CI builds or to run Gradle tasks without installing SDKs locally.

## Want to customize based on your needs?

- To change Node/Java versions or SDK packages, edit the `Dockerfile` or pass build args to `docker build`.

## License

- Copyright © 2025 [Sulthan Mohaideen](https://github.com/SulthanNK). It is released under the [Apache License](https://www.apache.org/licenses/LICENSE-2.0). See the [LICENSE](LICENSE) file for details.

Enjoy — simple, fast, and repeatable Android app builds for React Native / Expo. 🧪🚀

> Built with ❤️ by [SulthanNK](https://github.com/SulthanNK)
