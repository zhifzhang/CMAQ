
### CMAQ化学机理

CMAQ模型系统将化学反应分为三个阶段：气体、气溶胶和云滴。可用的化学机理包括三种光化学方案的变体，例如次级有机气溶胶的不同表示形式，代表有害空气污染物的其他模型物种，包括二甲基硫醚化学或详细的异戊二烯化学。请参阅发布说明，以了解特定版本的CMAQ中可用化学机理的变化情况。

Fortran模块和清单文件定义了CMAQ模型的化学机理。在$CMAQ_MODEL/CCTM/src/MECHS目录的子目录中包含了可用的化学机理的相关文件。物种清单和排放控制清单使您可以设置化学机理的运行选项。物种名称列表文件定义了物种的名称、分子量和大气过程（例如传输、云化学和沉积）。这些文件还决定了是否将物种的浓度和沉积结果写入输出文件。排放控制清单定义了模型物种的排放输入。RXNS_DATA_MODULE.F90和RXNS_FUNC_MODULE.F90这两个Fortran模块定义了该机理的光化学作用。数据模块指定了反应和参数。功能模块用于初始化光化学并计算反应速率常数。由于模型源代码定义了该化学机理的光化学作用，因此已经编译好的CMAQ可执行文件具有固定的光化学作用。
要修改或更改光化学反应，需要修改或替换模块，然后重新编译可执行文件。当使用Euler Backward Interative（EBI）求解器在光化学求解器中硬编码的数据不正确，或者用于计算光解速率的数据不完整时，该方法可能不起作用。
 
### 使用预定义的化学机理

要在CMAQ中选择预定义的化学机理配置文件，请将构建脚本（build scripts）中的*Mechanism*变量设置为$CMAQ_MODEL/CCTM/src/MECHS文件夹下的各个化学机理子目录之一。下表列出了此版本的CMAQ模型中可用的化学机理。

表 1.  CMAQv5.3化学机理

|**化学机理名称** | **光化学反应**                                   | **模型物种<sup>1,2</sup>**    | **云化学模块<sup>3</sup>** |
| ----------------- | ---------------------------------------------------- | -------------------- | ---------------------- |
| cb6r3_ae7_aq      | [Carbon Bond 6 version r3 with aero7 treatment of SOA](mechanism_information/cb6r3_ae7_aq/mech_cb6r3_ae7_aq.md) |  [物种表1](mechanism_information/cb6r3_ae7_aq/cb6r3_ae7_aq_species_table.md)                 | acm_ae7          |
| cb6r3_ae7_aqkmt2    | [Carbon Bond 6 version r3 with aero7 treatment of SOA](mechanism_information/cb6r3_ae7_aq/mech_cb6r3_ae7_aq.md) | [物种表1](mechanism_information/cb6r3_ae7_aq/cb6r3_ae7_aq_species_table.md)                   | acm_ae7_kmt2          |
| cb6r3m_ae7_kmtbr  | [Carbon Bond 6 version r3 with aero7 treatment of SOA and DMS and marine halogen chemistry](mechanism_information/cb6r3m_ae7_kmtbr/mech_cb6r3m_ae7_kmtbr.md) | [物种表2](mechanism_information/cb6r3m_ae7_kmtbr/cb6r3m_ae7_kmtbr_species_table.md)                   | acm_ae7_kmtbr          |
| cb6r3_ae6_aq      | [Carbon Bond 6 version r3 with aero6 treatment of SOA](mechanism_information/cb6r3_ae6_aq/mech_cb6r3_ae6_aq.md) | [物种表3](mechanism_information/cb6r3_ae6_aq/cb6r3_ae6_aq_species_table.md)                   | acm_ae6          |
| cb6mp_ae6_aq      | [Carbon Bond 6 version r3 with air toxics and aero6 treatment of SOA](mechanism_information/cb6r3_ae6_aq/mech_cb6r3_ae6_aq.md) | [物种表4](mechanism_information/cb6mp_ae6_aq/cb6mp_ae6_aq_species_table.md)                   | acm_ae6          |
| racm2_ae6_aq      | [Regional Atmospheric Chemistry Mechanism version 2 with aero6 treatment of SOA](mechanism_information/racm2_ae6_aq/mech_racm2_ae6_aq.md) | [物种表5](mechanism_information/racm2_ae6_aq/racm2_ae6_aq_species_table.md)                   | acm_ae6          |
| saprc07tic_ae7i_aq | [State Air Pollution Research Center version 07tc with extended isoprene chemistry and aero7i treatment of SOA]( mechanism_information/saprc07tic_ae7i_aq/mech_saprc07tic_ae7i_aq.md) | [物种表6](mechanism_information/saprc07tic_ae7i_aq/saprc07tic_ae7i_aq_species_table.md)                   | acm_ae7          |
| saprc07tic_ae7i_aqkmt2 | [State Air Pollution Research Center version 07tc with extended isoprene chemistry and aero7i treatment of SOA](mechanism_information/saprc07tic_ae7i_aq/mech_saprc07tic_ae7i_aq.md)  | [物种表6](mechanism_information/saprc07tic_ae7i_aq/saprc07tic_ae7i_aq_species_table.md)                   | acm_ae7_kmt2          |
| saprc07tic_ae6i_aq | [State Air Pollution Research Center version 07tc with extended isoprene chemistry and aero6i treatment of SOA]( mechanism_information/saprc07tic_ae6i_aq/mech_saprc07tic_ae6i_aq.md) | [物种表7](mechanism_information/saprc07tic_ae6i_aq/saprc07tic_ae6i_aq_species_table.md)                   | acm_ae6          |
| saprc07tic_ae6i_aqkmti | [State Air Pollution Research Center version 07tc with extended isoprene chemistry and aero6i treatment of SOA](mechanism_information/saprc07tic_ae6i_aq/mech_saprc07tic_ae6i_aq.md)  | [物种表7](mechanism_information/saprc07tic_ae6i_aq/saprc07tic_ae6i_aq_species_table.md)                   | acm_ae6_kmti          |
| saprc07tc_ae6_aq | [State Air Pollution Research Center version 07tc with aero6 treatment of SOA](mechanism_information/saprc07tc_ae6_aq/mech_saprc07tc_ae6_aq.md)  | [物种表8](mechanism_information/saprc07tc_ae6_aq/saprc07tc_ae6_aq_species_table.md)                   | acm_ae6         |       

