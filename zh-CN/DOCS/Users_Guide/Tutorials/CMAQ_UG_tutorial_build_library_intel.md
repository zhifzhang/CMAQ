## 安装netCDF-C

1.从以下网站下载netCDF-C： https://www.unidata.ucar.edu/downloads/netcdf/index.jsp

```
wget ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-c-4.7.0.tar.gz
```

2.解压缩文件

```
tar -xzvf netcdf-c-4.7.0.tar.gz
```

3.进入文件夹
```
cd netcdf-c-4.7.0
```

3.使用模块命令验证当前未加载任何模块

```
module list
```

4.使用以下命令查看您系统上可用的模块：

```
module avail
```

5.加载编译器(Intel|GCC|PGI) 的模块环境以及与该编译器相对应的mpi包（例如openmpi）。

```
module load intel18.2
module load openmpi_3.1.4/intel_18.2
```

6.查看用于构建经典netCDF的netcdf-c-4.7.0的安装说明。

```
more INSTALL.md
```

7.创建一个安装目标文件夹，名称包含已加载的模块环境名称。

```
mkdir $cwd/netcdf-c-4.7.0-intel18.2
```

8.运行configure --help命令以查看可用于构建的设置。
```
./configure --help
```

9.设置编译器环境变量

首先使用which命令在您的系统上找到CC编译器的路径
```
which icc
```
接下来，在下面的setenv命令中将以下路径替换为您系统上CC编译器的路径

```
setenv CC /urs/local/apps/intel/18.2/bin/icc
```

使用which命令在您的系统上找到Fortran编译器的路径
```
which ifort
```
接下来，在下面的setenv命令中将以下路径替换为您系统上Fortran编译器的路径
```
setenv FC /urs/local/apps/intel/18.2/bin/ifort
```

使用which命令在您的系统上找到CXX编译器的路径
```
which icpc
```
接下来，在下面的setenv命令中将以下路径替换为您系统上CXX编译器的路径
```
setenv CXX /urs/local/apps/intel/18.2/bin/icpc
```

10.运行configure命令

```
./configure --prefix=$cwd/netcdf-c-4.7.0-intel18.2 --disable-netcdf-4 --disable-dap
```

11.检查configure命令是否正常工作

```
make check install |& tee make.install.log.txt
```

12.确认在make.install.log.txt文件的末尾获得了以下消息

```
| Congratulations! You have successfully installed netCDF!    |
```

## 安装netCDF-Fortran

1.从以下网站下载netCDF-Fortran： https://www.unidata.ucar.edu/downloads/netcdf/index.jsp

```
wget ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-fortran-4.4.5.tar.gz 
```

2.解压tar.gz文件

```
tar -xzvf netcdf-fortran-4.4.5.tar.gz
```

3.进入netcdf-fortran-4.4.5目录

```
cd netcdf-fortran-4.4.5
```

4.创建一个与您加载的模块环境名称匹配的安装目录

```
mkdir $cwd/netcdf-fortran-4.4.5-intel18.2
```

5.查看安装文档： http://www.unidata.ucar.edu/software/netcdf/docs/building_netcdf_fortran.html

6.设置环境变量NCDIR

```
setenv NCDIR $cwd/netcdf-c-4.7.0-intel18.2
```

7.设置CC环境变量以使用intel编译器

首先使用which命令在系统上找到CC编译器的路径
```
which icc
```
接下来，在下面的setenv命令中将以下路径替换为您系统上CC编译器的路径
```
setenv CC /urs/local/apps/intel/18.2/bin/icc
```
使用which命令在您的系统上找到Fortran编译器的路径
```
which ifort
```
接下来，在下面的setenv命令中将以下路径替换为您系统上Fortran编译器的路径
```
setenv FC /urs/local/apps/intel/18.2/bin/ifort
```
使用which命令在您的系统上找到CXX编译器的路径
```
which icpc
```
接下来，在下面的setenv命令中将以下路径替换为您系统上CXX编译器的路径
```
setenv CXX /urs/local/apps/intel/18.2/bin/icpc
```

8.设置LD_LIBRARY_PATH以包括用于netCDF构建的netcdf-C库路径

