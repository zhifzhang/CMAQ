
<!-- BEGIN COMMENT -->

[<< 前一章](CMAQ_UG_ch11_ISAM.md) - [返回](README.md) - [下一章 >>](CMAQ_UG_ch13_WRF-CMAQ.md)

<!-- END COMMENT -->

# 12. 硫追踪方法
## 12.1 简介
CMAQv5.3包含一个运行诊断模型选项，该选项可以提供有关模拟硫总量的详细信息。此选项称为“硫磺跟踪方法（Sulfur Tracking Method，STM）”，可以跟踪排放源、气相和水相中化学反应产生的硫酸盐、以及初始条件和边界条件的贡献。每个被追踪的物种都被视为其他模拟物种，经历传输（对流、扩散、云混合）并通过干湿沉降去除。CMAQv5.3版本中的STM几个值得注意的功能包括：

- STM现在是由环境变量启用的运行选项。
- 还包括了用于跟踪无机硫酸盐向有机硫酸盐转化损失的其他物种（见表12-2），以及该损失途径包含的化学机理。

## 12.2 用法

要激活STM选项，请编辑CCTM运行脚本并将以下环境变量设置为“Y”（默认为“N”）：

- setenv STM_SO4TRACK Y

STM选项不需要任何其他输入文件。它将使用标准、非检测（non-instrumented）的CCTM的初始条件、边界条件和排放文件。

接下来，请按照第5章5.7节中的说明运行CMAQ CTM。

请注意，采用STM选项后，一些CMAQ标准输出文件（ACONC、CONC、CGRID、DDEP和WDEP）中将包括标准基本模型物种列表以外的其他物种。表12-1和表12-2提供了STM选项输出的其他物种的列表。可以使用标准实用程序对这些数据进行后处理，例如：

- combine（将多天合并为一个文件或汇总各种跟踪种类）
- m3tproc（对多天进行求和或平均）
- verdi（用于数据可视化）

<a id=Table12-1></a>

**表12-1. 硫追踪物种清单**

|    物种组   |  物种名称  |摩尔质量|  描述  |
|:------------|:-----------|:-----|:------------|
|AE           |ASO4AQH2O2J | 96.0 |水相中过氧化氢氧化反应生成的积聚模态硫酸盐(ASO4J): H<sub>2</sub>O<sub>2</sub> + S(IV) -> S(VI) + H<sub>2</sub>O |
|AE           |ASO4AQO3J   | 96.0 |水相中臭氧氧化反应生成的ASO4J: O<sub>3</sub> + S(IV) -> S(VI) + O<sub>2</sub> |
|AE           |ASO4AQFEMNJ | 96.0 |水相中Fe<sup>3+</sup>和Mn<sup>2+</sup>催化氧化反应生成的ASO4J: O<sub>2</sub> + S(IV) -> S(VI) |
|AE           |ASO4AQMHPJ  | 96.0 |水相中甲基过氧化氢氧化反应生成的ASO4J: MHP + S(IV) -> S(VI) |
|AE           |ASO4AQPAAJ  | 96.0 |水相中过氧乙酸氧化反应生成的ASO4J: PAA + S(IV) -> S(VI) |
|AE           |ASO4GASJ    | 96.0 |气相反应凝结生成的ASO4J: OH + SO<sub>2</sub> -> SULF + HO<sub>2</sub> |
|AE           |ASO4EMISJ   | 96.0 |污染源排放的ASO4J |
|AE           |ASO4ICBCJ   | 96.0 |边界条件和初始条件带入的ASO4J|
|AE           |ASO4GASI    | 96.0 |气相反应成核和/或冷凝生成的爱根模态硫酸盐(ASO4I): OH + SO<sub>2</sub> -> SULF + HO<sub>2</sub> |
|AE           |ASO4EMISI   | 96.0 |污染源排放的ASO4I|
|AE           |ASO4ICBCI   | 96.0 |边界条件和初始条件带入的ASO4I|
|AE           |ASO4GASK    | 96.0 |气相反应凝结生成的粗粒模态硫酸盐(ASO4K): OH + SO<sub>2</sub> -> SULF + HO<sub>2</sub>  |
|AE           |ASO4EMISK   | 96.0 |污染源排放的ASO4K|
|AE           |ASO4ICBCK   | 96.0 |边界条件和初始条件带入的ASO4K|
|NR           |SULF_ICBC   | 98.0 |边界条件和初始条件带入的硫酸雾(SULF)|