1. 化学机理可以共享相同的模型物种，但云化学不同
2. 物种表在化学机理的GC、AE和NR名称列表文件中定义模型物种
3. _kmt_ 和 _acm_ 分别表示转移到云滴的动力学质量和对流云/传输

### 创建或修改化学机理的光化学方案

编辑化学机理的Fortran模块是对光化学方案进行简单更改的一种方法。要进行更复杂的更改（ _添加反应和模型物种_ ）或创建新方案需要：1）使用文本编辑器创建新的名称列表文件（ _如需添加新的模型物种_ ）；2）使用CMAQ化学机制实用程序CHEMMECH生成新的Fortran模块。CHEMMECH实用程序可以将含有光化学反应清单的ASCII文件转换为CMAQ使用的Fortran模块。有关更多信息，请查阅$CMAQ_MODEL/UTIL/chemmech文件夹下的README文件。
创建新的化学机理模块可能不是CMAQ模型使用光化学更新的最后一步。如果更改增加了新的光解速率，则inline_phot_preproc或jproc实用程序必须为所用的光解模块创建CMAQ输入文件。如果CMAQ使用EBI求解器求解光化学，则必须使用create_ebi实用程序来创建新的求解器。这三个实用程序使用CHEMMECH实用程序生成的化学机理数据模块。

### 使用物种名称列表文件

物种名称列表文件定义了CMAQ模型模拟的四类物种：气体（GC），气溶胶（AE），非反应性（NR）和示踪剂（TR）物种。
它读取名称列表以定义确定浓度的过程。例如，物种名称列表可用于将统一的比例因子应用于几个物理过程。通过将NO的干沉积速度乘以0.5，可以将NO的干沉积减少50％。同样，通过应用1.5的因子，O<sub>3</sub>的边界条件可以增加50％。气体、气溶胶和非反应性名称列表定义了一种特定的化学机理。
示踪剂名称列表通常在化学机理之间可以互换。它可以用于传输和沉积研究。
示踪剂名称列表文件的示例位于$CMAQ_MODEL/CCTM/src/MECHS/trac0（ _最常用的版本_ ）和$CMAQ_MODEL/CCTM/src/MECHS/trac1下。

### 化学机理注意点

- 用于光化学的欧拉反向迭代（EBI）解算器被硬编码到Fortran数据模块中，该模块代表光化学和物种名称列表中的特定名称。如果有任何更改，则需要新的或不同的EBI求解器源代码。
- Rosenbrock和SMVGEAR光化学求解器未对上述文件进行硬编码，因此可以更轻松地更改这些文件。

### 硫追踪方法（STM）选项

