# CMAQ用户指南


本指南用于[Community Multiscale Air Quality (CMAQ)]( http://www.epa.gov/cmaq ) 模型在Linux系统上的安装，配置和使用。 CMAQ用户应该熟悉Linux脚本，并且对Fortran编程语言有所了解。用户还应该了解大气结构以及大气环境中发生的物理和化学过程。

注意：虽然本《用户指南》与下载或克隆的代码一起打包，但鼓励用户在线阅读以获取最新版本。

# 目录

[CMAQ教程：](Tutorials/README.md)一系列简短的教程，提供了有关如何设置和运行CMAQ的实用示例，包括：
* 运行CMAQ测试案例
* 运行CMAQ-ISAM测试案例
* 采用GNU或者Intel编译CMAQ
* 采用GNU编译WRF-CMAQ
* 调试技巧（Debugging tips）
* 使用DESID模块设置污染源排放
* 创建一个OCEAN文件
* 添加一种惰性示踪剂
* 从季平均半球CMAQ输出创建初始条件/边界条件
* 修改CMAQ化学机理

[第1章（概述）：](CMAQ_UG_ch01_overview.md)CMAQ的背景、功能、运行环境要求和支持资源。

[第2章（程序结构）：](CMAQ_UG_ch02_program_structure.md) CMAQ包含的程序概述。

[第3章（准备计算环境）：](CMAQ_UG_ch03_preparing_compute_environment.md) CMAQ默认配置的硬件/软件要求。

[第4章（模型输入）：](CMAQ_UG_ch04_model_inputs.md)CMAQ输入数据预处理工具的基本代码和说明。

[第5章（运行CMAQ）：](CMAQ_UG_ch05_running_a_simulation.md)获取CMAQ源代码、设置运行环境、运行模型。

[第6章（模型配置选项）：](CMAQ_UG_ch06_model_configuration_options.md) 不同CMAQ科学模块的配置选项。

[第7章（模型输出）：](CMAQ_UG_ch07_model_outputs.md)CMAQ输出文件的说明。

[第8章（分析工具）：](CMAQ_UG_ch08_analysis_tools.md) CMAQ的后处理、可视化和评估工具。

[第9章（过程分析）：](CMAQ_UG_ch09_process_analysis.md) 检测模型（Instrumented Models）-集成过程速率（IPR）和集成反应速率（IRR）。

[第10章（HDDM-3D）：](CMAQ_UG_ch10_HDDM-3D.md)检测模型（Instrumented Models）-三维直接解耦方法（DDM-3D，Decoupled Direct Method in 3D）。

[第11章（ISAM）：](CMAQ_UG_ch11_ISAM.md)检测模型（Instrumented Models）-集成源分配方法（ISAM，Integrated Source Apportionment Method）。

[第12章（硫跟踪）：](CMAQ_UG_ch12_sulfur_tracking.md)检测模型（Instrumented Models）-硫跟踪方法（STM，Sulfur Tracking Method）。

[第13章（WRF-CMAQ）：](CMAQ_UG_ch13_WRF-CMAQ.md) WRF-CMAQ耦合模型用于模拟化学转化和天气变化之间的相互影响作用。

[表格和图件：](CMAQ_UG_tables_figures.md)表格和图件清单。

[附录A（模型选项）：](Appendix/CMAQ_UG_appendixA_model_options.md)配置、编译和运行脚本中的模型选项列表。

[附录B（排放控制）：](Appendix/CMAQ_UG_appendixB_emissions_control.md)如何使用排放控制清单自定义排放处理。

[附录C（空间数据）：](Appendix/CMAQ_UG_appendixC_spatial_data.md) 为CMAQ输入创建一致的地理空间数据。

[附录D（并行计算）：](Appendix/CMAQ_UG_appendixD_parallel_implementation.md)介绍如何在CMAQ系统中应用数据并行计算以提高效率。

[附录E（配置WRF）：](Appendix/CMAQ_UG_appendixE_configuring_WRF.md)配置用于CMAQ的WRF（Weather Research and Forecasting Model）。

[附录F（错误修正）：](Appendix/CMAQ_UG_appendixF_importing_bugfixes.md) 从CMAQ GitHub Issues页面导入的错误修正的说明。

***

CMAQ用户指南 (c) 2020<br>