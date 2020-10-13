# 气象化学接口处理器(Meteorology-Chemistry Interface Processor，MCIP)

MCIP可以提取[WRF模型]( http://www.wrf-model.org )的输出文件，以生成CMAQ系统使用的气象文件。在可能的情况下，MCIP会直接使用WRF气象模型中的数据来最大化WRF与CMAQ模型系统的一致性。而当WRF未输出CMAQ模拟区域需要的气象场时，MCIP将使用科学算法为CMAQ创建这些气象场。MCIP输出文件可用于排放模型（例如为移动源排放提供随时间变化的温度条件），也可用于CCTM来定义气象条件。关于MCIP的科学概述，请参见[Otte and Pleim (2010)]( https://www.geosci-model-dev.net/3/243/2010/ )。

MCIP使用WRF的输出（历史）文件执行以下功能：

-   定义CCTM的计算区域。CCTM的计算区域通常比气象模型区域要小，并且CCTM通常不使用气象模型的横向边界单元。

-   为CCTM在指定的计算区域上提取气象模型的输出数据。

-   处理排放模型和CCTM所需的所有气象参数。诸如大气温度、压力、湿度和风之类的气象参数是直接从气象模型中获取的（即“通过”）。

-   使用可用的气象参数来计算CCTM所需但不属于气象模型输出数据的其他字段，例如用于坐标转换的雅可比行列式（Jacobian）。

-   输出包含排放模型和CCTM使用的气象和地理空间信息的文件。输出文件可以是I/O API或netCDF格式。

MCIP用FORTRAN语言编写，并且在Unix/Linux环境中的单个处理器上运行。MCIP由C-shell脚本运行，该脚本具有几个通过FORTRAN名称列表定义的运行选项。通常情况下，使用MCIP在每天的时间段内处理气象模型的每小时输出字段。

MCIP通常与CCTM同时更新。MCIP的更改记录可见软件的每次更新文件，并且存在特定于MCIP的“常见问题”（FAQ）文件。

从MCIPv5.0开始，WRF是唯一可以使用MCIP处理的气象模型，但是MCIP可以扩展为处理其他气象模型的数据。

MCIP可用于确定CMAQ处理的空间区域。MCIP可以处理完整的气象建模区域，从该区域统一调整网格，或“窗口化”该区域的直线子集。MCIP的配置选项包括从气象模型输出文件中提取数据的时间段、水平和垂直网格定义以及将卫星云观测结果集成到MCIP输出中的选择。

## 文件，配置和环境变量

所有MCIP配置都是在运行时（而不是在编译时）通过Fortran名称列表变量而不是环境变量建立的，这与其他CMAQ程序有所不同。用户不需要直接编辑MCIP名称列表文件。所有配置设置都包含在MCIP运行脚本（run_mcip.csh）中，该脚本每次执行时都会自动创建一个新的名称列表文件。表1列出了MCIP输入文件，表2列出了MCIP输出文件。

## 编译配置

MCIP的所有模型配置选项都是在运行期间而不是在编译时设置。必须在Linux Makefile中设置系统编译器选项，才能为不同的操作系统/编译器组合构建程序。默认的Makefile中提供了示例编译器路径、标志和库文件位置。

## 运行配置变量

此处列出的变量由用户在MCIP脚本（run_mcip.csh）中设置，并在程序执行期间使用。

-   `APPL [default: None]`  
    应用名称，文件命名的方案ID，用户自定义
-   `CoordName [default: None]`  
    写入GRIDDESC文件的MCIP输出网格的坐标系名称。有关GRIDDESC文件中参数的其他信息，请参见[I/O API文档]( https://www.cmascenter.org/ioapi/documentation/all_versions/html/GRIDDESC.html )
-   `GridName [default: None]`  
    写入GRIDDESC文件的MCIP输出网格的模型网格名称
-   `DataPath [default: $CMAQ_DATA]`  
    输入/输出数据目录路径
-   `InMetDir [default: None]`  
	输入数据（WRF‑ARW的输出文件）的目录
-   `InGeoDir [default: None]`  
	输入数据（WRF Geogrid文件）的目录
-   `OutDir [default: $CMAQ_HOME/data/mcip]`  
    MCIP输出数据的目录
-   `ProgDir [default: $CMAQ_HOME/PREP/mcip/src]`  
    包含MCIP可执行文件的工作目录
-   `WorkDir [default: $OutDir]`  
    Fortran链接和名称列表文件的临时工作目录
-   `InMetFiles [default: None]`  
    输入的气象文件列表，包括每个文件的目录路径；在不修改MCIP的情况下，最多允许300个气象模型输出文件作为一次MCIP执行的输入
-   `IfGeo [default: F]`  
	二进制标志，指示输入的WRF Geogrid文件的可用性；选项包括T (true)或F (false)
-   `InGeoFile [default: None]`  
	输入的WRF Geogrid文件的名称和位置
-   `LPV: [default: 0]`  
	是否计算并输出潜在涡度。必须激活它以支持[CCTM O3潜在涡度缩放]( ../../CCTM/docs/ReleaseNotes/Potential_Vorticity_Scaling.md )
    -   `0`: 不计算和输出潜在涡度
    -   `1`: 计算并输出潜在涡度
-   `LWOUT [default: 0]`  
    是否输出垂直速度
    -   `0`: 不输出垂直速度
    -   `1`: 输出垂直速度
-   `LUVBOUT [default: 0]`  
    是否在B交错网格上输出u和v分量风。
    -   `0`: 不要在B网格上输出u和v分量风
    -   `1`: 在B网格上输出u和v分量风 (除了C网格)
-   `MCIP_START [format: YYYY-MM-DD-HH:MM:SS.SSSS]`  
	MCIP输出数据的开始日期和时间（UTC）。开始日期和时间必须包含在WRF的输入数据中。
-   `MCIP_END [format: YYYY-MM-DD-HH:MM:SS.SSSS]`  
	MCIP输出数据的结束日期和时间（UTC）。结束日期和时间必须包含在WRF的输入数据中。
-   `INTVL [default: 60]`  
	输出间隔（以分钟为单位）。此设置确定每个输出时间步长中包含的模型时间量。MCIP的输出间隔可以不如输入的气象模型数据频繁（例如，从15分钟步长的WRF输出气象数据处理成用于CCTM的30分钟步长数据）。
-   `MKGRID [default: T]`  
    确定是否输出静态（GRID）气象文件
-   `IOFORM [default: 1]`  
    选择输出格式
    -   `1`: Models-3 I/O API
    -   `2`: netCDF
-   `BTRIM [default: 5]`  
	在气象输出的四个水平侧面的每一个上要删除的边界点数量，以定义MCIP输出区域。设置BTRIM=0将输入气象区域的最大范围。要删除WRF横向边界，请设置BTRIM=5（推荐）。此设置通过将输入气象区域减少2*BTRIM + 2*NTHIK + 1来影响输出的MCIP水平区域，其中NTHIK是横向边界厚度（来自BDY文件）。多余的点反映了从网格点（dot points）到网格单元（cross points）的转换。要裁剪输入气象文件的子集（“窗口”），请设置BTRIM=-1；此设置将BTRIM替换为X0、Y0、NCOLS和NROWS提供的信息（请参见下文）
-   `X0 [used only if BTRIM = -1]`  
    基于输入WRF-ARW区域的完整MCIP交叉点（cross-point）区域（包括MCIP横向边界）左下角的*x*坐标。X0指东西方向
-   `Y0 [used only if BTRIM = -1]`  
	基于输入WRF-ARW区域的完整MCIP交叉点（cross-point）区域（包括MCIP横向边界）左下角的*y*坐标。Y0指南北方向
-   `NCOLS [used only if BTRIM = -1]`  
	输出MCIP区域中的列数（不包括MCIP横向边界）
-   `NROWS [used only if BTRIM = -1]`  
	输出MCIP区域中的行数（不包括MCIP横向边界）
-   `LPRT_COL [default: 0]`  
	MCIP建模区域上诊断输出的列单元坐标
-   `LPRT_ROW [default: 0]`  
	MCIP建模区域上诊断输出的行单元坐标
-   `WRF_LC_REF_LAT [optional; used only for Lambert conformal projections; default: -999.0]`  
	WRF Lambert正兴参考纬度。使用此设置可以在输出MCIP数据中强制参考纬度。如果未设置，则MCIP将使用两个真实纬度的平均值。

## 编译和运行

**编译MCIP**

MCIP用Makefile编译。Makefile中的配置选项包括用于构建可执行文件的编译器和编译器标志。请注意，MCIP不是并行化的代码，因此不需要并行版本的netCDF和I/O API。Makefile位于带有MCIP源代码（`$CMAQ_HOME/PREP/mcip/src`）的目录中。要编译MCIP，请运行config_cmaq.csh文件并在命令行中调用Makefile：

```
cd $CMAQ_HOME/PREP/mcip/src/
source $CMAQ_HOME/config_cmaq.csh
./make |& tee make.mcip.log
```

要将MCIP移植到其他编译器，请在config_cmaq.csh脚本中更改编译器名称、位置和标志。

**运行MCIP**

根据上述配置变量设置运行脚本。然后运行MCIP以生成CCTM的气象输入数据：

```
cd $CMAQ_HOME/PREP/mcip/scripts
./run_mcip.csh |& tee run_mcip.log
```

**表1. MCIP输入文件**

|**文件名**|**格式**|**描述**|**是否必须**|
|------------|------------------------------|-----------------------------------------------------|---------------------|
|InMetFiles|netCDF (WRF)|输入到MCIP的WRF输出文件列表|必须|
|InGeoFile|netCDF (WRF)|来自WRF Geogrid处理器的输出文件|可选；仅在WRF输出文件不包含土地利用分数的情况下才需要|


**表2. MCIP输出文件**

|**文件名**|**格式**|**描述**|**是否必须**|
|--------------------|-----------------|------------------------------------------------------------------|---------------------------|
|GRIDDESC|ASCII|带有坐标和网格定义信息的网格描述文件|必须|
|GRID_BDY_2D|I/O API|与时间无关的2D边界层气象文件|必须|
|GRID_CRO_2D|I/O API|与时间无关的2D交叉点（cross-point）气象文件|必须|
|GRID_CRO_3D|I/O API|与时间无关的3D交叉点（cross-point）气象文件|必须|
|GRID_DOT_2D|I/O API|与时间无关的2D点（dot-point）气象文件|必须|
|LUFRAC_CRO|I/O API|与时间无关的按类别划分的土地利用分数|仅在WRF的输出文件或Geogrid的输出文件中提供了土地利用分数时创建|
|MET_BDY_3D|I/O API|随时间变化的3D边界层气象文件|必须|
|MET_CRO_2D|I/O API|随时间变化的2D交叉点（cross-point）气象文件|必须|
|MET_CRO_3D|I/O API|随时间变化的3D交叉点（cross-point）气象文件|必须|
|MET_DOT_3D|I/O API|随时间变化的3D点（dot-point）气象文件|必须|
|MOSAIC_CRO|I/O API|随时间变化的Mosaic土地利用3D输出文件|仅在WRF中运行了Noah Mosaic地表模型时创建|
|SOI_CRO|I/O API|每个土壤层随时间变化的土壤特性|仅在WRF中运行了地表模型时创建|
|mcip.nc|netCDF|包含与时间无关的和随时间变化的输出变量，这些变量包含2D层（仅在2D或3D中，其中第三维可以是大气层、土壤层、土地利用类别、mosaic类别等）|当IOFORM=2时必须|
|mcip_bdy.nc|netCDF|包含沿区域边界的与时间无关的和随时间变化的输出文件|当IOFORM=2时必须| 

MCIP输出文件的默认位置是`$CMAQ_HOME/data/mcip/$GridName`目录，但可以使用`$OutDir`变量在MCIP脚本中对其进行更改。MCIP输出文件的名称是通用的，没有有关它们正在模拟的模型网格或所涵盖的时间段的任何信息。这些属性可以由MCIP脚本控制。例如可以在输出目录的路径中使用网格名称。此外，所有MCIP输出文件默认都会在文件名后附加`APPL`环境变量，以按文件所代表的时间段来标识文件。MCIP输出的所有文件命名变量都在运行脚本中设置，可以轻松定制它们以适合每个用户的应用程序或样式。

**旧版本的MCIP**

MCIPv4.3和MCIPv4.2是通过CMAS Center MCIP GitHub存储库发布的。从4.5版本开始，MCIP作为CMAQ存储库的一部分发布。

* [MCIP v5.1 (2019年12月)](https://github.com/zhifzhang/CMAQ/blob/5.3.1/PREP/mcip/docs/ReleaseNotes) - 与CMAQv5.3.1一同发布
* [MCIP v5.0 (2019年8月)](https://github.com/zhifzhang/CMAQ/blob/5.3/PREP/mcip/docs/ReleaseNotes) - 与CMAQv5.3一同发布
* [MCIP v4.5 (2018年十月)](https://github.com/zhifzhang/CMAQ/blob/CMAQv5.3.b2_19Oct2018/PREP/mcip/docs/ReleaseNotes) - 与CMAQv5.3beta2一同发布
* [MCIP v4.3 (2015年十一月)](https://github.com/CMASCenter/MCIP/tree/4.3) - 在CMASCenter GitHub存储库中提供
* [MCIP v4.2 (2013年十二月)](https://github.com/CMASCenter/MCIP/tree/4.2) - 在CMASCenter GitHub存储库中提供
