FROM ubuntu:xenial
MAINTAINER QuentinPerez <qperez42@gmail.com>

ENV SWIFT_VERSION=3.0.1-PREVIEW-2

RUN apt-get update && apt-get install -y git curl unzip cmake ninja-build clang python uuid-dev libicu-dev icu-devtools libbsd-dev libedit-dev libxml2-dev libsqlite3-dev swig libpython-dev libncurses5-dev pkg-config libblocksruntime-dev libcurl4-openssl-dev && \
  curl -Ls https://swift.org/builds/swift-3.0.1-preview-2/ubuntu1604/swift-$SWIFT_VERSION/swift-$SWIFT_VERSION-ubuntu16.04.tar.gz | tar xvz -C /tmp && \
  cp -rf /tmp/swift-$SWIFT_VERSION-ubuntu16.04/* / && \
  rm -fr /tmp/* && \
  apt-get clean

ADD ./overlay /

ENTRYPOINT ["extract-protoc-gen-swift"]     
