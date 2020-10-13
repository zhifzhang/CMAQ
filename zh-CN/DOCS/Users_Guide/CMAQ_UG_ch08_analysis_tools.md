
<!-- BEGIN COMMENT -->

[<< 前一章](CMAQ_UG_ch07_model_outputs.md) - [返回](README.md) - [下一章 >>](CMAQ_UG_ch09_process_analysis.md)

<!-- END COMMENT -->

# 8 输出文件分析工具

## 8.1 简介
有许多免费软件可用于CMAQ输出文件的预处理、后处理、分析和可视化。[表8-1]( #Analysis_Software_Table )中提供了此类免费软件的示例。 其他一些商业软件，包括MATLAB和IDL，也支持CMAQ输入和输出文件的分析和可视化。大多数支持netCDF文件格式的可视化和分析软件都可以用于CMAQ输出文件。

<a id=Analysis_Software_Table></a>
<a id=Table8-1></a>

**表8-1 用于CMAQ数据分析和可视化的软件**

|**软件名称**|**描述**|     **来源**    |
|------------|-------------------------------|---------------------------------------------|
|***后处理工具***|||
|CMAQ POST Tools|与CMAQ源代码一起发布的程序，用于为模型评估准备输出数据|[Github](../../POST)|
|I/O API Tools|I/O API或netCDF格式数据的后处理工具|[https://www.cmascenter.org/ioapi](https://www.cmascenter.org/ioapi)|
|NCO|netCDF Operators：netCDF格式数据的后处理工具|[http://nco.sourceforge.net](http://nco.sourceforge.net)
|***评估/可视化***| | |
|AMET|大气模型评估工具（Atmospheric Model Evaluation Tool），用于分析和评估气象和空气质量模型|[https://www.epa.gov/cmaq/atmospheric-model-evaluation-tool](https://www.epa.gov/cmaq/atmospheric-model-evaluation-tool)|
|VERDI|用于NetCDF网格化数据图形分析的丰富数据解释可视化环境（Visualization Environment for Rich Data Interpretation）|[https://www.cmascenter.org/verdi](https://www.cmascenter.org/verdi)|
|PseudoNetCDF|用于大气科学数据格式（包括CMAQ文件）的读取和绘图，还有一些写入功能|[https://github.com/barronh/pseudonetcdf/wiki](https://github.com/barronh/pseudonetcdf/wiki)|
|RSIG|卫星和模型数据的2D和3D可视化|[https://www.epa.gov/hesc/remote-sensing-information-gateway](https://www.epa.gov/hesc/remote-sensing-information-gateway)|
|NCL|NCAR命令语言，用于科学数据处理和可视化|[http://www.ncl.ucar.edu](http://www.ncl.ucar.edu)|
|IDV|集成数据查看器（Integrated Data Viewer），可对NetCDF网格数据进行3D图形分析|[http://www.unidata.ucar.edu/software/idv/](http://www.unidata.ucar.edu/software/idv/)|

本章简要介绍了如何使用EPA和CMAS支持的软件工具来汇总CMAQ输出、将CMAQ输出与空气质量观测值在空间和时间上进行对比、创建各种评估图、以及可视化模型场。

## 8.2 汇总和转换模型物种
许多CMAQ输出物种需要进行后处理，以便与监测结果进行比较。例如，CMAQ的气溶胶模块会输出许多单个PM<sub>2.5</sub>物种，需要将他们组合起来生成总PM<sub>2.5</sub>才能与监测结果进行比较。作为CMAQ POST工具之一的*combine*实用程序可用于完成此项工作。由于不同的化学机制模块输出物种的数量和定义不同，因此*combine*实用程序依赖于一个特定于化学机制的“物种定义”文件，该文件规定了模型的输出变量应该如何组合生成不同的气体、颗粒物和沉积物种。下载5.2版或更高版本的CMAQ代码时，这些定义文件将自动包含在[CCTM/src/MECHS]( ../../CCTM/src/MECHS )目录下，该目录列出的每个化学机制（mechanism）文件夹中，您都可以找到“SpecDef_MECH_NAME.txt”和“SpecDef_dep_MECH_NAME.txt”文件，其中包含物种定义和相应文档的长列表。例如，要了解如何使用cb6r3_ae7_aq机制计算PM<sub>2.5</sub>，请打开文件“SpecDef_cb6r3_ae7_aq.txt”，并阅读有关PM<sub>2.5</sub>计算的文档。物种定义文件将指出哪些物种应包含在PM<sub>2.5</sub>中（例如：硫酸盐、铵和有机碳），以及获得对应于2.5 &#956;m（直径）和更小粒子的每个CMAQ粒径分布模块。类似的信息可用于计算PM<sub>10</sub>和PM<sub>1.0</sub>。这些物种定义文件被设计为与*combine*实用程序一起使用，以从特定的监视网络(monitoring networks)中提取与观测量匹配的模型变量。有关*combine*实用程序及其使用的详细信息，请参阅其[README文件]( ../../POST/combine/README.md)

## 8.3 用于模型评估的模拟-监测对比
使用*combine*处理模型输出文件后，即可使用*sitecmp*和*sitecmp_dailyo3*实用程序将空气污染物监测值与适当的模型预测变量进行对比。用于对比模型和监测的变量在*sitecmp*和*sitecmp_dailyo3*的运行脚本中指定。在*sitecmp_dailyo3*中，此步骤由环境变量OBS_SPECIES和OZONE的定义控制。有关设置这些环境变量的更多信息请参阅*sitecmp_dailyo3*的[README文件]( ../../POST/sitecmp_dailyo3/README.md )和[运行脚本]( ../../POST/sitecmp_dailyo3/scripts )文件夹中的运行脚本示例。*sitecmp*的运行脚本可以根据化学和气象量自定义各种不同类型的变量，具体描述请参阅*sitecmp*的[README文件]( ../../POST/sitecmp/README.md )。*sitecmp*的[运行脚本]( ../../POST/sitecmp/scripts )文件夹中提供了基于2016 CMAQ测试案例的AQS、CSN、IMPROVE、NADP和SEARCH网络的运行脚本示例。此外，*sitecmp*脚本文件夹中的[README文件]( ../../POST/sitecmp/scripts/README.md )文件提供了用于监视网络(monitoring networks)的配置选项。请注意，根据不同年份，CSN和SEARCH观测数据文件有多种格式。 该[README文件]( ../../POST/sitecmp/scripts/README.md )文件分为不同的部分，以反映这两个网络的观测文件中物种名称的变化。（例如，来自CSN网络的元素碳测量值在2009年或更早的时候标记为“ec_niosh”，在2010年标记为“ec_tor”，在2011年标记为“88380_val”。）

### 8.3.1 sitecmp和sitecmp_dailyo3中的空间匹配
在*sitecmp*中，会在包含监测点的网格单元中提取模型数据。而在*sitecmp_dailyo3*中，则提供了包含监测点的网格单元的模型数据，以及以监测点位置为中心的9个网格单元的最大值数据。输出文件中的这些变量在名称中包含字符串“9cell”。

### 8.3.2 sitecmp和sitecmp_dailyo3中的时间匹配
* **AQS_HOURLY, CASTNET_HOURLY, SEARCH_HOURLY, NAPS_HOURLY, AERONET**: 假定空气质量监测值是小时平均值，在每小时开始时以当地标准时间（local standard time，LST）标注（时间戳）。*sitecmp*实用程序将使用监测值中的时间戳确定匹配模型的时间步长，并考虑监测点所在时区。因此，最佳做法是使模型时间步长也设置为该小时开始时的每小时平均时间。这可以通过在遵循此约定的CMAQ “ACONC”输出文件上运行*combine*实用程序来完成。这些网络还包括气象测量。由于气象观测接近于瞬时测量（例如1分钟或5分钟的平均值），因此使用来自MCIP或*combine*结果中wrfout的气象场可以正确的匹配，因为这些场也是瞬时的。一个例外是对模型相对湿度（RH）的计算。此变量在MCIP或wrfout文件中不可用，但存储在CMAQ “APMDIAG”输出文件中，该文件表示小时平均值。这会导致在*sitecmp*输出文件中，此变量的观测值与模型值之间造成轻微的不一致。请注意，模型和观测中给定小时的降水量代表了小时总数，而不是小时平均值。
* **AQS_DAILY_O3, CASTNET_DAILY_O3, NAPS_DAILY_O3**: *sitecmp_dailyo3*从每小时观测到的臭氧值和模拟的每小时臭氧值中计算出各种每日指标。在这些计算中使用的每小时观测值和模拟值的时间匹配遵循上述针对AQS_HOURLY的相同方法。因此，最佳做法是将CMAQ输出的“ACONC”文件用于模拟臭氧预测。*sitecmp_dailyo3*文档中提供了有关各种每日指标计算的详细信息。
* **AQS_DAILY, CSN, IMPROVE, SEARCH_DAILY**: 空气质量观测值是日平均数据，以当地标准时间（LST）标记日期。*sitecmp*实用程序使用观测值中的日期（根据监测点所在的时区）来计算24小时模拟数据的日均值。因此，最佳做法是使用CMAQ输出的“ACONC”文件每小时平均浓度进行空气质量预测。
* **CASTNET**: 空气质量观测值是每周平均数据，以当地标准时间（LST）的每周间隔的开始和结束日期和时间。 *sitecmp*实用程序将使用观测值的开始和结束日期和时间，以每小时的建模值来计算每周平均值，并考虑监测点所在时区。因此，最佳做法是使用CMAQ输出的“ACONC”文件每小时平均浓度进行空气质量预测。
* **NADP**: 空气质量观测值是每周总和数据，以当地标准时间（LST）的每周间隔的开始和结束日期标记。 *sitecmp*实用程序将使用观测值的开始和结束日期，以每小时的建模值来计算每周总和，并考虑监测点所在时区。观测值与代表小时总数的CMAQ “DEP”文件的输出相匹配。
* **TOAR**: 空气质量观测值是O3日平均值、MDA8 O3（日最大8h平均值）、O3白天平均值、O3夜间平均值。必须先用*hr2day*实用工具从小时值计算得出日平均值，以提供给*sitecmp*实用工具。

## 8.4 大气模型评估工具（The Atmospheric Model Evaluation Tool，AMET）

大气模型评估工具（AMET）可以帮助评估CMAQ模型系统内的气象和空气质量模型（即WRF，MPAS，CMAQ-CTM）。AMET组织和提供一致性并加快评估过程，以进行气象和空气质量模型模拟。AMET软件主要是用R编写的，并得到了多个fortran程序和cshell脚本的支持。该工具还需要一个MySQL数据库，用于气象数据分析和对空气质量（CMAQ）数据进行全功能分析（CMAQ输出分析可以在没有数据库的情况下进行）。尽管它是专门为帮助评估CMAQ模型系统而开发的，但AMET软件也可适用于其他模型系统。

AMET中有单独的模块，用于评估气象和空气质量模型的输出。这种分离是必要的，因为观测和预测的气象和空气质量数据都非常不同，因此需要对观测和模型数据使用不同的文件格式。此外，观测到的气象和空气质量数据通常是从使用不同采样协议的网络获得的，这可能会使将气象和空气质量数据配对在一起变得困难。在AMET中将气象和空气质量模块分开的优点之一是可以单独安装模块，如果仅需要气象或空气质量分析，则用户可以减少安装时间和复杂性。

可以在 https://www.epa.gov/cmaq/atmospheric-model-evaluation-tool 上找到有关AMET的更详细的说明，包括AMET系统的流程图和该工具的示例输出图。AMET github存储库位于 https://github.com/USEPA/AMET 。该存储库包括最新版本的AMET，以及该工具的完整说明、全面的《用户指南》、《安装指南》和《快速入门指南》。最后，有关AMET的其他信息（包括如何下载支持AMET的观测数据文件）可以在CMAS中心网站上找到： https://www.cmascenter.org/amet/ 。

AMETv1.4存储库包含一个新脚本，可用于从单个文件设置和执行多个后处理步骤，包括运行*combine*、*sitecmp*、*sitecmp_dailyo3*和“批处理” AMET评估图件。安装AMET之后，用户可以在 scripts_db/aqExample/aqProject_pre_and_post.csh 下找到此脚本。 AMET的docs文件夹中也提供了用于配置此主评估脚本的文档：AMET_aqProject_Pre_and_Post_Analysis_Script_Guide_v14b.md。


## 8.5 丰富数据解释的可视化环境（Visualization Environment for Rich Data Interpretation，VERDI）

丰富数据解释的可视化环境（VERDI）是一种可视化分析工具，用于评估和绘制来自气象和空气质量模型的多变量的网格结果。VERDI用Java编写，因此可以在多种计算机操作系统上运行；VERDI软件包当前发布有Linux、Windows和Mac版本。除了支持CMAQ模型系统外，VERDI当前还支持对区域[天气研究和预报模型（Weather Research and Forecasting，WRF）]( https://ncar.ucar.edu/what-we-offer/models/weather-research-and-forecasting-model-wrf )、全球[跨尺度预测模型（Model for Prediction Across Scales ，MPAS）]( https://ncar.ucar.edu/what-we-offer/models/model-prediction-across-scales-mpas )、[气象-化学接口处理器（Meteorology-Chemistry Interface Processor，MCIP）]( ../../PREP/mcip/README.md )、以及[扩展的综合空气质量模型（Comprehensive Air Quality Model with Extensions，CAMx）]( http://www.camx.com )的模型结果进行分析和可视化。此外，VERDI可以在监测站点的位置读取和覆盖观测数据，以在视觉上将模型结果与观测值在空间和时间上进行比较。

VERDI的交互式图形用户界面（GUI）可以快速检查模型结果，而VERDI中的命令行脚本功能可以用于更多的常规分析和绘图制作。支持的输入数据格式包括来自模型的I/O API、netCDF和UAM-IV文件，以及来自观测数据集的ASCII文本、I/O API和netCDF文件。支持的地图投影包括兰伯特正形圆锥（Lambert conformal conic）、墨卡托（Mercator）、通用横向墨卡托（Universal Transverse Mercator，UTM）和极地立体影像（polar stereographic，PS）。将数据加载到VERDI中后，就可以对选择的独立变量进行绘图，或者将其作为输入采用数学公式计算后再进行绘制。可用的图类型包括空间图块（spatial tile）、基于shapefile的面插值（areal interpolation）、垂直横截面（vertical cross section）、时间序列（times series）、时间序列条（time series bar）、散点图（scatter）和3D等值线图。然后还可以叠加来自监测站点的观测数据、风向矢量、网格线/单元格边界、以及其他GIS图层（例如州、县、HUCs（水文单位代码）、河流、道路和用户自定义shapefiles）。变量的绘图可以限制在指定的空间和/或时间范围内，在每个绘图框的底部会自动显示区域和时间变量的最小值/最大值。可以将图件另存为具有选定像素大小的光栅图像（BMP、JPEG、PNG、TIFF）、矢量图像（EPS）或动画GIF“电影”。还可以导出与ESRI兼容的Areal格式shapefiles文件、ASCII文本、或CSV文件。交互式分析具有快速放大感兴趣区域并探究网格单元内数据值的能力。为了提高图件的可重复性，VERDI可以将会话另存为项目文件，并将每个图件的自定义设置（例如数据范围、调色板、字体特征、标题和标签）保存为图件配置文件。另外，使用VERDI的内置算法可轻松完成显示数据的快速统计分析，该算法可用于计算最小/最大值、均值、几何均值、中位数、第一和第三四分位数（quartiles）、方差、标准差、方差系数、范围、四分位数（interquartile）范围、总和、最小和最大时间步长、不合规小时数、最大8小时平均值、计数、第四最大数、以及自定义百分位数。

CMAS中心当前在 https://www.cmascenter.org/verdi 上发布VERDI，并提供简短的说明以及下载VERDI及其文档的链接。VERDI的主要代码存储库位于 https://github.com/CEMPD/VERDI ，用户可以在其中下载最新版本、阅读文档、注意最新的已知问题和错误。


<!-- BEGIN COMMENT -->

[<< 前一章](CMAQ_UG_ch07_model_outputs.md) - [返回](README.md) - [下一章 >>](CMAQ_UG_ch09_process_analysis.md)<br>
CMAQ用户指南 (c) 2020<br>

<!-- END COMMENT -->
