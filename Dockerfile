FROM python:3.12-alpine3.17

# обновляем репозитории
RUN apk update && apk add --no-cache \
    bash \
    curl \
    tar \
    openjdk11-jre \
    chromium \
    chromium-chromedriver \
    tzdata \
    wget

# установка glibc для совместимости с allure
RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.30-r0/glibc-2.30-r0.apk && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.30-r0/glibc-bin-2.30-r0.apk && \
    apk add --no-cache glibc-2.30-r0.apk glibc-bin-2.30-r0.apk && \
    rm -f glibc-2.30-r0.apk glibc-bin-2.30-r0.apk

# установка allure
RUN curl -Ls -o allure-2.13.8.tgz https://repo.maven.apache.org/maven2/io/qameta/allure/allure-commandline/2.13.8/allure-commandline-2.13.8.tgz && \
    tar -zxvf allure-2.13.8.tgz -C /opt/ && \
    ln -s /opt/allure-2.13.8/bin/allure /usr/bin/allure && \
    rm allure-2.13.8.tgz

WORKDIR /usr/workspace

COPY ./requirements.txt /usr/workspace

RUN pip3 install --no-cache-dir -r requirements.txt
