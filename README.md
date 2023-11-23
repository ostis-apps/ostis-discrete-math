# DM app

The DM app is a CLI tool for managing and running the Discrete Math (DM) web-platform during development. It provides a set of features for building both web-platform and knowledge base (including *smart building* and *cache management*), starting, stopping, configuring and efficient updading the app and its [components](#components).

## Installation

Please learn about [execution modes](#execution-modes) before installing the app.

```sh
# Natively (ubuntu)
curl -fsSL https://dev.ostis.tech/install/dm | sh

# Docker
curl -fsSL https://dev.ostis.tech/install/dm | sh -s docker
```

The web platform is installed to `~/.ostis` by default. The source directory, where DM components are stored, is set to location where the installation script was executed from, except for the case when the script was executed from home directory `~/`, in which case the source directory is set to `~/.ostis/dm`.

To specify a custom directory for the web-platform installation, please set `DM_INSTALL` environment variable before running the installation script, or `DM_SOURCE` variable to override the default source directory. Note that the source variable can be modified at any time later using [`dm config`](#configuration).

If installing for the first time, you may add `rc` variable pointing to your shell config file before `sh` command to make the installation script add necessary configuration automatically, e.g.
```sh
curl -fsSL https://dev.ostis.tech/install/dm | rc=~/.zshrc sh
```

## Getting started

Run `dm` to get started. The main commands are listed below:
- [`build`](#build) (shortcut `b`) — builds the knowledge base.
- [`start`](#start) (shortcut `s`) — starts the web-platform (on localhost:8000).
- [`stop`](#stop) — terminates the web-platform running in the background or another process.
- [`config`](#configuration) —  changes the app configuration.
- [`upgrade`](#upgrade) — upgrades the web-platform by picking up updates from sc-machine, scp-machine, sc-web, and ims.
- [`pull`](#pull) — pulls all changes from DM components, including kb, agents, and set theory.
- [`cache`](#cache) — runs the cache manager.

### Shortcuts

The app also provides a few shortcuts for commonly used commands:
- `sb` is equivalent to `start --build`.
- `sa` is equivalent to `start --build --save`.

### Execution modes

The DM app can be installed and executed in two different modes: natively or in a Docker container.

Running the DM app in **Docker mode** is generally more preferred and efficient as the dependencies required for building the platform do not get installed and remained on your host machine, isolating the core platform into a single image, and letting you focus on your project instead of its platform. Before installing, please make sure you have docker and docker-buildx installed.

In **Native mode**, the DM app is built and executed directly on your host machine. This option is preferred more for platform developers and contributors as it allows for better debugging and inspecting the web-platform itself. This option is available for Ubuntu only.


## Usage

Each command of the DM app has a specific role and can be executed with different options. Below is a detailed explanation of each command.

### Configuration

This command opens the app configuration file for editing.

Available options:

- `DOCKER` — whether the platform should be run in docker instead of natively.
- `BUILD` — always run kb build when starting the platform with `dm start`.\
  Not recommended, consider using shortcut `dm sb` or `dm sa` instead.
- `BG` — always start the platform in the background (docker-only).
- `DM_SOURCE` — default source directory where DM components should be stored.

By default, the `nano` editor is used, but you can set `EDITOR` environment variable to specify a different editor.

### Build

**Native only.** Builds the knowledge base.

For building the knowledge base in Docker, use `dm start --build` or its shortcut `dm sb`.

### Start

Starts the web-platform. Available options:

- `--build` —  builds the knowledge base before starting the web-platform.
    - The *smart build* feature never rebuilds the knowledge base if no source files are changed. **(docker only)**
- `--docker` —  starts the web-platform in Docker (always enabled if `DOCKER` variable is set in config).
- `--bg` — runs the web-platform in the background. **(docker only)**
- `--save` — when building, saves the build state of knowledge base to the cache. **(docker only)**
- `--force` — forcefully re-builds the web-platform, even if it is cached or no files are changed. **(docker only)**

### Stop

**Docker only.** Terminates the web-platform running in the background or another process.

### Upgrade

Pulls updates from sc-machine, scp-machine, sc-web, and ims repositories and re-builds the platform. 

Unless `DOCKER` variable is defined in config, this command can be executed with a `--docker` option to perform the upgrade in Docker.

By default, all platform dependencies are pulled shallowly with no git history, neither additional branches. Pass the `--deep` option or set `DM_DEEP` variable to `true` in the config file or before running the command to unshallow and perform deep updates.

Improvements of the platform build in Docker compared to ostis-web-platform:

- Support for scp-machine.
- Shared build & execution dependencies.
- More concurrenct executions during build.
- A more thoughtful caching of layers.
- Minimal resulting image (excluding IMS).
- IMS included (allowing to publish a single all-in image).

Platform components configuration: **Coming soon!**

### Pull

Pulls all changes from DM components, including graph theory knowledge base component, graph theory problem solver component, and set theory component.

The location of these components is defined by `DM_SOURCE` environment variable and can be changed using `dm config` command.

DM components configuration: **Coming soon!**

### Cache

**Docker only.** Runs the cache manager, which allows you to manage the cache of knowledge base builds. It is shipped with the following sub-commands:

- `save` — saves the current state of built knowledge base to the cache.
- `prune` — removes outdated knowledge base builds from the cache.
  - use `--all` option to remove all builds including the current state.

Natively: **Coming soon!**

## Components

[Knowledge base](https://github.com/ostis-apps/gt-knowledge-base/tree/0.8.0)

[Problem Solver](https://github.com/ostis-apps/gt-knowledge-processing-machine/tree/0.8.0_fix)

[Set Theory](https://github.com/ostis-apps/set-theory/tree/0.8.0_kb)

[Graph Editor](https://github.com/ostis-apps/gt-ostis-drawings)

[Graph Theory Book](https://github.com/ostis-apps/gt-book)


## Contributing

If you would like to contribute to the DM app, feel free to fork the repository and submit a pull request. Contributions are always welcome!

## License

The DM app is licensed under the MIT License.
