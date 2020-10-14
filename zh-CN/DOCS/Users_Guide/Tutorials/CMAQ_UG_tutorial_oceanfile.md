## CMAQ教程
### 创建OCEAN文件以输入到CMAQ
目的：本教程描述了如何创建海洋遮罩文件，该文件定义了CMAQ建模区域每个网格单元中被开放海洋或冲浪区域覆盖的比例。


------------

CMAQ海浪排放模块需要输入一个海洋遮罩文件（OCEAN）。OCEAN是一个与时间无关的I/O API文件，用于标识每个模型网格单元中分配给远洋（OPEN）或冲浪区（SURF）的覆盖比例[0-1]。CCTM在运行时使用此覆盖信息从模型网格单元在线计算海浪排放通量。

此外，除cb6r3m_ae7_kmtbr以外，CMAQ的气相化学机理还包含有效的一次卤族元素导致的臭氧在海洋上（当OPEN+SURF>0.0时）的损失。此过程也需要OCEAN文件。 cb6r3m_ae7_kmtbr机制包含更明确的海洋化学，同样也需要OCEAN文件。

如果您的模拟区域中包含海洋，建议使用选项1。但是，如果您的建模领域不包含任何海洋，或者您希望绕过CMAQ海浪排放模块以及臭氧与海洋卤族元素的反应，请按照选项2或3进行操作。

## 选项1：从域的shapefile创建OCEAN文件

### 步骤1：下载空间分配器（Spatial Allocator）

您可以从CMAS中心下载空间分配器（SA）工具，链接为： https://www.cmascenter.org/sa-tools/ 。登录并按照下载和安装说明进行操作。

### 步骤2：创建OCEAN文件

如果您的模拟区域位于美国，SA工具已在数据目录中包含一个shapefile（surfzone_poly_st.shp）。如果您的模拟区域不在美国，则您需要该区域的shapefile。有关空间分配器生成OCEAN文件所需的属性模板，请参见surfzone_poly_st.shp。

您可以使用示例脚本`alloc_srf_zone_to_oceanfile.csh`（位于SA工具的 **scripts** 目录中）作为指南，自定义脚本以在计算机上运行SA可执行文件。

默认的`alloc_srf_zone_to_oceanfile.csh`脚本如下所示。要为您的模拟区域自定义此脚本，请设置 `GRIDDESC` 变量以指向包含模拟区域定义的I/O API网格描述文件。同时按照GRIDDESC文件中的定义，将`OUTPUT_GRID_NAME` 设置为新网格的名称。如果需要，将`OUTPUT_FILE_MAP_PRJN`变量更改为模拟区域的投影设定。

```
#! /bin/csh -f
#******************* Allocate Shapefiles Run Script **************************
# Allocates a polygon shapefile's data to an I/O API gridded file
#*****************************************************************************

setenv DEBUG_OUTPUT Y

# Set executable
setenv EXE "$SA_HOME/bin/32bits/allocator.exe"

# Set Input Directory
setenv DATADIR $SA_HOME/data
setenv OUTPUT $SA_HOME/output

# Select method of spatial analysis

setenv MIMS_PROCESSING ALLOCATE

setenv TIME time

#set "data" shapefile parameters
setenv GRIDDESC $DATADIR/GRIDDESC.txt

#set parameters for file being allocated
setenv INPUT_FILE_NAME $DATADIR/surfzone/surfzone_NC_SC
setenv INPUT_FILE_TYPE ShapeFile
setenv INPUT_FILE_MAP_PRJN "+proj=lcc,+lat_1=33,+lat_2=45,+lat_0=40,+lon_0=-97"
setenv INPUT_FILE_ELLIPSOID "+a=6370000.0,+b=6370000.0"
setenv ALLOCATE_ATTRS TYPE
setenv ALLOC_MODE_FILE ALL_AREAPERCENT

#Set this to SURF_ZONE to create the variables needed for CMAQ OCEANfile
setenv ALLOC_ATTR_TYPE  SURF_ZONE

# Set name and path of resulting shapefile
setenv OUTPUT_FILE_TYPE IoapiFile
setenv OUTPUT_GRID_NAME NC4KM
setenv OUTPUT_FILE_MAP_PRJN "+proj=lcc,+lat_1=33,+lat_2=45,+lat_0=40,+lon_0=-97"
setenv OUTPUT_FILE_ELLIPSOID "+a=6370000.0,+b=6370000.0"
setenv OUTPUT_FILE_NAME $OUTPUT/ocean_file_${OUTPUT_GRID_NAME}.ncf

#echo "Allocating surf zone data to CMAQ OCEANfile"
$TIME $EXE
```

运行脚本并检查在脚本指定的输出目录中是否有新的OCEAN文件。

## 选项2：运行CMAQv5.3或更高版本时，无需OCEAN输入文件
如果您的模拟区域不包含任何沿海地区，则可以在没有OCEAN输入文件的情况下运行CMAQ。这将同时关闭CMAQ海浪排放模块和海洋上空的臭氧一次衰减。为此，请将运行脚本中的选项`CTM_OCEAN_CHEM`设置为"N"或"F"。

## 选项3：运行CMAQv5.2或更早版本时，需要零海浪排放文件

即使您的建模区域不包含海浪排放区域，您也需要向CCTM提供OCEAN文件。您可以为建模区域创建一个虚拟的OCEAN文件并设置为没有海浪源，也可以将海浪排放量设置为零。复制并运行以下I/O API工具m3fake脚本，以创建一个海洋和冲浪区覆盖率为零的OCEAN文件。使用此文件将有效配置CCTM模拟，使海浪排放为零。

请注意，您需要在Linux系统上安装并编译 [I/O API工具]( http://www.cmascenter.org/ioapi ) 才能使用此脚本。

```
#!/bin/csh -f

# m3fake script to create a dummy ocean file

setenv GRIDDESC $CMAQ_HOME/data/mcip/GRIDDESC
setenv GRID_NAME SE52BENCH
setenv OUTFILE $CMAQ_HOME/data/ocean/ocean_file.dummy.$GRID_NAME.ncf
m3fake << EOF
Y
2
SE52BENCH
1
0
2
OPEN
1
open ocean fraction 
1
5
0.
SURF
1
surf zone fraction
1
5
0.

OUTFILE
EOF
```

在运行此脚本之后，请检查脚本中指定的输出文件，并在CCTM中使用它代替OCEAN文件。