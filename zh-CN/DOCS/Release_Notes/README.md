CMAQv5.3.2发行说明
=====================================

[CMAQv5.3.2用户指南](../Users_Guide/README.md)

[CMAQ安装和运行教程](../Users_Guide/Tutorials/README.md) **- 有关运行CMAQ测试案例的教程以及有关WRF-CMAQ、ISAM和修改化学机制的新教程**  

[升级到CMAQ最新版本的常见问题](CMAQ_FAQ.md) **-v5.3.2发布中的新问题**

[CMAQv5.3.2已知问题](../Known_Issues/README.md)-在v5.3.2发行版之后进行了更新，以警告用户有关下一发行版将解决的问题

# CMAQv5.3.2更新摘要

CMAQv5.3.2包括对CMAQ集成源分配方法（ISAM）的重大更新，以及针对CMAQv5.3.1中多个存在问题的修复。新的CMAQ-ISAM版本包括对气相化学分配算法的实质性更新，从而在物理和数值方面改善了该方法。强烈建议ISAM用户更新到CMAQv5.3.2。

* [CMAQv5.3.2 bug修复](CMAQv5.3.2_bugfixes.md)
* [ISAM增加了对双向NH3通量的支持](ISAM_bidi_support.md)
* [修订了ISAM关于气体化学如何影响分配的方法](ISAM_gas_chemistry_v532.md)
* [可以临时采用更精细的气象运行](running_with_temporally_finer_MET.md)
* [使用CB6r3更新DMS化学](DMS_chemistry_update.md)
* [更新闪电NO垂直廓线文件](Update_the_lightning_NO_vertical_profile.md)
* [细气溶胶酸度输出](specdef_ae7_pH.md)
* [向bldmake配置文件添加make选项](Add_make_options_to_the_cfg_file_for_bldmake.md)
* [将2019年数据添加到CMAQ OMI输入文件](OMI_through_2019.md)
* [可以按列建模](Enable_Column_Modeling.md)
* [将ERF和SIGN函数添加到COMBINE](Add_ERF_and_SIGN_to_COMBINEs_grid_cell_functions.md)

# CMAQv5.3.1更新摘要

社区多尺度空气质量（CMAQ）模型版本5.3.1是对CMAQv5.3的小幅更新，其中包括多个错误修复和一些附加功能。

* [CMAQv5.3.1 bug修正](CMAQv5.3.1_bugfixes.md)
* [MCIPv5.1 bug修复](MCIPv5.1_bugfixes.md)
* [为“详细排放尺度隔离和诊断模块（Detailed Emission Scaling Isolation and Diagnostic，DESID）”增加新的功能，允许其定义化学、区域和物流族（definition of chemical, region and stream families）](DESID_families.md)
* [新的网格蒙版文件可支持使用DESID和ISAM进行区域分析](regional_12US1_gridmask.md)

# CMAQv5.3更新摘要

社区多尺度空气质量模型（CMAQ）5.3版是一个重大更新。 CMAQv5.3包括对基本模型（CCTM）中科学算法的一些更改，以及对检测模型，预处理程序，后处理程序和实用工具的更新。 CMAQv5.3主要由美国EPA开发，也包括研究合作伙伴的贡献。自上一版本（CMAQv5.2.1）以来，CMAQ模型的主要功能改进如下。

