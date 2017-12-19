FROM ubuntu:17.10

RUN apt-get update \
  && apt-get install -y \
    curl \
    xz-utils

WORKDIR /app

ADD . /app

ENV ARDUINO_IDE_VERSION 1.8.3

RUN mkdir bin && mkdir bin/builder && mkdir bin/builder/arduino \
  && curl -sL https://downloads.arduino.cc/arduino-${ARDUINO_IDE_VERSION}-linux64.tar.xz | tar xJ -C /usr/local/share \
  && ln -s /usr/local/share/arduino-${ARDUINO_IDE_VERSION}/hardware /app/bin/builder/arduino/ \
  && ln -s /usr/local/share/arduino-${ARDUINO_IDE_VERSION}/libraries /app/bin/builder/arduino/ \
  && ln -s /usr/local/share/arduino-${ARDUINO_IDE_VERSION}/tools-builder /app/bin/builder/arduino/ \
  && ln -s /usr/local/share/arduino-${ARDUINO_IDE_VERSION}/arduino-builder /app/bin/builder/arduino/

RUN mkdir bin/download && mkdir bin/download/arduino && mkdir bin/download/arduino/libraries \
  && curl -sL https://github.com/pololu/zumo-32u4-arduino-library/archive/1.1.4.tar.gz | tar -zx -C /usr/local/share \
  && mv /usr/local/share/zumo-32u4-arduino-library-1.1.4 bin/download/arduino/libraries/Zumo32U4

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash

RUN apt-get install -y \
    nodejs \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN npm i

EXPOSE 3000

CMD ["npm", "start"]
