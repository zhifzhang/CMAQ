
<!-- BEGIN COMMENT -->

[<< 前一章](CMAQ_UG_ch09_process_analysis.md) - [返回](README.md) - [下一章 >>](CMAQ_UG_ch11_ISAM.md)

<!-- END COMMENT -->

# 10 三维解耦直接方法 (Decoupled Direct Method in Three Dimensions，CMAQ-DDM-3D)

## 10.1 简介

三维解耦直接方法（DDM-3D）可以分析用户指定的模型参数对CMAQ浓度和沉降结果的敏感度。

在空气质量建模中，敏感度分析是评价模型对一个或多个参数变化的响应情况。在政策应用中，目标参数通常是排放，目标输出是污染物浓度。我们可能会关注来自特定地理区域（例如多个市、州或者国家）的排放和/或来自特定污染源（例如野火、发电机组（EGUs）或轻型柴油卡车）的排放。

这是我们可以通过简单地运行两次空气质量模型来计算排放的敏感度————一次使用标准的排放源输入，另一次对我们关注的排放源进行某种调整。相对于调整大小，两次运行之间的输出差异将成为模型的敏感度。尽管此过程相当容易实现和解释，但随着需要分析的敏感度参数的增加，采用这种计算方法就很快变得复杂起来。例如，要计算美国东南部10个州对EGU排放的敏感度，将需要进行11次单独的空气质量模型模拟。

或者，我们可以使用CMAQ-DDM-3D计算模型的敏感度。这是通过更改现有模型算法来实现的，该算法通过CMAQ中的每个科学模块来传递敏感度。尽管此过程确实比标准CMAQ运行过程需要更多的计算资源，但它可以随着所需参数的数量扩展而不需要重复多次计算。

除了排放源，CMAQ-DDM-3D还可以用来计算对其他模型参数的敏感度。目前，CMAQ-DDM-3D可用于对排放速率、边界条件、初始条件、反应速率、潜在涡度或这些参数的任意组合进行敏感度分析。也可以用于二阶敏感度计算、或者称为敏感度的敏感度、有时也称为高阶DDM-3D（HDDM-3D）。注意：关于颗粒物的二阶敏感度分析目前仍在开发中，应被作为一种研究选项而非正式功能。

## 10.2 CMAQ-DDM-3D发布

当前的CMAQ-DDM-3D可用于CMAQ模型的5.2版本。

* [CMAQv5.2 DDM-3D源代码和脚本储存库](https://github.com/zhifzhang/CMAQ/tree/5.2_DDM-3D)
* [下载CMAQv5.2 DDM-3D源代码和脚本的压缩包](https://github.com/zhifzhang/CMAQ/archive/5.2_DDM-3D.zip)
* [CMAQv5.2 DDM-3D文档](https://github.com/zhifzhang/CMAQ/blob/5.2_DDM-3D/DOCS/Instrumented_Docs/CMAQ_DDM.md)

目前将DDM-3D迁移到CMAQ新版本的开发过程正在进行中，将在基本模型发布之后择时发布。本文档将在那时进行更新。

**用于DDM应用程序的I/O API安装说明**

I/O API v3.2最多支持MXFILE3=64个打开文件，每个文件最多MXVARS3=2048。DDM应用程序在配置计算大量参数的敏感性时可能会超出模型该变量的上限，从而导致模型崩溃。为避免此问题，用户可以使用I/O API v5.3-large，它将MXFILE3增加到512，将MXVARS3增加到16384。编译该版本的说明详见[第3章]( CMAQ_UG_ch03_preparing_compute_environment.md#333-io-api-library )。

## 10.3 参考文献

Cohan, D.S., & Napelenok, S.L. (2011). Air Quality Response Modeling for Decision Support. Atmosphere, 2(3), 407-425. [doi: 10.3390/atmos2030407](https://www.mdpi.com/2073-4433/2/3/407)

Napelenok, S.L., Cohan, D.S., Odman, M.T., & Tonse, S. (2008). Extension and evaluation of sensitivity analysis capabilities in a photochemical model. Environmental Modelling & Software, 23(8), 994-999. [doi: 10.1016/j.envsoft.2007.11.004](https://www.sciencedirect.com/science/article/pii/S1364815207002186)

Napelenok, S.L., Cohan, D.S., Hu, Y.T., & Russell, A.G. (2006). Decoupled direct 3D sensitivity analysis for particulate matter (DDM-3D/PM). Atmospheric Environment, 40(32), 6112-6121. [doi: 10.1016/j.atmosenv.2006.05.039](https://www.sciencedirect.com/science/article/pii/S1352231006005012)

**联系人**

[Sergey L. Napelenok](mailto:napelenok.sergey@epa.gov), Computational Exposure Division, U.S. EPA

<!-- BEGIN COMMENT -->

[<< 前一章](CMAQ_UG_ch09_process_analysis.md) - [返回](README.md) - [下一章 >>](CMAQ_UG_ch11_ISAM.md)<br>
CMAQ用户手册 (c) 2020<br>

<!-- END COMMENT -->
