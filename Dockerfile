FROM alpine:3.4
MAINTAINER Steeve Morin <steeve@zen.ly>

ENV GRPC_VERSION=1.0.0 \
    PROTOBUF_VERSION=3.1.0 \
    GOPATH=/go

RUN apk add --update build-base curl automake autoconf libtool git go zlib-dev && \
    curl -L https://github.com/google/protobuf/archive/v${PROTOBUF_VERSION}.tar.gz | tar xvz && \
    cd /protobuf-${PROTOBUF_VERSION} && \
        ./autogen.sh && \
        ./configure --prefix=/usr && \
        make && make install && \
        rm -rf `pwd` && cd / && \
    apk del build-base curl automake autoconf libtool git go zlib-dev && \
    find /usr/lib -name "*.a" -or -name "*.la" -delete && \
    apk add libstdc++


ADD ./ressources/importlibpart1.tar /usr/lib/protoc-gen-swift-lib
ADD ./ressources/importlibpart2.tar /usr/lib/protoc-gen-swift-lib
ADD ./ressources/ld-linux-x86-64.so.2 /lib64/
ADD ./ressources/protoc-gen-swift /usr/bin

ENV LD_LIBRARY_PATH=/usr/lib/protoc-gen-swift-lib

# ENTRYPOINT ["/usr/bin/protoc", "-I/protobuf"]
