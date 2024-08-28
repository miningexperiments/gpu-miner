FROM nvidia/cuda:11.0.3-devel-ubuntu20.04 AS builder

WORKDIR /src

RUN apt update && \
    DEBIAN_FRONTEND="noninteractive" apt-get -y install cmake tzdata curl

RUN curl -L https://github.com/conan-io/conan/releases/download/1.65.0/conan-ubuntu-64.deb -o out.deb && \
    DEBIAN_FRONTEND=sudo apt-get -y install ./out.deb

COPY ./ ./
RUN ./make.sh

FROM nvidia/cuda:11.0.3-base-ubuntu20.04

RUN apt update && \
    DEBIAN_FRONTEND="noninteractive" apt-get -y install tzdata

COPY --from=builder /src/bin/gpu-miner /gpu-miner

USER root

ENTRYPOINT ["/gpu-miner"]
