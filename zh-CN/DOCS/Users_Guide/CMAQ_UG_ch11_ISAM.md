
<!-- BEGIN COMMENT -->

[<< 前一章](CMAQ_UG_ch10_HDDM-3D.md) - [返回](README.md) - [下一章 >>](CMAQ_UG_ch12_sulfur_tracking.md)

<!-- END COMMENT -->

# 11 综合源分配方法(Integrated Source Apportionment Method，CMAQ-ISAM)
## 11.1 简介

综合源分配方法（ISAM）在CMAQ模型中用于计算用户指定的臭氧和颗粒物前体物的来源信息。CMAQ-ISAM在CMAQv5.3版本中已进行了实质性更新，并且与以前的版本有显着差异。[ISAM化学补充文件]( Supplement/CMAQ_ISAM_Chemistry_Supplemental_Equations.pdf )中详细介绍了ISAM化学求解器的主要更改。

CMAQ模型为用户提供了许多污染物种类的浓度和沉积场。这些物种通常是已在模型中进行物理和化学转换的不同类型的一次排放和二次形成的组合。但是，有时用户希望知道模型输出的特定污染来源信息。例如，由于邻近州的机动车排放的氮氧化物，在市区形成了多少臭氧？

要回答此类问题，通常需要运行两次空气质量模型，一次是在标准排放情景下，一次是在完全去除目标源情境下。然后，假定两次运行之间的差异归因于已删除的污染源。尽管此方法实施起来相当简单，但它也有一些缺点。例如，在高度非线性的化学混合物系统中删除一个大的排放源会导致某些错误。而且，同时计算许多污染物的来源信息在逻辑上和计算上都是不可行的。

或者，在启用ISAM的情况下运行CMAQ，使用户能够通过模型在一次模拟中直接计算大量污染物的来源信息。

注意：虽然正在开发完整模型物种清单的分配方法，但目前ISAM仅限于CMAQ中的以下物种类别：

```
SULFATE   - ASO4J, ASO4I, SO2, SULF, SULRXN       
NITRATE   - ANO3J, ANO3I, HNO3, ANO3J, ANO3I, HNO3, NO, NO2, NO3, HONO, N2O5, PNA, PAN, PANX, NTR1, NTR2, INTR           
AMMONIUM  - ANH4J, ANH4I, NH3       
EC        - AECJ, AECI          
OC        - APOCI, APOCJ, APNCOMI, APNCOMJ                
VOC       - Various species depending on mechanism. Now includes CO. (see CCTM/src/isam/SA_DEFN.F for complete list)      
PM25_IONS - ANAI, ANAJ, AMGJ, AKJ, ACAJ, AFEJ, AALJ, ASIJ, ATIJ, AMNJ, AOTHRI, AOTHRJ      
OZONE     - all NITRATE species + all VOC species     
CHLORINE  - ACLI, ACLJ, HCL      
```

## 11.2 编译说明

从CMAQv5.3版本开始，ISAM直接随CMAQ模型的源代码一起提供。要使用ISAM，请按照[第5章]( CMAQ_UG_ch05_running_a_simulation.md )中描述的CMAQ正常编译过程进行，但请确保在bldit_cctm.csh中取消注释以下行：

```
set ISAM_CCTM
```

**用于ISAM应用程序的I/O API安装说明**

