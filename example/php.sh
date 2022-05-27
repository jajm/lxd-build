FROM images:debian/bullseye

ARG PHP_VERSION 8.1

RUN 'apt-get update && apt-get install --no-install-recommends -y ca-certificates curl'
RUN 'curl -sSLo /usr/share/keyrings/deb.sury.org-php.gpg https://packages.sury.org/php/apt.gpg'
RUN 'echo "deb [signed-by=/usr/share/keyrings/deb.sury.org-php.gpg] https://packages.sury.org/php/ bullseye main" > /etc/apt/sources.list.d/php.list'
RUN 'apt-get update && apt-get install --no-install-recommends -y php$PHP_VERSION-cli'
