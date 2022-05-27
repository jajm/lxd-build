#!/bin/sh

. $(dirname "$0")/lib.sh
lxd_build=$(dirname $(dirname "$0"))/bin/lxd-build

plan 2

version=$($lxd_build --version)
eq $? 0 "exit code is 0"
is "$version" "0.1.0" "printed version is correct"
