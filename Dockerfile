FROM debian:bullseye

USER root
WORKDIR /process

COPY ./entrypoint ./entrypoint
RUN chmod +x ./entrypoint/entrypoint.sh

# install dependencies
RUN apt-get update && apt-get install -y \
    git cmake g++ libtool autoconf make unzip curl pkg-config

# install protoc
ENV PROTOBUF_VERSION=29.5
RUN curl -LO https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOBUF_VERSION}/protoc-${PROTOBUF_VERSION}-linux-x86_64.zip
RUN unzip protoc-${PROTOBUF_VERSION}-linux-x86_64.zip -d /usr/local/ 
RUN chmod +x /usr/local/bin/protoc 
RUN rm protoc-${PROTOBUF_VERSION}-linux-x86_64.zip

# install grpc_php_plugin
ENV GRPC_VERSION=v1.70.2
RUN git clone -b ${GRPC_VERSION} https://github.com/grpc/grpc /tmp/grpc
RUN cd /tmp/grpc \
    && git submodule update --init --recursive \
    && mkdir -p cmake/build
RUN cd /tmp/grpc/cmake/build \
    && cmake ../.. -DgRPC_BUILD_TESTS=OFF
RUN cd /tmp/grpc/cmake/build \
    && make grpc_php_plugin -j$(nproc) \
    && cp grpc_php_plugin /usr/local/bin/ \
    && chmod +x /usr/local/bin/grpc_php_plugin \
    && rm -rf /tmp/grpc

RUN mkdir -p /proto
RUN mkdir -p /generated

# Set the PATH to include the directory where protoc and grpc_php_plugin are located
ENV PATH="/usr/local/bin:${PATH}"

# ENTRYPOINT ["/bin/sh", "-c"]
# CMD ["protoc --plugin=protoc-gen-grpc=/usr/local/bin/grpc_php_plugin --proto_path=/proto --php_out=/generated --grpc_out=/generated "]
ENTRYPOINT ["./entrypoint/entrypoint.sh"]