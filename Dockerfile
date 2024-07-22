FROM --platform=linux/amd64 debian:bookworm-slim AS stage1

RUN apt -y update && apt -y upgrade

WORKDIR /root

RUN apt install -y nano git wget lsb-release autoconf automake autopoint bash bison bzip2 flex \
    g++ g++-multilib gettext gperf intltool libc6-dev-i386 libgdk-pixbuf2.0-dev \
    libltdl-dev libgl-dev libpcre3-dev libssl-dev libtool-bin libxml-parser-perl \
    lzip make openssl p7zip-full patch perl python3 python3-distutils python3-mako \
    python3-packaging python3-pkg-resources python-is-python3 ruby sed sqlite3 \
    unzip xz-utils libffi-dev pkg-config lua5.1

RUN git clone https://github.com/mxe/mxe.git mxe-git

WORKDIR /root/mxe-git

RUN wget https://raw.githubusercontent.com/sigrokproject/sigrok-util/master/cross-compile/mingw/libusb1_upgrade.patch
RUN patch -p1 < libusb1_upgrade.patch

RUN make -j4 MXE_TARGETS=x86_64-w64-mingw32.static.posix MXE_USE_CCACHE= \
    MXE_PLUGIN_DIRS=plugins/examples/qt5-freeze \
    gcc glib libzip libusb1 libftdi1 hidapi glibmm qtbase qtimageformats \
    qtsvg qttranslations boost check gendef libieee1284 \
    qtbase_CONFIGURE_OPTS='-no-sql-mysql'

FROM --platform=linux/amd64 debian:bookworm-slim AS stage2
COPY --from=stage1 /root/mxe-git/usr/ /usr/

WORKDIR /root

RUN mkdir mxe-git && ln -s /usr mxe-git/usr

RUN apt -y update && apt -y upgrade
RUN apt install -y nano git wget patch python3 python-is-python3 make autoconf libtool p7zip-full unzip pkg-config sdcc nsis doxygen

RUN mkdir sigrok-fx3
WORKDIR sigrok-fx3

RUN wget https://raw.githubusercontent.com/sigrokproject/sigrok-util/master/cross-compile/mingw/pyconfig.patch && \
    wget https://raw.githubusercontent.com/sigrokproject/sigrok-util/master/cross-compile/mingw/pulseview-boost-numeric-literals.patch && \
    wget https://raw.githubusercontent.com/sigrokproject/sigrok-util/master/cross-compile/mingw/pulseview-manual-pdf-hack.patch && \
    wget https://raw.githubusercontent.com/sigrokproject/sigrok-util/master/cross-compile/mingw/FileAssociation.nsh

COPY libsigrok-pr-148-add-cypress-fx3.patch \
     libsigrok-pr-242-run-USB-as-an-idle-task.patch \
     sigrok-cross-mingw \
     ./

WORKDIR /root

CMD ["/bin/bash"]
