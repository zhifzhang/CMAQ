<!-- BEGIN COMMENT -->

[<< 前一章](CMAQ_UG_ch12_sulfur_tracking.md) - [返回](README.md) - [图件和表格清单 >>](CMAQ_UG_tables_figures.md)

<!-- END COMMENT -->

# 13 WRF-CMAQ模型

## 13.1 简介
空气质量模型通常以两种不同的方式运行：
* 独立 – 气象模型的输出用于驱动空气质量模型
* 耦合 – 空气质量和气象模型同时运行，化学作用会影响天气

后一种“耦合”方法有利于研究气溶胶存在条件与天气之间的重要相互作用。例如，气溶胶会影响到达地表的太阳光量，从而影响温度（气溶胶的直接影响）。气溶胶对云的形成（气溶胶的间接影响）和云的反照率也有重要影响。为此，CMAQ与WRF模型耦合，重点模拟了气溶胶的直接影响。另外，相对于独立模式，耦合模型中的气象信息可以更高的频率传递给CMAQ。

在WRF-CMAQ模型中（Wong等，2012），WRF和CMAQ被同时集成，并且来自CMAQ的信息（如气溶胶浓度）被传递到WRF中，因此气溶胶的存在会影响天气。具体而言，WRF-CMAQ模型为用户提供了将气溶胶光学特性传递到WRF中的辐射模块（气溶胶的直接辐射影响）的选项。目前正在开发将气溶胶信息传递到云的微物理学程序中的功能（气溶胶的间接影响；Yu等，2014），并将在以后的版本中提供。

## 13.2 气溶胶直接辐射反馈影响
来自CMAQ的气溶胶信息被传输到WRF气象模型。使用由CMAQ模拟的气溶胶成分和尺寸分布信息，并结合基于Mie理论的算法，估算与波长相关的气溶胶光学特性（消光、单散射反照率和不对称因子）。炭黑通过Frank Binkowski根据Bohren和Huffman（1983）开发的核-壳方法进行处理。这已在WRF的通用循环模型短波快速辐射传输模型（Rapid Radiative Transfer Model for General Circulation Models，RRTMG）辐射方案中实现，其中计算了14个波段的气溶胶光学特性（Clough等，2005）。WRF-CMAQ耦合模型中的气溶胶光学计算是通过与在碳质气溶胶和辐射效应研究（Carbonaceous Aerosol and Radiation Effects Study，CARES）中进行的环境气溶胶测得的光学性能进行比较来评估的，如Gan等人（2015a）所述。

## 13.3 应用与评估
最近通过长期模拟的广泛比较，评估了WRF-CMAQ模型重现对流层气溶胶负荷、气溶胶光学深度以及北半球和美国晴空短波辐射的历史趋势的能力。这些数量中有1990年至2010年观测到的记录（Xing等，2015a，b； Gan等，2015b）。该模型捕获了在美国东部、欧洲和北大西洋2000-2010年下降的气溶胶光学深度（Aerosol Optical Depth，AOD）趋势，以及大气顶层（top-of-atmosphere，TOA）短波辐射（short-wave radiation，SWR）的相应减少或上升，以及地表SWR的上升或下降。大气顶层（top-of-atmosphere，TOA）的气溶胶直接辐射影响（aerosol direct radiative effects，ADE）的模拟值与测量值相当，而且与一般的循环模型相比，本耦合模型对地表气溶胶直接辐射效率（Eτ）的模拟结果更好（Xing等人，2015b）。

此外，根据NASA的云端和地球辐射能系统（Cloud and Earth’s Radiant Energy System，CERES）卫星推算显示，2000-2010年美国东部地区的大气顶层（TOA）晴空短波辐射呈下降趋势，而中国东部地区呈上升趋势。WRF-CMAQ中包含的气溶胶直接辐射影响模拟结果（ADE）与这些趋势达成了很好的一致性，表明晴空辐射的趋势受对流层气溶胶负荷趋势的影响。

气溶胶冷却的影响不仅限于地表温度的变化，由于增加的稳定性引起的大气动力学变化还会恶化当地空气质量并影响人体健康。

在过去的二十年（1990-2010年）中进行的半球WRF-CMAQ耦合模型的模拟结果显示，由于气溶胶直接影响，世界上最污染的地区地表PM2.5浓度增加。


## 13.4 最新的WRF-CMAQ版本

新的WRF-CMAQ模型基于WRFv4.1.1和CMAQv5.3.2。它仅支持RRTMG辐射方案以实现短波气溶胶直接影响。它使用核-壳模型执行气溶胶光学计算，而不是像先前版本的WRF-CMAQ模型中那样使用体积混合技术。

