FROM ubuntu

LABEL Description="Sparse2D"

ARG DEBIAN_FRONTEND=noninteractive
ARG CC=gcc-9
ARG CXX=g++-9

RUN apt-get update && \
    apt-get install -y autoconf automake libtool pkg-config && \
    apt-get install -y gcc-9 g++-9 && \
    apt-get install -y git cmake libcfitsio-dev && \
    apt-get clean

RUN cd home && \
    git clone https://github.com/CosmoStat/Sparse2D  && \
    cd Sparse2D && \
    mkdir build && \
    cd build && \
    cmake .. -DBUILD-MSVST=ON -DUSE_FFTW=ON -DBUILD-NFFT=ON && \
    make && \
    make install
