后处理工具
========

## 概述
以下实用程序可用来处理和准备用于模型评估的数据。每个子目录下的README文件中提供了每个实用程序的说明。请注意，在以前的CMAQ版本中，这些实用程序位于"models/TOOLS"文件夹下。

## 5.3.2版本发行说明
以下链接总结了自先前版本（CMAQ v5.3.1）以来对Combine实用程序的更新。
* [combine实用程序中的新功能](../DOCS/Release_Notes/Add_ERF_and_SIGN_to_COMBINEs_grid_cell_functions.md)

## 实用程序
* **[appendwrf](appendwrf/README.md)**:  用户可以沿时间（无限制）维度将多个WRF输入或输出文件中的变量合并到单个文件中。
* **[bldoverlay](bldoverlay/README.md)**:  用户可以创建一个观测覆盖文件，该文件可以导入到PAVE或VERDI中。
* **[block_extract](block_extract/README.md)**: 用户可以从1个或多个（最多99个）IOAPI文件中为指定范围的单元格提取1个或多个变量的时间序列。
* **[calc_tmetric](calc_tmetric/README.md)**: 用户可以创建网格化的IOAPI文件，这些文件的时间平均值或总和值是根据一个或多个网格化的时间相关IOAPI文件计算得出的。
* **[combine](combine/README.md)**: 用户可以将原始CMAQ输出文件或wrfout输入文件中的物种组合到新的IOAPI输出文件中。可以将物种聚集或转化为感兴趣的变量（例如以匹配来自特定监测网的观测数量）。
* **[hr2day](hr2day/README.md)**: 用户可以从包含小时值的网格IOAPI文件中创建具有每日值的网格IOAPI文件（例如每日总和值、每日最大8小时平均值等）。可以使用GMT或LST计算每日值。
* **[sitecmp](sitecmp/README.md)**: 用户可以生成一个csv（逗号分隔值）文件，该文件将CMAQ生成的浓度与观测数据进行比较。
* **[sitecmp_dailyo3](sitecmp_dailyo3/README.md)**: 用户可以生成一个csv（逗号分隔值）文件，该文件可将CMAQ生成的逐小时臭氧文件计算为各种日均评价标准臭氧文件，并与测数据进行比较。
* **[writesite](writesite/README.md)**: 用户可以从IOAPI数据文件为已定义站点位置处的一组物种生成一个csv文件。

## 用于模型评估的观测数据
运行sitecmp和sitecmp_dailyo3实用程序所需的2000至2017年格式化观测数据文件可在CMAS中心数据交换所的"2000-2017 North American Air Quality Observation Data"标题内下载： https://www.cmascenter.org/download/data.cfm

## 用于模型评估的“模型-观测对比”的一点说明
将模型模拟结果与观测值对比的任务是由sitecmp和sitecmp_dailyo3实用程序执行的。[CMAQ用户指南第8章]( ../DOCS/Users_Guide/CMAQ_UG_ch08_analysis_tools.md )中提供了有关这些程序如何在时间和空间上处理对比模型模拟结果与观测值的文档。