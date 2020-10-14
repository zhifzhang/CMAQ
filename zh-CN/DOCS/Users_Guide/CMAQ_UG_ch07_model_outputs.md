
<!-- BEGIN COMMENT -->

[<< 前一章](CMAQ_UG_ch06_model_configuration_options.md) - [返回](README.md) - [下一章 >>](CMAQ_UG_ch08_analysis_tools.md)

<!-- END COMMENT -->

# 7 模型输出文件

## 7.1 简介
在本节中，提供了有关常规CCTM输出文件的详细信息。所有CMAQ程序都会生成符合netCDF格式的模型输出文件。除了模型输出数据外，CMAQ还可以选择生成ASCII日志文件，其中包含来自各种CMAQ进程的中间模型执行信息，并根据处理器编号进行分别记录。如果用户未选择输出日志文件选项，且采用交互运行方式运行模型，则CMAQ会在运行过程中将所有日志信息和标准错误一起显示在屏幕上，可以使用基本UNIX语法将其捕获到文本文件中。另外，在使用“过程分析”（PA），“综合源分配方法”（ISAM）和“详细排放量缩放、隔离和诊断模块”（DESID）选项时，还会创建其他输出文件。与这些选项相关的文件分别在[第9章](CMAQ_UG_ch09_process_analysis.md)，[第11章](CMAQ_UG_ch11_ISAM.md)和[附录B](Appendix/CMAQ_UG_appendixB_emissions_control.md)中进行了讨论。

<a id=Output_Table></a>
<a id=Table7-1></a>

**表7-1. CMAQ输出文件**

