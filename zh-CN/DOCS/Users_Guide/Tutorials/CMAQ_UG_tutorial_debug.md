# CMAQ调试技巧（Debugging Tips）

目的：本指南介绍如何检查日志文件以及调试在安装和运行CMAQ测试案例时遇到的问题。本指南可帮助您查找错误并在遵循[向论坛发布新问题的最佳做法]( https://forum.cmascenter.org/t/please-read-before-posting/1321 )的基础上向CMAS中心的用户论坛报告错误。


## 编译CMAQ
### 先决条件：使用gcc和intel编译器构建库和CMAQ
按照CMAQ安装教程进行适当的编译：
* [用GNU构建CMAQ](CMAQ_UG_tutorial_build_library_gcc.md)
* [用intel构建CMAQ](CMAQ_UG_tutorial_build_library_intel.md)

### 确认已创建可执行文件
```
cd $CMAQ_HOME/CCTM/scripts
ls */*.exe
```

### 检查CMAQ编译日志文件
```
grep -i error  bldit_cctm.log
tail bldit_cctm.log
```

### 如果您在编译CMAQ时遇到错误
* [在CMAS论坛搜索](https://forum.cmascenter.org/search?expanded=true)类似于您在bldit_cctm.log文件中看到的错误。
* [查阅CMAQ常见问题](https://www.epa.gov/cmaq/frequent-cmaq-questions)

如果找不到解决您所遇到问题的答案，请在CMAS中心用户论坛上创建一个新主题，并提交新的问题，即使您遇到的问题与另一个用户相似。


**请参阅本教程底部的说明，以在CMAS用户论坛上创建新主题。**

## 运行CMAQ
### 先决条件：运行CMAQ基准测试案例
[按照基准测试案例教程运行](CMAQ_UG_tutorial_benchmark.md) (不需要运行ICON/BCON，因为基准测试案例中提供了输入数据)。



### 检查CMAQ运行日志文件

检查运行目录中输出的日志文件，查看是否已成功完成模拟。
```
cd $CMAQ_HOME/CCTM/scripts
```

**输出的日志文件的类型取决于您提交作业的方式。** 如果您使用slurm（集群管理和作业调度系统），使用sbatch命令提交作业，则标准错误和输出将记录到slurm-\*.out文件。

使用grep命令验证用于运行cmaq的处理器数量。
```
grep -i ‘Number of Processors’ slurm-*.out
```

使用grep命令确定CMAQ是否成功完成。

```
grep -i 'PROGRAM COMPLETED SUCCESSFULLY' slurm-*.out
```

使用grep命令检查slurm日志文件中是否有任何错误。
```
grep -i 'error' slurm-*.out
```

### 如果您的运行错误中包含以下消息

```
error while loading shared libraries  …  cannot open shared object file …
```

在您的.cshrc中设置$LD_LIBRARY_PATH，以包括netCDF和netCDFF库共享对象文件的位置。注意：.cshrc文件应位于您的主目录中。

进入您的主目录：
```
cd ~
```

查看您.cshrc文件的内容：
```
more .cshrc
```

编辑您的.cshrc文件以将LD_LIBRARY_PATH设置为包括netcdf库的位置。请注意，此路径取决于您使用的编译器，如果使用的是gnu而不是intel编译器，则将intel替换为gcc。

```
setenv NCDIR ${CMAQ_HOME}/lib/x86_64/intel/netcdf
setenv NCFDIR ${CMAQ_HOME}/lib/x86_64/intel/netcdff
setenv LD_LIBRARY_PATH ${NCDIR}/lib:$NCFDIR/lib:${LD_LIBRARY_PATH}
```

### 如果程序由于其他原因未能成功完成
如果程序由于其他原因未能成功完成，则需要检查以“CTM_LOG_\*”名称开头的每个处理器的日志文件。
* 如果运行脚本被中止，则这些文件可能位于运行目录中。
* 或者它们可能已被运行脚本移动到输出目录下的LOGS文件夹中。

在以下位置查找CTM_LOG*日志文件：
```
cd $CMAQ_HOME/CCTM/scripts
```
or
```
cd $CMAQ_HOME/data/LOGS
```

使用ls命令和word count命令确定日志文件数量。
```
ls CTM_LOG* | wc
```

运行CMAQ的每个处理器在每个模拟天都应该有1条日志文件。

使用grep命令确定“PROGRAM COMPLETED SUCCESSFULLY”的消息是否在所有日志文件的底部。
```
grep -i 'PROGRAM COMPLETED SUCCESSFULLY' CTM_LOG* | wc
```

* 如果在16个处理器上并行运行程序，则在每个模拟日，您应该看到包含此​​消息的16个文件的字数统计。
* 如果发现成功运行命令消息的数量少于用于运行CMAQ的处理器数量，则使用grep命令在任何日志文件中查找错误：

```
grep -i error CTM_LOG*
```

## 如果您在运行CMAQ时遇到错误
* [在CMAS论坛搜索](https://forum.cmascenter.org/search?expanded=true)类似于您在CTM_LOG文件中看到的错误。
* [查阅CMAQ常见问题](https://www.epa.gov/cmaq/frequent-cmaq-questions)

* 如果您在论坛问题或FAQ中未看到类似的错误报告，或没有为您提供了足够的信息来解决问题，请提交新主题。

## 如果程序崩溃
* 如果程序崩溃（而不是中止并显示错误消息），您可能会看到类似于以下内容的堆栈跟踪信息：
```
forrtl: severe (174): SIGSEGV, segmentation fault occurred
Image              PC                Routine            Line        Source
CCTM_s07tic_noche  00000000009AF90D  Unknown               Unknown  Unknown
libpthread-2.18.s  00002AF0F5B4B6D0  Unknown               Unknown  Unknown
CCTM_s07tic_noche  00000000006F3A8A  Unknown               Unknown  Unknown
CCTM_s07tic_noche  0000000000605EF2  Unknown               Unknown  Unknown
CCTM_s07tic_noche  00000000005FEC8C  Unknown               Unknown  Unknown
CCTM_s07tic_noche  00000000005FD619  Unknown               Unknown  Unknown
CCTM_s07tic_noche  0000000000406D9E  Unknown               Unknown  Unknown
libc-2.18.so       00002AF0F6464D65  __libc_start_main     Unknown  Unknown
CCTM_s07tic_noche  0000000000406CA9  Unknown               Unknown  Unknown
```
请不要将无法读取的堆栈跟踪信息发布到用户论坛！而是以调试模式重新编译模型（取消注释bldit_cctm.csh中的“set Debug_CCTM”）并重新运行。模型将运行得慢得多，但是当发生崩溃时，堆栈跟踪将提供有助于调试的信息。例如：
```
forrtl: severe (174): SIGSEGV, segmentation fault occurred
Image              PC                Routine            Line        Source
CCTM_s07tic_noche  0000000001A61C1D  Unknown               Unknown  Unknown
libpthread-2.18.s  00002B8D9E0FC6D0  Unknown               Unknown  Unknown
CCTM_s07tic_noche  0000000001551229  aero_                     503  aero_driver.F
CCTM_s07tic_noche  0000000000E617C1  sciproc_                  298  sciproc.F
CCTM_s07tic_noche  0000000000E48385  cmaq_driver_              679  driver.F
CCTM_s07tic_noche  0000000000E40B84  MAIN__                     96  cmaq_main.F
CCTM_s07tic_noche  0000000000406D9E  Unknown               Unknown  Unknown
libc-2.18.so       00002B8D9EA15D65  __libc_start_main     Unknown  Unknown
CCTM_s07tic_noche  0000000000406CA9  Unknown               Unknown  Unknown
```
此堆栈跟踪表明该错误发生在文件aero_driver.F的第503行上。

## 在CMAS用户论坛上提交新的主题问题

* [访问目录](https://forum.cmascenter.org/categories)查找最符合您的问题的类型。

* 例如，如果您在运行CMAQ时遇到问题，应选择[CMAQ运行类别](https://forum.cmascenter.org/c/cmaq/run-time-errors-and-issues/14)。

* 或者选择[CMAQ总类别](https://forum.cmascenter.org/c/cmaq/7) 

* 点击右上角的+新主题
如果您从某个类别内启动新的主题请求，则该类别将被预先选择，如果类别为“未分类”，则使用下拉菜单为您的主题选择类别。

### 为您的问题选择一个类别
选择类别非常重要，因为CMAS中心和EPA工作人员仅监视与他们的专业知识相匹配的类别中提交的主题。
 
* 输入描述您的CMAQ编译器环境的主题标题，例如：

```
CMAQv5.3.2 segmentation fault using gcc and openmpi
```

### 提出新问题时应包含的内容模板
**创建新的问题时，请提供以下信息：**  这将使其他人更快，更轻松地理解您的问题并提出适当的建议。

1. 报告**用于运行CMAQ的编译器和版本**
```
mpif90 --version
```
2. 报告您使用的**CMAQ版本**。
```
ls */*.exe
```
3. 如果是基准测试案例错误，请报告运行脚本的名称，或者**报告模拟区域和分辨率**。

4. 在问题的正文中报告有限数量的**错误消息内容**，可以使用以下命令查找输出文件中的错误消息内容：
```
cd $CMAQ_HOME/data/{YOUR_OUTPUT_DIR}/LOGS/
```
* 采用grep -B NUM命令，在找到的错误语句之前打印NUM行。
```
grep -B
```

#### 新问题中的信息示例：

| | |
|:--------:|:----------------:|
| Compiler Version | GNU Fortran (GCC) 9.1.0 |
|CMAQ Version | BLD_CCTM_v532_intel/CCTM_v532.exe |
| Run Script | run_cctm_Bench_2016_12SE1.csh|

遇到错误消息：
```
error while loading shared libraries  …  cannot open shared object file …
```

### 通过单击创建新主题标题下方菜单中的向上箭头图标来上传其他文件，包括：
* 您的运行脚本
* 标准输出日志文件
* 包含错误消息的每个处理器的日志文件
* 注意，您需要将文件重命名以匹配以下扩展名之一：jpg，jpeg，png，gif，csh，txt，csv，例如，将cmaq.log复制为cmaq.log.txt：

```
cp CTM_LOG_000.v532_intel_Bench_2016_12SE1_20160701 CTM_LOG_000.v532_intel_Bench_2016_12SE1_20160701.txt
```

* 当有人回复您的主题时，您将收到一封电子邮件通知。
* 请单击电子邮件中的“访问主题”按钮以返回到CMAS中心论坛问题，并回答任何后续问题或建议。
