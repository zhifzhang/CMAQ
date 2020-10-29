## CMAQ-ISAM基本测试案例教程 ## 

### 使用GNU编译器构建和运行CMAQ-ISAM模型的过程：###

### 步骤1：下载并运行CMAQv5.3.2基准测试案例（不带ISAM），以确认您的模型运行与提供的基准测试输出一致。
- [CMAQ基本测试案例教程](CMAQ_UG_tutorial_benchmark.md)

如果遇到任何错误，请尝试在调试模式下运行模型，并参考CMAS用户论坛以确定是否已有报告的已知问题。

https://forum.cmascenter.org/

### 步骤2：阅读《用户指南》中有关集成源分配方法（ISAM）的章节。
- [CMAQ用户指南中有关ISAM的章节](../CMAQ_UG_ch11_ISAM.md)

注意：此基准测试案例旨在演示如何使用提供的输入文件来构建和运行CMAQ-ISAM：

当您从Github获取CMAQv5.3.2代码时（以下步骤5），CCTM/scripts目录中提供了以下ISAM控制文件：

```
isam_control.txt
```

以下网格掩码文件随CMAQv5.3.2_Benchmark_2Day_Input/2016_12SE1目录中的基准输入一起提供（请参阅下面的步骤10）。

```
GRIDMASK_STATES_12SE1.nc
```

这些说明要求用户在BLD目录中编辑排放控制名称列表（namelist）文件（请参阅下面的步骤9）。

```
EmissCtrl_cb6r3_ae7_aq.nml
```


### 步骤3（可选）：选择编译器并请使用module命令加载（如果系统上可用）

```
module avail
```

```
module load openmpi_4.0.1/gcc_9.1.0 
```

### 步骤4（可选）：安装I/O API（注意，这里假定您已经安装了netCDF C和Fortran库）

I/O API v3.2最多支持MXFILE3=64个打开文件，每个文件最多MXVARS3=2048。由于ISAM应用程序用于计算大量污染源的源属性，因此可能会超过模型变量的上限，从而导致模型崩溃。为避免此问题，用户可以使用I/O API v3.2 "large"，该版本将MXFILE3增加到512，将MXVARS3增加到16384。有关构建此版本的说明，请参阅第3章。注意，CMAQ-ISAM基准测试案例<b>不需要</b>使用ioapi-large版本。同时，如果用户需要使用大的MXFILE3和MXVAR3设置来支持其应用程序，则模型的内存需求将会增加。如果需要，可以从以下地址以zip文件的形式获取此版本：

https://www.cmascenter.org/ioapi/download/ioapi-3.2-large-20200828.tar.gz

否则，请使用此处提供的普通I/O API版本：
https://www.cmascenter.org/ioapi/download/ioapi-3.2-20200828.tar.gz

### 步骤5：安装CMAQ-ISAM

```
git clone -b master https://github.com/USEPA/CMAQ.git CMAQ_REPO
```

在存储库外部的用户指定目录中构建并运行。

在CMAQ_REPO的顶级目录中，bldit_project.csh脚本将自动复制CMAQ文件夹结构，并将每个构建和运行脚本复制到资源库之外，以便您可以自由地对其进行修改而无需版本控制。

编辑bldit_project.csh，修改变量$CMAQ_HOME，以标识要在其下安装CMAQ软件包的文件夹。例如：

```
set CMAQ_HOME = /work/your_username/CMAQ_v5.3.2
```

执行脚本。

```
./bldit_project.csh
```

将目录更改为CMAQ_HOME目录

```
cd /work/your_username/CMAQ_v5.3.2
```


### 步骤6：编辑config_cmaq.csh以指定ioapi和netCDF库的路径

### 步骤7：修改bldit_cctm.csh

将目录更改为CCTM/scripts

```
cd CCTM/scripts
```

注释掉以下选项以使用ISAM编译CCTM：

```
#> Integrated Source Apportionment Method (ISAM)
set ISAM_CCTM                         #> uncomment to compile CCTM with ISAM activated
```

