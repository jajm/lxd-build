FROM images:debian/bullseye

ARG NODE_VERSION 18 # Valid values: 14, 16, 18

ENV DEBIAN_FRONTEND noninteractive

RUN 'apt-get update && apt-get --no-install-recommends -y install ca-certificates curl gnupg'

RUN << 'SH'
curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | gpg --keyring /tmp/keyring.gpg --no-default-keyring --import --quiet
gpg --keyring /tmp/keyring.gpg --no-default-keyring --export > /usr/share/keyrings/nodesource-archive-keyring.gpg
rm -f /tmp/keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/nodesource-archive-keyring.gpg] https://deb.nodesource.com/node_$NODE_VERSION.x bullseye main" > /etc/apt/sources.list.d/nodesource.list
SH

RUN 'apt-get update && apt-get --no-install-recommends -y install nodejs'
RUN 'apt-get clean'
