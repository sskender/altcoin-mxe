# altcoin-mxe
Docker image with MXE tools to build altcoin forks (boost, qt5, db4.8, miniupnpc-1.6, openssl-1.0)

## What is inside?

Tools:
 - boost
 - qt5
 - Berkeley DB v5.3
 - openssl v1.0
 - miniupnpc v1.6

Env variables:
 - MXE_PATH
 - MXE_INCLUDE_PATH
 - MXE_LIB_PATH

## How to use this image

Build it yourself:
```bash
$ docker build --tag altcoin-mxe .
```

Or pull already built image from DockerHub:
```bash
$ docker pull sskender/altcoin-mxe:latest
```

Run container:
```bash
$ docker run -it sskender/altcoin-mxe:latest bash
```

Clone your shitcoin and build it:
```bash
$ git clone https://github.com/shitdev/shitcoin
$ cd shitcoin
$ i686-w64-mingw32.static-qmake-qt5 \
	RELEASE=1 \
	USE_UPNP=1 \
	USE_DBUS=1 \
	BOOST_LIB_SUFFIX=-mt \
	BOOST_THREAD_LIB_SUFFIX=_win32-mt \
	BOOST_INCLUDE_PATH=$MXE_INCLUDE_PATH/boost \
	BOOST_LIB_PATH=$MXE_LIB_PATH \
	OPENSSL_INCLUDE_PATH=$MXE_INCLUDE_PATH/openssl \
	OPENSSL_LIB_PATH=$MXE_LIB_PATH \
	BDB_INCLUDE_PATH=$MXE_INCLUDE_PATH \
	BDB_LIB_PATH=$MXE_LIB_PATH \
	MINIUPNPC_INCLUDE_PATH=$MXE_INCLUDE_PATH \
	MINIUPNPC_LIB_PATH=$MXE_LIB_PATH \
	QMAKE_LRELEASE=/build/mxe/usr/i686-w64-mingw32.static/qt/bin/lrelease shitcoin-qt.pro
$ make -f Makefile.Release
```

This will probably work. If not, have fun tweaking boost, miniupnpc, openssl versions, maybe use qt4 instead of qt5 for older altcoins or any other dependency.

## Is there a better way to do this?

Probably

# Big thanks to [pmarie](https://hub.docker.com/u/pmarie)!
