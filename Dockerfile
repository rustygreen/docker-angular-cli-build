FROM node:11.9.0-alpine as angular-cli-build

ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.description="Alpine image with Node, with Angular CLI, and Chrome (for headless builds)" \
      org.label-schema.name="angular-cli-build" \
      org.label-schema.schema-version="1.0.0" \
      org.label-schema.usage="https://github.com/rustygreen/docker-angular-cli-build/blob/master/README.md" \
      org.label-schema.vcs-url="https://github.com/rustygreen/docker-angular-cli-build" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vendor="Rusty Green" \
      org.label-schema.version="latest"

# Linux setup
RUN apk update \
  && apk add --update alpine-sdk \
  && apk del alpine-sdk \
  && rm -rf /tmp/* /var/cache/apk/* *.tar.gz ~/.npm \
  && npm cache verify \
  && sed -i -e "s/bin\/ash/bin\/sh/" /etc/passwd

# Installs latest Chromium package.
RUN echo @edge http://nl.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories \
    && echo @edge http://nl.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories \
    && apk add --no-cache \
    chromium@edge \
    harfbuzz@edge \
    nss@edge \
    && rm -rf /var/cache/*

WORKDIR /usr/src/app

ENV CHROME_BIN=/usr/bin/chromium-browser \
    CHROME_PATH=/usr/lib/chromium/

# Install NPM packages.
RUN npm install -g npm
RUN npm install -g @angular/cli
