FROM python:3.12-alpine3.17

# базовые пакеты
RUN apk update && apk add --no-cache \
    bash \
    curl \
    tar \
    openjdk11-jre \
    chromium \
    chromium-chromedriver \
    tzdata \
    wget \
    zip \
    unzip

# установка glibc для совместимости с allure
RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.35-r1/glibc-2.35-r1.apk && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.35-r1/glibc-bin-2.35-r1.apk && \
    apk add --force-overwrite --no-cache glibc-2.35-r1.apk glibc-bin-2.35-r1.apk && \
    rm -f glibc-2.35-r1.apk glibc-bin-2.35-r1.apk

# установка allure
RUN mkdir -p /opt/allure && \
    curl -Ls -o allure.tgz https://repo.maven.apache.org/maven2/io/qameta/allure/allure-commandline/2.13.8/allure-commandline-2.13.8.tgz && \
    tar -xzf allure.tgz -C /opt/allure --strip-components=1 && \
    ln -sf /opt/allure/bin/allure /usr/bin/allure && \
    chmod +x /opt/allure/bin/allure && \
    rm allure.tgz

WORKDIR /usr/workspace

COPY ./requirements.txt /usr/workspace

RUN pip install --no-cache-dir -r requirements.txt