<a id="instrumented_models"></a>
## 检测模型（Instrumented Models）
* [CMAQv5.3的ISAM](updates_to_CMAQ_ISAM.md)
* [CMAQv5.3的硫追踪模型（STM）](sulfur_tracking.md)
* CMAQv5.3-DDM-3D将于2020年晚些时候发布。
* [CMAQv5.2-DDM-3D文档](https://github.com/zhifzhang/CMAQ/blob/5.2_DDM-3D/DOCS/Instrumented_Docs/CMAQ_DDM.md )

<a id="chemistry"></a>
## 化学
### 光化学

* [删除过时的化学机制](obsolete_mechanisms.md)
* [修订卤族元素导致的一次臭氧损失（所有化学机制）](simple_halogen_chemistry.md)
* [在CB6r3中添加详细的卤族元素和DMS化学成分](detailed_halogen_and_DMS_chemistry.md)
* [更新B6r3中氯化学](chlorine_chemistry_CB6r3.md)
* [更新创建EBI求解器的实用程序](updates_to_create_ebi.md)
* [允许EBI求解器进行综合反应速率分析](allow_ebi_to_do_IRR_analysis.md)

### 光解速率
* [更新在线光解诊断和OMI数据文件](inline_phot_diagnostic_and_OMI.md)
* [使用PGI Fortran编译器解决偶发的浮点崩溃问题](inline_phot_pgi_floating_point_crashes.md)
* [更新在线光解预处理实用程序](updates_to_inline_phot_preproc.md)

### 新的气溶胶模块AERO7和AERO7i
* [ *AERO7* 和 *AERO7i* 概述](aero7_overview.md)
* [单萜SOA（萜类化合物之一）](monoterpene_SOA.md)
* [重组人为的SOA物种](anthro_SOA.md)
* [在亲水性有机气溶胶中增加水吸收](organic_water.md)
* [纠正了无机盐向有机硫酸盐的转化错误](inorganicsulfate_iepox_fix.md)
* [非易失性POA选项](nonvolatile_POA.md)
* [精简SOA模块](streamlined_SOA.md)

### 其他气溶胶处理
* [更新溶胶干法沉积算法](aerosol_dry_deposition.md)
* [修正重力沉降子时间步长的计算](gravitational_settling.md)
* [简化气溶胶表面积向异质化学算法的传播](HetChem_aerosol_param.md)

### 水和非均相化学
* [AQCHEM-KMT2：使用动力学预处理程序扩展了无机和有机云化学](aqchem-kmt2.md)

## 运输过程处理
* [更改ACM2 PBL模型 _vdiff_ 以使用Z坐标](VdiffZ.md)
* [更改了ACM云模型以使用Z坐标](Z-coords%20for%20ACMcloud.md)

## 空气地面交换
* [在M3Dry中新增与每日EPIC输入关联的NH<sub>3</sub>双向通量](M3dry-Bidi.md)
* [阶段： *表面平铺的气溶胶和气体交换* 干法沉积选项](stage_overview.md)
* [轻微更新了空气地面交换选项](asx_run_options.md)

## 排放更新

* [DESID： *详细的排放尺度，隔离和诊断* 模块](emissions_redesign.md)
* [BEIS默认化学图谱](BEIS_mapping.md)
* [更新 *AERO7* 的生物物种](biogenic_apinene.md)

## 分析程序
* [气溶胶子过程的过程分析](aerosol_process_analysis.md)
* [EBI求解器中的IRR分析](allow_ebi_to_do_IRR_analysis.md)

## 结构改进
* [简化和集中化日志文件输出](logfile.md)
* [将光解速率计算移至SCIPROC](move_phot_to_sciproc.md)
* [输出变量的标准化单位](output_units.md)
* [新的集中式输入/输出模块（CIO）](centralized_io.md)
* [实现新的化学名称列表格式](chemical_namelists.md)

## 诊断选项
* [垂直廓线提取：扩展CCTM以在指定位置输出垂直廓线](vertical_extraction.md)

## 前处理器，后处理器和实用程序
* [MCIPv5.0中的更新](../../PREP/mcip/docs/ReleaseNotes)
* [更新ICON和BCON预处理器。](updates_to_ICON_BCON.md)
* [ *create_omi*  ：创建用于在线光解的OMI数据文件](Add_create_omi_tool.md)
* [更新 *create_ebi* 实用程序](updates_to_create_ebi.md)
* [更新 *inline_phot_preproc* 实用程序](updates_to_inline_phot_preproc.md)
* [更新有机气溶胶种类定义文件](specdef_aero.md)
* [更新后处理实用程序](postprocessing_tools.md)
