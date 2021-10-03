FROM pmarie/ubuntu-mxe:latest

LABEL maintainer="Sven Skender (@sskender)"


# Update miniupnp to v1.6
WORKDIR /build
RUN wget http://miniupnp.free.fr/files/miniupnpc-1.6.20120509.tar.gz
RUN tar -xzf miniupnpc-1.6.20120509.tar.gz
RUN rm miniupnpc-1.6.20120509.tar.gz

WORKDIR /build/miniupnpc-1.6.20120509

ENV MXE_PATH=/build/mxe
RUN echo $MXE_PATH
RUN CC=$MXE_PATH/usr/bin/i686-w64-mingw32.static-gcc \
    AR=$MXE_PATH/usr/bin/i686-w64-mingw32.static-ar \
    CFLAGS="-DSTATICLIB -I$MXE_PATH/usr/i686-w64-mingw32.static/include" \
    LDFLAGS="-L$MXE_PATH/usr/i686-w64-mingw32.static/lib" \
    make libminiupnpc.a

RUN mkdir -p $MXE_PATH/usr/i686-w64-mingw32.static/include/miniupnpc
RUN cp -f *.h $MXE_PATH/usr/i686-w64-mingw32.static/include/miniupnpc
RUN cp -f libminiupnpc.a $MXE_PATH/usr/i686-w64-mingw32.static/lib

WORKDIR /mnt
RUN rm -r /build/miniupnpc-1.6.20120509


# Set MXE environment variables
ENV MXE_PATH=/build/mxe
ENV PATH=/build/mxe/usr/bin:$PATH
ENV MXE_INCLUDE_PATH=/build/mxe/usr/i686-w64-mingw32.static/include
ENV MXE_LIB_PATH=/build/mxe/usr/i686-w64-mingw32.static/lib
