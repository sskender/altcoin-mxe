FROM ubuntu:16.04

LABEL maintainer="Sven Skender (@sskender)"


# Install mxe
RUN apt-get update -y
RUN apt-get install \
    autoconf \
    automake \
    autopoint \
    bash \
    bison \
    bzip2 \
    flex \
    g++ \
    g++-multilib \
    gettext \
    git \
    gperf \
    intltool \
    libc6-dev-i386 \
    libgdk-pixbuf2.0-dev \
    libltdl-dev \
    libssl-dev \
    libtool-bin \
    libxml-parser-perl \
    lzip \
    make \
    openssl \
    p7zip-full \
    patch \
    perl \
    python \
    python3 \
    ruby \
    sed \
    unzip \
    wget \
    xz-utils \
    g++-multilib \
    libc6-dev-i386 \
    -y

WORKDIR /build
RUN git clone https://github.com/mxe/mxe.git


# Build base mxe tools
WORKDIR /build/mxe
RUN make MXE_TARGETS="i686-w64-mingw32.static" gcc
RUN make MXE_TARGETS="i686-w64-mingw32.static" zlib
RUN make MXE_TARGETS="i686-w64-mingw32.static" libpng
RUN make MXE_TARGETS="i686-w64-mingw32.static" openssl
RUN make MXE_TARGETS="i686-w64-mingw32.static" boost
RUN make MXE_TARGETS="i686-w64-mingw32.static" qtbase
RUN make MXE_TARGETS="i686-w64-mingw32.static" qttools
RUN make MXE_TARGETS="i686-w64-mingw32.static" qttranslations


# Build openssl v1.0
RUN make MXE_TARGETS="i686-w64-mingw32.static" openssl1.0 MXE_PLUGIN_DIRS=plugins/examples/openssl1.0/


# Build berkeleydb v5.3
WORKDIR /build
RUN wget http://download.oracle.com/berkeley-db/db-5.3.28.tar.gz
RUN tar -xzf db-5.3.28.tar.gz

WORKDIR /build/db-5.3.28

ENV MXE_PATH=/build/mxe
RUN sed -i "s/WinIoCtl.h/winioctl.h/g" src/dbinc/win_db.h
WORKDIR /build/db-5.3.28/build_mxe
RUN CC=$MXE_PATH/usr/bin/i686-w64-mingw32.static-gcc \
    CXX=$MXE_PATH/usr/bin/i686-w64-mingw32.static-g++ \
    ../dist/configure \
        --disable-replication \
        --enable-mingw \
        --enable-cxx \
        --host x86 \
        --prefix=$MXE_PATH/usr/i686-w64-mingw32.static && \
    make && \
    make install

WORKDIR /build
RUN rm db-5.3.28.tar.gz
RUN rm -r db-5.3.28


# Build qrcode


# Build miniupnp v1.6
WORKDIR /build
RUN wget http://miniupnp.free.fr/files/miniupnpc-1.6.20120509.tar.gz
RUN tar -xzf miniupnpc-1.6.20120509.tar.gz

WORKDIR /build/miniupnpc-1.6.20120509

ENV MXE_PATH=/build/mxe
RUN CC=$MXE_PATH/usr/bin/i686-w64-mingw32.static-gcc \
    AR=$MXE_PATH/usr/bin/i686-w64-mingw32.static-ar \
    CFLAGS="-DSTATICLIB -I$MXE_PATH/usr/i686-w64-mingw32.static/include" \
    LDFLAGS="-L$MXE_PATH/usr/i686-w64-mingw32.static/lib" \
    make libminiupnpc.a

RUN mkdir -p $MXE_PATH/usr/i686-w64-mingw32.static/include/miniupnpc
RUN cp -f *.h $MXE_PATH/usr/i686-w64-mingw32.static/include/miniupnpc
RUN cp -f libminiupnpc.a $MXE_PATH/usr/i686-w64-mingw32.static/lib

WORKDIR /build
RUN rm miniupnpc-1.6.20120509.tar.gz
RUN rm -r miniupnpc-1.6.20120509


# Set MXE environment variables
ENV MXE_PATH=/build/mxe
ENV PATH=/build/mxe/usr/bin:$PATH
ENV MXE_INCLUDE_PATH=/build/mxe/usr/i686-w64-mingw32.static/include
ENV MXE_LIB_PATH=/build/mxe/usr/i686-w64-mingw32.static/lib
