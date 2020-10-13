CMAQ实用工具
========

## 概述
CMAQ包括几个供模型开发人员使用的可选实用程序。其中，化学机制编译器（chemmech）可以处理化学反应数据，用于所有化学反应求解器方法。该工具需要化学名称列表（例如GC_NAMELIST，AE_NAMELIST等）才能运行，这些名称列表可以使用文本编辑器直接修改，也可以使用名称列表转换器nml将其转换为CSV格式。运行chemmech之后，还要用create_ebi生成专门用于欧拉向后迭代（EBI）求解器方法的文件。最后，内联光解预处理器（inline_phot_preproc）用于生成自定义化学机制的光解速率输入文件。此外，CMAQ存储库还包括用于生成编译CCTM和其他组件所需的Makefile的软件，此bldmake实用程序旨在解决用户选项、诊断源代码中的依存关系、并生成可用于构建可执行文件的Makefile。每个实用程序文件夹中的README文件中提供了该实用程序的文档。

## 实用程序

* **[bldmake](bldmake/README.md)**: CMAQ Makefile生成器和模型构建器
* **[chemmech](chemmech/README.md)**: 从化学机制定义文件生成CMAQ程序需要的化学机制输入文件
* **[create_ebi](create_ebi/README.md)**: 创建依赖于化学机制的EBI化学求解器源代码
* **[inline_phot_preproc](inline_phot_preproc/README.md)**: 为CCTM的内联光解模块创建光解反应参数表
* **[nml](nml/README.md)**: 将从chemmech输出的化学机理csv文件转换为CMAQ程序所需的名称列表文件
* **[jproc](jproc/README.md)**: 计算洁净空气中光解速率的每日查询表，该表被CMAQ CCTM用来采用查表法计算光解速率
