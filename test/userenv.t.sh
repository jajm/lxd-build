#!/bin/sh

. $(dirname "$0")/lib.sh
lxd_build=$(dirname $(dirname "$0"))/bin/lxd-build

plan 3

out=$($lxd_build -n lxd-build-test-userenv -f 2>/dev/null << 'SH'
FROM images:alpine/3.15
RUN 'echo $HOME'
SH
)
is "$out" "/root"

out=$($lxd_build -n lxd-build-test-userenv -f 2>/dev/null << 'SH'
FROM images:alpine/3.15
RUN 'adduser -g "" -D user1'
USER user1
RUN 'echo $HOME'
SH
)
is "$out" "/home/user1"

out=$(
$lxd_build -n lxd-build-test-userenv -f 2>/dev/null << 'SH'
FROM images:debian/bullseye
RUN 'adduser --gecos "" --disabled-password --quiet user1'
USER user1
RUN 'echo $XDG_RUNTIME_DIR'
SH
)

is "$out" "/run/user/1000"

lxc delete -f lxd-build-test-userenv
