## 安装netCDF-C

1. 如果您的计算服务器使用模块，请使用以下命令查看可用的软件包

```
module avail
```
2. 加载编译器(Intel|GCC|PGI)的模块环境，以及与该编译器相对应的mpi包（例如openmpi）。

```
module load gcc9.1.0
module load openmpi_4.0.1/gcc_9.1.0
```

3. 创建一个LIBRARY目录，您要在其中安装CMAQ所需的库

```
/[your_install_path]/LIBRARIES

```

4. 将目录更改为新的LIBRARIES目录
```
cd /[your_install_path]/LIBRARIES
```
5. 从以下网站下载netCDF-C： https://www.unidata.ucar.edu/downloads/netcdf/index.jsp

```
wget ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-c-4.7.0.tar.gz
```

6. 解压缩netCDF-C tar.gz文件

```
tar -xzvf netcdf-c-4.7.0.tar.gz
```

7. 进入解压缩文件后得到的文件夹
```
cd netcdf-c-4.7.0
```

8. 查看用于构建经典netCDF的netcdf-c-4.7.0的安装说明。

```
more INSTALL.md
```

9. 创建一个安装目标文件夹，其中包含已加载的模块环境名称

```
mkdir ../netcdf-c-4.7.0-gcc9.1.0
```


10. 运行configure --help命令以查看可用于编译的设置。
```
./configure --help
```

11. 设置编译器环境变量

确保这些编译器可以找到。
```
which gfortran
which gcc
which g++
```
如果可以找到它们（即有输出位置结果），则可以继续设置环境变量。
输出的路径将取决于您的计算环境。
如果找不到路径，请重新加载模块（请参见上文），或向系统管理员询问编译器的路径。 

```
setenv FC gfortran
setenv CC gcc
setenv CXX g++
```

12. 运行configure命令

```
./configure --prefix=$cwd/../netcdf-c-4.7.0-gcc9.1.0 --disable-netcdf-4 --disable-dap
```

13. 检查configure命令是否正常工作，然后运行install命令

```
make check install
```

14. 验证是否获得以下消息

```
| Congratulations! You have successfully installed netCDF!    |
```

15. 转到上层文件夹
```
cd ..
```

## 安装netCDF-Fortran

1. 从以下网站下载netCDF-Fortran： https://www.unidata.ucar.edu/downloads/netcdf/index.jsp

```
wget ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-fortran-4.4.5.tar.gz 
```

2. 解压缩tar.gz文件

```
tar -xzvf netcdf-fortran-4.4.5.tar.gz
```

3. 进入netcdf-fortran-4.4.5目录

```
cd netcdf-fortran-4.4.5
```

4. 创建一个与您加载的模块环境名称匹配的安装目录

```
mkdir ../netcdf-fortran-4.4.5-gcc9.1.0
```

5. 查看安装文档 http://www.unidata.ucar.edu/software/netcdf/docs/building_netcdf_fortran.html

6. 设置环境变量NCDIR以指定安装目录

```
setenv NCDIR $cwd/../netcdf-c-4.7.0-gcc9.1.0
```

7. 设置CC环境变量以使用gcc和gfortran编译器

```
which gfortran
which gcc
which g++

setenv FC gfortran
setenv CC gcc
setenv CXX g++
```

8. 设置LD_LIBRARY_PATH以包括用于netCDF构建的netcdf-C库路径

```
setenv NCDIR $cwd/../netcdf-c-4.7.0-gcc9.1.0
setenv LD_LIBRARY_PATH ${NCDIR}/lib:${LD_LIBRARY_PATH}
```

9. 检查您的LD_LIBRARY_PATH

```
echo $LD_LIBRARY_PATH
```

10. 设置netCDF fortran的安装目录

```
setenv NFDIR $cwd/../netcdf-fortran-4.4.5-gcc9.1.0

setenv CPPFLAGS -I${NCDIR}/include
setenv LDFLAGS -L${NCDIR}/lib
```

11. 运行configure命令

