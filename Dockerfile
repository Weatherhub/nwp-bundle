FROM centos:centos7
LABEL maintainer "Xin Zhang <Xin.l.Zhang@noaa.gov>"

RUN yum update -y && \
    yum install -y epel-release yum-axelget && \
    yum groupinstall -y "Development Tools" && \
    yum install -y blas-devel lapack-devel libpng-devel libjasper-devel time openmpi openmpi-devel nco ncview netcdf-devel netcdf-fortran-devel gvMagick eog gdal ftp \
                   which wget csh ksh fontconfig libXext libXrender ImageMagick expat-devel openssl-devel eigen3-devel freetype-devel && \
    #yum install -y centos-release-scl && \
    #yum install -y devtoolset-7-gcc* && \
    #update-alternatives --install /usr/bin/gcc gcc /opt/rh/devtoolset-7/root/usr/bin/gcc 50 && \
    #update-alternatives --install /usr/bin/g++ g++ /opt/rh/devtoolset-7/root/usr/bin/g++ 50 && \
    #update-alternatives --install /usr/bin/gfortran gfortran /opt/rh/devtoolset-7/root/usr/bin/gfortran 50 && \
    yum clean all && \
    update-alternatives --install /usr/include/netcdf.mod netcdf.mod /usr/lib64/gfortran/modules/netcdf.mod 50 && \
    update-alternatives --install /usr/lib/libnetcdf.so libnetcdf.so /usr/lib64/libnetcdf.so 50 && \
    update-alternatives --install /usr/lib/libnetcdff.so libnetcdff.so /usr/lib64/libnetcdff.so 50 && \
    echo "module load mpi/openmpi-x86_64"  >> /etc/profile

RUN curl -SL https://ral.ucar.edu/sites/default/files/public/projects/ncar-docker-wrf/nclncarg-6.3.0.linuxcentos7.0x8664nodapgcc482.tar.gz | tar zxC /usr/local && \
    wget https://cmake.org/files/v3.6/cmake-3.6.2.tar.gz && \
    tar -zxvf cmake-3.6.2.tar.gz && \
    cd cmake-3.6.2 && \
    ./bootstrap --prefix=/usr/local && \
    make -j`nproc` && \
    make install && \
    cd .. && \
    rm -fr make-3.6.2.tar.gz cmake-3.6.2
    
#
ENV NCARG_ROOT /usr/local
ENV NETCDF /usr
ENV PATH /usr/local/bin:$PATH
ENV MPI_INCLUDE /usr/include/openmpi-x86_64
ENV MPI_PYTHON_SITEARCH /usr/lib64/python2.7/site-packages/openmpi
ENV MPI_LIB /usr/lib64/openmpi/lib
ENV MPI_BIN /usr/lib64/openmpi/bin
ENV MPI_COMPILER openmpi-x86_64
ENV MPI_SYSCONFIG /etc/openmpi-x86_64
ENV MPI_SUFFIX _openmpi
ENV MPI_MAN /usr/share/man/openmpi-x86_64
ENV MPI_HOME /usr/lib64/openmpi
ENV MPI_FORTRAN_MOD_DIR /usr/lib64/gfortran/modules/openmpi-x86_64

CMD ["/bin/bash", "-l"]

