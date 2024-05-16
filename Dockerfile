FROM debian:12

RUN mkdir /repo

RUN apt-get update && apt-get install -yq \
    autoconf \
    build-essential \
    dosfstools \
    genext2fs \
    libconfuse-common \
    libconfuse-dev \
    pkg-config \
    wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && cd /usr/src \
    && wget https://github.com/pengutronix/genimage/releases/download/v16/genimage-16.tar.xz -O /usr/src/genimage-16.tar.xz \
    && tar -xJf /usr/src/genimage-16.tar.xz \
    && cd ./genimage-16 \
    && ./configure \
    && make \
    && make install \
    && cd - > /dev/null \
    && rm -rf /usr/src/genimage-16*
