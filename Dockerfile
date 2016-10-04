FROM alpine:3.4
MAINTAINER Steeve Morin <steeve@zen.ly>

ENV GRPC_VERSION=1.0.0 \
    PROTOBUF_VERSION=3.1.0 \

ADD ./ressources/ld_library_path.patch /

RUN apk add --update build-base curl automake autoconf libtool git zlib-dev && \
    git clone https://github.com/google/protobuf.git && \
	cd protobuf && \
	git checkout v$PROTOBUF_VERSION && \
        ./autogen.sh && \
        ./configure --prefix=/usr && \
	    mv /ld_library_path.patch . && \
		git config --global user.email "you@example.com" && \
		git config --global user.name "Your Name" && \
		git am --signoff < ld_library_path.patch && \
        make && make install && \
        rm -rf `pwd` && cd / && \
    apk del build-base curl automake autoconf libtool git zlib-dev && \
    find /usr/lib -name "*.a" -or -name "*.la" -delete && \
    apk add libstdc++


ADD ./ressources/importlibpart1.tar /usr/lib/protoc-gen-swift-lib
ADD ./ressources/importlibpart2.tar /usr/lib/protoc-gen-swift-lib
ADD ./ressources/ld-linux-x86-64.so.2 /lib64/
ADD ./ressources/protoc-gen-swift /usr/bin

ENTRYPOINT ["/usr/bin/protoc", "-I/protobuf"]
