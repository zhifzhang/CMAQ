
<!-- BEGIN COMMENT -->

[<< 前一章](CMAQ_UG_ch01_overview.md) - [返回](README.md) - [下一章 >>](CMAQ_UG_ch03_preparing_compute_environment.md)

<!-- END COMMENT -->

# 2 程序结构
## 2.1 简介
CMAQ系统是一套协同工作的软件程序，可以估算臭氧、颗粒物、有毒化合物、酸沉降以及其他感兴趣的大气污染物。作为模拟多个复杂大气过程相互作用的框架，CMAQ需要许多类型的输入，包括气象信息、主要污染物排放速率、化学性质和化学反应、以及影响与大气交换污染物的土地性质。

## 2.2 CMAQ核心程序
温度、风、云的形成和降水率等天气条件是大气传输的主要物理驱动力。这些条件在空气质量模型中进行模拟，而这些模拟使用的是区域尺度的数值气象模型的输出，例如[WRF（Weather Research and Forecasting Model，天气研究和预报模型）]( https://www.mmm.ucar.edu/weather-research-and-forecasting-model )。对于污染物排放的输入，CMAQ依靠开源的[SMOKE（Sparse Matrix Operator Kernel Emissions model，稀疏矩阵算子内核排放模型）]( http://www.smoke-model.org ) 模型来估计污染源的大小和位置。另一个开源系统
[FEST-C（Fertilizer Emission Scenario Tool for CMAQ，肥料排放情景工具）]( https://www.cmascenter.org/fest-c/ ) 用于运行EPIC模型（Environmental Policy Integrated Climate model，环境政策综合气候模型）以生成农用地土壤氮素信息，以向CMAQ提供建模所需的双向NH<sub>3</sub>。

CMAQ系统的结构如图2-1所示。CMAQ的核心程序，即CCTM（the CMAQ Chemistry Transport Model，CMAQ化学迁移模型），通常简称为CMAQ，包含上述给定输入下用于预测污染物浓度的主要方程式。这些偏微分方程设计用于质量守恒，并考虑了许多重要过程，例如排放、化学反应、云和降水的吸收、以及干沉降。有关CMAQ中科学配置选项的概述，请参见[第6章](  CMAQ_UG_ch06_model_configuration_options.md  )。有关编译和运行CCTM的说明，请参见第3章（[准备计算环境]( CMAQ_UG_ch03_preparing_compute_environment.md )）、第4章（[模型输入]( CMAQ_UG_ch04_model_inputs.md )）和第5章（[运行CMAQ模拟]( CMAQ_UG_ch05_running_a_simulation.md )）。

<a id=Figure2-1></a> ![图 2-1](./images/Figure2-1.jpg)

**图2‑1  CMAQ系统结构**

CMAQ系统提供了一些重要工具来对重要的输入数据进行预处理。上游气象模型（例如WRF）提供的气象数据由MCIP（Meteorology-Chemistry Interface Processor，气象化学接口处理器）输入到CCTM。CCTM还需要输入数据来指定模型处理的每种化学物质的初始条件和边界条件，这些数据可以分别由ICON和BCON工具进行处理和准备。[PREP]( ../../PREP/README.md )文件夹下提供了有关编译和运行MCIP、ICON和BCON的文档。

## 2.3 在线排放源选项
CMAQ包括多个“在线（online）”排放源选项，以支持气象和化学过程之间的耦合，有助于进行空气质量预测建模。可在CMAQ中“在线”运行的排放源包括：生物源、风吹起尘、海浪排放和闪电产生的NO。将这些过程直接纳入CCTM模拟（而不需要采用预处理工具进行输入）的一个重要优点是，排放是在同步（化学）时间步长进行气象调制的，而不是在每个模拟小时内进行线性时间插值。另外，这种方法可以节省磁盘空间，因为对于这些高点源不再需要3D排放文件。

## 2.4 后处理工具
CMAQ包括一组Fortran程序，用于处理CMAQ输入和输出文件，包括将模型输出结果与空气质量监测数据进行对照。这些后处理工具的信息可在[POST]( ../../POST/README.md )文件夹下找到。[第8章]( CMAQ_UG_ch08_analysis_tools.md )中介绍了许多用于可视化和评估CMAQ输入和输出文件的后处理工具。

## 2.5 开发人员实用程序
CMAQ包括几个供模型开发人员使用的可选实用程序。这些工具对于希望使用其他化学机制和/或一组不同的光解反应输入数据的高级用户可能有用。化学反应数据由 chemmech（Chemical Mechanism Compiler，化学机制编译器）处理，用于所有化学反应求解。该工具需要化学名称列表（例如GC_NAMELIST，AE_NAMELIST等）才能运行，可以使用文本编辑器直接修改这些名称列表，也可以使用 nml（namelist converter，名称列表转换器）将其转换为CSV文件。运行 chemmech之后，要生成专门用于 EBI（Euler Backward Iterative，欧拉向后迭代）求解器方法的文件，及需要提供 create_ebi。最后，光解预处理器（inline_phot_preproc）为生成光解速率输入提供支持，以自定义化学机制。此外，CMAQ存储库包括用于生成Makefile的软件，这些是编译CCTM和其他组件所需的。这个bldmake实用程序旨在解决用户选项，诊断源代码中的依赖关系，并生成可用于构建可执行文件的Makefile。[UTIL]( ../../UTIL/README.md )文件夹下提供了每个实用程序的文档。

<!-- BEGIN COMMENT -->

[<< 前一章](CMAQ_UG_ch01_overview.md) - [返回](README.md) - [下一章 >>](CMAQ_UG_ch03_preparing_compute_environment.md)

CMAQ用户指南 (c) 2020<br>

<!-- END COMMENT -->
