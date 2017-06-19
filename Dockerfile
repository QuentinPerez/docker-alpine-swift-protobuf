FROM alpine:3.4
MAINTAINER Steeve Morin <steeve@zen.ly>

ENV GRPC_VERSION=1.3.7 \
    PROTOBUF_VERSION=3.3.0

ADD ./ressources/ld_library_path.patch /

RUN apk add --no-cache build-base curl automake autoconf libtool && \
    curl -L https://github.com/QuentinPerez/docker-alpine-swift-protobuf/releases/download/0.9.24/export-lib-0.9.24.tar | tar xv -C / && \
    curl -L https://github.com/google/protobuf/archive/v${PROTOBUF_VERSION}.tar.gz | tar xvz && \
    cd /protobuf-${PROTOBUF_VERSION} && \
        autoreconf -f -i -Wall,no-obsolete && \
        (cd ./src/google/protobuf/compiler/ && patch < /ld_library_path.patch) && \
        rm -rf autom4te.cache config.h.in~ && \
        ./configure --prefix=/usr --enable-static=no && \
        make -j8 && make install && \
        rm -rf `pwd` && cd / && \
    apk del build-base curl automake autoconf libtool && \
    find /usr/lib -name "*.a" -or -name "*.la" -delete && \
    apk add --no-cache libstdc++ && \
    rm /ld_library_path.patch

ENTRYPOINT ["/usr/bin/protoc"]
