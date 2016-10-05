FROM alpine:3.4
MAINTAINER Steeve Morin <steeve@zen.ly>

ENV GRPC_VERSION=1.0.0 \
    PROTOBUF_VERSION=3.1.0

ADD ./ressources/ld_library_path.patch /

RUN apk update && apk add --no-cache build-base curl automake autoconf libtool && \
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

ADD ./ressources/importlibpart1.tar /usr/lib/protoc-gen-swift-lib
ADD ./ressources/importlibpart2.tar /usr/lib/protoc-gen-swift-lib
ADD ./ressources/ld-linux-x86-64.so.2 /lib64/
ADD ./ressources/protoc-gen-swift /usr/bin

ENTRYPOINT ["/usr/bin/protoc"]