### 步骤8：运行bldit_cctm.csh脚本
```
./bldit_cctm.csh gcc |& tee bldit_cctm_isam.log
```

### 步骤9：编辑排放控制名称列表以识别CMAQ_REGIONS文件

将目录更改为构建目录
```
cd BLD_CCTM_v532_ISAM_gcc
```

编辑排放名称列表文件

```
gedit EmissCtrl_cb6r3_ae7_aq.nml 
```

取消注释文件标签中包含ISAM_REGIONS的行

```
&RegionsRegistry
 RGN_NML  =
 !          | Region Label   | File_Label  | Variable on File
 !<Default>    'EVERYWHERE'  ,'N/A'        ,'N/A',
 !<Example>    'WATER'       ,'CMAQ_MASKS' ,'OPEN',
 !<Example>    'ALL'         ,'CMAQ_MASKS' ,'ALL',
               'ALL'         ,'ISAM_REGIONS','ALL',
```
  
### 步骤10：下载基准测试案例输入数据

链接到[Google Drive]( https://drive.google.com/drive/u/1/folders/1jAKw1EeEzxLSsmalMplNwYtUv08pwUYk )的CMAQv5.3.2_Benchmark_2Day_Input.tar.gz输入数据

  - 您可以在Benchmark数据集中单击CMAQv5.3.2_Benchmark_2Day_Input.tar.gz.list以查看文件列表
  - 使用gdrive命令下载数据集
  - 如果这是您第一次使用gdrive，或者您的秘钥有问题，请阅读以下说明
  - [从CMAS数据仓库下载数据的说明]( https://docs.google.com/document/d/1e7B94zFkbKygVWfrhGwEZL51jF4fGXGXZbvi6KzXYQ4 )
  
  
  ```
  gdrive download 1ex6Wr4dX6a0fgaDfhO0VEJNaCKqOflI5
  ```
  
    
### 步骤11：编辑CMAQ-ISAM运行脚本

```
gedit run_cctm_Bench_2016_12SE1.csh
```

设置用于配置模拟的常规参数

```
set VRSN = v532_ISAM
```


打开ISAM并取消注释ISAM区域文件

```
setenv CTM_ISAM Y
setenv ISAM_REGIONS $INPDIR/GRIDMASK_STATES_12SE1.nc
```
   
运行或将脚本提交到批处理排队系统

```
./run_cctm_Bench_2016_12SE1.csh
```

或（如果使用SLURM）

```
sbatch run_cctm_Bench_2016_12SE1.csh
```

### 步骤12：验证运行是否成功
   - 查看输出目录
   
   ```
   cd ../../data/output_CCTM_v532_ISAM_gcc_Bench_2016_12SE1
   ```
   如果运行成功，您将看到以下输出内容
   
   ```
   tail ./LOGS/CTM_LOG_000.v532_ISAM_gcc_Bench_2016_12SE1_20160701
   ```
   |>---   PROGRAM COMPLETED SUCCESSFULLY   ---<|

### 第13步：将输出结果与Google云端硬盘上提供的2天基准测试结果进行比较

    https://drive.google.com/drive/u/1/folders/1jAKw1EeEzxLSsmalMplNwYtUv08pwUYk

    请注意，除标准CMAQ输出文件外，还会生成以下ISAM输出文件。

```
    CCTM_SA_CONC_v532_ISAM_gcc_Bench_2016_12SE1_20160701.nc
    CCTM_SA_WETDEP_v532_ISAM_gcc_Bench_2016_12SE1_20160701.nc
    CCTM_SA_DRYDEP_v532_ISAM_gcc_Bench_2016_12SE1_20160701.nc
    CCTM_SA_ACONC_v532_ISAM_gcc_Bench_2016_12SE1_20160701.nc
    CCTM_SA_CGRID_v532_ISAM_gcc_Bench_2016_12SE1_20160701.nc
```