WRFv4.1.1-CMAQv5.3.2模型的代码以压缩文件（WRFv4.1.1-CMAQv5.3.2_twoway.tar.gz）的形式发布在CMAS中心数据仓库Google Drive中。
- [链接到Google Drive上的WRFv4.1.1-CMAQv5.3.2模型](https://drive.google.com/file/d/1oZecf-4aRu9q0ZptNsyI63QU4KUrTFFl/view?usp=sharing)

压缩文件的顶层**readme**文件以及[WRF-CMAQ教程](Tutorials/CMAQ_UG_tutorial_WRF-CMAQ_build_gcc.md)中提供了编译和运行说明。

## 13.5 WRF-CMAQ基准测试案例

基准测试案例输入和输出数据集可从CMAS中心数据仓库的Google Drive中获取。从CMAQv5.3.1开始，包含基本（未耦合）模型的基准输入的.tar.gz文件还包含一个文件夹（WRF-CMAQ），其中包含用于运行WRF-CMAQ模型所需的其他输入文件和WRF-CMAQ运行脚本示例（其中run.twoway_model_411_532_sf_run_script.16pe.csh用于以短波辐射计算运行WRF-CMAQ，run.twoway_model_411_532_sf_run_script.16pe.csh用于以无反馈运行WRF-CMAQ）。同样，基本模型的基准测试案例.tar.gz输出文件也包含一个文件夹（WRFv4.1.1_CMAQv5.3.2_outputs），该文件夹包括以短波辐射计算运行的WRF-CMAQ模型的参考输出文件（文件结尾为“sf.nc”），以及没有使用短波辐射计算运行的模型的参考输出文件（文件结尾为“nf.nc”）。这些输入和输出基准文件也已发布在美国EPA的匿名ftp服务器上。

- [链接到Google Drive上的WRF-CMAQ基准测试案例输入和输出数据集]( https://drive.google.com/drive/folders/1poigGFlABCfepaIjDw-6JOyznJ6xz1ck?usp=sharing )
- EPA匿名ftp服务器上的WRF-CMAQ基准测试案例输入和输出数据集: ftp://newftp.epa.gov/exposure/CMAQ/V5_3_1/Benchmark

为期两天的基准测试案例的WRF-CMAQ输出文件包含了关闭调试模式（包含"opt"的.tar.gz文件）和打开调试模式（包含"rel_debug"的.tar.gz文件）两种版本，以便允许用户将他们的结果与任何一个进行比较。为了减少编译器标志对模型输出的影响，最好使用调试版本。为了比较由于编译器优化而实现的更快运行时间而获得的模型结果，还提供了“优化版本”输出。

CMAQ基准测试案例的元数据发布在CMAS中心Dataverse网站上: https://doi.org/10.15139/S3/IQVABD 

用户成功完成安装后，可以运行快速测试以确保模型真正安装成功。用户可以根据提供的运行脚本和基准输入数据集设置运行。用户应查阅测试数据集或发行文档附带的readme文件，以使用适当的编译器标志进行此快速测试。测试完成后，用户可以将生成的结果与提供的基准输出进行比较。如果用户具有相同的编译器版本和系统环境，则比较应返回相同的结果。此快速测试使用户可以放心模型安装确实成功。

用户应注意，将WRF-CMAQ给定输入的运行结果与CMAQ（离线）给定输入的运行结果进行比较时，即便在同一区域中，结果之间的差异除了WRF和CMAQ的差异外，也将包括其他来源的差异。这些差异来自于用于通过MCIP为CMAQ（离线）生成输入文件的WRF的版本和推算，以及从美国本土缩小到CMAQ（离线）东南区域基准案例区域而产生的影响。

如有任何疑问，请通过wong.david-c@epa.gov与David Wong联系。


## 13.6 参考文献

Clough, S.A., Shephard, M. W., Mlawer, E. J., Delamere, J. S., Iacono, M. J., Cady-Pereira, K., Boukabara, S., & Brown, P. D. (2005). Atmospheric radiative transfer modeling: a summary of the AER codes. J. Quant. Spectrosc. Ra., 91, 233–244.

Gan, C., Binkowski, F., Pleim, J., Xing, J., Wong, D-C., Mathur, R., & Gilliam, R. (2015a). Assessment of the Aerosol Optics Component of the Coupled WRF-CMAQ Model using CARES Field Campaign data and a Single Column Model. Atmospheric Environment, 115, 670-682. doi: 10.1016/j.atmosenv.2014.11.028 

Gan, C., Pleim, J., Mathur, R., Hogrefe, C., Long, C., Xing, J., Wong, D-C., Gilliam, R., & Wei, C. (2015b). Assessment of long-term WRF–CMAQ simulations for understanding direct aerosol effects on radiation "brightening" in the United States. Atmospheric Chemistry and Physics, 15, 12193-12209. doi: 10.5194/acp-15-12193-2015 EXIT

Mathur, R., Pleim, J., Wong, D., Otte, T., Gilliam, R., Roselle, S., Young, J. (2011). Overview of the Two-way Coupled WRF-CMAQ Modeling System. 2011 CMAS Conference, Chapel Hill, NC. Presentation available from the CMAS conference website. 

Wong, D.C., Pleim, J., Mathur, R., Binkowski, F., Otte, T., Gilliam, R., Pouliot, G., Xiu, A., and Kang, D. (2012). WRF-CMAQ two-way coupled system with aerosol feedback: software development and preliminary results. Geosci. Model Dev., 5, 299-312. doi: 10.5194/gmd-5-299-2012

Yu, S., Mathur, R., Pleim, J., Wong, D., Gilliam, R., Alapaty, K., Zhao, C., Liu, X. (2014). Aerosol indirect effect on the grid-scale clouds in the two-way coupled WRF-CMAQ: model description, development, evaluation and regional analysis.  Atmos. Chem. Phys., 14, 11247–11285. doi: 10.5194/acp-14-11247-2014

有关2路耦合（2-way Coupled）WRF-CMAQ的概述，请参见: http://www.cmascenter.org/conference/2011/slides/mathur_overview_two-way_2011.pptx

有关2路耦合（2-way Coupled）WRF-CMAQ系统的更多详细信息，请参见: http://www.cmascenter.org/conference/2011/slides/wong_wrf-cmaq_two-way_2011.pptx

<!-- BEGIN COMMENT -->

[<< 前一章](CMAQ_UG_ch12_sulfur_tracking.md) - [返回](README.md) - [图件和表格清单 >>](CMAQ_UG_tables_figures.md)<br>
CMAQ用户指南 (c) 2020<br>

<!-- END COMMENT -->
