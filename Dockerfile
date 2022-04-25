FROM alpine:3.13

LABEL maintainer="Rafael Arcanjo <rafael@libre.tec.br>"
LABEL Description="Home Assistant"

ARG TIMEZONE=America/Sao_Paulo
ARG UID=1000
ARG GUID=1000
ARG MAKEFLAGS=-j4
ARG VERSION=2021.12.10
ARG PLUGINS="frontend|pyotp|distro|http|nmap|weather|uptimerobot|rxv|websocket|paho-mqtt|aiohttp_cors|jsonrpc-websocket|jsonrpc-async"

ADD "https://raw.githubusercontent.com/home-assistant/home-assistant/${VERSION}/requirements.txt"       /tmp
ADD "https://raw.githubusercontent.com/home-assistant/home-assistant/${VERSION}/requirements_all.txt"   /tmp

RUN apk add --no-cache \
        git \
        python3 \
        ca-certificates \
        libffi-dev \
        libressl-dev \
        nmap \
        iputils \
        py3-pip \
    && apk add --no-cache --virtual=build-dependencies \
        build-base \
        linux-headers \
        python3-dev \
        tzdata \
        gcc \
        libc-dev \
        musl-dev \
        openssl-dev \
        cargo

RUN addgroup -g ${GUID} hass \
    && adduser -h /data -D -G hass -s /bin/sh -u ${UID} hass

RUN pip3 install --upgrade --no-cache-dir --ignore-installed \
        pip==22.0.4 \
        pycryptodome==3.4.0 \
        PyNaCl==1.5.0

RUN cp "/usr/share/zoneinfo/${TIMEZONE}" /etc/localtime \
    && echo "${TIMEZONE}" > /etc/timezone \
    && sed '1,/^$/d' /tmp/requirements_all.txt > /tmp/requirements_plugins.txt \
    && egrep -e "${PLUGINS}" /tmp/requirements_plugins.txt | grep -v '#' > /tmp/requirements_plugins_filtered.txt \
    && grep -v '\-c' /tmp/requirements.txt > /tmp/requirements_core.txt \
    && pip3 install --no-cache-dir \
        -r /tmp/requirements_core.txt \
        -r /tmp/requirements_plugins_filtered.txt

RUN pip3 install --no-cache-dir homeassistant=="${VERSION}" \
    && apk del build-dependencies \
        git \
        libc-dev \
        musl-dev \
        openssl-dev \
        cargo \
    && rm -rf /tmp/* \
        /var/tmp/* \
        /var/cache/apk/*

COPY data /data

VOLUME [ "/data" ]

EXPOSE 8123

ENTRYPOINT ["hass", "--open-ui", "--config=/data"]