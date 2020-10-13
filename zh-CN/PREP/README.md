预处理工具
========

## 概述
以下程序用来处理和准备CMAQ化学传输模型（CMAQ Chemistry Transport Model，CCTM）的输入数据。每个程序文件夹中的README文件提供了这些程序的文档。

## 预处理程序
* **[bcon](bcon/README.md)**: 从ASCII垂直廓线文件或现有CCTM输出浓度（CONC）文件为CCTM准备侧向化学边界条件（BCs）
* **[icon](icon/README.md)**: 从ASCII垂直廓线文件或现有CCTM输出浓度（CONC）文件为CCTM准备化学初始条件（ICs）
* **[mcip](mcip/README.md)**: 将来自MM5或WRF-ARW模型的气象模型输出文件处理为与CMAQ和SMOKE兼容的I/O API格式文件
* **[create_omi](create_omi/README.md)**: 生成一个OMI输入文件，该文件支持CMAQ CCTM的“内联（in-line）”光解速率计算。