I/O API v3.2最多支持MXFILE3=256个打开文件，每个文件最多MXVARS3=2048。ISAM应用程序在配置计算大量污染物来源属性时可能会超出模型该变量的上限，从而导致模型崩溃。为避免此问题，用户可以使用I/O API v5.3-large，它将MXFILE3增加到512，将MXVARS3增加到16384。有关编译此版本的说明，请参见[第3章]( CMAQ_UG_ch03_preparing_compute_environment.md#333-io-api-library )。
请注意，对于CMAQ-ISAM基准测试案例，不需要使用此ioapi-large版本。
如果用户需要使用更大的MXFILE3和MXVAR3设置来支持其应用程序，请注意内存需求将增加。
该版本可以从以下地址以zip文件形式提供：

https://www.cmascenter.org/ioapi/download/ioapi-3.2-large-2020220.tar.gz

## 11.3 运行说明

要在启用ISAM的情况下开始CMAQ模拟，必须配置运行脚本的ISAM部分。 表11-1中列出了其他必要的环境变量。

<a id=Table11-1></a>

**表11-1. ISAM运行脚本变量**

|**变量** | **设置** | **描述**|
|-------|----------|------------|
|CTM_ISAM|Y/N|设为“Y”以启用ISAM|
|SA_IOLIST|path/filename|提供ISAM控制文件的位置和文件名（详见下述）|
|ISAM_BLEV_ELEV|" MINVALUE MAX VALUE "|瞬时ISAM输出浓度的LAYER范围|
|AISAM_BLEV_ELEV|" MINVALUE MAX VALUE "|平均ISAM输出浓度的LAYER范围|
|ISAM_NEW_START|Y/N|设为“Y”是开始新的模拟，设为“N”是从前一天的输出继续模拟|
|ISAM_PREVDAY|path/filename|提供前一天的ISAM重新启动文件的位置和文件名|
|SA_ACONC_1|path/filename|ISAM输出的平均分配浓度的位置和文件名|
|SA_CONC_1|path/filename|ISAM输出的瞬时分配浓度的位置和文件名|
|SA_DD_1|path/filename|ISAM输出的分配干沉降的位置和文件名|
|SA_WD_1|path/filename|ISAM输出的分配湿沉降的位置和文件名|
|SA_CGRID_1|path/filename|ISAM输出的重新启动文件的位置和文件名，可用于下次模拟|

此外，ISAM可以跟踪仅限于地理区域的排放。可以通过在`EmissCtrl`清单（附录B.4）中设置CMAQ的`RegionsRegistry`以启用此功能，下面将进一步讨论。

#### ISAM和双向NH<sub>3</sub>交换

CMAQ v5.3中ISAM使用的M3Dry和STAGE沉积选项都支持双向NH<sub>3</sub>交换。要使用此选项运行，必须在ISAM控制文件中设置铵盐物种类别：

```
TAG CLASSES     |AMMONIUM
```

同时必须在运行脚本中设置ABFLUX。

```
setenv CTM_ABFLUX Y          #> ammonia bi-directional flux for in-line deposition
```

设置这些选项将自动为模型输出设置BID标签。具有BID标签的模拟物种输出代表肥料和生物源NH<sub>3</sub>排放源对NH<sub>3</sub>排放的影响。在STAGE或M3Dry模型中参数化的生物源NH<sub>3</sub>排放包括从非农业植被和土壤NH<sub>4</sub>库中逃逸NH<sub>3</sub>。

### 11.3.1 ISAM控制文件(SA_IOLIST)

ISAM的`SA_IOLIST`是一个文本文件，用于配置模型将跟踪的标签类别（tag classes）、排放源和源区域。在$CMAQ_HOME/CCTM/scripts中提供了此文件的一个示例：`isam_control.txt`。该文件的顺序和格式必须保持完整，但允许插入注释行。

每次ISAM模拟都需要用户提供希望分配污染物的标签类别（tag classes）说明。当前列表包括以下选项：硫酸盐（SULFATE）、硝酸盐（NITRATE）、铵盐（AMMONIUM）、EC、OC、VOC、PM25_IONS、OZONE。11.1节提供了与这些物种类别相关的物种。这些标签类别（tag classes）中的一个或多个必须在`SA_IOLIST`文件中指定。多个标签类别以逗号分隔。为该字段指定错误的选择将导致模型崩溃。

```
TAG CLASSES     |OZONE, SULFATE
```

设置标签类别（tag classes）后，还需要一个或多个标签的信息。每个单独的标签都会从指定的标签类别（tag classes）中跟踪物种，并在控制文件中拥有自己的三个选项。第一个选项是名称：

```
TAG NAME        |EGU
```

建议将标签名称的文本字符串保持简短（三个字符或更少），以适应ISAM输出文件中某些化学机理中较长的物种名称。如果指定的'TAG NAME'太长而无法容纳每个标记的CMAQ物种名称和附加的标记名称，则输出的ISAM种类名称可能无法正确写入输出文件，因为在IOAPI中变量名称最多可以包含16个字符。例如，'BUTADIENE13_EGU'可以使用，因为它是15个字符，但是'BUTADIENE13_EGUT1'可能会导致措施，因为它是17个字符。

第二个选项是用此标签跟踪的区域名称，多个区域以逗号分隔。关键字`EVERYWHERE`用于跟踪全部区域的排放。为了跟踪某些特定区域的排放，请使用`EmissCtrl`名称列表中指定的区域文件中的变量名称来代替`EVERYWHERE`关键字。要求区域文件应与用于在预定地理区域中缩放排放的可选文件相同。有关区域文件（包括如何下载示例文件）的更多详细信息，请参见[附录B.4]( Appendix/CMAQ_UG_appendixB_emissions_control.md#b4-applying-masks-for-spatial-dependence )。

```
REGION(S)       |EVERYWHERE
```

或者

```
REGION(S)       |NC, SC, GA
```

最后，排放源标签是控制文件中要求的第三个选项。标签对应于在基本CMAQ模拟的编译和运行脚本中设置的排放和其他输入源。另外，可以将'PVO3'指定为源标签，以便跟踪由于潜在涡度计算而导致的上层注入对浓度的贡献。此选项需要带有适当选项的模型编译来支持这些计算。

```
EMIS STREAM(S)  |PT_EGU, PT_NONEGU
```

控制文件中的最后一行需要保持不变，以帮助文件解析器读取此文件。

```
ENDLIST eof
```

除了用户指定的列表之外，如果模拟同时包含双向NH<sub>3</sub>和铵盐物种种类，则ISAM还将始终跟踪并输出每个模拟和BID标签的三个附加默认标签。（注意，必须定义至少一个有效的用户指定标签，因此至少需要4个标签）：

```
ICO - 模拟第一天初始条件的贡献
BCO - 整个模拟期中边界条件的贡献
OTH - 模型中所有未标记的排放源和其他过程的贡献
BID - 双向NH3交换的贡献
```

请注意，当前同一用户定义标签的ISAM结果可能会有所不同，具体取决于ISAM控制文件的整体配置和内容。该方法的弱点在[ISAM化学补充文件]( Supplement/CMAQ_ISAM_Chemistry_Supplemental_Equations.pdf )的最后一部分中进行了详细说明。通常，跟踪大量标签会产生更加一致的分配结果。

#### OTH标签解释
OTH标签（例如ISAM基准测试案例中的“O3_OTH”）表示归因于以下因素的物种的浓度：1）所有其他排放源；2）未包含在指定标签类别中的前体物种；3）模型中的其他过程。

对于第1项，这包括用户决定从控制文件中排除的内部计算的排放量（可能是为了减少计算量），比如在线生物源，在线闪电，扬尘等。

对于第2项，它们是一些次生的中间物种，对臭氧的产生影响较小。

对于第3项，这些是模型中的过程，这些过程会创建给定的物种，但不会从可通过控制文件指定的排放源中产生。例如，“O3_OTH”包括由模型中指定为常数的背景甲烷产生的臭氧。

最后，ISAM是归因的近似值。在公式中，假设哪些物种在所研究物种的化学形式中最重要。例如，在基于cb6r3的机理中，来自芳族化合物的过氧自由基会少量影响臭氧的产生，因此ISAM忽略了它们的作用。即使ISAM公式中未包含的物种的排放源已包含在控制文件中，也会将其对臭氧的贡献定为“O3_OTH”。

## 11.4 ISAM基准测试数据
CMAQv5.3.2 ISAM基准测试案例的输入文件与基础模型的基准测试输入文件相同，详见[CMAQ基准测试教程]( Tutorials/CMAQ_UG_tutorial_benchmark.md )中所述。与该发行包中提供的`isam_control.txt` 示例相关联的源分配输出文件包含在基本模型的基准测试输出文件中。

可以从[CMAS中心数据仓库SE53BENCH]( https://drive.google.com/drive/folders/1wvz0jQuqnuT8RNj_EMuLec154-rFXucv )Google Drive文件夹中下载CMAQ基准测试案例数据。CMAQ基准测试案例是美国东南部区域2016年7月1-2日的为期两天的模拟，网格划分为100列×80行×35层，网格12公里。同时，为期两周，涵盖了2016年7月1日至14日的基准测试案例数据也可以在同一Google Drive文件夹中下载。

- CMAQ基准测试案例输入元数据: https://doi.org/10.15139/S3/IQVABD 
- CMAQ基准测试案例输出元数据: https://doi.org/10.15139/S3/PDE4SS


## 11.5 参考文献

Kwok, R.H.F, Napelenok, S.L., & Baker, K.R. (2013). Implementation and evaluation of PM2.5 source contribution analysis in a photochemical model. Atmospheric Environment, 80, 398–407 [doi:10.1016/j.atmosenv.2013.08.017](https://doi.org/10.1016/j.atmosenv.2013.08.017).

Kwok, R.H.F, Baker, K.R., Napelenok, S.L., & Tonnesen, G.S. (2015). Photochemical grid model implementation of VOC, NOx, and O3 source apportionment. Geosci. Model Dev., 8, 99-114. [doi:10.5194/gmd-8-99-2015](https://doi.org/10.5194/gmd-8-99-2015).  


**联系人**

[Sergey L. Napelenok](mailto:napelenok.sergey@epa.gov), Computational Exposure Division, U.S. EPA


<!-- BEGIN COMMENT -->

[<< 前一章](CMAQ_UG_ch10_HDDM-3D.md) - [返回](README.md) - [下一章 >>](CMAQ_UG_ch12_sulfur_tracking.md)<br>
CMAQ用户指南 (c) 2020<br>

<!-- END COMMENT -->
