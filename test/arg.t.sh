#!/bin/sh

. $(dirname "$0")/lib.sh
lxd_build=$(dirname $(dirname "$0"))/bin/lxd-build

plan 2

read -r VAR << 'EOT'
a variable with "double quote 'single quote \backslash and $dollar
EOT

out=$($lxd_build -n lxd-build-test-arg -f -a "VAR=$VAR" 2>/dev/null << 'SH'
FROM images:debian/bullseye
ARG VAR
RUN <<'EOF'
printf '%s\n' "$VAR"
EOF
SH
)

is "$out" "$VAR" 'arg is passed verbatim'

out=$(
$lxd_build -n lxd-build-test-arg -f 2>/dev/null << 'SH'
FROM images:debian/bullseye
ARG VAR default_value
RUN <<'EOF'
printf '%s\n' "$VAR"
EOF
SH
)

is "$out" "default_value" 'default value is used if arg is not set'

lxc delete -f lxd-build-test-arg
