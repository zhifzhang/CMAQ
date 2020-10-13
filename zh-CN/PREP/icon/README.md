ICON
========

ICON程序为CMAQ化学传输模型（CCTM）准备化学初始条件（initial conditions，ICs）。ICON的输出文件中包含建模区域中所有网格的化学初始浓度。根据用户指定的选项和/或输入数据，由ICON生成的初始条件可以是与时间相关的，也可以是与时间无关的，在整个建模区域的空间上可以是统一的，也可以是可变的。如果从ASCII垂直廓线文件中生产初始浓度，则ICON会创建空间上统一的且与时间无关的初始条件。而从现有浓度（CONC）文件中，ICON可以在相同的网格单元分辨率（窗口化建模区域）上，或在更精细的网格分辨率建模区域（嵌套建模区域）中提取空间变化的初始条件。如果输入的CONC文件是有随时间变化的，则从CONC文件生成的初始条件也将与时间有关；如果CONC文件没有时间步长，则生成的初始条件也将与时间无关。

ICON有两种不同的操作模式。运行ICON时，用户必须指定从以下哪种选项生成初始条件：（1）现有的CONC文件(*regrid*)；或（2）ASCII垂直廓线文件(*profile*)。

CMAQ还可以使用全球化学模型（global chemistry models，GCMs）生成的初始条件。尽管ICON不支持直接处理GCMs源格式的数据，但用户可以开发自己的自定义代码，将GCMs数据转换为I/O API格式，然后再将这些数据输入ICON中以生成CCTM的初始条件。

## 使用的环境变量：

**表1. 运行时环境变量**

|**变量名称**|**运行脚本（Runscript）中的例子**|**描述**|
|---------------------|-------------|-----------------------------------------------------------------------|
|VRSN|v53|ICON的版本号，在构建脚本（buildscript）和运行脚本（Runscript）之间的值应保持一致|
|APPL|SE53BENCH|标识ICON运行的目的，例如模型区域和使用的化学机理，可由用户自定义|
|ICTYPE|regrid, profile|指定初始条件文件类型|
|EXEC|ICON_${VRSN}.exe|ICON可执行程序|
|GRIDDESC|$CMAQ_HOME/scripts/GRIDDESC1|网格描述文件，用于为目标区域设置水平网格定义|
|GRID_NAME|SE53BENCH|GRIDDESC文件中包含的网格定义名称，用于指定目标区域的水平网格|
|OUTDIR|$CMAQ_HOME/data/icon|输出数据目录|
|SDATE|0|从CCTM的CONC文件中提取初始条件的儒略日开始日期，如果未设置SDATE，它将从MET_CRO_3D_FIN文件自动设置|
|STIME|0|从CCTM的CONC文件中提取初始条件的开始时间，如果未设置STIME，它将从MET_CRO_3D_FIN文件自动设置|
|IOAPI_ISPH|20|椭球体（spheroid）类型的I/O API设置（地理投影信息），请查阅I/O API文档以获取[椭球体（spheroid）]( https://www.cmascenter.org/ioapi/documentation/all_versions/html/SETSPHERE.html )的更多信息|
|IOAPI_OFFSET_64|YES|大文件的I/O API设置，如果您的每个时间步长的输出文件>2GB，则这里必须设置为YES|

## ICON输入文件

**表2. "regrid"类型的ICON输入文件**

|**文件名**|**格式**|**描述**|
|---------------------|-------------|-----------------------------------------------------------------------|
|GRIDDESC|ASCII|水平网格描述文件，用于为目标区域定义模型网格，该文件由MCIP输出或由用户自行创建|
|CTM_CONC_1|IOAPI/GRDDED3|输入的CMAQ浓度文件的名称和位置|
|MET_CRO_3D_CRS|IOAPI/GRDDED3|如果在嵌套网格模拟之间网格结构发生变化，则要输入创建垂直网格结构所需的粗网格MET_CRO_3D文件的名称和位置，由MCIP输出|
|MET_CRO_3D_FIN|IOAPI/GRDDED3|如果在嵌套网格模拟之间网格结构发生变化，则要输入创建垂直网格结构所需的细网格MET_CRO_3D文件的名称和位置，由MCIP输出|

**表3. "profile"类型的ICON输入文件**

|**文件名**|**格式**|**描述**|
|-------------|----------|---------------|
|GRIDDESC|ASCII|水平网格描述文件，用于为目标区域定义模型网格，该文件由MCIP输出或由用户自行创建|
|IC_PROFILE|ASCII|输入的垂直扩线文件，由用户创建|
|MET_CRO_3D_FIN|IOAPI/BNDARY3|细网格（或目标建模区域）MET_CRO_3D文件的名称和位置|

## ICON输出文件

**表4. ICON输出文件**

|**文件名**|**格式**|**描述**|
|------------|-----------|---------------------------------------------------------------|
|INIT_CONC_1|IOAPI/GRDDED3|在模型网格定义的VRSN、BCTYPE、APPL和DATE上输出的网格化初始条件数据的名称和位置|

ICON输出文件的默认位置是`$CMAQ_DATA/icon`目录，由运行脚本中的`OUTDIR`变量控制。所有ICON输出文件均默认在文件名中使用`APPL`和`GRID_NAME`环境变量。对于从现有`CCTM CONC`文件创建的初始条件，文件名中还使用了`DATE`环境变量的儒略历日期。所有`ICON`输出文件命名变量都在运行脚本中设置。

## 编译ICON源代码

执行构建脚本来编译ICON:

```
cd $CMAQ_HOME/PREP/icon/scripts
./bldit_icon.csh [compiler] [version] |& tee build_icon.log
```

## 运行ICON

根据上述变量配置运行脚本，然后运行ICON以生成CCTM的初始条件：

```
cd $CMAQ_HOME/PREP/icon/scripts
./run_icon.csh |& tee run_icon.log
```

检查日志文件以程序运行完整、正确、没有错误。