此版本的CMAQ包含一个运行选项，该选项提供有关硫预算建模的详细信息。此选项称为“硫追踪方法（STM）”，可跟踪气相和水相化学反应产生的硫酸盐的贡献，以及排放量、初始条件和边界条件的贡献。通过在CTM运行脚本中设置环境变量来激活STM选项：

```
setenv STM_SO4TRACK Y
```

如果启用此选项，则会在运行时将硫跟踪物种添加到AE和NR组中。表2列出了无机硫追踪物质。表3列出了其他无机化学物质向有机硫酸盐的损失的跟踪物种，其化学机理包括该损失途径（SAPRC07TIC_AE6I，SAPRC07TIC_AE7I，CB6R3_AE7或CB6R3M_AE7机理）。

表 2. 硫跟踪物种

|物种组|物种名称|摩尔质量|描述|
|:------------|:-----------|:-----|:------------|
|AE           |ASO4AQH2O2J | 96.0 |Accumulation mode sulfate (ASO4J) produced by aqueous-phase hydrogen peroxide oxidation reaction:  H<sub>2</sub>O<sub>2</sub> + S(IV) -> S(VI) + H<sub>2</sub>O |
|AE           |ASO4AQO3J   | 96.0 |ASO4J produced by aqueous-phase ozone oxidation reaction:  O<sub>3</sub> + S(IV) -> S(VI) + O<sub>2</sub> |
|AE           |ASO4AQFEMNJ | 96.0 |ASO4J produced by aqueous-phase oxygen catalyzed by Fe<sup>3+</sup> and Mn<sup>2+</sup> oxidation reaction: O<sub>2</sub> + S(IV) -> S(VI) |
|AE           |ASO4AQMHPJ  | 96.0 |ASO4J produced by aqueous-phase methyl hydrogen peroxide oxidation reaction:  MHP + S(IV) -> S(VI) |
|AE           |ASO4AQPAAJ  | 96.0 |ASO4J produced by aqueous-phase peroxyacetic acid oxidation reaction:  PAA + S(IV) -> S(VI) |
|AE           |ASO4GASJ    | 96.0 |ASO4J condensation following gas-phase reaction:  OH + SO<sub>2</sub> -> SULF + HO<sub>2</sub> |
|AE           |ASO4EMISJ   | 96.0 |ASO4J from source emissions |
|AE           |ASO4ICBCJ   | 96.0 |ASO4J from boundary and initial conditions |
|AE           |ASO4GASI    | 96.0 |Aitken mode sulfate (ASO4I) nucleation and/or condensation following gas-phase reaction:  OH + SO<sub>2</sub> -> SULF + HO<sub>2</sub> |
|AE           |ASO4EMISI   | 96.0 |ASO4I from source emissions |
|AE           |ASO4ICBCI   | 96.0 |ASO4I from boundary and initial conditions |
|AE           |ASO4GASK    | 96.0 |Coarse mode sulfate (ASO4K) condensation following gas-phase reaction:  OH + SO<sub>2</sub> -> SULF + HO<sub>2</sub>  |
|AE           |ASO4EMISK   | 96.0 |ASO4K from source emissions |
|AE           |ASO4ICBCK   | 96.0 |ASO4K from boundary and initial conditions |
|NR           |SULF_ICBC   | 98.0 |Sulfuric acid vapor (SULF) from boundary and initial conditions |

表 3.  表示无机硫酸盐向有机硫酸盐损失的其他跟踪物种（仅当使用SAPRC07TIC_AE6I，SAPRC07TIC_AE7I，CB6R3_AE7或CB6R3M_AE7机制时才包括在内）

|物种组|物种名称|摩尔质量|描述|
|:------------|:-----------|:-----|:------------|
|AE           |OSO4J       | 96.0 |Loss of ASO4J to organosulfate |
|AE           |OSO4AQH2O2J | 96.0 |Loss of ASO4AQH2O2J to organosulfate |
|AE           |OSO4AQO3J   | 96.0 |Loss of ASO4AQO3J to organosulfate |
|AE           |OSO4AQFEMNJ | 96.0 |Loss of ASO4AQFEMNJ to organosulfate |
|AE           |OSO4AQMHPJ  | 96.0 |Loss of ASO4AQMHPJ to organosulfate |
|AE           |OSO4AQPAAJ  | 96.0 |Loss of ASO4AQPAAJ to organosulfate |
|AE           |OSO4GASJ    | 96.0 |Loss of ASO4GASJ to organosulfate |
|AE           |OSO4EMISJ   | 96.0 |Loss of ASO4EMISJ to organosulfate |
|AE           |OSO4ICBCJ   | 96.0 |Loss of ASO4ICBCJ to organosulfate |
