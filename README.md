# Expo RN Runner - Android Docker Image

This repository contains a lightweight Docker image useful for building and testing React Native / Expo Android apps in CI environments. The image installs the Android command-line tools, selected SDK/platforms/emulator bits, Node.js LTS, Yarn, and OpenJDK 17. It is intended to be used as a build runner image in CI pipelines or locally when you need a reproducible Android build environment.

## Contents

- docker/android-runner/Dockerfile - Dockerfile that builds the Android runner image.
- docker/android-runner/build-and-push.sh - Small helper script to build the image locally.

## Image features

- Ubuntu 22.04 base
- OpenJDK 17
- Node.js LTS (configured via build ARG)
- Yarn (latest installed globally)
- Android SDK command-line tools and platform tools
- Android platforms: android-31, android-33 and build-tools 33.0.2
- Non-root user `expo-rn-builder` for safer CI runs

## Quick start - build locally

From the repository root run the build script:

```bash
# From repo root (Windows Git Bash / WSL)
cd docker/android-runner
./build-and-push.sh
```

The script builds the Docker image defined by `docker/android-runner/Dockerfile` and tags it as `sulthannk/expo-rn-ci-runner:latest`.

If you want to build with docker directly, from the `docker/android-runner` directory run:

```bash
docker build -t yourorg/expo-rn-ci-runner:latest -f Dockerfile .
```

You can customize build-time arguments:

- ANDROID_CMDLINE_TOOLS_ZIP - specific command-line tools archive (defaults in Dockerfile)
- NODE_VERSION - Node major version setup script (default 22.x)
- JAVA_VERSION - Java version installed (default 17)

Example with args:

```bash
docker build \
  --build-arg NODE_VERSION=22.x \
  --build-arg JAVA_VERSION=17 \
  -t yourorg/expo-rn-ci-runner:20-java17 .
```

## Usage examples

Run the image interactively (the image's ENTRYPOINT keeps the container running):

```bash
docker run --rm -it yourorg/expo-rn-ci-runner:latest bash
```

Mount your project and run Android builds inside the container:

```bash
docker run --rm -it \
  -v "$(pwd):/home/expo-rn-builder/project" \
  -w /home/expo-rn-builder/project \
  yourorg/expo-rn-ci-runner:latest bash -lc "yarn install && yarn android:build"
```

Adjust commands to match your project's build scripts (Gradle/Expo/Metro/npm/yarn scripts).

## CI integration tips

- Use the image as a build step in your CI. Mount the workspace and run Gradle or npm/yarn scripts as needed.
- Ensure the container has access to any Android keystores or environment secrets through your CI's secret management; avoid baking secrets into images.

## Environment and customization

- The Dockerfile exposes ARGS for Node and Java versions. Use `--build-arg` during `docker build` to adjust.
- SDK_ROOT is set to `/opt/android-sdk`. If you need to install additional SDK packages, you can extend the Dockerfile or run `sdkmanager` inside a derived image.

## Troubleshooting

- If sdkmanager fails to download packages, ensure the container has outbound network access and the `ANDROID_CMDLINE_TOOLS_ZIP` URL is valid.
- If Android license acceptance errors appear, confirm the `licenses` content in the Dockerfile matches required license hashes for the SDKs you need.
- To speed up builds in CI, consider pre-building and pushing the image to your registry and use that cached image in pipelines.

## Security notes

- The image adds a non-root user `expo-rn-builder`; prefer running build steps as that user.
- Do not store secret values (keystore passwords, API keys) inside images. Pass them at runtime or via your CI.

## Contributing

Contributions welcome. If you need support for additional Android platforms/build-tools, send a PR that updates the SDK packages in `docker/android-runner/Dockerfile`.

## License

This repository has no license specified. Add a LICENSE file to make usage terms explicit.
