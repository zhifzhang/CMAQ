CMAQv5.3.2
==========

美国EPA CMAQ（Community Multiscale Air Quality Model-社区多尺度空气质量模型） 网页: ( https://www.epa.gov/cmaq )

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.4081737.svg)](https://doi.org/10.5281/zenodo.4081737)

CMAQ是美国EPA研究与开发办公室开发的一个开源项目，它包括了用于进行空气质量模拟的一系列程序。CMAQ由CMAS中心负责支持：（ http://www.cmascenter.org ）。

CMAQ采用开放源代码框架，将当前大气科学和空气质量建模方面的知识与多处理器计算技术相结合，可以快速、技术上合理地计算出臭氧、颗粒物、有毒物质和酸沉降。

## CMAQ v5.3.2 概述：
CMAQv5.3.2包括对CMAQ集成源分配方法（ISAM）的重大更新，以及针对CMAQv5.3.1中多个存在问题的修复。新的CMAQ-ISAM版本包括对气相化学分配算法的实质性更新，从而在物理和数值方面改善了该方法。强烈建议ISAM用户更新到CMAQv5.3.2。
* [CMAQv5.3.2发行说明](DOCS/Release_Notes/README.md)   
* [升级到最新CMAQ版本的常见问题](DOCS/Release_Notes/CMAQ_FAQ.md) **-更新到v5.3.2** 
* [CMAQv5.3.2已知问题](DOCS/Known_Issues/README.md) -更新到v5.3.2，以警告用户下一发行版时将解决的问题。


## CMAQ v5.3 的新功能包括：
* 简化排放规模（Simplified emissions scaling）
* 改善天然气溶胶的表现（Improved representation of natural aerosols ）
* 扩大生态应用能力（Expanded capability for ecological applications ）
* 流线型CMAQ-ISAM和CMAQ-STM（Stream-lined CMAQ-ISAM and CMAQ-STM）
* 更新了前处理程序，包括ICON，BCON和MCIP
* 加快了运行时间，增强了科学的复杂性（Enhanced scientific complexity with faster run times）
* 完全修订的用户指南和教程
* 其他更新记录在发行说明中

## 获取CMAQ存储库

在USEPA/CMAQ的Git存储库中，每一个正式发布的版本都作为分支（branch）储存。模型的最新发布版本始终位于“master”分支上。要从CMAQ Git存储库中克隆代码，请指定分支（即版本号），然后输入以下命令（前提是电脑上安装了Git程序）：

```
git clone -b master https://github.com/USEPA/CMAQ.git CMAQ_REPO
```

## CMAQ储存库指南
源代码和脚本的组织方式如下（即文件夹结构）：
* **CCTM（CMAQ Chemical Transport Model 化学传输模型）:** 用于在CMAQ核心运行3D-CTM的代码和脚本。
* **DOCS:** CMAQ正式发布版本的发布说明、用户指南、开发人员指南、简短教程和已知问题。
* **PREP:** 用于重要输入数据的预处理工具，例如初始和边界条件，气象资料等。
* **POST:** 数据后处理工具，用于汇总和评估CMAQ的输出结果（例如合并、站点比较等）
* **UTIL:** 用于生成代码和使用CMAQ的实用工具（例如化学机理生成器）

## 文献资料
发行说明和代码文档一同储存在此存储库中（它们与代码本身一起受版本控制）。

* [CMAQ用户指南](DOCS/Users_Guide/README.md)   
* [发行说明](DOCS/Release_Notes/README.md)   
* [已知问题](DOCS/Known_Issues/README.md)   
* [教程](DOCS/Users_Guide/Tutorials/README.md)   
* [开发人员指南](DOCS/Developers_Guide/CMAQ_Dev_Guide.md)   
* [升级到最新CMAQ版本的常见问题](DOCS/Release_Notes/CMAQ_FAQ.md) 

## CMAQ测试案例
可从CMAS的数据仓库中获得每个CMAQ版本的基准/教程数据。输入和输出文件与通过Dataverse整理的元数据存储在Google Drive中。CMAQv5.3.2附带了2016年7月1-2日在美国东南部区域的基准输入输出数据（下面提供了链接）。这两天的输入数据集与v5.3.1发行的数据集相同，除了为美国添加了网格掩码文件：[GRIDMASK_STATES_12SE1.nc](https://drive.google.com/file/d/16JJ4d6ChBJsvMc_ErqwDBrFfGh2MnVYR/view?usp=sharing) 。因此，除非需要网格掩码文件来运行新的[ISAM测试案例](DOCS/Users_Guide/Tutorials/CMAQ_UG_tutorial_ISAM.md) ，或者需要使用[DESID](DOCS/Users_Guide/Tutorials/CMAQ_UG_tutorial_emissions.md) 来测试区域排放量缩放比例，否则已经下载了v5.3.1版本东南部区域基准输入数据的用户无需再次下载v5.3.2版本数据。v5.3.2的东南部区域基准测试输出数据与随v5.3发布的数据略有不同，详见[升级到最新CMAQ版本的常见问题](DOCS/Release_Notes/CMAQ_FAQ.md)中所述。

| **CMAQ版本** | **数据类型** | **区域** | **模拟日期** | **Dataverse DOI** |
|:----:|:----:|:--------------:|:----:|:--------:|
| v5.3 | 输入 | 美国本土 | 2016年1月1日至12月31日 | https://doi.org/10.15139/S3/MHNUNE |
| v5.3, v5.3.1, v5.3.2 | 输入 | 美国东南部 | 2016年7月1日至14日 | https://doi.org/10.15139/S3/IQVABD |
| v5.3, v5.3.1 | 输出 | 美国东南部 | 2016年7月1日至14日 | https://doi.org/10.15139/S3/PDE4SS |
| v5.3.2 | 输出 | 美国东南部| 2016年7月1日至2日 |https://doi.org/10.15139/S3/PDE4SS |

也可以从美国EPA匿名ftp服务器获得基准数据： ftp://newftp.epa.gov/exposure/CMAQ/V5_3_2/Benchmark/WRFv4.1.1-CMAQv5.3.2/

## 以前的CMAQ版本
CMAQ的后续发行版本当前可在GitHub上获得。需要特定版本时，可以使用Zenodo的DOI值。
* [v5.3.1 (2019年12月)](https://github.com/zhifzhang/CMAQ/tree/5.3.1) - [doi:10.5281/zenodo.3585898](https://doi.org/10.5281/zenodo.3585898) | [用户指南](https://github.com/zhifzhang/CMAQ/blob/5.3.1/DOCS/Users_Guide/README.md) | [已知问题](https://github.com/zhifzhang/CMAQ/blob/5.3.1/DOCS/Known_Issues/README.md) | [发行说明](https://github.com/zhifzhang/CMAQ/blob/5.3.1/DOCS/Release_Notes/README.md) | [教程](https://github.com/zhifzhang/CMAQ/blob/5.3.1/DOCS/Users_Guide/Tutorials/README.md) 
* [v5.3（2019年8月）](https://github.com/zhifzhang/CMAQ/tree/5.3 ) [-doi:10.5281/zenodo.1212601](https://doi.org/10.5281/zenodo.3379043 ) | [用户指南](https://github.com/zhifzhang/CMAQ/blob/5.3/DOCS/Users_Guide/README.md ) | [已知问题](https://github.com/zhifzhang/CMAQ/blob/5.3/DOCS/Known_Issues/README.md )  | [发行说明](https://github.com/zhifzhang/CMAQ/blob/5.3/DOCS/Release_Notes/README.md ) | [教程](https://github.com/zhifzhang/CMAQ/blob/5.3/DOCS/Users_Guide/Tutorials/README.MD )
* [v5.2.1（2018年3月）](https://github.com/zhifzhang/CMAQ/tree/5.2.1 ) [-doi:10.5281/zenodo.1212601](https://zenodo.org/record/1212601 ) | [用户指南](https://github.com/zhifzhang/CMAQ/blob/5.2.1/DOCS/User_Manual/README.md ) | [已知问题](https://github.com/zhifzhang/CMAQ/blob/5.2.1/DOCS/Known_Issues/README.md ) | [发行说明](https://github.com/zhifzhang/CMAQ/blob/5.2.1/CCTM/docs/Release_Notes/README.md ) | [教程](https://github.com/zhifzhang/CMAQ/tree/5.2.1/DOCS/Tutorials )
* [v5.2 (2017年六月)](https://github.com/zhifzhang/CMAQ/tree/5.2 ) - [doi:10.5281/zenodo.1167892](https://zenodo.org/record/1167892 ) | [用户指南](https://github.com/zhifzhang/CMAQ/blob/5.2/DOCS/User_Manual/README.md ) | [已知问题](https://github.com/zhifzhang/CMAQ/blob/5.2/DOCS/Known_Issues/README.md ) | [发行说明](https://github.com/zhifzhang/CMAQ/blob/5.2/CCTM/docs/Release_Notes/README.md ) | [教程](https://github.com/zhifzhang/CMAQ/blob/5.2/DOCS/Tutorials/README.md )
* [v5.1 (2015年12月)](https://github.com/zhifzhang/CMAQ/tree/5.1 ) - [doi:10.5281/zenodo.1079909](https://zenodo.org/record/1079909 )
* [v5.0.2 (2014年4月)](https://github.com/zhifzhang/CMAQ/tree/5.0.2 ) - [doi:10.5281/zenodo.1079898](https://zenodo.org/record/1079898 )
* [v5.0.1 (2012年7月)](https://github.com/zhifzhang/CMAQ/tree/5.0.1 )
* [v5.0（2012年2月）](https://github.com/zhifzhang/CMAQ/tree/5.0 ) - [doi：10.5281 / zenodo.1079888](https://zenodo.org/record/1079888 )
* [v4.7.1 (2010年6月)](https://github.com/zhifzhang/CMAQ/tree/4.7.1 ) - [doi:10.5281/zenodo.1079879](https://zenodo.org/record/1079879 )

## 用户支持
* CMAQ常见问题详见[网页]( https://www.epa.gov/cmaq/frequent-cmaq-questions )。
* [CMAS用户论坛](https://forum.cmascenter.org/)供用户和开发人员讨论与CMAQ系统使用有关的问题。在向论坛提交新问题之前[**请阅读并遵循以下步骤**](https://forum.cmascenter.org/t/please-read-before-posting/1321) 。

## EPA免责声明
美国环境保护局（EPA）GitHub项目代码是按“原样”提供的，用户对其使用承担责任。 EPA放弃了对信息的控制，并且不再负责保护信息的完整性，机密性或可用性。通过服务标记、商标、制造商或其他方式对特定商业产品，过程或服务的任何引用，均不构成或暗含其对EPA的认可，推荐或偏爱。 EPA印章和徽标不得以任何方式暗示EPA或美国政府对任何商业产品或活动的认可。   [<img src="https://licensebuttons.net/p/mark/1.0/88x31.png" width="50" height="15">](https://creativecommons.org/publicdomain/zero/1.0/)