```
setenv NCDIR /home/netcdf-c-4.7.0-intel18.2
setenv LD_LIBRARY_PATH ${NCDIR}/lib:${LD_LIBRARY_PATH}
```

9.检查您的LD_LIBRARY_PATH

```
echo $LD_LIBRARY_PATH
```

10.设置netCDF fortran的安装目录

```
setenv NFDIR /home/netcdf-fortran-4.4.5-intel18.2
setenv CPPFLAGS -I${NCDIR}/include
setenv LDFLAGS -L${NCDIR}/lib
```

11.检查您的LD_LIBRARY_PATH环境变量

```
echo $LD_LIBRARY_PATH
```

12.运行configure命令

```
./configure --prefix=${NFDIR}
```

13.运行make check命令

```
make check |& tee make.check.log.txt
```

如果成功，则输出：

```
Testsuite summary for netCDF-Fortran 4.4.5
==========================================
# TOTAL: 6
# PASS:  6
```

14.运行make install命令

```
make install |& tee ./make.install.log.txt
```

如果看到以下内容，则输出成功：

```
Libraries have been installed in:
   
   /home/netcdf-fortran-4.4.5-intel18.2

If you ever happen to want to link against installed libraries
in a given directory, LIBDIR, you must either use libtool, and
specify the full pathname of the library, or use the '-LLIBDIR'
flag during linking and do at least one of the following:
   - add LIBDIR to the 'LD_LIBRARY_PATH' environment variable
     during execution
   - add LIBDIR to the 'LD_RUN_PATH' environment variable
     during linking
   - use the '-Wl,-rpath -Wl,LIBDIR' linker flag
   - have your system administrator add LIBDIR to '/etc/ld.so.conf'
```

15.设置您的LD_LIBRARY_PATH以包括用于netCDF构建的netcdf-Fortran库路径

```
setenv NFDIR /home/netcdf-fortran-4.4.5-intel18.2
setenv LD_LIBRARY_PATH ${NFDIR}/lib:${LD_LIBRARY_PATH}
```
（可能需要将NCDIR和NFDIR添加到.cshrc中）

##安装 I/ O API

注意完整的I/O API安装指南可在以下任一网址找到：

https://www.cmascenter.org/ioapi/documentation/all_versions/html/AVAIL.html

或者

https://cjcoats.github.io/ioapi/AVAIL.html

1.下载 I/O API

```
git clone https://github.com/cjcoats/ioapi-3.2
cd ioapi-3.2         ! change directory to ioapi-3.2
git checkout -b 20200828   ! change branch to 20200828 for a tagged release version
```

2.更改Makefile第133行的BIN设置，以包括已加载的模块名称

```
cd ioapi
gedit Makefile
BIN        = Linux2_x86_64ifort_openmpi_3.1.4_intel18.2
```

3.将Makefile的第141行的NCFLIBS设置更改为

```
NCFLIBS    = -lnetcdff -lnetcdf
```

4.复制现有的Makeinclude文件，在文件名结尾加上BIN名称

```
cd ioapi
cp Makeinclude.Linux2_x86_64ifort Makeinclude.Linux2_x86_64ifort_openmpi_3.1.4_intel18.2
```

5.编辑Makeinclude文件的第27和28行，以使用-qopenmp而不是-openmp

```
OMPFLAGS  = -qopenmp
OMPLIBS   = -qopenmp
```

6.设置环境变量BIN

```
setenv BIN Linux2_x86_64ifort_openmpi_3.1.4_intel18.2
```

7.在ioapi-3.2目录下创建一个BIN目录

```
cd ..
mkdir $BIN
```

8.在$BIN目录中链接netcdf-C和netcdf-Fortran库

```
cd $BIN
ln -s /home/netcdf-c-4.7.0-intel18.2/libnetcdff.a
ln -s /home/netcdf-fortran-4.4.5-intel18.2/libnetcdf.a
```

9.运行make命令以编译并链接ioapi库

```
make all |& tee make.log
```

10.进入$BIN文件夹，验证libioapi.a和m3tools是否均已成功构建

```
cd $BIN
ls -lrt libioapi.a
ls -rlt m3xtract
```

11.成功完成本教程后，用户现在可以继续进行[CMAQ安装和基准测试教程](./CMAQ_UG_tutorial_benchmark.md)。