表中提到了三种硫酸盐的粒度分布模态（即粒度分布的类型，简称粒度模态）：
1. 积聚模态（Accumulation mode）：粒径（直径）0.05~2微米，来自于爱根核的凝聚，燃烧过程产生的蒸汽冷凝及凝聚，以及二次气溶胶等。
2. 爱根模态（Aitken mode）：粒径（直径）＜0.05微米，来自燃烧过程所产生的一次气溶胶粒子和气体分子通过化学反应均相成核转化成的二次气溶胶粒子。其特点主要是粒径小，数量多，表面积（体积）总量大。
3. 粗粒模态（coarse mode）：粒径（直径）>2微米，主要来自机械过程。
粒度分布模态是根据气溶胶粒子的大小划分的，在1976年由怀特裴（K.T.Whitby）根据大气颗粒物的表面积与粒度分布关系提出。不同模态的颗粒来源、形成过程及消除过程各不相同。爱根模态颗粒物很不稳定，在大气中扩散很快被其他物质或地面吸附而去除，或凝聚长大成为积聚模态颗粒物。积聚模态颗粒物不易去除，多数为二次颗粒物，80%以上的硫酸盐颗粒物属于此模态。粗粒模态颗粒物主要是自然界和人类活动产生的一次颗粒物。爱根模态的颗粒物可以凝聚而转化为积聚模态的颗粒物；但积聚模态与粗粒模态之间一般不会互相转化。经研究，目前多数城市大气中颗粒物的分布属双模态，即积聚模态和粗粒模态。

<a id=Table12-2></a>

**表12-2. 代表无机硫酸盐向有机硫酸盐转化损失的其他跟踪物质（仅用于SAPRC07TIC_AE6I、SAPRC07TIC_AE7I、CB6R3_AE7或CB6R3M_AE7化学机制)**

|    物种组   |  物种名称  |摩尔质量| 描述 |
|:------------|:-----------|:-----|:------------|
|AE           |OSO4J       | 96.0 |ASO4J转化为有机硫酸盐损失|
|AE           |OSO4AQH2O2J | 96.0 |ASO4AQH2O2J转化为有机硫酸盐损失|
|AE           |OSO4AQO3J   | 96.0 |ASO4AQO3J转化为有机硫酸盐损失|
|AE           |OSO4AQFEMNJ | 96.0 |ASO4AQFEMNJ转化为有机硫酸盐损失|
|AE           |OSO4AQMHPJ  | 96.0 |ASO4AQMHPJ转化为有机硫酸盐损失|
|AE           |OSO4AQPAAJ  | 96.0 |ASO4AQPAAJ转化为有机硫酸盐损失|
|AE           |OSO4GASJ    | 96.0 |ASO4GASJ转化为有机硫酸盐损失|
|AE           |OSO4EMISJ   | 96.0 |ASO4EMISJ转化为有机硫酸盐损失|
|AE           |OSO4ICBCJ   | 96.0 |ASO4ICBCJ转化为有机硫酸盐损失|

**联系人**

 [Shawn Roselle](mailto:roselle.shawn@epa.gov), Computational Exposure Division, U.S. EPA
 
<!-- BEGIN COMMENT -->

[<< 前一章](CMAQ_UG_ch11_ISAM.md) - [返回](README.md) - [下一章 >>](CMAQ_UG_ch13_WRF-CMAQ.md) <br>
CMAQ用户手册 (c) 2020<br>

<!-- END COMMENT -->
