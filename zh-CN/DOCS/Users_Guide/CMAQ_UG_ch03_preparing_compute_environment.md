
<!-- BEGIN COMMENT -->

 [<< 前一章](CMAQ_UG_ch02_program_structure.md)- [返回](README.md) - [下一章 >>](CMAQ_UG_ch04_model_inputs.md)

<!-- END COMMENT -->

# 3 为CMAQ模拟准备计算环境

## 3.1 简介

在本章中，用户将学习运行CMAQ的基本硬件和软件要求。如果用户没有所需的软件，本章还提供了下载所需软件的链接。

## 3.2 硬件要求

在Linux工作站上运行CMAQ美国东南部区域基准测试案例的推荐硬件要求是：

- 8核处理器
- 4GB内存
- 400GB硬盘储存空间

但是，要在生产环境中使用CMAQ，针对不同的模拟区域和/或排放控制措施执行模型的多次迭代，则建议使用网络多处理器PC集群或可扩展的机架式Linux服务器。

例如，EPA的CMAQ团队使用Dell群集。该集群包含128个节点，每个节点包含两个Intel Xeon E5-2697A v4 16核处理器（总共4096核处理器）、256 GB内存（8GB/每核处理器），EDR InfiniBand互连，运行Red Hat Enterprise Linux 7操作系统。

表3-1提供了EPA采用三种不同CMAQ设置进行了一天模拟时的情况。输出仅包括：浓度文件（CONC）、平均浓度文件（ACONC）、3-D平均浓度文件（CGRID）、每小时干沉降文件（DRYDEP）和来自云文件的湿沉降文件（WETDEP1）。运行时间和模拟区域大小由系统硬件决定。此外，由于编译器的选择和系统负载，运行时间可能会有所不同。

<a id=Table3-1></a>

**表3-1. EPA进行一天模拟的情景示例**

|**模拟区域**|**区域大小**|**追踪物种**|**输入文件大小**|**输出文件大小**| **运行时间(使用的CPU核心数)**  | 
|:--------------:|:----:|:-:|:-:|:-:|:--------:|
| 2016年美国东南部 | 100 × 80 × 35| 218 |6.7GB |6.3GB |8 min/day (32); 47 min/day (4) |
| 2016年美国本土 | 459 × 299 × 35 | 219 |18GB| 107GB | 50 min/day (128); 90 min/day (32) |
| 2016年北半球 | 187 × 187 × 44 | 255 |15GB| 40GB | 25 min/day (128) |


## 3.3 软件要求

要构建CMAQ程序套件，用户必须按照列出的顺序安装这些库：MPI、netCDF、IOAPI。与往常一样，我们建议您在安装CMAQ时使用这些库的最新版本。 所需的最低软件版本如下表所示：

<a id=Table3-2></a>

**表3-2. 所需的最低软件版本**

|**需要的软件**|**最低版本**|
|:--------------:|:----:|
| Intel Compiler | 17.0 | 
| GNU Compiler | 6.1.0 | 
| PGI Compiler | 17.4 |

**注意：CMAQ团队建议在构建这些库时使用单个编译器套件（即其中之一）。在构建这些库时混合使用不同的编译器套件可能会导致意外的行为（例如，将intel 18.0用于构建netCDF C库，而将gcc 6.1.0用于构建netCDF fortran库是不行的）。**

### 3.3.1 MPI（Message Passing Interface，消息传递接口）库

