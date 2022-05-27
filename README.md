# lxd-build

CLI and shell framework for building LXD instances

# Synopsis

```sh
lxd-build --name hello-world <<'EOF'
FROM images:debian/bullseye
RUN 'echo "Hello, world!"'
EOF
```

This minimal example creates an instance named `hello-world` from image
`images:debian/bullseye`. It then runs the `echo` command from inside the
instance, as root

# Usage

```
Usage: lxd-build [options] [BUILD_SCRIPT]
       lxd-build --help
       lxd-build --version

Create LXD instance using instructions from BUILD_SCRIPT

If BUILD_SCRIPT is not given or is '-', the build instructions will be read
from stdin

Options:
    -a, --arg NAME=VALUE
        Define a build argument. This option is repeatable.

    -f, --force
        Delete INSTANCE_NAME if it already exists.

    -h, --help
        Show this help message and exit.

    -n, --name INSTANCE_NAME
        Instance name. If not given, a random name will be used.

    -v, --verbose
        Be more verbose.
        This option only affects verbosity of lxd-build itself, not the
        verbosity of build scripts

    -V, --version
        Print lxd-build version and exit.
```

# Build scripts

Build scripts are plain shell scripts with a few added functions:

## FROM

```
FROM <image_name>
```

Create and start an LXD instance from `<image_name>`.

It must be called before any `RUN` command.

### Examples

```
FROM images:debian/bullseye
FROM images:ubuntu/focal
```

## RUN

```
RUN "<commands>"

RUN << 'SH'
<commands>
SH
```

Run `<commands>` inside the instance.

`<commands>` are executed by `/bin/sh` which is started as a login shell. It means that:

* environment variables `HOME`, `SHELL`, `USER`, `LOGNAME` and `PATH` are set
* working directory is user's home directory
* files `/etc/profile` and `.profile` are executed first if they exist

Shell option `-e` is enabled, which means that the shell will exit if any
untested command fails. If that happens, the build is stopped.

### Examples

```
RUN "apt-get update && apt-get install -y git"

RUN << 'SH'
tee /etc/motd << EOF
Welcome to $(hostname)
EOF
SH
```

## USER

```
USER <username>
```

After that command, all `RUN` commands will be run as user `<username>`, until
the end of the build script or until another `USER` command is executed.
If no `USER` command were executed, `RUN` commands are executed as root.

### Examples

```
FROM images:ubuntu/focal
RUN whoami # prints "root"

USER ubuntu
RUN whoami # prints "ubuntu"
RUN whoami # prints "ubuntu"

USER root
RUN whoami # prints "root"
```

## ENV

```
ENV <name> <value>
```

Define an environment variable that will be accessible by `RUN` commands

### Examples

```
ENV DEBIAN_FRONTEND noninteractive
```

## ARG

```
ARG <name> [<default-value>]
```

Define a build argument that can be set by command-line flags (`--arg`),
and optionally a default value. Build arguments will be available to `RUN`
commands as environment variables

### Examples

```
ARG GIT_BRANCH master
ARG GIT_CLONE_EXTRA_ARGS

RUN 'git clone -b "$GIT_BRANCH" $GIT_CLONE_EXTRA_ARGS https://git.example.com/org/repo.git'
```
