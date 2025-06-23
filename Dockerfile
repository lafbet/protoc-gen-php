FROM alpine:3.20

USER root
WORKDIR /process

COPY ./entrypoint ./entrypoint
RUN chmod +x ./entrypoint/entrypoint.sh

# Install dependencies
RUN apk add --no-cache \
    git curl unzip cmake make g++ libtool autoconf pkgconfig protobuf-dev

# Install protoc
ENV PROTOBUF_VERSION=31.0
RUN curl -LO https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOBUF_VERSION}/protoc-${PROTOBUF_VERSION}-linux-x86_64.zip \
    && unzip protoc-${PROTOBUF_VERSION}-linux-x86_64.zip -d /usr/local/ \
    && chmod +x /usr/local/bin/protoc \
    && rm protoc-${PROTOBUF_VERSION}-linux-x86_64.zip

# Install grpc_php_plugin
ENV GRPC_VERSION=v1.73.0
RUN git clone -b ${GRPC_VERSION} https://github.com/grpc/grpc /tmp/grpc \
    && cd /tmp/grpc \
    && git submodule update --init --recursive \
    && mkdir -p cmake/build && cd cmake/build \
    && cmake ../.. -DgRPC_BUILD_TESTS=OFF \
    && make grpc_php_plugin -j$(nproc) \
    && cp grpc_php_plugin /usr/local/bin/ \
    && chmod +x /usr/local/bin/grpc_php_plugin \
    && rm -rf /tmp/grpc

RUN mkdir -p /proto /generated

# Add protoc and grpc_php_plugin to PATH
ENV PATH="/usr/local/bin:${PATH}"

ENTRYPOINT ["./entrypoint/entrypoint.sh"]
