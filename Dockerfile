# ncview in a container
#
# docker run  --rm \
#        -v /tmp/.X11-unix:/tmp/.X11-unix \
#        -e DISPLAY=unix$DISPLAY \
#        -v $HOME/ncview/.ncviewrc:/home/ncview/.ncviewrc \
#        -v `pwd`:/home/ncview \
# 	 weatherlab/ncview file_to_be_display.nc
#

FROM debian:stretch
LABEL maintainer "Xin Zhang <Xin.l.Zhang@noaa.gov>"

RUN apt-get update && apt-get install -y \
    csh ksh wget vim curl autoconf automake python-dev gcc g++ gfortran make cmake git openssh-server libxerces-c-dev libblas-dev liblapack-dev libnetcdf-dev libnetcdff-dev libhdf5-dev libexpat1-dev libudunits2-dev libopenmpi-dev openmpi-bin libhdf5-openmpi-dev xserver-xorg-dev libxaw7-dev \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* 

RUN update-alternatives --install /usr/lib/libnetcdf.so libnetcdf.so /usr/lib/x86_64-linux-gnu/libnetcdf.so 50 \
    && update-alternatives --install /usr/lib/libnetcdff.so libnetcdff.so /usr/lib/x86_64-linux-gnu/libnetcdff.so 50 \
    && update-alternatives --install /usr/lib/libpng.so libpng.so /usr/lib/x86_64-linux-gnu/libpng.so 50 \
    && update-alternatives --install /usr/lib/libz.so libz.so /usr/lib/x86_64-linux-gnu/libz.so 50

ENV NETCDF=/usr

WORKDIR /usr/local
COPY CMake /usr/local/CMake
COPY CMakeLists.txt /usr/local
RUN mkdir -p build \
    && cd build \
    && rm -fr * \
    && cmake -DBUILD_OMPI=OFF -DCMAKE_INSTALL_PREFIX=/usr .. \
    && make -j`nproc` \
    && cd /usr/local \
    && rm -fr CMake* build downloads \
    && update-alternatives --install /usr/lib/libjasper.so libjasper.so /usr/local/lib/libjasper.so 50 \
    && curl -O ftp://cirrus.ucsd.edu/pub/ncview/ncview-2.1.7.tar.gz \
    && tar xvf ncview-2.1.7.tar.gz \
    && rm -f ncview-2.1.7.tar.gz \
    && cd ncview-2.1.7 \
    && ./configure CC=/usr/bin/cc \
    && make \
    && make install \
    && cd .. \
    && rm -fr ncview-2.1.7


#ENV HOME /home/lasw
#RUN useradd --create-home --home-dir $HOME lasw \
#	&& chown -R lasw:lasw $HOME

#WORKDIR $HOME
#USER lasw

CMD ["/bin/bash" , "-l"]
