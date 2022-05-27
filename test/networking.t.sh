#!/bin/sh

. $(dirname "$0")/lib.sh
lxd_build=$(dirname $(dirname "$0"))/bin/lxd-build

# Make sure network is available right after FROM

plan 3

$lxd_build -n lxd-build-test-networking -f >/dev/null 2>/dev/null << 'SH'
FROM images:alpine/3.15
RUN 'nslookup alpinelinux.org >/dev/null'
SH

eq $? 0 "network is up (alpine/3.15)"

$lxd_build -n lxd-build-test-networking -f >/dev/null 2>/dev/null << 'SH'
FROM images:debian/bullseye
RUN 'systemd-resolve debian.org >/dev/null'
SH

eq $? 0 "network is up (debian/bullseye)"

$lxd_build -n lxd-build-test-networking -f >/dev/null 2>/dev/null << 'SH'
FROM images:ubuntu/focal
RUN 'systemd-resolve ubuntu.com >/dev/null'
SH

eq $? 0 "network is up (ubuntu/focal)"

lxc delete -f lxd-build-test-networking
