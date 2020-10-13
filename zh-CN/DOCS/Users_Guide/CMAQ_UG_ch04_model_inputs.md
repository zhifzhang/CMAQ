
<!-- BEGIN COMMENT -->

 [<< 前一章](CMAQ_UG_ch03_preparing_compute_environment.md) - [返回](README.md) - [下一章 >>](CMAQ_UG_ch05_running_a_simulation.md)

<!-- END COMMENT -->

# 4 模型输入文件

## 4.1 简介
本章提供有关CMAQ输入文件的格式和内容的基本信息，以及有关使用存储库中提供的预处理工具来准备初始条件和边界条件以及气象输入的信息，还提供了排放处理工具的存储库或网站链接。可在[表4-1]( #Input_Table )中找到CMAQ输入文件的列表。一些CMAQ输入文件为ASCII格式，而大多数为[netCDF格式（Network Common Data Form，网络公共数据格式]( http://www.unidata.ucar.edu/software/netcdf )。 CMAQ输入和输出文件是自描述的netCDF格式文件，其文件头中具有定义常驻数据所需的所有尺寸和描述性信息。用户可从[NetCDF网站]( http://www.unidata.ucar.edu/software/netcdf )下载NetCDF的最新代码，并通过该网站获得NetCDF的编译和配置信息。

所有CMAQ输入和输出文件均符合I/O API netCDF文件格式。有关详细信息，请参阅[I/O API用户手册]( https://www.cmascenter.org/ioapi/ )。

用户可以从CMAS数据仓库中公开下载两个区域中2016年的完整输入数据集。输入文件与通过Dataverse整理的元数据一起存储在Google Drive中。

|**模拟区域**|**模拟日期**|**Dataverse DOI**|
|:--------------:|:----:|:--------:|
|美国东南部|2016年7月1日至14日| https://doi.org/10.15139/S3/IQVABD |
|美国本土|2016年1月1日至12月31日| https://doi.org/10.15139/S3/MHNUNE |

## 4.2 CMAQ预处理程序
<a id=Figure2-1></a> ![图 2-1](./images/Figure2-1.jpg)

**图2‑1  CMAQ系统结构**

上图给出了CMAQ预处理程序与CMAQ主程序CCTM（CMAQ Chemistry Transport Model ）之间的关系。MCIP、ICON和BCON包含在CMAQ存储库中，用于创建气象、初始条件和边界条件输入文件。SMOKE、FEST-C和空间分配器工具（Spatial Allocator Tools）是为CMAQ创建排放输入文件所需的外部软件包。以下小节提供了有关这些软件的更多信息，并为用户提供了更多的文档信息。

### 4.2.1 MCIP（Meteorology-Chemistry Interface Processor，气象-化学接口处理器）

MCIP将WRF模型输出的气象场处理为与CCTM和SMOKE（为CMAQ生成排放输入文件的排放处理器）兼容的文件。MCIP生成的输出文件由ICON和BCON以及CMAQ中的各种其他程序使用，因此MCIP必须是安装CMAQ源代码并初始化CMAQ环境变量之后运行的第一个程序。MCIP的配置选项包括：从气象模型输出文件中提取数据的时间段、用于输出的水平网格定义、以及控制可选的3D输出变量。MCIP可以处理来自WRF的整个水平区域，也可以处理该区域的用户定义子集（即一个“窗口”）。与CMAQ程序套件中的许多程序不同，MCIP是使用Makefile编译的，然后使用运行脚本运行。PREP/mcip文件夹中的[README.md]( ../../PREP/mcip/README.md )文件中提供了有关如何编译和运行MCIP的说明。

对于CCTM和排放模型，MCIP不会修改WRF模拟的大多数字段，它们会被“传递”到输出文件中。此外，转换为CMAQ的广义坐标系所需的字段也在MCIP中计算。现在，干沉降速度在CCTM中计算，MCIPv3.4是在内部计算干沉降速度的最后一个版本。

### 4.2.2 ICON（Initial Conditions Processor，初始条件处理器）

ICON会在模拟的初始时间为建模区域中的所有网格单元生成一个包含化学条件的网格化的netCDF文件。这些初始条件可以从现有的CCTM输出文件中生成，也可以从随CMAQ一起发布的垂直解析浓度曲线的四个ASCII文件之一生成。运行ICON要求用户已经为其目标建模区域生成了MCIP文件。对于这两个输入文件选项，ICON会将数据插值到MCIP文件中定义的目标区域的水平和垂直结构中去。ICON输出文件中的物质种类应与输入文件（即前述的CCTM输出文件或ASCII垂直解析浓度曲线文件）中的种类相同。

在将初始条件从粗网格区域插值到细网格区域时，可以使用现有的CCTM输出文件生成初始条件，例如在设置嵌套网格（在粗网格的一部分区域设置细网格）模拟时可能会发生这种情况。这是指定初始条件的首选模式，因为在模拟开始时，可​​以将源自粗网格模拟的空间浓度视为细网格子区域上浓度场的第一近似值。

随CMAQ一起发布的四个[垂直解析浓度曲线ASCII文件]( ../../PREP/bcon/src/profile )是通过CMAQv5.3 beta2模拟的2016年半球范围的太平洋地区网格单元的年平均浓度。因此，这些浓度曲线反映了偏远海洋环境中的状况。该模拟使用了cb6r3m_ae7_kmtbr化学机理，以及[CMAQ教程第3步（根据CMAQ输出的半球季平均数据创建初始条件和边界条件）]( ./Tutorials/CMAQ_UG_tutorial_HCMAQ_IC_BC.md )中所述的物种映射方法得出racm_ae6_aq、saprc07tc_ae6_aq和saprc07tic_ae7i_aq的浓度曲线。如果使用这些ASCII曲线文件之一来生成初始条件，则所得的初始浓度场在建模区域上将是完全一致的，并且不是建模区域上初始条件的真实表示。因此，基于这些垂直解析浓度曲线的模拟可能比基于CCTM的浓度场初始条件的模拟需要更长的启动时间，以确保模拟区域内的条件不再受这些不切实际的初始浓度场影响。

ICON的配置选项包括选择初始条件是从现有CCTM输出文件生成，还是从ASCII垂直解析浓度曲线文件生成，以及定义生成初始条件的水平网格、垂直网格和时间。PREP/icon文件夹中的[README.md]( ../../PREP/icon/README.md )文件提供了有关ICON各种输入数据、环境变量、输入和输出文件的配置信息，以及编译和运行ICON的信息。

### 4.2.3 BCON（Boundary Conditions Processor，边界条件处理器）

BCON沿建模区域的横向边界生成包含化学条件的netCDF文件。BCON将生成一个输出文件，其中包含沿建模区域水平边界的所有网格单元的化学浓度。这些边界条件可以从现有的CCTM输出文件生成，也可以从随CMAQ发布的垂直解析浓度曲线的四个ASCII文件之一生成。运行BCON要求用户已经为其建模区域生成了MCIP文件。对于这两个输入文件选项，BCON会将数据插值到MCIP文件中定义的目标区域的水平和垂直结构中去。BCON输出文件中的物质种类应与输入文件（即前述的CCTM输出文件或ASCII垂直解析浓度曲线文件）中的种类相同。根据用户指定的选项和/或输入数据集，由BCON生成的边界条件可以是随时间变化的或与时间无关的，在模型边界上可以是空间均匀的或是可变的。

在设置“窗口模拟“（具在相同分辨率下仅模拟一部分区域）或”嵌套模拟“（在粗网格的一部分区域设置细网格）时，可使用现有的CCTM输出文件生成边界条件。这是指定边界条件的首选模式，因为从粗网格模拟得出的空间浓度场将沿细网格区域的边界空间上变化。从CCTM输出文件生成的边界条件可以随时间变化，也可以与时间无关。

随CMAQ一起发布的四个[垂直解析浓度曲线ASCII文件]( ../../PREP/bcon/src/profile )是通过CMAQv5.3 beta2模拟的2016年半球范围的太平洋地区网格单元的年平均浓度。因此，这些浓度曲线反映了偏远海洋环境中的状况。该模拟使用了cb6r3m_ae7_kmtbr化学机理，以及[CMAQ教程第3步（根据CMAQ输出的半球季平均数据创建初始条件和边界条件）]( ./Tutorials/CMAQ_UG_tutorial_HCMAQ_IC_BC.md )中所述的物种映射方法得出racm_ae6_aq、saprc07tc_ae6_aq和saprc07tic_ae7i_aq的浓度曲线。如果使用这些ASCII曲线文件之一来生成边界条件，则所得的浓度场在沿建模区域的边界上是完全一致的，并且不会随时间变化。因此，它们不是建模区域边界条件的真实表示，仅应在不希望边界条件影响模型结果解释的情况下使用。

CMAQ可以使用从GCMs（global chemistry models ，全球化学模型）导出的边界条件。虽然BCON不支持直接处理GCMs（除了CMAQ的半球版本）中原始格式的数据集，但用户可以开发自己的自定义代码将GCMs数据集转换为I/O API格式，然后将这些数据集以与采用现有CCTM输出文件相同的方式输入BCON。

BCON的配置选项包括选择边界条件是从现有CCTM输出文件生成，还是从ASCII垂直解析浓度曲线文件生成，以及定义生成边界条件的水平网格、垂直网格和时间周期。PREP/bcon文件夹中的[README.md]( ../../PREP/bcon/README.md ) 文件提供了有关BCON各种输入数据、环境变量、输入和输出文件的配置信息，以及编译和运行BCON的信息。

### 4.2.4 用于准备CMAQ输入的外部软件
SMOKE和FEST-C模型以及空间分配器工具（Spatial Allocator tools）用于创建CMAQ排放量和地表输入文件。这些系统由EPA和CMAS开发人员维护，并由CMAS中心托管和支持。下面提供了每个系统的文档和软件下载链接。

**排放处理器（SMOKE）**
[Sparse Matrix Operator Kerner Emissions (SMOKE) Modeling System，稀疏矩阵算子核心排放模型]( https://www.cmascenter.org/smoke/ )用于创建网格化的指定物种的逐时排放量，以输入CMAQ和其他空气质量模型。SMOKE支持面源、生物源、移动源（包括道路移动源和非道路移动源）以及点源排放的基本污染物、颗粒物和有毒污染物的处理。对于生物排放模型，SMOKE使用生物排放清单系统（Biogenic Emission Inventory System）。SMOKE还集成了道路移动源排放模型MOBILE6和MOVES。

**肥料排放处理器（FEST-C）**
[用于CMAQ的肥料排放情景工具（FEST-C，Fertilizer Emission Scenario Tool for CMAQ）]( https://www.cmascenter.org/fest-c/ ) 系统可生成农地氮和土壤信息，用于CMAQ双向NH<sub>3</sub>建模。FEST-C包含三个主要组件：Java界面，EPIC（Environmental Policy Integrated Climate，环境政策综合气候）模型，以及SA栅格工具。Java界面指导用户制作生成EPIC输入文件所需的土地利用和农作物数据，模拟EPIC，以及为CMAQ提取EPIC输出数据。

FEST-C用于创建[E2C_LU]( #e2c_lu )，[E2C_SOIL]( #e2c_soil )和[E2C_CHEM]( #e2c_chem )文件，在本章稍后讨论。

**使用空间分配器（SA）处理空间数据**
[空间分配器，Spatial Allocator（SA）]( https://www.cmascenter.org/sa-tools/ ) 是帮助用户操作和生成与排放源和空气质量建模有关的数据文件的一组工具。这些工具的功能类似于地理信息系统（GIS），但免费提供给建模社区。此外，这些工具还可以支持CMAQ、SMOKE和WRF模型的某些特殊文件格式。

SA用于生成碎浪带（surf zone）和开放海域文件，该文件是CMAQ中模拟海洋排放物和化学物质所必需的输入。该文件将在本章后面的[OCEAN_1：Sea spray mask](#ocean_1) 一节内讨论。

[附录C]( Appendix/CMAQ_UG_appendixC_spatial_data.md )中提供了有关处理CMAQ输入数据的其他信息。

<a id=inputs></a>

## 4.3 CMAQ输入文件

[跳至输入文件列表]( #Input_Table )<br>
[跳到第7章的CCTM输出文件]( CMAQ_UG_ch07_model_outputs.md )

CMAQ需要一组基本的输入文件：初始条件文件（由ICON或前一天的输出创建），边界条件文件（由BCON创建），排放源文件，以及MCIP使用WRF和地形数据创建的气象数据。根据特定的运行选项，可能还需要其他输入文件。CMAQ输出文件包括一组基本的文件，其中包含气溶胶和气相物质的浓度、干湿沉降量、能见度指标、以及一组辅助输出文件用于诊断模型性能和在线计算的排放量。模型输出相关内容详见[第7章]( CMAQ_UG_ch07_model_outputs.md )。

I/O API netCDF文件格式不是强迫用户处理硬编码的文件名或硬编码的单元号，而是利用逻辑文件名的概念。建模者可以将逻辑名定义为程序的属性，然后在运行时可以使用环境变量将逻辑名链接到实际文件名。出于编程目的，唯一的限制是逻辑文件名不能包含空格且最长不能超过16个字符。当建模者运行使用I/O API格式的程序时，必须使用环境变量来设置程序的逻辑文件名的值。[表4-1]( #Input_Table )中提供了CMAQ输入的完整列表。

本节描述了各种CMAQ程序所需的每个输入文件。本节从网格定义文件GRIDDESC的描述开始，该定义文件被多个CMAQ程序使用，然后逐个程序列出CMAQ输入文件要求。[表4-1]( #Input_Table )列出了来源、文件类型（例如ASCII、[GRDDED3]( https://www.cmascenter.org/ioapi/documentation/all_versions/html/DATATYPES.html )、[BNDARY3]( https://www.cmascenter.org/ioapi/documentation/all_versions/html/DATATYPES.html )等），以及每个CMAQ输入文件的时间周期和空间尺度。典型的时间步长是1小时，但用户也可以指定一个值，例如20分钟。此外，边界文件的典型厚度为1，即NTHIK = 1，但也可以是任何正整数。

<a id=Input_Table></a>
<a id=Table4-1></a>
**表4-1  CMAQ输入文件**。请注意，当“时间周期”列为“Hourly”时，它是指随时间变化的文件的缩写。这是因为建议CMAQ使用的时间增量不超过一小时。另一方面，CMAQ可以采用短于一小时的时间周期运行。

|**文件的环境变量名称**|**文件类型**|**时间周期**|**空间尺度**|**来源**|**是否必须**|
|----------------------|-----------|-----------|----------|----------|---------|
|**通用**|  | | |||
|[GRIDDESC](#griddesc) <a id=griddesc_t></a>|ASCII|n/a|n/a|MCIP|必须|
|[gc_matrix_nml](#matrix_nml) <a id=matrix_nml_t></a>|ASCII|n/a|n/a|CMAQ repo|必须|
|[ae_matrix_nml](#matrix_nml) <a id=matrix_nml_t></a>|ASCII|n/a|n/a|CMAQ repo|必须|
|[nr_matrix_nml](#matrix_nml) <a id=matrix_nml_t></a>|ASCII|n/a|n/a|CMAQ repo|必须|
|[tr_matrix_nml](#matrix_nml) <a id=matrix_nml_t></a>|ASCII|n/a|n/a|CMAQ repo|必须|
|**初始条件输入**|  | | ||
|[INIT_CONC_1](#init_conc_1) <a id=init_conc_1_t></a>|GRDDED3|时间无关 | XYZ | ICON or CCTM |必须|
|**边界条件输入**| | | | ||
|[BNDY_CONC_1](#bndy_conc_1) <a id=bndy_conc_1_t></a> |BNDARY3| Hourly |PERIM\*Z|BCON|必须|
|**MCIP**| | | | |||
|[GRID_CRO_2D](#grid_cro_2d) <a id=grid_cro_2d_t></a>| GRDDED3 | 时间无关 | XY | MCIP|必须|
|[GRID_BDY_2D](#grid_bdy_2d) <a id=grid_bdy_2d_t></a>| BNDARY3 | 时间无关 | PERIM\*Z | MCIP|必须|
|[GRID_DOT_2D](#grid_dot_2d) <a id=grid_dot_2d_t></a>| GRDDED3 | 时间无关 | (X+1)\*(Y+1) | MCIP|必须|
|[MET_BDY_3D](#met_bdy_3d) <a id=met_bdy_3d_t></a>| BNDARY3 | Hourly | PERIM\*Z | MCIP|必须|
|[MET_CRO_2D](#met_cro_2d) <a id=met_cro_2d_t></a>| GRDDED3 | Hourly | XY | MCIP|必须|
|[MET_CRO_3D](#met_cro_3d) <a id=met_cro_3d_t></a>| GRDDED3 | Hourly | XYZ | MCIP|必须|
|[MET_DOT_3D](#met_dot_3d) <a id=met_dot_3d_t></a>| GRDDED3 | Hourly | (X+1)\*(Y+1)Z | MCIP|必须|
|[LUFRAC_CRO](#lufrac_cro) <a id=lufrac_cro_t></a>| GRDDED3 | 时间无关 | XYL | MCIP|必须|
|[SOI_CRO](#soi_cro) <a id=soi_cro_t></a>| GRDDED3 | Hourly | XYS | MCIP | 可选项（包含不同层的土壤水分和土壤温度。当前在MET_CRO_2D中镜像了两层作为这些区域的代表）|
|[MOSAIC_CRO](#mosaic_cro) <a id=mosaic_cro_t></a>| GRDDED3| Hourly| XYM | MCIP|可选项（如果在WRF中运行了Noah Mosaic LSM，则包含版块化的土地使用类别中的表面场。可以与CCTM中的STAGE沉降一起使用）|
|[mcip.nc](#mcip) <a id=mcip_t></a>| netCDF | varies by field | varies by field | MCIP|IOFORM=2时必须（目前与其他CMAQ系统不兼容）|
|[mcip_bdy.nc](#mcip_bdy) <a id=mcip_bdyt></a>| netCDF | varies by field | varies by field | MCIP|IOFORM=2时必须（目前与其他CMAQ系统不兼容）|
|**排放源输入**||||||
|[EmissCtrl_matrix_nml](#emissctrl) <a id=emissctrl_t></a>|ASCII|n/a|n/a|CMAQ repo|必须|
|[GR_EMIS_XXX*](#emis_xxx) <a id=emis_xxx_t></a> | GRDDED3 | Hourly | XYZ | SMOKE|必须|
|[STK_GRPS_XXX](#stk_grps) <a id=stk_grps_t></a> | GRDDED3 |时间无关|XY | SMOKE|必须|
|[STK_EMIS_XXX](#stk_emis) <a id=stk_emis_t></a> | GRDDED3 | Hourly | XY | SMOKE|必须|
|[NLDN_STRIKES](#nldn_strikes) <a id=nldn_strikes_t></a>| GRDDED3 | Hourly | XY |Must purchase data|可选项，用于包含闪电产生的NO|
|[LTNGPARMS_FILE](#ltngparm_file) <a id=ltngparm_file_t></a>| GRDDED3 | 时间无关 | XY |CMAS|必须，用于包含闪电产生的NO|
|**生物源和地表参数输入**||||||
|[OCEAN_1](#ocean_1) <a id=ocean_1_t></a>| GRDDED3 | 时间无关 | XY |Spatial Allocator|必须|
|[GSPRO](#gspro) <a id=gspro_t></a>| ASCII | 时间无关 | N/a | CMAQ repo|必须，用于CMAQ模拟在线生物源|
|[B3GRD](#b3grd) <a id=b3grd_t></a>| GRDDED3 | 时间无关 | XY | SMOKE|必须，用于CMAQ模拟在线生物源|
|[BIOSEASON](#bioseason) <a id=bioseason_t></a>|GRDDED3 |时间无关 | XY | SMOKE|运行可选项，用于CMAQ运模拟在线生物源|
|[E2C_LU](#e2c_lu) <a id=e2c_lu_t></a>| GRDDED3 | 时间无关 |XY|EPIC|必须，用于CMAQ模拟双向NH3|
|[E2C_SOIL](#e2c_soil) <a id=e2c_soil_t></a>| GRDDED3 | 时间无关 | XY|EPIC|必须，用于CMAQ模拟双向NH3|
|[E2C_CHEM](#e2c_chem) <a id=e2c_chem_t></a>| GRDDED3 | Daily |XY|EPIC|可选项|
|[DUST_LU_1](#dust_lu_1) <a id=dust_lu_1_t></a>| GRDDED3 | 时间无关 | XY|Spatial Allocator|可选项，用于CMAQ模拟刮风起尘|
|[DUST_LU_2](#dust_lu_2) <a id=dust_lu_2_t></a>| GRDDED3 | 时间无关 | XY|Spatial Allocator|可选项，用于CMAQ模拟刮风起尘|
|**光解作用** | | | |||
|[OMI](#omi) <a id=omi_t></a>| ASCII | Daily | n/a |CMAQ repo or create_omi|必须|

*XXX -表示排放源编号的三位数字变量。网格和排队点源独立编号。

## 4.4 GRIDDESC和物种名称列表文件

<a id=griddesc></a> 
**GRIDDESC：水平区域定义**

<!-- BEGIN COMMENT -->

[返回表4-1](#griddesc_t)

<!-- END COMMENT -->

Used by: ICON, BCON, CCTM

CMAQ网格描述文件（**GRIDDESC**）是ASCII文件，包含两个部分：水平坐标部分和区域描述部分。GRIDDESC文件是由MCIP自动生成的，或者也可以使用文本编辑器创建GRIDDESC。

GRIDDESC中的水平坐标部分由文本记录组成，包括了坐标系名称、地图投影以及定义投影的描述性参数。本部分用于提供由一系列嵌套区域使用的投影信息，每个区域共享坐标系名称。

GRIDDESC中的网格描述部分由文本记录组成，包括了网格名称、相关的坐标系名称（即，在上一部分中定义的应用于该网格的GRIDDESC水平坐标名称）、网格左下角的坐标、网格单元大小、列数和行数等描述性参数。在一个文件中最多可以列出32个坐标系和256个网格。这些文件足够小，可以轻松地进行存档研究，并且格式足够简单，可以轻松地“手动”构建。GRIDDESC文件的元素通常包含在CMAQ输出文件的元数据中。

GRIDDESC文件的示例如下所示：

` ' '`

` 'LAM_40N100W'`

` 2 30.0 60.0 -100.0 -100.0 40.0`

` ' '`

` 'M_32_99TUT02'`

` 'LAM_40N100W' 544000.0 -992000.0 32000.0 32000.0 38 38 1`

` ' '`

在此示例中，GRIDDESC文件中的水平坐标部分（第一部分）定义了名为“LAM_40N100W”的水平坐标。坐标定义为兰伯特正形网格，由坐标描述行（即名称下一行）的第一列作为关键字表示，它对应于多种I/O API支持的网格类型的数字代码（2 = Lambert）。接下来的三个参数（P_ALP、P_BET和P_GAM）对不同的地图投影具有不同的定义。对于兰伯特正形，P_ALP和P_BET是投影锥的真实纬度（在示例中为30°N和60°N），而P_GAM是投影的中央子午线（在示例中为100°W，即-100）。最后两个参数XCENT和YCENT是区域的参考经度和纬度，在示例中为100°W和40°N。

示例中的第二部分描述了一个名为“M_32_99TUT02”的区域。在本示例中，名为“LAM_40N100W”的坐标在区域定义中被引用。区域定义中的接下来两个参数（XORIG和YORIG）是XCENT和YCENT的东西偏移和南北偏移，单位为米。接下来的两个参数（XCELL和YCELL）是X和Y方向的水平网格间距（即， &#916;x and &#916;y，以米为单位）。接下来的两个参数（NCOLS和NROWS）是X和Y方向的网格单元数量。最后一个参数是网格边界单元的数量（NTHIK），通常设置为1。请注意，CMAQ的边界单元的数量与WRF使用的边界单元的数量不同。

有关GRIDDESC文件中参数的其他信息，请参见[I/O API文档]( https://www.cmascenter.org/ioapi/documentation/all_versions/html/GRIDS.html )。

<a id=matrix_nml></a>

**{gc|ae|nr|tr}_matrix.nml: 物种名称列表文件**
<!-- BEGIN COMMENT -->
[返回表4-1](#matrix_nml_t)
<!-- END COMMENT -->

Used by: CCTM, CHEMMECH

CMAQ程序执行时，使用不同类别模拟污染物的名称列表查询表来定义不同模型物种的参数。气相（gc）、气溶胶（ae）、非反应性（nr）和示踪剂（tr）物种名称列表文件在不同的分类中包含了模拟物质的这些参数。物种名称列表文件用于控制不同的CMAQ程序如何处理模型物种。物种名称列表文件为每种模拟种类定义以下过程：

- 初始条件 – 该污染物映射到哪种初始条件物种，如果未指定，则默认为物种名称。
- IC因子 – 如果污染物映射到初始条件物种，则对浓度统一应用比例因子。
- 边界条件 – 该污染物映射到哪种边界条件物种，如果未指定，则默认为物种名称。
- BC因子 – 如果污染物映射到边界条件物种，则对浓度统一应用比例因子。
- 沉降速率 – （如果设置为）映射到污染物沉降速率的物种，允许的沉降速率在模型源代码中指定。
- 沉降速率因子 – 如果污染物映射到沉降速率，则对沉降速率统一应用比例因子。
- 清除 - （如果设置为）映射到的污染物的物种，在模型源代码（"[hlconst.F]( ../../CCTM/src/cloud/acm_ae6/hlconst.F )"）中指定了允许的清除替代。
- 清除因子 - 如果污染物映射到某个物种进行清除，则对清除率统一应用比例因子。
- 气态-气溶胶转化 - （如果设置为）气溶胶化学物质，会导致气相污染物浓度从气相转化为气溶胶相。在模型源代码（"[PRECURSOR_DATA.F](../../CCTM/src/aero/aero6/PRECURSOR_DATA.F)"和"[SOA_DEFN.F](../../CCTM/src/aero/aero6/SOA_DEFN.F)"）中指定了允许的气溶胶替代物。
- 气态-水相替代物 – （如果设置为）云化学物种，则气态污染物浓度用来模拟在云中水里的化学转化。在模型源代码中指定了允许的气态-水相替代物，取决于所使用的云模型/水化学转化（例如，对于acm_ae6，请参阅"[AQ_DATA.F](../../CCTM/src/cloud/acm_ae6/AQ_DATA.F)"）。
- 气溶胶-水相替代物 - （如果设置为）云化学物种，则气溶胶污染物浓度用来模拟在云中水里的化学转化。在模型源代码中指定了允许的气溶胶-水相替代物，具体取决于所使用的云模型/水化学转化（例如，对于acm_ae6，请参阅“[AQ_DATA.F](../../CCTM/src/cloud/acm_ae6/AQ_DATA.F)"）。
- 传输 - 模型中的污染物是否通过对流和扩散的方式传输？
- 干沉降 – 将污染物写入干沉降输出文件吗？
- 湿沉降 – 将污染物写入湿沉降输出文件？
- 浓度 – 将污染物写入瞬时浓度输出文件吗？

名称列表文件中的内容包括：标题信息（描述了文件中包含的物种类别、参数数量），描述参数字段的标题，以及一系列行（用于描述每个模型种类的的配置参数）。[表4-2]( #Table4-2 )包含气相（GC）物种名称列表文件的格式，其他物种类型（AE，NR，TR）与的[表4-2]( #Table4-2 )的格式类似。

<a id=Table4-2></a>

**表4-2 气相（GC）物种名称列表文件格式**

| **行**| **列** |**名称** | **类型**| **描述** |**语法选项**:|
|-----|-----|----------------------|----------|--------------------------------------------|----------------------------|
| 1 || File Type |字符串|描述气相(GC)、气溶胶(AE)、非反应性(NR)和示踪剂(TR)物种名称的字符串|{&GC_nml, &AE_nml, &NR_nml, &TR_nml}|
| 3 || Header ID |字符串|用于定义与名称列表有关数据结构的字符串|{GC_SPECIES_DATA=, AE_SPECIES DATA= , NR_SPECIES_DATA= ,TR_SPECIES_DATA = }|
| 5 |1| SPECIES | 字符串 |CMAQ物种名称，比如NO、HNO<sub>3</sub>、PAR，取决于化学机理|-|
||2| MOLWT| 整数 |物种的分子量|-|
|  |3| IC | 字符串 |CMAQ物种的初始条件替代物种名称|{'Species name', ' '}|
|  |4| FAC | 整数 |初始条件浓度的比例系数|{任意实数:如果IC未指定则默认取-1}|
|  |5| BC | 字符串 |CMAQ物种的边界条件替代物种名称|{'Species name', ' '}|
|  |6| FAC | 整数 |边界条件浓度的比例系数|{任意实数:如果BC未指定则默认取-1}|
| |7| DRYDEP SURR | 字符串 |CMAQ物种的沉降速率变量名称|{'Species name', ' '}|
| |8| FAC | 整数 |沉降速率的比例系数|{任意实数:如果SURR未指定则默认取-1}|
| |9| WET-SCAV SURR | 字符串 |湿沉降清除替代物种|{'Species name', ' '}|
| | 10 | FAC | 整数 |清除的比例系数|{任意实数:如果SURR未指定则默认取-1}|
|| 11 | GC2AE SURR | 字符串 |气相-气溶胶转化物种|{'Species name', ' '}|
|| 12 | GC2AQ SURR | 字符串 |气相-水相转化物种|{'Species name', ' '}|
|| 13 | TRNS | 字符串 |传输开关。 _注意_: 除了使用标记为"TRNS"的一列来同时打开/关闭污染物的对流和扩散选项，也可以使用标记为"ADV"和"DIFF"的两个单独的列分别来打开/关闭对流（advection）和扩散（diffusion）选项|{YES/NO}|
|| 14 | DDEP | 字符串 |干沉降输出文件开关|{YES/NO}|
|| 15 | WDEP | 字符串 |湿沉降输出文件开关|{YES/NO}|
|| 16 | CONC | 字符串 |浓度输出文件开关|{YES/NO}|


其他污染物类别的名称列表文件配置信息与[表4-2](#Table4-2)中所示的气相物种配置类似。有关示例，请参见用于cb06r3_ae7_aq机制的[气相（GC）物种名称列表文件]( ../../CCTM/src/MECHS/cb06r3_ae7_aq/GC_cb6r3_ae7_aq.nml )。

<a id=init_conc_1></a>

## 4.5 初始条件输入

**INIT_CONC_1: 初始条件**

<!-- BEGIN COMMENT -->
 
[返回表4-1](#init_conc_1_t)

<!-- END COMMENT -->

Used by: CCTM

要建模的每个物种的初始浓度必须输入到CMAQ中。初始条件输入文件类型为GRDDED3，并且不会随时间变化。实际文件数据以这种方式组织：按列、按行、按层、按变量。初始条件文件与浓度文件具有相同的结构，因此第一天最后一个小时的预测浓度可用于初始化第二天的模拟。这使CMAQ用户可以灵活地选择任何方式对模拟进行细分。

<a id=bndy_conc_1></a>

## 4.6 边界条件输入

**BNDY_CONC_1: 边界条件**

<!-- BEGIN COMMENT -->

[返回表4-1](#bndy_conc_1_t)

<!-- END COMMENT -->

Used by: CCTM

CMAQ边界条件数据为BNDARY3文件类型。这些数据由边界条件处理器BCON生成，被CCTM读取，并使用指针系统将其与内部数据相关联。该指针系统指定数据在存储器中的开始位置，该数据从模拟区域的新侧开始（即南，东，北或西）。有关图片说明，请查阅《I/O API用户指南》。

每个要建模的物种都应在BNDY_CONC_1文件中。如果此文件中未包含某些建模物种，则这些物种的边​​界条件将默认为1×10e<sup>-30</sup>。CMAQ模拟区域的边缘是NTHIK单元的宽度（通常NTHIK=1），边界单元的数量=NTHIK\*(2\*NCOLS + 2\*NROWS +4\*NTHIK）。

## 4.7 气象输入（使用MCIP为CMAQ生成）

<a id=grid_cro_2d></a>
<a id=grid_bdy_2d></a>
<a id=grid_dot_2d></a>
<a id=met_bdy_3d></a>
<a id=met_cro_2d></a>
<a id=met_cro_3d></a>
<a id=met_dot_3d></a>
<a id=lufrac_cro></a>
<a id=soi_cro></a>
<a id=mosaic_cro></a>
<a id=mcip></a>
<a id=mcip_bdy></a>


**_MCIP生成的输出文件（IOFORM=1时），(Models-3 I/O API)_**
- GRIDDESC:     整个CMAQ系统使用的网格描述
- GRID_CRO_2D:  单元中心（交叉点）的2D场（XY），不随时间变化
- GRID_BDY_2D:  来自GRID_CRO_2D的沿模拟区域侧向的边界场，不随时间变化
- GRID_DOT_2D:  单元角（点）和单元面的2D场（XY），不随时间变化
- MET_CRO_2D:   单元中心（交叉点）的2D场（XY），随时间变化
- MET_CRO_3D:   单元中心（交叉点）的3D场（XYZ），随时间变化
- MET_BDY_3D:   来自MET_CRO_3D的沿模拟区域侧向的边界场，随时间变化
- MET_DOT_3D:   单元角（点）和单元面的3D场（XYZ），随时间变化
- LUFRAC_CRO:   单元角（交叉点）的3D土地利用分数（XYL），不随时间变化
- SOI_CRO:      单元中心处模型土壤层中的3D土壤湿度和温度（XYS），随时间变化
- MOSAIC_CRO:   单元中心处镶嵌土地使用类型（XYM）的3D表面场，随时间变化

**_MCIP生成的输出文件（IOFORM=2时），(netCDF)_**
- GRIDDESC:     整个CMAQ系统使用的网格描述
- mcip.nc:      所有维度的2D和3D场（包括随时间变化的和不随时间变化的）
- mcip_bdy.nc:  沿侧向边界的所有必需的2D和3D场（包括随时间变化的和不随时间变化的）

<!-- BEGIN COMMENT -->

[返回表4-1](#grid_cro_2d_t)

<!-- END COMMENT -->

Used by: ICON, BCON, CCTM, 以及其他可选程序模块

<a id=Table4-3></a>

**表 4-3**  在CMAQ系统中使用的MCIP输出变量。
除“描述”列中指出的位置外，所有字段都位于单元中心。“维度”列的信息表示：XY=水平、T=随时间变化、Z=地面以上的层、S=地面以下的层、L=土地使用类型、M=镶嵌土地使用类型。

|**变量名称**|**描述**|**单位**|**维度**|**文件**|**是否必须**|
|--------|---------------|--------------|----------|------------|----------|
|LAT|latitude，纬度|度，北半球为正数，南半球为负数|XY|GRIDCRO2D and GRIDBDY2D, or mcip.nc and mcip_bdy.nc|yes|
|LON|longitude，经度|度，东半球为正数，西半球为负数|XY|GRIDCRO2D and GRIDBDY2D, or mcip.nc and mcip_bdy.nc|yes|
|MSFX2|squared map-scale factor|m<sup>2</sup> m<sup>-2</sup>|XY|GRIDCRO2D and GRIDBDY2D, or mcip.nc and mcip_bdy.nc|yes|
|HT|terrain elevation，地形标高|m|XY|GRIDCRO2D and GRIDBDY2D, or mcip.nc and mcip_bdy.nc|yes|
|DLUSE|dominant land use，主要土地利用|category|XY|GRIDCRO2D and GRIDBDY2D, or mcip.nc and mcip_bdy.nc|yes|
|LWMASK|land-water mask|1=land, 0=water|XY|GRIDCRO2D and GRIDBDY2D, or mcip.nc and mcip_bdy.nc|yes|
|PURB|urban percent of cell based on land coverage，基于土地利用的城市单元的百分比|percent|XY|GRIDCRO2D and GRIDBDY2D, or mcip.nc and mcip_bdy.nc|no，但可以改善城市地区的垂直混合|
|LUFRAC|fraction of land use by category，土地使用类别的比例|1|XYL|LUFRACCRO or mcip.nc|yes|
|LATD|latitude，纬度|度，北半球为正数，南半球为负数(at cell corners)|XY|GRIDDOT2D or mcip.nc|no|
|LOND|longitude，经度|度，东半球为正数，西半球为负数(at cell corners)|XY|GRIDDOT2D or mcip.nc|no|
|MSFD2|squared map scale factor|m<sup>2</sup> m<sup>-2</sup> (at cell corners)|XY|GRIDDOT2D or mcip.nc|no|
|LATU|latitude，纬度|度，北半球为正数，南半球为负数(at cell west-east faces)|XY|GRIDDOT2D or mcip.nc|no|
|LONU|longitude，经度|度，东半球为正数，西半球为负数 (at cell west-east faces)|XY|GRIDDOT2D or mcip.nc|no|
|MSFU2|squared map scale factor|m<sup>2</sup> m<sup>-2</sup> (at cell west-east faces)|XY|GRIDDOT2D or mcip.nc|yes|
|LATV|latitude，纬度|度，北半球为正数，南半球为负数 (at cell south-north faces)|XY|GRIDDOT2D or mcip.nc|no|
|LONV|longitude，经度|度，东半球为正数，西半球为负数 (at cell south-north faces)|XY|GRIDDOT2D or mcip.nc|no|
|MSFV2|squared map scale factor|m<sup>2</sup> m<sup>-2</sup> (at cell south-north faces)|XY|GRIDDOT2D or mcip.nc|yes|
|PRSFC|surface pressure，表面压力|Pa|XYT|METCRO2D or mcip.nc|yes|
|USTAR|cell-averaged horizontal friction velocity，单元平均水平摩擦速度|m s<sup>-1</sup>|XYT|METCRO2D or mcip.nc|yes|
|WSTAR|convective velocity scale，对流速度尺度|m s<sup>-1</sup>|XYT|METCRO2D or mcip.nc|yes|
|PBL|planetary boundary layer height，行星边界层高度|m|XYT|METCRO2D or mcip.nc|yes|
|ZRUF|surface roughness length，表面粗糙度长度|m|XYT|METCRO2D or mcip.nc|yes|
|MOLI|inverse Monin-Obukhov length，反向Monin-Obukhov长度|m<sup>-1</sup>|XYT|METCRO2D or mcip.nc|yes|
|HFX|sensible heat flux，显热通量|W m<sup>-2</sup>|XYT|METCRO2D or mcip.nc|yes|
|LH|latent heat flux，潜热通量|W m<sup>-2</sup>|XYT|METCRO2D or mcip.nc|yes|
|RADYNI|inverse aerodynamic resistance，反空气动力学阻力|m s<sup>-1</sup>|XYT|METCRO2D or mcip.nc|yes|
|RSTOMI|inverse bulk stomatal resistance，反向气孔阻力|m s<sup>-1</sup>|XYT|METCRO2D or mcip.nc|yes|
|TEMPG|skin temperature at ground，地表温度|K|XYT|METCRO2D or mcip.nc|yes|
|TEMP2|2-m temperature，2m温度|K|XYT|METCRO2D or mcip.nc|yes|
|Q2|2-m water vapor mixing ratio，2m水汽混合比|kg kg<sup>-1</sup>|XYT|METCRO2D or mcip.nc|yes|
|WSPD10|10-m wind speed，10m风速|m s<sup>-1</sup>|XYT|METCRO2D or mcip.nc|yes|
|WDIR10|10-m wind direction，10m风向|degrees|XYT|METCRO2D or mcip.nc|no|
|GLW|longwave radiation at ground，地面的长波辐射|W m<sup>-2</sup>|XYT|METCRO2D or mcip.nc|yes|
|GSW|solar radiation absorbed at ground，地面吸收的太阳辐射|W m<sup>-2</sup>|XYT|METCRO2D or mcip.nc|yes|
|RGRND|solar radiation reaching the surface，到达地面的太阳辐射|W m<sup>-2</sup>|XYT|METCRO2D or mcip.nc|yes|
|RN|incremental (per output time step) nonconvective precipitation，递增非对流降水（每输出时间步长）|cm|XYT|METCRO2D or mcip.nc|yes|
|RC|incremental (per output time step) convective precipitation，递增对流降水（每输出时间步长）|cm|XYT|METCRO2D or mcip.nc|yes|
|CFRAC|total column integrated cloud fraction，总列综合云分数|1|XYT|METCRO2D or mcip.nc|yes,如果在CCTM中光解作用使用表格选项|
|CLDT|cloud layer top height，云层顶部高度|m|XYT|METCRO2D or mcip.nc|yes,如果在CCTM中光解作用使用表格选项|
|CLDB|cloud layer bottom height，云层底部高度|m|XYT|METCRO2D or mcip.nc|yes,如果在CCTM中光解作用使用表格选项|
|WBAR|average liquid water content of cloud，云的平均液态水含量|g m<sup>-3</sup>|XYT|METCRO2D or mcip.nc|yes,如果在CCTM中光解作用使用表格选项|
|SNOCOV|snow cover，雪覆盖|1=yes, 0=no|XYT|METCRO2D or mcip.nc|yes|
|VEG|vegetation coverage，植被覆盖|1|XYT|METCRO2D or mcip.nc|yes|
|LAI|leaf-area index，叶面积指数|m<sup>2</sup> m<sup>-2</sup>|XYT|METCRO2D or mcip.nc|yes|
|WR|canopy moisture content，冠层含水量|m|XYT|METCRO2D or mcip.nc|yes|
|SEAICE|sea ice，海冰|1|XYT|METCRO2D or mcip.nc|yes|
|SNOWH|snow height，雪高|m|XYT|METCRO2D or mcip.nc|yes|
|SOIM1|volumetric soil moisture in top cm，土壤体积水分|m<sup>3</sup> m<sup>-3</sup>|XYT|METCRO2D or mcip.nc|yes,但首选从SOIM3D使用|
|SOIM2|volumetric soil moisture in top m，土壤体积水分|m<sup>3</sup> m<sup>-3</sup>|XYT|METCRO2D or mcip.nc|yes,但首选从SOIM3D使用|
|SOIT1|soil temperature in top cm，土壤温度|K|XYT|METCRO2D or mcip.nc|yes,但首选从SOIT3D使用|
|SOIT2|soil temperature in top m，土壤温度|K|XYT|METCRO2D or mcip.nc|yes,但首选从SOIT3D使用|
|SLTYP|soil texture type，土壤质地类型|1|XYT|METCRO2D or mcip.nc|yes|
|WWLT_PX|soil wilting point from PX LSM，土壤枯萎点|m<sup>3</sup> m<sup>-3</sup>|XYT|METCRO2D or mcip.nc|no, but used if available|
|WFC_PX|soil field capacity from PX LSM，土壤场容量|m<sup>3</sup> m<sup>-3</sup>|XYT|METCRO2D or mcip.nc|no, but used if available|
|WSAT_PX|soil saturation from PX LSM，土壤饱和度|m<sup>3</sup> m<sup>-3</sup>|XYT|METCRO2D or mcip.nc|no, but used if available|
|CLAY_PX|clay from PX LSM，粘土|1|XYT|METCRO2D or mcip.nc|no, but used if available|
|CSAND_PX|coarse sand from PX LSM，粗砂|1|XYT|METCRO2D or mcip.nc|no, but used if available|
|FMSAND_PX|fine-medium sand from PX LSM，中细砂|1|XYT|METCRO2D or mcip.nc|no, but used if available|
|JACOBF|total Jacobian at layer face，层表面总雅可比|m|XYZT|METCRO3D and METBDY3D, or mcip.nc and mcip_bdy.nc|yes|
|JACOBM|total Jacobian at layer middle，层中部总雅可比|m|XYZT|METCRO3D and METBDY3D, or mcip.nc and mcip_bdy.nc|yes|
|DENSA_J|Jacobian-weighted total air density，雅可比权重总空气密度|kg m<sup>-2</sup>|XYZT|METCRO3D and METBDY3D, or mcip.nc and mcip_bdy.nc|yes|
|WHAT_JD|Jacobian- and density-weighted vertical contravariant velocity，雅可比和密度加权的垂直协变速度|kg m<sup>-1</sup> s<sup>-1</sup>|XYZT|METCRO3D and METBDY3D, or mcip.nc and mcip_bdy.nc|yes|
|TA| air temperature，空气温度|K|XYZT|METCRO3D and METBDY3D, or mcip.nc and mcip_bdy.nc|yes|
|QV| water vapor mixing ratio，水汽混合比|kg kg<sup>-1</sup>|XYZT|METCRO3D and METBDY3D, or mcip.nc and mcip_bdy.nc|yes|
|PRES| air pressure，空气压力|Pa|XYZT|METCRO3D and METBDY3D, or mcip.nc and mcip_bdy.nc|yes|
|DENS| air density，空气密度|kg m<sup>-3</sup>|XYZT|METCRO3D and METBDY3D, or mcip.nc and mcip_bdy.nc|yes|
|WWIND| vertical velocity，垂直速度|m s<sup>-1</sup>|XYZT|METCRO3D and METBDY3D, or mcip.nc and mcip_bdy.nc|yes|
|ZH|mid-layer height above ground，地面以上中层高度|m|XYZT|METCRO3D and METBDY3D, or mcip.nc and mcip_bdy.nc|yes|
|ZF|full layer height above ground，地面以上全层高度|m|XYZT|METCRO3D and METBDY3D, or mcip.nc and mcip_bdy.nc|yes|
|TKE|turbulent kinetic energy，湍流动能|J kg<sup>-1</sup>|XYZT|METCRO3D and METBDY3D, or mcip.nc and met_bdy.nc|no|
|PV|potential vorticity，潜在涡度|m<sup>2</sup> K kg<sup>-1</sup> s<sup>-1</sup> x 10<sup>-6</sup>|XYZT|METCRO3D and METBDY3D, or mcip.nc and mcip_bdy.nc|no, but required for PV scaling|
|WWIND|vertical velocity，垂直速度|m s<sup>-1</sup>|XYZT|METCRO3D and METBDY3D, or mcip.nc and mcip_bdy.nc|no|
|CFRAC_3D|3D resolved cloud fraction，3D解析云分数|1|XYZT|METCRO3D and METBDY3D, or mcip.nc and mcip_bdy.nc|no, but used if available|
|QC|cloud water mixing ratio，云水混合比|kg kg<sup>-1</sup>|XYZT|METCRO3D and METBDY3D, or mcip.nc and mcip_bdy.nc|yes|
|QR|rain water mixing ratio，雨水混合比|kg kg<sup>-1</sup>|XYZT|METCRO3D and METBDY3D, or mcip.nc and mcip_bdy.nc|yes|
|QI|ice mixing ratio，冰混合比|kg kg<sup>-1</sup>|XYZT|METCRO3D and METBDY3D, or mcip.nc and mcip_bdy.nc|no, but used if available|
|QS|snow mixing ratio，雪混合比|kg kg<sup>-1</sup>|XYZT|METCRO3D and METBDY3D, or mcip.nc and mcip_bdy.nc|no, but used if available|
|QG|graupel mixing ratio，霰混合比|kg kg<sup>-1</sup>|XYZT|METCRO3D and METBDY3D, or mcip.nc and mcip_bdy.nc|no, but used if available|
|QC_CU|subgrid cloud water mixing ratio from KF，KF的亚网格云水混合比|kg kg<sup>-1</sup>|XYZT|METCRO3D and METBDY3D, or mcip.nc and mcip_bdy.nc|no; only output if available from WRF; for future development|
|QI_CU|subgrid cloud ice mixing ratio from KF，KF的亚网格云冰混合比|kg kg<sup>-1</sup>|XYZT|METCRO3D and METBDY3D, or mcip.nc and mcip_bdy.nc|no; only output if available from WRF; for future development|
|CLDFRA_DP|subgrid deep cloud fraction，亚网格深云分数|1|XYZT|METCRO3D and METBDY3D, or mcip.nc and mcip_bdy.nc|no; only output if available from WRF; for future development|
|CLDFRA_SH|subgrid shallow cloud fraction，亚网格浅云分数|1|XYZT|METCRO3D and METBDY3D, or mcip.nc and mcip_bdy.nc|no; only output if available from WRF; for future development|
|UWIND|u-component of horizontal wind (cell corners)，水平风的U分量|m s<sup>-1</sup>|XYZT|METDOT3D or mcip.nc|no|
|VWIND|v-component of horizontal wind (cell corners)，水平风的V分量|m s<sup>-1</sup>|XYZT|METDOT3D or mcip.nc|no|
|UHAT_JD|contravariant-U x Jacobian x density|kg m<sup>-1</sup> s<sup>-1</sup> [cell faces; Arakawa-C grid]|XYZT|METDOT3D or mcip.nc|yes|
|VHAT_JD|contravariant-V x Jacobian x density|kg m<sup>-1</sup> s<sup>-1</sup> [cell faces; Arakawa-C grid]|XYZT|METDOT3D or mcip.nc|yes|
|UWINDC|u-component of horizontal wind (west-east cell faces)，水平风的U分量|m s<sup>-1</sup>|XYZT|METDOT3D or mcip.nc|yes|
|VWINDC|v-component of horizontal wind (south-north cell faces)，水平风的V分量|m s<sup>-1</sup>|XYZT|METDOT3D or mcip.nc|yes|
|SOIT3D|soil temperature，土壤温度|K|XYST|SOICRO or mcip.nc|yes|
|SOIM3D|soil moisture，土壤湿度|kg kg<sup>-1</sup>|XYST|SOICRO or mcip.nc|yes|
|LUFRAC2|fractional land use in mosaic categories，镶嵌类别中的土地利用分数|1|XYM|MOSAICCRO or mcip.nc|no,但可以用于STAGE沉积|
|MOSCAT|mosaic land use categories，镶嵌土地利用类别|1|XYM|MOSAICCRO or mcip.nc|no,但可以用于STAGE沉积|
|LAI_MOS|leaf area index (by mosaic categories)，叶面积指数|m<sup>2</sup> m<sup>-2</sup>|XYMT|MOSAICCRO or mcip.nc|no,但可以用于STAGE沉积|
|RAI_MOS|inverse of aerodynamic resistance (by mosaic categories)，空气动力学阻力的倒数|m s<sup>-1</sup>|XYMT|MOSAICCRO or mcip.nc|no,但可以用于STAGE沉积|
|RSI_MOS|inverse of stomatal resistance (by mosaic categories)，气孔阻力的倒数|m s<sup>-1</sup>|XYMT|MOSAICCRO or mcip.nc|no,但可以用于STAGE沉积|
|TSK_MOS|skin temperature (by mosaic categories)，表面温度|K|XYMT|MOSCRO or mcip.nc|no,但可以用于STAGE沉积|
|ZNT_MOS|roughness length (by mosaic categories)，粗糙度长度|m|XYMT|MOSCRO or mcip.nc|no,但可以用于STAGE沉积|



## 4.8 排放输入
<a id=emis_xxx></a>

**EmissCtrl_matrix_nml: 排放控制名称列表**
<a id=emissctrl></a>

<!-- BEGIN COMMENT -->

[返回表4-1](#emissctrl_t)

<!-- END COMMENT -->

除了运行脚本中可用的选项之外，CMAQ现在还可以读取专用的名称列表，以应用全面的规则来读取和缩放排放。默认情况下，“Emission Control Namelist（排放控制名称列表）”被命名为“EmissCtrl.nml”，并且每种机制都有一个单独的版本，因为这些名称列表中预载了可能的规则，这些规则将重要的CMAQ主要物种的排放与其SMOKE输出的典型替代名称相关联。默认情况下，此名称列表存储在每个化学机制文件夹（例如MECHS/cb6r3_ae7_aq）中，并在执行bldit_cctm.csh时复制到用户的构建目录中。如果用户修改了此名称列表的名称或位置，则还应更新运行脚本中的以下命令：
```
setenv EMISSCTRL_NML ${BLD}/EmissCtrl.nml
```

CMAQv5.3随附的“详细的排放比例（The Detailed Emissions Scaling）、隔离和诊断（DESID，Isolation and Diagnostics）”模块为用户提供了全面的可自定义的和透明的排放操作。通过“排放控制名称列表”可以实现排放的自定义，该列表包含四个部分的变量，这些变量可修改排放模块的行为，其中包括***General Specs（一般规格）***，***Emission Scaling Rules（排放缩放规则）***，***Size Distributions（尺寸分布）***，以及***Regions Registry（区域注册）***

* 有关排放基本操作的步骤说明可跳转到[DESID教程]( Tutorials/CMAQ_UG_tutorial_emissions.md )。
* 有关排放的指南可跳转到本用户指南的第六章[排放概述]( CMAQ_UG_ch06_model_configuration_options.md )。


**GR_EMIS_XXX: 排放**

<!-- BEGIN COMMENT -->

[返回表4-1](#emis_xxx_t)

<!-- END COMMENT -->

Used by: CCTM

CMAQ可以接受来自各种排放模型和预处理器的排放输入，只要创建的输入文件与I/O API格式兼容即可。用于准备排放输入的最常用软件是稀疏矩阵操作内核排放（SMOKE）模型，该模型是程序的集合，这些程序分别处理和合并每个排放源的排放数据，以输入到空气质量模型中。

排放文件按模型网格单元和时间提供主要污染物排放速率。文件类型为GRDDED3，气相物质的单位为摩尔/秒（moles s<sup>-1</sup>），气溶胶物质的单位为克/秒（g s<sup>-1</sup>）。文件内数据按以下方式循环：按列、按行、按层、按变量和按输入时间步长。如果GR_EMIS_XXX文件为3D形式，则可以将高架源排放速率作为垂直解析的排放提供给CCTM。网格化的排放文件应分配三位数的数字后缀以标识它们。此后缀用于将排放文件名链接到用户定义的源标签和其他选项（例如GR_EMIS_LAB_XXX、GR_EM_DTOVRD_XXX）。在[第6章]( CMAQ_UG_ch06_model_configuration_options.md )中进一步讨论了链接和修改排放源。

从CMAQv5.3开始，用户可以根据需要使用任意数量的网格排放文件来运行模型，包括零文件。同时需要将N_EMIS_GR运行变量设置为网格化排放文件的数量。

<a id=stk_grps></a>

**STK_GRPS_XXX: Stack groups，排气筒组**

<!-- BEGIN COMMENT -->

[返回表4-1](#stk_grps_t)

<!-- END COMMENT -->

Used by: CCTM – inline emissions version only

XXX标记是唯一用来表示源的标识。确保将N_EMIS_PT运行变量设置为在线排放源（inline emissions）的总数。

排气筒组文件是一个I/O API文件，其中包含高架源的排气筒参数。可以使用SMOKE程序ELEVPOINT创建此文件。有关创建排气筒组文件的其他信息，请参阅SMOKE用户手册中的[ELEVPOINT文档]( https://www.cmascenter.org/smoke/documentation/4.0/html/ch06s03.html )。

<a id=stk_emis></a>

**STK_EMIS_XXX: Point source emissions，点源排放**

<!-- BEGIN COMMENT -->

[返回表4-1](#stk_emis_t)

<!-- END COMMENT -->

Used by: CCTM – inline emissions version only

XXX标记是唯一用来表示源的标识。确保将N_EMIS_PT运行变量设置为在线排放源（inline emissions）的总数。

高架点源排放文件是一个I/O API GRDDED3文件，其中点源的排放被CCTM视为高架源。使用CCTM包含的烟羽抬升算法，该文件中的排放通过垂直模型分层进行分布。可以使用SMOKE创建架点源排放文件。有关准备点源排放以使用CMAQ在线烟羽抬升计算的其他信息，请参阅SMOKE用户手册中的[ELEVPOINT文档]( https://www.cmascenter.org/smoke/documentation/4.0/html/ch06s03.html )。

<a id=nldn_strikes></a>

**NLDN_STRIKES: Hourly observed lightning strikes，每小时观察到的雷击**

<!-- BEGIN COMMENT -->

[返回表4-1](#nldn_strikes_t)

<!-- END COMMENT -->

Used by: CCTM – lightning NO<sub>x</sub> version only

NLDN雷击文件用于根据每小时观察到的雷击次数计算在线NO排放量。每小时的NLDN雷击数据可以从私有供应商处购买。此文件包含插值到建模网格的以下变量：

<a id=Table4-4></a>

 **表4-4  每小时观察到的雷击文件中的变量**

|**变量名称**|**描述**|**单位**|**是否必须**|
 |--------|-------------------|--------------|-----------|
 |LNT|每平方公里的每小时闪电数|km<sup>-2</sup>|yes|

<a id=ltngparm_file></a>

在[第6章]( CMAQ_UG_ch06_model_configuration_options.md )中将进一步讨论在CMAQ模型中使用雷击数据。

**LTNGPARMS_FILE: Lightning parameters file，闪电参数文件**

<!-- BEGIN COMMENT -->

[返回表4-1](#ltngparm_file_t)

<!-- END COMMENT -->

Used by: CCTM – lightning NO<sub>x</sub> version only

闪电参数文件用于根据每小时观察到的闪电次数计算在线NO排放量。
可以从[CMAS数据仓库]( https://drive.google.com/drive/folders/1R8ENVSpQiv4Bt4S0LFuUZWFzr3-jPEeY )下载此文件。

此文件包含插值到建模网格的以下变量：

<a id=Table4-5></a>

**表4-5 闪电参数文件中的变量**

|**变量名称**|**描述**|**单位**|**是否必须**|
|--------|---------------|--------------|-----------|
| SLOPE|linear equation parameter for estimating lightning flash count from hourly convective precipitation，线性方程参数，用于根据每小时对流降水估算闪电次数|unitless|yes|
|INTERCEPT| linear equation parameter for estimating lightning flash count from hourly convective precipitation，线性方程参数，用于根据每小时对流降水估算闪电次数|km<sup>-2</sup>*|yes|
|SLOPE_lg| logarithmic equation parameter for estimating lightning flash count from hourly convective precipitation，对数方程参数，用于从每小时对流降水中估算闪电计数|unitless|yes|
|INTERCEPT_lg| logarithmic equation parameter for estimating lightning flash count from hourly convective precipitation，对数方程参数，用于从每小时对流降水中估算闪电计数|km<sup>-2</sup>*|yes|
|ICCG_SUM| Ratio of intercloud to cloud-to-ground flashes during the summer season，夏季云间闪电与云向地面闪电的比率|unitless|yes|
|ICCG_WIN| Ratio of intercloud to cloud-to-ground flashes during the winter season，夏季云间闪电与云向地面闪电的比率|unitless|yes|
|OCNMASK| Land/water mask to remove spurious flashes over the ocean，陆地/水面罩，用于消除海洋上的假闪电|unitless|yes|

*回归方程生成每平方公里每厘米对流降水的闪电数量（或对数闪电数量）。

在[第6章]( CMAQ_UG_ch06_model_configuration_options.md )中将进一步讨论在CMAQ模型中使用闪电数据。

## 4.9 生物源和地表输入

<a id=ocean_1></a>

**OCEAN_1: Sea spray mask，海洋排放罩**

<!-- BEGIN COMMENT -->

[返回表4-1](#ocean_1_t)

<!-- END COMMENT -->

Used by: CCTM

CMAQ海浪排放模块需要输入海洋排放罩文件（OCEAN）。 OCEAN是一个不随时间变化的I/O API文件，用于标识分配给开放海域（OPEN）或碎浪带（SURF）的每个模型网格单元中的覆盖率分数[0-1]。CCTM使用此覆盖信息在运行期间从模型网格单元在线计算海浪排放通量。

此外，除cb6r3m_ae7_kmtbr以外，CMAQ的气相化学机理还包含有效的一次卤族元素导致的臭氧在海洋上的损失（当输入的OPEN+SURF>0.0时）。此过程也需要OCEAN文件。cb6r3m_ae7_kmtbr机制包含更明确的海洋化学，但还需要OCEAN文件。

有关创建此文件的步骤说明，请参见[CMAQ海洋文件教程]( Tutorials/CMAQ_UG_tutorial_oceanfile.md ) 。

<a id=gspro></a>
**GSPRO: Speciation profiles，物种概况**
<!-- BEGIN COMMENT -->
[返回表4-1](#gspro_t)
<!-- END COMMENT -->

Used by: CCTM – online biogenics emissions version only

物种概况文件GSPRO包含用于将汇总的清单污染物排放总量分离为CMAQ要求格式的模型物种排放的因子。如果仅在CMAQ中在线计算生物排放，则CCTM使用的GSPRO文件仅需要包含B3GRD文件中输入的生物VOC排放的分解因子。如果CCTM同时计算其他排放源，则这些其他排放源的VOC分配因子必须包含在GSPRO文件中。GSPRO文件格式在SMOKE用户手册中列出，请参阅[GSPRO文档]( https://www.cmascenter.org/smoke/documentation/4.0/html/ch08s05s02.html )。

<a id=b3grd></a>
**B3GRD: Gridded, normalized biogenic emissions，网格化归一化生物源排放**
<!-- BEGIN COMMENT -->
[返回表4-1](#b3grd_t)
<!-- END COMMENT -->

Used by: CCTM – online biogenics emissions version only

一个I/O API GRDDED3文件，其中包含网格化、归一化的生物源排放量（每小时碳或氮的克数，具体取决于物种）和叶面积指数。B3GRD文件包含使用夏季和冬季排放因子计算的归一化排放。B3GRD文件由SMOKE程序NORMBEIS3使用网格化的土地利用数据生成。有关创建B3GRD文件的其他信息，请参阅SMOKE用户手册中的[NORMBEIS3文档]( https://www.cmascenter.org/smoke/documentation/4.0/html/ch06s12.html )。

<a id=bioseason></a>
**BIOSEASON: Freeze dates，冰冻日期**
<!-- BEGIN COMMENT -->
[返回表4-1](#bioseason_t)
<!-- END COMMENT -->

Used by: CCTM – online biogenics emissions version only

BIOSEASON开关文件是一个I/O API GRDDED3文件，用于指示在建模区域中每个网格单元在给定年份的每一天中使用哪种生物源排放因子。可以使用随SMOKE一起分发的Metscan实用程序来创建此文件。BIOSEASON文件是时间相关的，通常包含一整年（365天或366天）的数据。它使用一个变量SEASON，该变量可以为0（当天网格单元使用冬季因子）或1（当天网格单元使用夏季因子）。有关创建BIOSEASON文件的其他信息，请参阅SMOKE用户手册中的[Metscan文档]( https://www.cmascenter.org/smoke/documentation/4.0/html/ch05s03s10.html )。

<a id=e2c_lu></a>
**E2C_LU – Fractional crop distributions，农作物分布分数**
<!-- BEGIN COMMENT -->
[返回表4-1](#e2c_lu_t)
<!-- END COMMENT -->

Used by: CCTM – bidirectional NH<sub>3</sub> flux version only

包括农作物和树木分数的土地使用数据分布栅格化到建模区域。通过FEST-C界面中的BELD4数据生成工具为美国本土范围内的EPIC模拟生成土地使用数据时，会创建此数据集。有关该工具和FEST-C界面的详细信息，请访问： https://www.cmascenter.org/fest-c/


<a id="e2c_soil"></a>
**E2C_SOIL – EPIC soil properties，EPIC土壤特性**
<!-- BEGIN COMMENT -->
[返回表4-1](#e2c_soil_t)
<!-- END COMMENT -->

Used by: CCTM – bidirectional NH<sub>3</sub> flux version only

此3-D文件由EPIC to CMAQ工具通过FEST-C界面创建。它包含第1层（深度为0到1厘米）和第2层（深度为1厘米到100厘米）以及农用地网格单元中每种农作物的土壤属性。有关EPIC模拟和FEST-C界面的更多信息，请访问： https://www.cmascenter.org/fest-c/

<a id="e2c_chem"></a>
**E2C_CHEM – EPIC crop types and fertilizer application，EPIC农作物类型和肥料施用**
<!-- BEGIN COMMENT -->
[返回表4-1](#e2c_chem_t)
<!-- END COMMENT -->

Used by: CCTM – bidirectional NH<sub>3</sub> flux version only

这是一种3D逐日文件，由EPIC to CMAQ工具通过FEST-C界面创建。该工具提取EPIC模拟的土壤化学信息，包括第1层和第2层土壤剖面的施肥，以及每个农用地网格单元中的植物生长信息。FEST-C界面有助于在美国本土范围内对任何CMAQ建模区域进行EPIC模拟。有关EPIC模拟和FEST-C界面的更多信息，请访问： https://www.cmascenter.org/fest-c/

<a id="dust_lu_1"></a>
**DUST_LU_1 – Gridded land cover/land use，网格化的土地覆盖/地利用**
<!-- BEGIN COMMENT -->
[返回表4-1](#dust_lu_1_t)
<!-- END COMMENT -->

Used by: CCTM – windblown dust version only

网格化的土地覆盖/土地利用（LCLU）文件是投影到建模区域的BELD3数据，是一种I/O API GRDDED3格式文件。该文件必须包含以下LCLU变量才能与CMAQ灰尘模块兼容：

-   USGS_urban，城市
-   USGS_drycrop，旱地
-   USGS_irrcrop，水浇地
-   USGS_cropgrass，饲料作物
-   USGS_cropwdlnd，
-   USGS_grassland，草地
-   USGS_shrubland，灌木丛
-   USGS_shrubgrass，灌木草地
-   USGS_savanna，大草原
-   USGS_decidforest，落叶林
-   USGS_evbrdleaf，
-   USGS_coniferfor，针叶林
-   USGS_mxforest，混合林
-   USGS_water，水面
-   USGS_wetwoods，湿木
-   USGS_sprsbarren，
-   USGS_woodtundr，
-   USGS_mxtundra，混合苔原
-   USGS_snowice，冰雪

这些类别用于确定粉尘源位置和冠层清除因子，以估算模型中的粉尘排放量。可以使用空间分配器（Spatial Allocator，SA）和BELD3 tiles为北美地区创建此文件。DUST_LU_1文件对应于空间分配器的“a”输出文件。有关详细信息，请参见《空间分配器用户指南》中有关[为SMOKE创建生物输入]( https://www.cmascenter.org/sa-tools/documentation/4.2/html/smoke_bio_inputs.html )和[生成BELD3数据进行生物排放处理]( https://www.cmascenter.org/sa-tools/documentation/4.2/html/scripts_test.html )的章节。

<a id="dust_lu_2"></a>
**DUST_LU_2 – BELD land use “TOT” data file**
<!-- BEGIN COMMENT -->
[返回表4-1](#dust_lu_1_t)
<!-- END COMMENT -->

Used by: CCTM – windblown dust version only

网格化的土地覆盖/土地利用（LCLU）文件是投影到建模区域的BELD3数据，是一种I/O API GRDDED3格式文件。该文件必须包含以下LCLU变量才能与CMAQ灰尘模块兼容：

-   FOREST，森林

该变量与DUST_LU_1文件中的变量结合使用，用于估算模型中粉尘排放量的冠层清除因子。可以使用空间分配器（Spatial Allocator，SA）和BELD4 tiles为北美地区创建此文件。DUST_LU_2文件对应于空间分配器的“tot”输出文件。有关详细信息，请参见《空间分配器用户指南》中有关[为SMOKE创建生物输入]( https://www.cmascenter.org/sa-tools/documentation/4.2/html/smoke_bio_inputs.html )和[为生物排放处理生成BELD3数据]( https://www.cmascenter.org/sa-tools/documentation/4.2/html/scripts_test.html )的章节。另请注意，2020年3月12日之前，空间分配器软件包中附带的“tot”输入文件包含了不正确的FOREST变量值。包含更正后的“tot”文件的空间分配器输入数据的更新文件已发布在CMAS数据仓库上，可以通过[此链接]( https://drive.google.com/file/d/1wUo0E45U6o_JNoxmnx1Cxv89LsvENTrI/view )访问。

## 4.10 光解输入

<a id=omi></a>

**OMI: Ozone Monitoring Instrument Column Data，臭氧监测仪器列数据**

<!-- BEGIN COMMENT -->

[返回表4-1](#omi_t)

<!-- END COMMENT -->

Used by: CCTM

OMI臭氧列数据（按纬度和经度）用于光解计算。CMAQ附带了从1978年到2019年的[臭氧列](../../CCTM/src/phot/inline/OMI_1979_to_2019.dat)。 数据为以Dobson单位表示的22.5°×10°网格臭氧列。PREP文件夹下的[create_omi]( ../../PREP/create_omi/README.md )工具可用于创建用于支持2019年以后模拟的数据文件，或具有更精细空间分辨率的数据文件。

<!-- BEGIN COMMENT -->
 [<< 前一章](CMAQ_UG_ch03_preparing_compute_environment.md) - [返回](README.md) - [下一章 >>](CMAQ_UG_ch05_running_a_simulation.md)
 
 CMAQ用户指南 (c) 2020<br>

<!-- END COMMENT -->
