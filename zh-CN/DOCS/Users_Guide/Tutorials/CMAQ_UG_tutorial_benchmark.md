# CMAQ安装和基准测试教程

目的：本指南描述了如何安装和运行CMAQ测试案例。通过本指南，首先可以使用户熟悉CMAQ程序套件以及它们如何协同工作。其次通过基准测试，可以验证您系统上的各项软件是否正确安装。

基准测试用于模拟验证您系统上的各项软件是否正确安装。在以下情况下，建议对CMAQ进行基准测试：
- 由新用户安装
- 在新服务器上安装
- 内核升级后
- Fortran/C编译器升级后
- netCDF或I/O API库升级后

## 系统检查

编译和运行CMAQ需要以下支持软件：

1. Fortran和C编译器，例如[Intel]( https://software.intel.com/en-us/fortran-compilers ), [Portland Group]( http://www.pgroup.com ), [Gnu]( https://gcc.gnu.org/wiki/GFortran )
2. [Git]( https://git-scm.com/book/en/v2/Getting-Started-Installing-Git )
3. 消息传递接口（MPI，Message Passing Interface），例如[OpenMPI]( https://www.open-mpi.org ) 或者 [MVAPICH2]( http://www.mcs.anl.gov/research/projects/mpich2 ).
4. [netCDF-C]( https://www.unidata.ucar.edu/software/netcdf/docs/getting_and_building_netcdf.html ) 和[netCDF-Fortran]( https://www.unidata.ucar.edu/software/netcdf/docs/building_netcdf_fortran.html ) 的最新版本。**构建时不支持netCDF4、HDF5、HDF4、DAP客户端、PnetCDF或zlib**
5. [I/O API](https://www.cmascenter.org/download/software/ioapi/ioapi_3-2.cfm?DB=TRUE) v3.2 **tagged 20200828**

注意：如果您尚未安装上述库，请参见本目录下的编译教程。

采用Linux系统运行CMAQ东南部区域基准测试案例的推荐硬件要求是：

1. 16核处理器的Linux系统环境
2. 16GB 内存
3. 400GB 硬盘

## 安装CMAQ以及必需的运行库

在要安装CMAQ的目录中，按照以下命令来克隆CMAQv5.3.2的EPA GitHub存储库到名为”CMAQ_REPO“的文件夹下：

```
git clone -b master https://github.com/USEPA/CMAQ.git CMAQ_REPO
```

有关从Zip文件安装CMAQ的说明，请参阅[第5章](../CMAQ_UG_ch05_running_a_simulation.md)。

## 在CMAQ存储库中设置新的分支（Check Out a new Branch）

即使您本身不进行代码开发，也仍然建议您设置出一个新的分支。您将来可能会希望更新CMAQ代码，而执行此操作的一种简单方法是通过git来更新repo中的master分支。因此，设置出一个新的分支，有助于master分支不受干扰。采用以下命令设置新的分支：
```
cd CMAQ_REPO
git checkout -b my_branch
```

## 配置CMAQ构建（build）环境

用户有两种方法来构建系统环境。一种方法可以直接在存储库（repository）中构建和运行CMAQ组件（使用.gitignore将忽略目标文件和可执行文件），另一种方法可以从存储库（repository）中提取构建和运行脚本到单独的位置。如果要直接在存储库（repository）中构建，请跳至下面的“链接CMAQ库”。

### 在存储库之外的用户指定目录中构建并运行
在CMAQ_REPO文件夹的最上层，bldit_project.csh脚本将自动复制CMAQ文件夹结构，并将每个构建和运行脚本复制到存储库之外，以便您可以自由修改它们而无需版本控制（由于这个目录是Git Clone的repository库，所在在这个文件夹下操作的文件会被纳入Git的版本控制）。

在bldit_project.csh中，修改变量$CMAQ_HOME 以设置要安装CMAQ软件包的文件夹。例如：
```
set CMAQ_HOME = /home/username/CMAQ_v5.3.2
```
现在执行脚本。
```
./bldit_project.csh
```

## 链接CMAQ库
CMAQ构建脚本需要以下库和INCLUDE文件在CMAQ_LIB目录中可用（注意：CMAQ_LIB由config_cmaq.csh脚本自动设置，其中`CMAQ_LIB = $CMAQ_HOME/lib`）：

- netCDF C库文件位于`$CMAQ_LIB/netcdf/lib`目录中
- netCDF Fortran库文件位于`$CMAQ_LIB/netcdff/lib`目录中
- I/O API库，包含文件和模块文件，位于`$CMAQ_LIB/ioapi` 目录中
- MPI库和INCLUDE文件位于`$CMAQ_LIB/mpi`目录中

config_cmaq.csh脚本将自动将所需的库链接到CMAQ_LIB目录。使用以下config_cmaq.csh环境变量，在您的Linux系统上设置netCDF、I/O API和MPI的安装位置：

- `setenv IOAPI_INCL_DIR`：I/O API包含的头文件（include header files）在系统中的位置。
- `setenv IOAPI_LIB_DIR`：已编译的I/API库在系统中的位置。
- `setenv NETCDF_LIB_DIR`：netCDF C库在系统中的安装位置。
- `setenv NETCDF_INCL_DIR`：netCDF C包含文件（include files）在系统中的位置。
- `setenv NETCDFF_LIB_DIR`：netCDF Fortran库在系统中的安装位置。
- `setenv NETCDFF_INCL_DIR`：netCDF Fortran包含文件（include files）在系统中的位置。
- `setenv MPI_LIB_DIR`：MPI（OpenMPI或MVAPICH）在系统中的位置。

例如，如果您的netCDF C库安装在 /usr/local/netcdf/lib 中，请将`NETCDF_LIB_DIR`设置为 /usr/local/netcdf/lib 。同样，如果您的I/O API库安装 /home/cmaq/ioapi/Linux2_x86_64gfort 中，请将 `IOAPI_LIB_DIR` 设置为 /home/cmaq/ioapi/Linux2_x86_64gfort 。

*1.* 使用脚本变量`ioapi_lib` 和`netcdf_lib` 来检查I/O API和netCDF库的名称。

*2.* 使用`mpi_lib`脚本变量来检查MPI库的名称。对于MVAPICH，使用`-lmpich`；对于openMPI，请使用`-lmpi`。

当您进行任何构建或运行脚本时，系统将自动创建指向这些库的链接。要手动创建这些库（可选项），请执行config_cmaq.csh脚本，并在命令行中标识编译器。[intel | gcc | pgi]：
```
source config_cmaq.csh [compiler] 
```
如果您需要，也可以在构建目录和可执行文件名称中标识编译器的版本（可选项），例如：
```
source config_cmaq.csh gcc 9.1
```

## 安装CMAQ输入参考/基准测试数据

从[CMAS中心数据仓库SE532BENCH]( https://drive.google.com/drive/folders/1jAKw1EeEzxLSsmalMplNwYtUv08pwUYk?usp=sharing )Google Drive文件夹中下载CMAQ的两天参考数据，并拷贝到`$CMAQ_DATA`文件夹。进入`$CMAQ_DATA`目录，解压缩两天基准测试的输入和输出文件：

```
cd $CMAQ_DATA
tar xvzf CMAQv5.3.2_Benchmark_2Day_Input.tar.gz
tar xvzf CMAQv5.3.2_Benchmark_2Day_Output_Optimized.tar.gz
tar xzvf CMAQv5.3.2_Benchmark_2Day_Output_Debug.tar.gz
```

CMAQ的基准测试案例是2016年7月1-2日为期两天的模拟，模拟范围为美国东南部，网格大小为100列×80行×35层，网格分辨率为12km。
- 也可以从美国EPA匿名ftp服务器获得基准数据： ftp://newftp.epa.gov/exposure/CMAQ/V5_3_2/Benchmark/WRFv4.1.1-CMAQv5.3.2/
- CMAQ基准测试案例的元数据发布在CMAS Center Dataverse网站上： https://doi.org/10.15139/S3/IQVABD 

#### 关于v5.3+和v5.3基准测试数据差异的说明
从CMAQv5.3.2开始，基准数据包含美国GRIDMASK_STATES_12SE1.nc的网格掩码文件和新的输入tar文件，但是输入tar文件的唯一区别是网格掩码文件。
为CMAQ-ISAM基准测试案例提供了CMAQv5.3.2输出tar文件，除了新的_SA_输出文件外，它还包括标准的CMAQv5.3.2输出文件。
对于CMAQv5.3.1，2016年7月美国东南部测试案例的基准数据同时提供了输入和输出文件。
CMAQv5.3.1输入数据集与v5.3发布的数据集相同，但.tar.gz文件中现在包含其他文件，这些文件使用户可以在美国东南部区域基准测试WRFv4.1.1-CMAQv5.3+耦合模型。因此，除非计划运行耦合模型，否则已经下载v5.3版本基准测试输入文件的用户无需再下载v5.3+版本的文件。v5.3.2的美国东南部基准测试输出数据随v5.3.1和v5.3发布的数据略有不同，详见详细说明见[CMAQv5.3.2发行说明常见问题](../../Release_Notes/CMAQ_FAQ.md)。


## 编译CMAQ

* 操作之前请注意，在专门处理基准测试数据时，构建ICON和BCON可执行文件是可选步骤。这是因为在基准测试数据中已为您提供了初始条件和边界条件文件。有关这些预处理器的更多信息，请参考[第4章]( ../CMAQ_UG_ch04_model_inputs.md )。

使用以下步骤为CCTM创建模型可执行文件：

##### 多处理器运行的配置（默认）：

```
set ParOpt #>  Option for MPI Runs
````

##### 单处理器运行的配置（可选）：

对于单处理器计算，请编辑CCTM构建脚本（bldit_cctm.csh），以通过注释掉Set ParOpt来实现单处理器运行，如下所示。

```
#set ParOpt #> Option for Single Processor Runs
````

#### 配置CMAQ基准测试科学模块：

基准测试案例的构建目录参数包括以下内容：

- 多处理器运行模拟
- 3-D对流方案：wrf_cons
- 水平扩散：多尺度
- 垂直扩散：ACM2_M3Dry
- 沉降：M3Dry
- 化学求解器：EBI
- 气溶胶模块：AERO7
- 云模块：ACM_AE7
- 机制（Mechanism）：cb6r3_ae7_aq
- 在线生物成因排放
- 直列烟羽抬升

要配置这些参数，需要在bldit_cctm.csh中设置CCTM科学模块。脚本中的注释有助于引导用户了解每个变量的选项以及如何设置它们。有关变量名称的更多信息，请参见
[附录A]( ../Appendix/CMAQ_UG_appendixA_model_options.md )。

在对CCTM构建脚本进行必要的更改之后，使用以下命令创建CCTM可执行文件：

```
cd $CMAQ_HOME/CCTM/scripts
./bldit_cctm.csh [compiler] [version] |& tee bldit.cctm.log
```

## 配置CCTM脚本

对于具有16个处理器的MPI配置，

```
cd $CMAQ_HOME/CCTM/scripts
```

根据您将要使用的MPI配置和编译器，编辑CCTM运行脚本（run_cctm_Bench_2016_12SE1.csh）：

```
setenv compiler gcc
setenv compilerVrsn 9.1
setenv INPDIR  ${CMAQ_DATA}/CMAQv5.3.2_Benchmark_2Day_Input
@ NPCOL 4 ; @ NPROW = 4
```

大多数群集多处理器系统都需要一个命令来启动MPI运行环境。CCTM运行脚本默认使用* mpirun *命令。请咨询您的系统管理员，以了解在运行多处理器应用程序时如何调用MPI。

对于单处理器计算，将PROC设置为串行（serial）：

```
set PROC     = serial
```

对于基准测试案例，在运行脚本中将CCTM科学配置选项（Science Configuration Options）设置为** Y **，包括：

-  ```CTM_OCEAN_CHEM``` - 使用海洋卤族元素化学物质和海雾气溶胶排放物
-  ```KZMIN``` - 每个网格单元中的最小涡流扩散率，取决于土地利用比例
-  ```PX_VERSION``` - WRF PX地表模型
-  ```CTM_ABFLUX``` - 用于在线沉积速率的双向氨通量
-  ```CTM_BIDI_FERT_NH3``` - 从排放中减去化肥NH3，因为它将由BiDi计算处理
-  ```CTM_SFC_HONO``` - 表面HONO交互
-  ```CTM_GRAV_SETL``` - vdiff气溶胶重力沉降
-  ```CTM_BIOGEMIS``` - 在线生物成因排放

要配置这些参数，需要在$CMAQ_HOME/CCTM/scripts/run_cctm_Bench_2016_12SE1.csh中设置“科学选项（Science Options）”。脚本中的注释应有助于引导用户了解每个变量的选项以及如何设置它们。有关变量名称的更多信息，请参见
[附录A]( ../Appendix/CMAQ_UG_appendixA_model_options.md )。

在为您的Linux系统配置MPI设置之后，请检查脚本的其余部分，以确保将正确的路径、日期和名称用于输入数据文件。根据以上说明，不同的Linux系统对提交MPI作业有不同的要求。以下命令是如何提交CCTM运行脚本的示例，注意该命令可能会因Linux系统的MPI要求而异。

```
./run_cctm_Bench_2016_12SE1.csh |& tee cctm.log
```

## 确认基准测试案例已完成模拟

要确认基准测试案例已运行完成，请查看run.benchmark.log文件。对于MPI运行，请检查每个CTM_LOG_[ProcessorID]*.log文件。如果成功运行，日志文件底部将会包含以下内容：

``>>---->  Program completed successfully  <----<<``

注意：如果在多处理器系统中运行，每个处理器的日志文件也将从$CMAQ_HOME/CCTM/scripts目录移动到基准测试输出目录：

```
$CMAQ_DATA/output_CCTM_v532_[compiler]_Bench_2016_12SE1
```
而且，这些日志文件的名称设置为：

```
CTM_LOG_[ProcessorID].v532_[compiler]_[APPL]_[YYYYMMDD]
CTM_LOG_[ProcessorID].v532_gcc_Bench_2016_12SE1_20160701
```

基准测试案例的输出结果将放置在以下目录中：

```
$CMAQ_DATA/output_CCTM_v532_[compiler]_Bench_2016_12SE1
```

输出结果中最多可以包含23个netCDF-type的文件：ACONC, AOD_DIAG, APMDIAG, APMVIS, B3GTS_S, CGRID, CONC, DEPV, DRYDEP, DUSTEMIS, LTNGCOL, LTNGHRLY, MEDIA_CONC, PHOTDIAG1, PHOTDIAG2, PMDIAG, PMVIS, SOILOUT, SSEMIS, VDIFF, VSED, WETDEP1,以及 WETDEP2。


CCTM模拟中的常见错误包括以下内容：
- 输入文件的路径不正确。请在CCTM屏幕输出（在日志文件中截取）中查找有关输入文件无法找到（input file not being found）的错误消息。
- 错误的MPI操作。在日志文件末尾的一系列MPI错误通常表明MPI操作未能正确提交。

检查CCTM输出日志的最后几行信息，以帮助分析为什么模拟未能完成。

## 检查CMAQ基准测试结果

要确定CMAQ是否正确的安装在您的Linux系统上，请将您基准测试的输出结果与从CMAS中心下载的参考输出数据进行比较。该参考数据是在以下Linux系统上生成的：
- Linux Kernel 3.10.0-514.el7.x86_64
- Red Hat Enterprise Linux Server 7.3 (Maipo) (use command: cat /etc/os-release)
- GNU GCC compiler version 9.1.0, 16 processors with OpenMPIv4.0.1 and I/O APIv3.2 tagged version 20200828
- 关闭调试模式（Debug mode）（在$CMAQ_HOME/CCTM/scripts/bldit_cctm.csh中注释掉```set Debug_CCTM```）
- 打开调试模式（Debug mode）（在$CMAQ_HOME/CCTM/scripts/bldit_cctm.csh中取消注释```set Debug_CCTM```）
- CMAQv5.3.2

针对关闭调试模式（优化）和打开调试模式（调试），提供了为期两天的基准测试案例的CMAQv.5.3.2输出，以使用户可以将他们的结果与任一版本进行比较。为了减少编译器标志对模型输出的影响，最好使用调试版本。为了比较由于编译器优化而在获得更快的运行时间的同时获得的模型结果，还提供了优化版本输出。

CMAQv5.3.2参考输出数据包括一组CCTM_ACONC_\*.nc文件，每个模型小时的第1层平均模型物质浓度为226个变量，以及一组CCTM_WETDEP1_\*.nc文件，其累积每小时的湿沉积通量为其他 136个变量。当您运行CMAQ-ISAM基准测试时，会生成CCTM_SA_ACONC_\*.nc，CCTM_SA_CGRID_\*.nc，CCTM_SA_CONC_\*.nc，CCTM_SA_WETDEP_\*.nc以及CCTM_SA_DRYDEP_\*.nc文件。有关更多信息，请参见[CMAQ-ISAM教程]( ../Tutorials/CMAQ_UG_tutorial_ISAM.md )。

使用netCDF评估工具来评估基准测试结果。例如，[VERDI]( https://www.verdi-tool.org/ ) 是一种可视化工具，可以将CCTM结果作为填充图（tile plot）查看；也可以使用I/O API工具或 R 对结果进行统计比较。

请注意，即使成功安装和运行了基准测试案例，由于多处理器模拟过程的区域分解差异以及编译器差异，您的模拟结果和参考数据之间仍可能会出现一些差异。这些差异倾向于在模型的上层（upper layers）表现出来，主要用于预测气溶胶水（AH2O）和气溶胶酸度（AH3OP），而其他关键物种（如ASO4，ANO3，ACL，ALOO1等）的差异则较小。这些物质在大气中寿命短、时间和空间导数变化大、或者有对浓度微小变化敏感的物理模型。这些物质的预测对机器精度和准确性的微小变化更敏感。