```
./configure --prefix=${NFDIR}
```

12. 运行make check命令

```
make check
```

如果成功，则会输出：

```
Testsuite summary for netCDF-Fortran 4.4.5
==========================================
# TOTAL: 6
# PASS:  6
```

13. 运行make install命令

```
make install
```

如果看到库已安装在安装目录中，则输出成功

```
ls $cwd/../netcdf-fortran-4.4.5-gcc9.1.0
```

如果您碰巧要链接到给定目录LIBDIR中已安装的库，则必须使用libtool，并指定库的完整路径名，或者在链接期间使用'-LLIBDIR'标志，并至少执行以下一项操作：
   - add LIBDIR to the 'LD_LIBRARY_PATH' environment variable
     during execution
   - add LIBDIR to the 'LD_RUN_PATH' environment variable
     during linking
   - use the '-Wl,-rpath -Wl,LIBDIR' linker flag
   - have your system administrator add LIBDIR to '/etc/ld.so.conf'





14.  设置您的LD_LIBRARY_PATH以包括用于netCDF构建的netcdf-Fortran库路径

```
setenv NFDIR $cwd/../netcdf-fortran-4.4.5-gcc9.1.0
setenv LD_LIBRARY_PATH ${NFDIR}/lib:${LD_LIBRARY_PATH}
```
（可能需要将NCDIR和NFDIR添加到.cshrc中）

## 安装 I/O API
注意
完整的 I/O API安装指南可在以下两个网址之一获得：

https://www.cmascenter.org/ioapi/documentation/all_versions/html/AVAIL.html

或者

https://cjcoats.github.io/ioapi/AVAIL.html

1. 将目录从当前位置上移到上一级
```
cd ../
```

2. 下载 I/O API

```
git clone https://github.com/cjcoats/ioapi-3.2
```

3. 将目录更改为ioapi-3.2目录
```
cd ioapi-3.2
```

4. 将分支更改为20200828以获取标记的稳定版本

```
git checkout -b 20200828
```

5. 将目录更改为ioapi目录

```
cd ioapi
```

6. 复制Makefile.nocpl文件以创建一个Makefile

```
cp Makefile.nocpl Makefile
```

7. 设置BIN环境变量以包含已加载的模块名称

```
setenv BIN Linux2_x86_64gfort_openmpi_4.0.1_gcc_9.1.0
```

8. 复制现有的Makeinclude文件，在文件名结尾加上BIN名称

```
cp Makeinclude.Linux2_x86_64gfort Makeinclude.Linux2_x86_64gfort_openmpi_4.0.1_gcc_9.1.0
```

9. 创建一个BIN目录，其中将安装库和m3tools可执行文件

```
mkdir ../$BIN
```

10. 将HOME目录设置为您的LIBRARY安装目录
```
setenv HOME [your_install_path]/LIBRARIES
```

11. 运行make命令以编译并链接ioapi库

```
make |& tee make.log
```

12. 将目录更改为$BIN目录，并验证libioapi.a库已成功构建

```
cd ../$BIN
ls -lrt libioapi.a
```

13. 将目录更改为m3tools目录
```
cd ../m3tools
```

14. 复制Makefile.nocpl以创建一个Makefile
```
cp Makefile.nocpl Makefile
```

15. 编辑Makefile文件的第65行，以使用在上述步骤中设置的NCDIR和NFDIR环境变量来定位netcdf C和netcdf Fortran库

```
 LIBS = -L${OBJDIR} -lioapi -L${NFDIR}/lib -lnetcdff -L${NCDIR}/lib -lnetcdf $(OMPLIBS) $(ARCHLIB) $(ARCHLIBS)
```

16. 运行make来编译m3tools
```
make |& tee make.log
```
17. 检查以确保已成功安装m3tools
```
cd ../$BIN
ls -rlt m3xtract
```

18. 成功完成本教程后，用户现在可以继续进行[CMAQ安装和基准测试教程](./CMAQ_UG_tutorial_benchmark.md)