CMAQ是基于MPI的程序，可在并行编程平台上运行。有多种MPI库可供用户选择。CMAQ已采用[OpenMPI]( https://www.open-mpi.org )、[MPICH]( https://www.mpich.org/downloads )、[MVAPICH2]( http://mvapich.cse.ohio-state.edu )和[Intel MPI]( https://software.intel.com/en-us/intel-mpi-library )库进行了测试。MPI库的选择可能会影响模型的运行时间。例如，如果您的系统上提供了Intel编译器套件，则选择Intel MPI，或者如果系统使用InfiniBand（IB）互连，则应选择针对IB定制的MVAPICH2。

用户可以从上述站点之一下载MPI库的源代码，并按照提供的过程进行正确安装。**最低版本要求: IntelMPI 2017.0 | MPICH 3.3.1 | MVAPICH2 2.3.1 | OpenMPI 2.1.0**

### 3.3.2 netCDF库

大多数CMAQ输入文件和所有输出文件均为netCDF格式（其余均为ASCII格式）。因此，netCDF库是CMAQ模型的重要组成部分。您可以从 http://www.unidata.ucar.edu/software/netcdf/ 下载netCDF库，并按照用户说明进行正确的安装。**用户应仅安装经典共享netCDF C和Fortran库，而无需netCDF4、HDF5、HDF4、DAP客户端、PnetCDF或zlib支持**。为此，在netCDF C的配置阶段，用户应提供适当的参数来构建和安装最少的netCDF-3而不需要DAP客户端支持，例如--disable-netcdf-4和--disable-dap。安装成功后，请检查环境PATH和LD_LIBRARY_PATH确保已更新为包括netCDF C和Fortran库以及bin的路径。请注意，如果这些路径未被设置，则必须手动设置，并且每次启动新的Shell时必须加载这些路径。**最低版本要求：NetCDF-C 4.2 | NetCDF-Fortran 4.4.2**

### 3.3.3 I/O API库

I/O API库在netCDF库和CMAQ以及WRF-CMAQ之间提供接口，以处理整个CMAQ代码中的输入和输出（I/O）调用。CMAQv5.3.2支持的I/O API库版本（版本3.2，标记为20200828）可从 https://github.com/cjcoats/ioapi-3.2/releases/tag/20200828 下载。 用户应注意，I/O API库要求netCDF文件严格遵守I/O API文档中的格式指南。为简单起见，从现在起，遵循IOAPI-netCDF格式指南的文件将称为"IOAPI文件"。 **支持的版本：IOAPI 3.2 tagged 20200828**

下面是在Linux系统（带有C-shell和GNU编译器）上安装I/O API库的一般步骤。这些说明只是示例，建议您在安装CMAQ时使用可用的最新版本。

以下是安装“基本” I/O API库的过程（此过程基于gfortran编译器，对于其他编译器，请寻找对应的Linux2_x86_64*）：

```
mkdir ioapi_3.2
cd ioapi_3.2

## 下载IOAPI库，解压缩源代码
wget http://github.com/cjcoats/ioapi-3.2/archive/20200828.tar.gz
tar -xzvf 20200828.tar.gz
cd ioapi-3.2-20200828

### 设置Linux系统环境
setenv BIN Linux2_x86_64gfort
setenv BASEDIR $cwd
setenv CPLMODE nocpl
```

通过以下步骤编辑顶级Makefile：

1. 用NCFLIBS = 注释掉该行
2. 在-lnetcdf -lnetcdff前面分别添加完整的netCDF C和Fortran库路径，下面是一个示例：

```
NCFLIBS = -L/usr/local/apps/netcdf-c-4.7.0/gcc-9.1.0/lib -lnetcdf -L/usr/local/apps/netcdf-fortran-4.4.5/gcc-9.1.0/lib -lnetcdff
```

编辑ioapi文件夹中的Makeinclude.Linux2_x86_64gfort文件，注释掉所有openMP选项，因为CMAQ不支持openMP。注意：如果用户使用的是ifort编译器，则还需要删除ioapi/Makeinclude.Linux2_x86_64ifort文件中的-Bstatic标志。

```
OMPFLAGS = # -fopenmp 
OMPLIBS = # -fopenmp
```

在顶级IOAPI_3.2目录中运行：

```
make configure
make
```

其他I/O API库配置选项可用，用户可以在I/O API文档中看到这些选项的列表。例如，可以配置I/O API，打开“mpi” I/O API库，可以使CMAQ模型采用并行I/O（PIO）功能（Wong等人，2015）。有关如何在CMAQ中启用PIO的更多信息，请参见[附录D.3]( Appendix/CMAQ_UG_appendixD_parallel_implementation.md#d3-parallel-io )。

还有一个I/O API v3.2-large，该版本设计用来专为处理具有大量模型输出文件的应用程序（例如，处理所有CMAQv5.3可选诊断输出文件）和/或大量模型变量（例如CMAQ-HDDM或CMAQ-ISAM应用程序）。I/O API v3.2-large将MXFILE3变量从64增加到512，并将MXVARS3变量从2048增加到16384，这两个变量都可在PARAMS3.EXT文件中找到，如[I/O API文档]( https://www.cmascenter.org/ioapi/documentation/all_versions/html/AVAIL.html#build )所示。用户可以使用[以下方法]( https://www.cmascenter.org/ioapi/documentation/all_versions/html/AVAIL.html#build )编译large版本：

```
cp -r ioapi-3.2-20200828 ioapi-3.2-20200828_large
cd ioapi-3.2-20200828_large/ioapi/fixed_src
cp ../PARMS3-LARGE.EXT ./PARMS3.EXT
```

该版本还可以从以下地址以zip文件形式下载：

https://www.cmascenter.org/ioapi/download/ioapi-3.2-large-20200828.tar.gz

I/O API v3.2-large的安装说明在.tar.gz文件的README.txt中提供。

**注意：使用I/O API v3.2-large的用户在编译和运行时将需要更多的计算资源，以解决内存占用量增加的问题。此外，如果文件是使用此版本的I/O API生成的，则用户在使用其他不同版本的I/O API时可能会遇到向前和向后兼容性的问题。**


## 3.4 可选软件

<a id=Table3-3></a>

**表3-3. CMAQ的可选支持软件**

|**软件名称**|**说明**|     **来源**    |
|------------|-------------------------------|---------------------------------------------|
|***评估和可视化工具***| | |
|VERDI|用于NetCDF网格化数据图形分析的丰富数据解释的可视化环境|[<http://www.verdi-tool.org>](http://www.verdi-tool.org/)|
|PAVE|用于对NetCDF网格数据进行图形分析的环境数据分析和可视化软件包|[<http://www.cmascenter.org>](http://www.cmascenter.org/)|
|IDV|集成数据查看器，可对NetCDF网格数据进行3-D图形分析|[<http://www.unidata.ucar.edu/software/idv/>](http://www.unidata.ucar.edu/software/idv/)|
|I/O API Tools|用于处理I/O API/netCDF格式数据的后处理工具|[<https://www.cmascenter.org/ioapi/>](https://www.cmascenter.org/ioapi/)|
|netCDF Tools|用于处理netCDF格式数据的后处理工具|[<http://my.unidata.ucar.edu/content/software/netcdf/index.html>](http://my.unidata.ucar.edu/content/software/netcdf/index.html)|
| ***源代码诊断*** |
|GDB|Gnu Fortran debugger|[<https://www.sourceware.org/gdb/>](https://www.sourceware.org/gdb/)|
|PGDBG|Portland Group Fortran debugger|[<http://www.pgroup.com/>](http://www.pgroup.com/)|
|PGPROF|Portland Group Fortran code profiler|[<http://www.pgroup.com/>](http://www.pgroup.com/)|
|IDB|Intel Fortran debugger|[<https://software.intel.com/en-us/articles/idb-linux>](https://software.intel.com/en-us/articles/idb-linux)|

## 3.5 参考文献:

Wong, D. C., Yang, C. E., Fu, J. S., Wong, K., and Gao, Y., “An approach to enhance pnetCDF performance in environmental modeling applications”, Geosci. Model Dev., 8, 1033-1046, 2015.

<!-- BEGIN COMMENT -->

 [<< 前一章](CMAQ_UG_ch02_program_structure.md)- [返回](README.md) - [下一章 >>](CMAQ_UG_ch04_model_inputs.md)<br>
CMAQ用户指南 (c) 2020<br>

<!-- END COMMENT -->
