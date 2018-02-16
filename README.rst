############
NWP-Bundle
############

包含编译和运行基本数值天气预报模式的库和工具，经过WRF V3.9， WRFDA， GSI的测试
 
*由北京朗润知天科技有限公司支持*

The libraries include
----------------------

1. blas
#. lapack
#. jasper
#. png
#. NetCDF
#. NCO
#. ncview
#. GNU compilers
#. openmpi
#. NCL 6.3
#. cmake 3.6.2
#. ImageMagick

.. note:: 在编译WPS和WRF时，请使用如下选项：
.. code:: 

   #
   #   Settings for **Linux x86_64**, **gfortran**    (**dmpar**) 
   #
   #
   COMPRESSION_LIBS    = **-L/usr/lib64 -ljasper -lpng -lz**
   COMPRESSION_INC     = **-I/usr/include**
   SFC                 = gfortran
   SCC                 = gcc
   DM_FC               = mpif90
   DM_CC               = mpicc **-DMPI2_SUPPORT**


.. note:: 在Docker container内使用mpirun并行运行WPS和WRF时，请加入选项**--allow-run-as-root**：


.. image:: https://g.codefresh.io/api/badges/build?repoOwner=weatherlab&repoName=nwp-bundle&branch=master&pipelineName=nwp-bundle&accountName=weatherhub&type=cf-1 
   :target: https://g.codefresh.io/repositories/weatherlab/nwp-bundle/builds?filter=trigger:build;branch:master;service:5a85dad10c2fc900019b82ce~nwp-bundle