|**文件名称<sup>1</sup>**|**文件类型**|**Time-Dependence<sup>2</sup>**|**Spatial Dimensions<sup>3</sup>** |
|----------------------------|------|----|-----------------------------------|
|**标准输出文件**| | | |
|[Output Log](#cmaq_output_log) <a id=cmaq_output_log_t></a>|ASCII|n/a|n/a
|[CCTM_CONC](#conc)<a id=conc_t></a>|GRDDED3|Hourly|XYZ'
|[CCTM_ACONC](#aconc) <a id=aconc_t></a>|GRDDED3|Hourly|XYZ'
|[CCTM_DRYDEP](#drydep) <a id=drydep_t></a>|GRDDED3|Hourly|XY
|[CCTM_WETDEP1](#wetdep) <a id=wetdep_t></a>|GRDDED3|Hourly|XY
|**重启动文件**| | | |
|[CCTM_CGRID](#cgrid) <a id=cgrid_t></a>|GRDDED3|1-hour|XYZ
|[CCTM_MEDIA](#media)<a id=media_t></a>|GRDDED3|Hourly|XY
|[CCTM_SOILOUT](#soilout) <a id=soilout_t></a>|GRDDED3|n/a (请参阅下面的详细文件说明)|XY
|**诊断和高级输出文件**| | | |
|[FLOOR](#floor) <a id=floor_t></a>|ASCII|n/a|n/a
|[CCTM_PMDIAG](#pmdiag) <a id=pmdiag_t></a>|GRDDED3|Hourly|XYZ'
|[CCTM_APMDIAG](#apmdiag) <a id=apmdiag_t></a>|GRDDED3|Hourly|XYZ'
|[CCTM_B3GTS_S](#b3gts) <a id=b3gts_t></a>|GRDDED3|Hourly| XY
|[CCTM_DEPV](#depv) <a id=depv_t></a>|GRDDED3|Hourly|XY
|[CCTM_PT3D](#pt3d) <a id=pt3d_t></a>|GRDDED3|Hourly|XYZ
|[CCTM_DUSTEMIS](#dust) <a id=dust_t></a>|GRDDED3|Hourly|XY
|[CCTM_DEPVMOS](#depv_mos) <a id=depv_mos_t></a>|GRDDED3|Hourly|XYW
|[CCTM_DEPVFST](#depv_fst) <a id=depv_fst_t></a>|GRDDED3|Hourly|XYW
|[CCTM_DDEP_MOS](#dry_dep_mos) <a id=dry_dep_mos_t></a>|GRDDED3|Hourly|XYW
|[CCTM_DDEP_FST](#dry_dep_fst) <a id=dry_dep_fst_t></a>|GRDDED3|Hourly|XYW
|[CCTM_LTNGHRLY](#ltngdiag1) <a id=ltngdiag1_t></a>|GRDDED3|Hourly|XYZ
|[CCTM_LTNGCOL](#ltngdiag2) <a id=ltngdiag2_t></a>|GRDDED3|Hourly|XY
|[CCTM_PHOTDIAG1](#ctm_rj_1) <a id=ctm_rj1_t></a>|GRDDED3|Hourly|XY
|[CCTM_PHOTDIAG2](#ctm_rj_2) <a id=ctm_rj2_t></a>|GRDDED3|Hourly|XYZ'
|[CCTM_PHOTDIAG3](#ctm_rj_3) <a id=ctm_rj3_t></a>|GRDDED3|Hourly|XYZ'
|[CCTM_SSEMIS](#ssemis) <a id=ssemis_t></a>|GRDDED3|Hourly|XY
|[CCTM_WETDEP2](#wetdep2) <a id=wetdep2_t></a>|GRDDED3|Hourly|XY
|[CCTM_VEXT](#vext) <a id=vext_t></a>|GRDDED3|Hourly|WZ

<sup>1</sup>默认情况下，输出文件名为CCTM_XXX_${CTM_APPL}.nc，其中XXX是文件标识符，而${CTM_APPL}是用户自定义的字符串，用于标识模型运行。

<sup>2</sup>虽然显示“每小时（Hourly）”，但用户可以通过更改运行脚本中的TSTEP变量来为模型输出定义不同的时间步长（例如30分钟）。因此从这里开始，术语“每小时（Hourly）”将用于描述目的。

<sup>3</sup>X是沿x轴的尺度，Y是沿y轴的尺度，Z是垂直尺度，Z'是用户预定义的垂直尺度（通过环境变量ONC_BLEV_ELEV，ACONC_BLEV_ELEV，APMDIAG_BLEV_ELEV和NLAYS_PHOTDIAG控制，范围从1到所有层），W是非层（non-layer）的尺度，例如LU分数的数量，垂直提取的点位的数量。

<sup>4</sup>特殊的ASCII输出文件FLOOR_xxx，其中xxx为处理器编号，包含模拟结果为负浓度时的信息。

## 7.2 CCTM标准输出文件

CCTM创建的某些输出文件属于标准输出文件，因为它们包含每小时浓度和沉降量以及记录运行的信息。这些文件的选项由CCTM运行脚本（如run_cctm.csh）中相应的环境变量控制。
<a id=cmaq_output_log></a>

**CMAQ输出日志**
<!-- BEGIN COMMENT -->
[返回表7-1](#cmaq_output_log_t)
<!-- END COMMENT -->
所有的CMAQ程序在执行期间都会生成标准输出文件和标准错误。当您以交互式运行CMAQ可执行文件时，可以使用UNIX重定向命令将诊断输出信息捕获到日志文件中：

```
run.cctm >& tee cctm.log
```


LOGFILE环境变量允许用户指定用于捕获程序标准输出的日志文件的名称。如果未设置此变量，则将标准输出写入终端显示，并可以使用UNIX重定向命令（“>”）捕获，如上例所示。

<a id=conc></a>

**CCTM_CONC：每小时瞬时浓度文件**
<!-- BEGIN COMMENT -->
[返回表7-1](#conc_t)
<!-- END COMMENT -->

2D或3D的CCTM小时浓度文件（CONC）包含每个模拟时间步长末尾输出的瞬时气相物质的混合比（ppmV）和气溶胶物种浓度（µg m<sup>-3</sup>）。CONC文件中包含的物种数量和类型取决于编译CCTM时选择的化学机理和气溶胶模型配置。化学机理文件夹中的[物种名称清单文件（NameList）](CMAQ_UG_ch04_model_inputs.md#matrix_nml)列出了用于建模的物种，并包含指定将哪些物种写入CONC文件的列（例如[AE_cb6r3_ae7_aq.nml](../../CCTM/src/MECHS/cb6r3_ae7_aq/AE_cb6r3_ae7_aq.nml)）。GC_*mechname*.nml文件列出了气相物种，AE_*mechname*.nml文件列出了气溶胶物种，而NR_*mechname*.nml文件列出了非反应性（惰性）物种。可以通过编辑NameList文件中的CONC列来从CONC文件中删除物种，以减少写入的物种数量，从而减少CONC文件的大小。用户还可以通过修改运行脚本中的环境变量CONC_SPCS来指定输出的物种列表（包括温度、压力和相对湿度），该环境变量将覆盖NameList文件中CONC列的设置。默认情况下，所有模拟层的浓度都输出到CONC文件中。用户可以使用运行脚本中的CONC_BLEV_ELEV环境变量指定要输出的层，其中BLEV对应于最底层的编号，而ELEV对应于最顶层的编号。


<a id=aconc></a>

**CCTM_ACONC：每小时平均浓度文件**
<!-- BEGIN COMMENT -->
[返回表7-1](#aconc_t)
<!-- END COMMENT -->

2D或3D的CCTM积分平均浓度文件包含每个模拟小时的平均模拟物种浓度，而不是每个输出时间步长结束时的瞬时浓度。用户可在CCTM的运行脚本中使用环境变量AVG_CONC_SPCS设置写入ACONC文件的物种。还可以在CCTM的运行脚本中使用环境变量ACONC_BLEV_ELEV设置输出的每小时平均浓度的模型层数，其中BLEV对应于最底层的编号，而ELEV对应于最顶层的编号。ACONC_BLEV_ELEV变量的示例设置为“1 6”，它将第1层至第6层定义为垂直输出范围，该范围内各层上的每小时平均浓度将会写入ACONC文件。

<a id=drydep></a>

**CCTM_DRYDEP：每小时累积干沉降文件**
<!-- BEGIN COMMENT -->
[返回表7-1](#drydep_t)
<!-- END COMMENT -->

2D的CCTM干沉降文件包含所选模型物种的每小时累积干沉降通量(kg 公顷<sup>-1</sup>)。CCTM为化学机理文件夹中的[物种名称清单文件（NameList）](CMAQ_UG_ch04_model_inputs.md#matrix_nml)的“干沉降列”中列出的所有物种计算干沉降。GC_*mechname*.nml文件列出了气相物种，AE_*mechname*.nml文件列出了气溶胶物种，而NR_*mechname*.nml文件列出了非反应性（惰性）物种。通过编辑NameList文件中的DDEP列，可以从干沉降文件中除去物种。

##### CCTM_DRYDEP中的NH<sub>3</sub>通量组成

CMAQ v5.3和更高版本包含两个用于计算干沉降/表面交换的编译选项：M3DRY和STAGE。（有关更多信息，请参见[6.8节]( CMAQ_UG_ch06_model_configuration_options.md#68-dry-depositionair-surface-exchange ) 。M3DRY和STAGE都支持对氨气双向表面通量进行模拟。在CCTM_DRYDEP文件中NH<sub>3</sub>通量组成的定义取决于是否启用了双向NH<sub>3</sub>通量选项（一个运行选项，可通过将CTM_ABFLUX设置为Y或N来控制）。在未启用双向NH<sub>3</sub>通量选项（CTM_ABFLUX设置为N）的情况下运行模型时，CCTM_DRYDEP文件中的变量NH3代表STAGE和M3DRY中的单向氨干沉降通量。

在将CTM_ABFLUX设置为Y的情况下运行模型时，CCTM_DRYDEP文件将包含其他NH3通量组成。变量名称和定义详见表7-2。请注意，这些变量定义可能与CMAQ v5.3.2之前的版本中使用的定义不一致。

<a id=Table7-2></a>

**表7-2 启用氨双向表面通量后CCTM_DRYDEP输出文件中的NH3通量组成**

|**变量名称**|**变量描述**|
|:----:|:----------------------------:|
|NH3|向下沉降通量（始终为正）|	
|NH3_Emis|向上排放通量（始终为正）|  
|NH3_Flux|净通量（如果向下则为正，如果向上则为负）| 
|NH3_Stom*|来自叶片气孔途径的NH3通量（正值为排放，负值为沉积）|
|NH3_Cut*|来自叶片表皮途径的NH3通量（正值为排放，负值为沉积）|
|NH3_Soil*|来自土壤途径的NH3通量（正值为排放，负值为沉积）|
|NH3_Ag*|农业土地利用上的NH3通量（正值为排放，负值为沉积）|
|NH3_Nat*|非农业土地利用上的NH3通量（正值为排放，负值为沉积）|
|NH3_Wat*|水体上的NH3通量（正值为排放，负值为沉积）|

\*当使用STAGE干沉积选项并启用了双向氨通量时，可以使用更多的诊断沉积值。

<a id=wetdep></a>

**CCTM_WETDEP1：每小时累积湿沉降文件**
<!-- BEGIN COMMENT -->
[返回表7-1](#wetdep_t)
<!-- END COMMENT -->

2D的CCTM湿沉降文件包含所选模型物种的每小时累积湿沉降通量(kg 公顷<sup>-1</sup>)。CCTM为化学机理文件夹中的[物种名称清单文件（NameList）](CMAQ_UG_ch04_model_inputs.md#matrix_nml)的“湿沉降列”中列出的所有物种计算湿沉降。GC_*mechname*.nml文件列出了气相物种，AE_*mechname*.nml文件列出了气溶胶物种，而NR_*mechname*.nml文件列出了非反应性（惰性）物种。通过编辑NameList文件中的WDEP列，可以从湿沉积文件中除去物种。

## 7.3 CCTM重启动文件

CCTM可以创建多个文件，用于在任何特定的日期重新开始运行CCTM。这些文件包含一天结束时参数的值，这些参数用于初始化第二天开始计算的值。

<a id=cgrid></a>

**CCTM_CGRID：网格浓度重启动文件**
<!-- BEGIN COMMENT -->
[返回表7-1](#cgrid_t)
<!-- END COMMENT -->

3D的CCTM结束浓度文件包含每个模拟周期结束时的气相物质混合比（ppmV）和气溶胶物质浓度(µg m<sup>-3</sup>)。输出CGRID文件中包含的物种数量和类型取决于编译CCTM时选择的化学机理和气溶胶模型配置。该文件可用于从模型完成时的时间初始化CCTM运行。例如，如果CCTM配置为生成每日输出文件，则将在每个模拟日结束时写入CGRID文件。这些浓度随后成为下一个模拟周期的初始条件。

<a id=media></a>

**CCTM_MEDIA：双向建模媒介中浓度文件**
<!-- BEGIN COMMENT -->
[返回表7-1](#media_t)
<!-- END COMMENT -->

此2D的CCTM文件包含土壤NH<sub>4</sub><sup>+</sup>浓度和pH值，和/或土壤、植被和水体Hg浓度。仅当CCTM运行脚本中的CTM_ABFLUX环境变量或CTM_HGBIDI变量设置为Y（默认值为N）时，才会创建本文件，本文件将用于初始化第二天的模型模拟。

<a id=soilout></a>

**CCTM_SOILOUT：每小时降雨量文件**
<!-- BEGIN COMMENT -->
[返回表7-1](#soilout_t)
<!-- END COMMENT -->

这个可选的2D的CCTM文件包含每小时的总降雨量信息，供CCTM内联（in-line）生物源模块使用。它在每个模拟日结束时被写出，并且仅在CCTM运行脚本中的CTM_BIOGEMIS环境变量设置为Y（默认为N）时创建。除了模拟的第一天，当环境变量INITIAL_RUN设置为Y时，文件中包含的前一天的降雨信息将用于CCTM内联（in-line）生物源模块计算土壤NO排放量。这是通过将运行脚本中给定日期的SOILINP环境变量设置为前一天模拟结束时创建的CCTM_SOILOUT文件来实现的。请注意，即使此文件包含24小时的栅格化降雨字段，它仍具有与时间无关的文件结构，并将这24个值存储为24个独立的与时间无关的变量（RAINFALL01、...、RAINFALL24）。尽管文件的结构与时间无关，但由于气象每天变化，因此每天的CCTM_SOILOUT文件都是唯一的。所以必须注意确保给定日期指定的SOILINP文件确实是前一天而不是另一天的CCTM_SOILOUT文件。


## 7.4 CMAQ诊断和高级输出文件

除了上一节中详细介绍的标准输出文件外，还可以将CCTM配置为输出多个辅助文件以用于诊断模型。每个选项均由CCTM运行脚本（如run_cctm.csh）中相应的环境变量控制。对于逻辑值，TRUE/T等效于Y，FALSE/F等效于N。

请注意，I/O API v3.2最多支持MXFILE3=64个打开文件，每个文件最多MXVARS3=2048。打开CMAQ所有诊断和高级输出文件可能会超过I/O API v3.2打开文件的上限，从而导致模型崩溃。为避免此问题，用户可以使用I/O API v3.2-large，它将MXFILE3增加到512，将MXVARS3增加到16384。可以从以下地址获得此版本的压缩包：

https://www.cmascenter.org/ioapi/download/ioapi-3.2-large.tar.gz

I/O API v3.2-large的安装说明在压缩包的README.txt中提供。

<a id=floor></a>

**FLOOR：浓度重置诊断文件**
<!-- BEGIN COMMENT -->
[返回表7-1](#floor_t)
<!-- END COMMENT -->

这个可选的ASCII文件包含特定的网格单元/时间步长，其中负浓度的物种浓度被重置为零。文件的位置和名称由FLOOR_FILE环境变量设置。

<a id=pmdiag></a>

**CCTM_PMDIAG：每小时瞬时气溶胶诊断文件**
<!-- BEGIN COMMENT -->
[返回表7-1](#pmdiag_t)
<!-- END COMMENT -->

该可选的2D或3D的CCTM诊断文件包含每个模拟小时结束时的瞬时信息，包括几何平均直径、几何标准偏差、堆积密度、对数正态模式的第二矩和第三矩。该文件还包括每种模式对PM1、PM2.5和PM10的贡献比例以及每种模式的AMS传输系数。还提供了许多与异质化学有关的诊断，包括N<sub>2</sub>O<sub>5</sub>反应概率，ClNO<sub>2</sub>反应收率和IEPOX吸收系数。在输出文件中指定所有变量的单位。此输出文件中的层数由运行脚本中的CONC_BLEV_ELEV环境变量的设置确定。仅当运行脚本中的CTM_APMDIAG环境变量设置为Y（默认值为N）时，才创建此文件。

<a id=apmdiag></a>

**CCTM_APMDIAG：每小时平均气溶胶诊断文件**
<!-- BEGIN COMMENT -->
[返回表7-1](#apmdiag_t)
<!-- END COMMENT -->

该可选的2D或3D的CCTM诊断文件包含每个模拟小时的积分平均信息，包括几何平均直径、几何标准偏差、堆积密度、对数正态模式的第二矩和第三矩。该文件还包括每种模式对PM1、PM2.5和PM10的贡献比例以及每种模式的AMS传输系数。还提供了许多与异质化学有关的诊断，包括N<sub>2</sub>O<sub>5</sub>反应概率，ClNO<sub>2</sub>反应收率和IEPOX吸收系数。在输出文件中指定所有变量的单位。此输出文件中的层数由运行脚本中的APMDIAG_BLEV_ELEV环境变量的设置确定。仅当运行脚本中的CTM_APMDIAG环境变量设置为Y（默认值为N）时，才创建此文件。

<a id=b3gts></a>

**CCTM_B3GTS_S：生物源排放诊断文件**
<!-- BEGIN COMMENT -->
[返回表7-1](#b3gts_t)
<!-- END COMMENT -->

当CTM_BIOGEMIS环境变量设置为Y时，此可选的2D的CCTM每小时输出文件包含CCTM实时（in-line）计算的总的每小时生物源排放（质量单位）。仅当运行脚本中的B3GTS_DIAG环境变量设置为Y时（默认为Y），才创建此文件。

<a id=depv></a>

**CCTM_DEPV：实时（in-line）沉降诊断文件**
<!-- BEGIN COMMENT -->
[返回表7-1](#depv_t)
<!-- END COMMENT -->

该可选的2D的CCTM文件包含每小时的最后时间步长上计算出的每种化学物质的沉降速度（m/s）。CCTM为化学机理文件夹中的[物种名称清单文件（NameList）](CMAQ_UG_ch04_model_inputs.md#matrix_nml)的“沉降速度列”中列出的所有物种计算沉降速度。GC_*mechname*.nml文件列出了气相物种，AE_*mechname*.nml文件列出了气溶胶物种，而NR_*mechname*.nml文件列出了非反应性（惰性）物种。通过编辑NameList文件中的DDEP列，可以从沉降速度文件中除去物种。仅当运行脚本中的CTM_DEPV_FILE环境变量设置为Y（默认为N）时，才创建此文件。

<a id=pt3d></a>

**CCTM_PT3D：点源排放诊断文件**
<!-- BEGIN COMMENT -->
[返回表7-1](#pt3d_t)
<!-- END COMMENT -->

该可选的3D的CCTM文件将每一层的3D点源排放记录为输出时间步长上的线性平均值。仅当运行脚本中的PT3DDIAG环境变量设置为Y（默认值为N）时，才创建此文件。

<a id=dust></a>

**CCTM_DUSTEMIS：风吹起尘排放诊断文件**
<!-- BEGIN COMMENT -->
[返回表7-1](#dust_t)
<!-- END COMMENT -->

当CTM_WB_DUST环境变量设置为Y时，此可选的2D的CCTM每小时输出文件包含由CCTM实时计算的风吹粉尘排放量（质量单位）。仅当运行脚本中的CTM_DUSTEM_DIAG环境变量设置为Y（默认值为N），才创建此文件。

<a id=depv_mos></a>

**CCTM_DEPVMOS：特定于土地利用的沉降速度文件**
<!-- BEGIN COMMENT -->
[返回表7-1](#depv_mos_t)
<!-- END COMMENT -->

这个可选的3D的CCTM文件包含网格单元中每种土地使用类型的每小时最后时间步长的沉降速度（m s<sup>-1</sup>）。在该输出文件中，土地利用类别为第3维（即相当于浓度输出文件中的层）。因此，对于使用NLCD土地利用类别系统的模型运行，文件将有40个“层”。仅当编译构建脚本（BuildScript）中的DepMod环境变量设置为stage（而不是m3dry）并且运行脚本（RunScript）中的CTM_MOSAIC环境变量设置为Y（默认值为N）时，才创建此文件。


<a id=dry_dep_mos></a>

**CCTM_DDMOS：特定于土地利用的沉降通量文件**
<!-- BEGIN COMMENT -->
[返回表7-1](#dry_dep_mos_t)
<!-- END COMMENT -->

此可选的3D的CCTM文件包含每个网格单元中每种土地使用类型的小时总沉积量（kg公顷<sup>-1</sup>）。在该输出文件中，土地利用类别为第3维（即相当于浓度输出文件中的层）。因此，对于使用NLCD土地使用类别系统的模型运行，文件将有40个“层”。仅当编译构建脚本（BuildScript）中的ModDepv环境变量设置为stage（而不是m3dry）并且运行脚本（RunScript）中的CTM_MOSAIC环境变量设置为Y（默认值为N）时，才创建此文件。


<a id=depv_fst></a>

**CCTM_DEPVFST：气孔沉降速度文件**
<!-- BEGIN COMMENT -->
[返回表7-1](#depv_fst_t)
<!-- END COMMENT -->

对于网格单元内每种土地利用类型，此可选的3D的CCTM文件包含每小时的最后时间步长通过气孔途径的沉降速度（m s<sup>-1</sup>）。在该输出文件中，土地利用类别为第3维（即相当于浓度输出文件中的层）。因此，对于使用NLCD土地使用类别系统的模型运行，文件将有40个“层”。仅当编译构建脚本（BuildScript）中的ModDepv环境变量设置为stage（而不是m3dry）并且运行脚本（RunScript）中的CTM_FST环境变量设置为Y（默认值为N）时，才创建此文件。

<a id=dry_dep_fst></a>

**CCTM_DDFST：气孔通量文件**
<!-- BEGIN COMMENT -->
[返回表7-1](#dry_dep_fst_t)
<!-- END COMMENT -->

该可选的3D的CCTM文件包含每个网格单元中每种土地利用类型在一个小时内通过气孔途径的总沉降量（kg公顷<sup>-1</sup>）。在该输出文件中，土地利用类别为第3维（即相当于浓度输出文件中的层）。因此，对于使用NLCD土地使用类别系统的模型运行，文件将有40个“层”。仅当编译构建脚本（BuildScript）中的ModDepv环境变量设置为stage（而不是m3dry）并且运行脚本（RunScript）中的CTM_FST环境变量设置为Y（默认值为N）时，才创建此文件。

<a id=ltngdiag1></a>

**CCTM_LTNGHRLY：每小时闪电源排放文件**
<!-- BEGIN COMMENT -->
[返回表7-1](#ltngdiag1_t)
<!-- END COMMENT -->

当将CTM_LTNG_NO环境变量设置为Y时，此可选的3D的CCTM文件包含由CCTM实时（in-line）计算的每小时闪电NO排放（mol/s）。仅当运行脚本中的CTM_LTNGDIAG_1环境变量设置为Y（默认为N）时，才创建此文件。

<a id=ltngdiag2></a>

**CCTM_LTNGCOL：每小时总列（column-total）闪电源排放文件**
<!-- BEGIN COMMENT -->
[返回表7-1](#ltngdiag2_t)
<!-- END COMMENT -->

将CTM_LTNG_NO环境变量设置为Y时，此可选的2D的CCTM文件包含CCTM实时（in-line）计算的每小时总列（column-total）闪电NO排放量（mol/s）。仅当运行脚本中的CTM_LTNGDIAG_2环境变量为设置为Y（默认为N）时，才创建此文件。

<a id=ctm_rj1></a>

**CCTM_PHOTDIAG1：实时光解输入和输出-摘要文件**
<!-- BEGIN COMMENT -->
[返回表7-1](#ctm_rj1_t)
<!-- END COMMENT -->

此可选的2D的CCTM文件包含用于光解计算的常规摘要信息，包括表面反照率、选择光解速率和通量值。仅当运行脚本中的CTM_PHOTDIAG环境变量设置为Y（默认值为N）时，才创建此文件。

<a id=ctm_rj2></a>

**CCTM_PHOTDIAG2_2：实时光解输出–网格化光解速率文件**
<!-- BEGIN COMMENT -->
[返回表7-1](#ctm_rj2_t)
<!-- END COMMENT -->

此可选的3D的CCTM文件包含CCTM实时计算的光解速率。层数由NLAYS_PHOTDIAG环境变量设置（默认为所有层）。仅当运行脚本中的CTM_PHOTDIAG环境变量设置为T（默认为N）时，才创建此文件。

<a id=ctm_rj3></a>

**CCTM_PHOTDIAG3：实时光解输入和输出–详细文件**
<!-- BEGIN COMMENT -->
[返回表7-1](#ctm_rj3_t)
<!-- END COMMENT -->

这个可选的3D的CCTM文件包含CCTM实时完成的光解速率计算的详细输入和输出数据。层数由NLAYS_PHOTDIAG环境变量设置（默认为所有层）。文件中包含的波长数由NWAVE_PHOTDIAG环境变量设置（默认为所有波长）。仅当运行脚本中的CTM_PHOTDIAG环境变量设置为T（默认为N）时，才创建此文件。

<a id=ssemis></a>

** CCTM_SSEMIS：海盐排放诊断文件**
<!-- BEGIN COMMENT -->
[返回表7-1](#ssemis_t)
<!-- END COMMENT -->

此可选的2D的CCTM每小时输出文件包含计算出的海盐排放量（g/s）。仅当运行脚本中的CTM_SSEMDIAG环境变量设置为Y（默认值为N）时，才创建此文件。

<a id=wetdep2></a>

**CCTM_WETDEP2：CCTM云诊断文件**
<!-- BEGIN COMMENT -->
[返回表7-1](#wetdep2_t)
<!-- END COMMENT -->

在CMAQ中，分别为解析（网格尺度）云和对流（子网格尺度）云计算湿沉降。WETDEP1文件包含总湿沉降量，即网格尺度和子网格尺度沉降的总和。WETDEP2文件仅包含子网格尺度的沉降，以及一些云诊断变量。2D的CCTM湿沉降文件（WETDEP2）包含所选模型物种的每小时累积湿沉降通量（kg公顷<sup>-1</sup>）。CCTM为化学机理文件夹中的[物种名称清单文件（NameList）](CMAQ_UG_ch04_model_inputs.md#matrix_nml)的“湿沉降列”中列出的所有物种计算湿沉降。GC_*mechname*.nml文件列出了气相物种，AE_*mechname*.nml文件列出了气溶胶物种，而NR_*mechname*.nml文件列出了非反应性（惰性）物种。通过编辑NameList文件中的WDEP列，可以从湿沉降文件中除去物种。仅当运行脚本中的CLD_DIAG环境变量设置为Y（默认为N）时，才创建此文件。

<a id=vext></a>

**CCTM_VEXT：选定位置的浓度垂直分布文件**
<!-- BEGIN COMMENT -->
[返回表7-1](#vext_t)
<!-- END COMMENT -->

此可选的3D的CCTM文件包含VERTEXT_COORD_PATH文件中指定的纬度/经度坐标的多种化学物质浓度的垂直分布数据。写入此输出文件的物种与写入3D的CONC文件的物种相同，后者又由运行脚本中的CONC_SPCS设置，或GC、AE、NR和TR名称列表文件的最后一列控制。指定的每个位置都有一行。每个位置的坐标都在“历史记录（history）”字段的文件元数据中回显。仅当运行脚本中的VERTEXT环境变量设置为Y（默认为N）时，才创建此文件。

<!-- BEGIN COMMENT -->

[<< 前一章](CMAQ_UG_ch06_model_configuration_options.md) - [返回](README.md) - [下一章 >>](CMAQ_UG_ch08_analysis_tools.md)<br>
CMAQ用户指南 (c) 2020<br>

<!-- END COMMENT -->
