BCON
========

BCON程序为CMAQ化学传输模型（CCTM）准备化学边界条件（boundary conditions，BCs）。BCON会生成一个输出文件，其中包含沿建模区域水平边界的所有网格单元的化学浓度。根据用户指定的选项和/或输入数据，由BCON生成的边界条件可以是随时间变化的，也可以是与时间无关的，可以在模型的边界空间上是均匀的，也可以随空间变化。如果用ASCII垂直扩线来生成边界条件，则BCON会创建空间均匀且与时间无关的边界条件。如果采用浓度场（CONC）作为输入文件，则BCON可以在相同的网格单元分辨率上（窗口建模区域）或在更精细的网格分辨率上（嵌套建模区域）生成随空间变化的边界条件。如果输入的浓度场（CONC）文件是随时间变化的，则从CONC文件生成的边界条件也是随时间变化的；如果CONC文件只有一个时间步长，则从CONC文件生成的边界条件也与时间无关。

BCON有两种不同的操作模式。运行BCON时，用户必须指定从以下哪种输入文件生成边界条件：（1）现有的CONC文件（*regrid*）；或（2）ASCII垂直扩线文件（*profile*）。

CMAQ还可以使用从全球化学模型（global chemistry models，GCMs）导出的边界条件。虽然BCON不支持直接处理GCMs中原始格式的数据，但用户可以开发自己的自定义代码以将GCMs数据转换为I/O API格式，然后将这些数据输入到BCON中以生成用于CCTM的边界条件。社区中也有些工具可以从GCMs生成边界条件。例如，CAMx开发人员（Ramboll Environ）具有可用于从GEOS-Chem和MOZART模型中提取边界条件的代码。请访问[www.CAMx.com的支持软件]( http://www.camx.com/download/support-software.aspx )下载这些实用程序。

## 运行环境变量：

**表1. 运行环境变量**

|**变量名称**|**运行脚本（Runscript）中的示例**|**描述**|
|---------------------|-------------|-----------------------------------------------------------------------|
|VRSN|v53|标识BCON运行版本，对于单个应用程序，BCON构建脚本（buildscript）和运行脚本（Runscript）中的值应保持一致|
|APPL|SE53BENCH|标识BCON运行的目的，例如模型区域和使用的化学机理，可由用户自定义|
|BCTYPE|regrid, profile|指定边界条件输入文件类型|
|EXEC|BCON_${VRSN}.exe|BCON可执行程序|
|GRIDDESC|$CMAQ_HOME/scripts/GRIDDESC1|网格描述文件，用于为目标区域设置水平网格定义|
|GRID_NAME|SE53BENCH|GRIDDESC文件中包含的网格定义名称，用于指定目标区域的水平网格|
|OUTDIR|$CMAQ_HOME/data/bcon|输出数据目录|
|DATE|2016183|对于regrid边界条件类型，设置用于命名BCON输出文件的儒略历日期|
|SDATE|0|从CCTM的CONC文件中提取边界条件的儒略日开始日期，如果未设置SDATE，它将从MET_BDY_3D_FIN文件自动设置|
|STIME|0|从CCTM的CONC文件中提取边界条件的开始时间，如果未设置STIME，它将从MET_BDY_3D_FIN文件自动设置|
|RUNLEN|0|从CCTM的CONC文件中提取边界条件的运行步长，如果未设置RUNLEN，它将从MET_BDY_3D_FIN文件自动设置|
|IOAPI_ISPH|20|椭球体（spheroid）类型的I/O API设置（地理投影信息），请查阅I/O API文档以获取[椭球体（spheroid）]( https://www.cmascenter.org/ioapi/documentation/all_versions/html/SETSPHERE.html )的更多信息|
|IOAPI_OFFSET_64|YES|大文件的I/O API设置，如果您的每个时间步长的输出文件>2GB，则这里必须设置为YES|

## BCON输入文件

**表2. "regrid"类型的BCON输入文件**

|**文件名**|**格式**|**描述**|
|---------------------|-------------|-----------------------------------------------------------------------|
|GRIDDESC|ASCII|水平网格描述文件，用于为目标区域定义模型网格，该文件由MCIP输出或由用户自行创建|
|CTM_CONC_1|IOAPI/GRDDED3|输入的CMAQ浓度文件的名称和位置|
|MET_CRO_3D_CRS|IOAPI/GRDDED3|粗网格（或源建模区域）MET_CRO_3D文件的名称和位置|
|MET_BDY_3D_FIN|IOAPI/BNDARY3|细网格（或目标建模区域）MET_BDY_3D文件的名称和位置|

**表3. "profile"类型的BCON输入文件**

|**文件名**|**格式**|**描述**|
|---------------------|-------------|-----------------------------------------------------------------------|
|GRIDDESC|ASCII|水平网格描述文件，用于为目标区域定义模型网格，该文件由MCIP输出或由用户自行创建|
|BC_PROFILE|ASCII|输入的垂直扩线文件，由用户创建|
|MET_BDY_3D_FIN|IOAPI/BNDARY3|细网格（或目标建模区域）MET_BDY_3D文件的名称和位置|

## BCON输出文件

**表4. BCON输出文件**

**>>注：<<** 文件名需要更改为变量名。

|**文件名**|**格式**|**描述**|
|------------|-----------|---------------------------------------------------------------|
|BNDY_CONC_1|BNDARY3|在模型网格定义的VRSN、BCTYPE、APPL和DATE上输出的网格化边界条件数据的名称和位置|

BCON输出文件的默认位置是`$CMAQ_DATA/bcon`目录，由运行脚本中的`OUTDIR`变量控制。所有BCON输出文件均默认在文件名中使用`APPL`和`GRID_NAME`环境变量。对于从现有`CCTM CONC`文件创建的边界条件，文件名中还使用了`DATE`环境变量的儒略历日期。所有`BCON`输出文件命名变量都在运行脚本中设置。

## 编译BCON源代码

执行构建脚本来编译BCON：

```
cd $CMAQ_HOME/PREP/bcon/scripts
./bldit_bcon.csh [compiler] [version] |& tee build_bcon.log
```

## 运行BCON

根据上述变量配置运行脚本，然后运行BCON以生成CCTM的边界条件：

```
cd $CMAQ_HOME/PREP/bcon/scripts
./run_bcon.csh |& tee run_bcon.log
```

检查日志文件以程序运行完整、正确、没有错误。
