<!-- BEGIN COMMENT -->

[<< 附录A](CMAQ_UG_appendixA_model_options.md) - [返回](../README.md) - [附录C >>](CMAQ_UG_appendixC_spatial_data.md)

<!-- END COMMENT -->

* * *

# 附录B 排放源输入和控制
跳转到[DESID教程](../Tutorials/CMAQ_UG_tutorial_emissions.md) 查阅有关排放源基本操作的逐步说明。

跳转到本用户指南[第6章的排放源概述](../CMAQ_UG_ch06_model_configuration_options.md)。

## B.1 带有DESID模块的排放控制

除了运行脚本中可用的选项之外，CMAQ现在还可以读取专用的名称列表，以应用全面的规则来读取和缩放排放。默认情况下，名为**排放控制名称列表，Emission Control Namelist**的名称列表被命名为“EmissCtrl.nml”，并且每种机理都有一个对应的单独版本，因为在这些名称列表中预载了可能的规则，这些规则将重要的CMAQ主要物种的排放与其由SMOKE输出的典型替代名称联系起来。默认情况下，此名称列表存储在每个化学机理文件夹中（例如MECHS/cb6r3_ae7_aq），并在执行bldit_cctm.csh时复制到用户的构建目录中。如果用户修改了此名称列表的文件名或位置，则还应相应的更新运行脚本中的以下命令：

```
setenv EMISSCTRL_NML ${BLD}/EmissCtrl.nml
```

CMAQv5.3中的DESID模块为用户提供了全面的自定义设置和排放操作透明性。通过**排放控制名称列表，Emission Control Namelist**可以实现排放的自定义，该列表包含四个部分的变量，这些变量可以修改排放模块的行为。其中包括***一般规格***、***排放缩放规则***、***尺寸分布***和***地区注册***。

## B.2 一般规格

这些变量会修改或限制名称列表其他部分的效果。"Guard_XXX"选项允许用户来保护特定的源，使其避免受到源字段中的“ALL”关键字通过缩放规则（在B.3节中进行说明）的修改。例如，"Guard_BiogenicVOC"选项表示模型不要缩放来自实时计算BEIS模块的生物源VOC排放，即使规则指示“ALL”（全部的）排放源将被缩放。其他“Guard_XXX”选项对于其他实时计算排放源（如风吹扬尘、海浪、海洋气体和闪电NO）也具有相同的效果。

## B.3 排放缩放规则

利用本节中的规则，用户可以对应用于特定流、特定地理区域和/或特定化合物的排放量的缩放比例进行复杂、精确的控制。CMAQ用于解释排放的规则集应在一个称为EM_NML的数组中提供。必须为每个规则填充每个字段（即列）。这些字段在此处和“排放控制名称列表”的注释部分中给出和定义：

```
! Region      | Stream Label  |Emission | CMAQ-        |Phase/|Scale |Basis |Op  
!  Label      |               |Surrogate| Species      |Mode  |Factor|      |
```

- “区域标签（Region Label）” - 对模型区域的特定区域应用缩放。将此字段设置为“EVERYWHERE”以将规则应用于整个模型区域。

- “源标签（Stream Label）” - 运行脚本的简称（例如GR_EMIS_01_LAB或STK_EMIS_01_LAB的值）。有一些保留名称适用于实时计算排放源。这些是：
  - BIOG - 生物源VOC排放
  - MGEM - 海洋气体排放
  - LTNG - 闪电NO排放
  - WBDUST - 风吹扬尘排放
  - SeaSpray - 海浪气溶胶排放

  将此字段设置为“ALL”以将规则应用于所有排放源。

- “排放替代物（Emission Surrogate）” - 标识排放文件或实时计算中应映射CMAQ物种的替代物的字符串。通常，为方便起见，此名称与CMAQ物种相同。对于气溶胶，通常略有不同（例如ANO3与PNO3）。将此字段设置为“ALL”以将规则应用于所有排放替代物。

- “CMAQ-物种（Species）” - 内部物种名称。将此字段设置为“ALL”以将规则应用于所有CMAQ内部物种。

- “相/模态（Phase/Mode）” - 如果CMAQ-物种是气体，则此字段应为“Gas”。如果CMAQ-物种是一种气溶胶，则此字段应指示一种可能的排放气溶胶模态。默认情况下，每个源都被赋予“COARSE（粗）”和“FINE（细）”模态。用户可以直接设置为这些内容，或在上面定义其他类型并设置它们。需要这种特殊性水平，以便正确计算气溶胶数量和表面积，并可以正确处理气体和气溶胶之间的任何单位转换。

- “比例因子” - 应用于映射的调整因子。

- “基数（Basis）” - 指定在执行缩放操作时是否应直接应用缩放选项，或者应用缩放操作时是否保存摩尔或质量。CMAQ拥有一个已知排放替代物种类的分子量查找表，可以使用这些表将摩尔和质量排放率从输入文件转换为CMAQ物种。CMAQ通过读取文件头来确定排放替代物种类的单位，即单位的准确性很重要。输入选项包括：

  - “质量（MASS）” - 保存质量。例如，如果要将气溶胶的排放量与气体替代物的排放量成比例，通常希望保存质量。

  - 'MOLE（MOLE）' - 保存摩尔数。例如，如果要将气相物质的排放按比例缩放到另一种气体，则有时希望保存摩尔数，因为气体排放是以摩尔数为基础提供的。

  - 'UNIT（UNIT）' - 忽略分子量转换并直接应用排放率，与单位无关。

- '执行（Operation）' - 指定要执行的规则的种类，选项有：

  - 'a' - 将规则添加到现有说明中。此操作也应用于新条目。

  - 'm' - 查找与该规则的特征（即物种、流等）匹配的现有缩放指令，并将它们乘以该特定规则中的因子。

  - 'o' - 查找符合此规则的现有扩展指令并覆盖它们。

### B.3.1 默认规则

CMAQ存储库中的“排放控制名称列表”包含默认规则，这些规则与每种化学机理相对应。下面是一个默认规则的示例，该规则将CMAQ中的NO链接到比例因子为1.0的每个模型网格单元中每个排放源的NO。

```
! Region      | Stream Label  |Emission | CMAQ-        |Phase/|Scale |Basis |Op  
!  Label      |               |Surrogate| Species      |Mode  |Factor|      |
'EVERYWHERE'  , 'All'         ,'NO'     ,'NO'          ,'GAS' ,1.0  ,'UNIT','a',
```

为了将每种排放源的污染物与CMAQ物种正确关联，此处需要许多规则。气相和气溶胶相物种需要规则。对于实时计算气溶胶模块，例如风吹扬尘和海浪排放模块，还存在其他规则，因为来自这些模块的气溶胶替代物的名称不同于通常用SMOKE输出的名称。例如，细模式的气溶胶硫酸盐在SMOKE中通常称为PSO4，而在风吹扬尘和海浪排放模块中则称为PMFINE_SO4。

### B.3.2 修改默认规则

用户可以修改任何默认规则来更改应用的比例因子。或者，用户可以在默认规则之后添加新规则以自定义排放。典型的修改可能包括将特定源中的特定物种的排放量乘以2倍，或将特定源中的所有物种的排放量乘以零，等等。请参见有关[使用DESID规定排放量]( ../Tutorials/CMAQ_UG_appendixB_emissions_control.md )以获取修改的具体示例以及用于调用它们的语法。

#### B.3.2.1 支持挥发性基础集

用于处理一次有机排放物的半挥发性分区的*挥发性基础集（Volatility Basis Set）*是DESID很好支持的模型特征的一个示例。该方法涉及在一系列挥发性不同的气溶胶和气体种类之间分配总的一次有机气溶胶（碳和非碳质量、或POC和PNCOM）的排放。

如果用户想调用不挥发性划分假设，则可以通过将所有POC和PNCOM排放定向到CMAQ中的POC和PNCOM种类来实现。

```
  ! --> Nonvolatile POA
  'EVERYWHERE', 'ALL'         ,'POC'    ,'APOC'        ,'FINE',1.   ,'MASS','a',
  'EVERYWHERE', 'ALL'         ,'PNCOM'  ,'APNCOM'      ,'FINE',1.   ,'MASS','a',
```

如果用户希望将默认挥发性划分应用于POA排放，则可以使用以下默认规则来完成。

```
  ! --> Semivolatile POA
  'EVERYWHERE', 'ALL'         ,'POC'    ,'VLVPO1'      ,'GAS' ,0.   ,'MASS','a',
  'EVERYWHERE', 'ALL'         ,'PNCOM'  ,'VLVPO1'      ,'GAS' ,0.   ,'MASS','a',
  'EVERYWHERE', 'ALL'         ,'POC'    ,'VSVPO1'      ,'GAS' ,0.045,'MASS','a',
  'EVERYWHERE', 'ALL'         ,'PNCOM'  ,'VSVPO1'      ,'GAS' ,0.045,'MASS','a',
  'EVERYWHERE', 'ALL'         ,'POC'    ,'VSVPO2'      ,'GAS' ,0.14 ,'MASS','a',
  'EVERYWHERE', 'ALL'         ,'PNCOM'  ,'VSVPO2'      ,'GAS' ,0.14 ,'MASS','a',
  'EVERYWHERE', 'ALL'         ,'POC'    ,'VSVPO3'      ,'GAS' ,0.18 ,'MASS','a',
  'EVERYWHERE', 'ALL'         ,'PNCOM'  ,'VSVPO3'      ,'GAS' ,0.18 ,'MASS','a',
  'EVERYWHERE', 'ALL'         ,'POC'    ,'VIVPO1'      ,'GAS' ,0.50 ,'MASS','a',
  'EVERYWHERE', 'ALL'         ,'PNCOM'  ,'VIVPO1'      ,'GAS' ,0.50 ,'MASS','a',
  'EVERYWHERE', 'ALL'         ,'POC'    ,'ALVPO1'      ,'FINE',0.09 ,'MASS','a',
  'EVERYWHERE', 'ALL'         ,'PNCOM'  ,'ALVPO1'      ,'FINE',0.09 ,'MASS','a',
  'EVERYWHERE', 'ALL'         ,'POC'    ,'ASVPO1'      ,'FINE',0.045,'MASS','a',
  'EVERYWHERE', 'ALL'         ,'PNCOM'  ,'ASVPO1'      ,'FINE',0.045,'MASS','a',
  'EVERYWHERE', 'ALL'         ,'POC'    ,'ASVPO2'      ,'FINE',0.   ,'MASS','a',
  'EVERYWHERE', 'ALL'         ,'PNCOM'  ,'ASVPO2'      ,'FINE',0.   ,'MASS','a',
  'EVERYWHERE', 'ALL'         ,'POC'    ,'ASVPO3'      ,'FINE',0.   ,'MASS','a',
  'EVERYWHERE', 'ALL'         ,'PNCOM'  ,'ASVPO3'      ,'FINE',0.   ,'MASS','a',
  'EVERYWHERE', 'ALL'         ,'POC'    ,'AIVPO1'      ,'FINE',0.   ,'MASS','a',
  'EVERYWHERE', 'ALL'         ,'PNCOM'  ,'AIVPO1'      ,'FINE',0.   ,'MASS','a',
```

请注意，对于每个物种（例如ALVPO1），都需要一个规则来将该物种与POC的排放联系起来，并且需要另一个规则来添加PNCOM。这是因为碳和非碳质量都是每个半挥发性物质排放的一部分。要更改所有源的挥发性分布，用户可以在上面的默认规则中修改比例因子。如果要为特定源（例如住宅木材燃烧、森林火灾、柴油车辆等）引入专门的挥发性分布，可以在“源标签（Stream Label）”字段中添加规则，以明确标识排放源。

## B.4 为空间依赖性应用蒙版

网格化的蒙版用于将规则应用于模型区域的特定区域。例如，以下规则：

```
! Region      | Stream Label  |Emission | CMAQ-        |Phase/|Scale |Basis |Op  
!  Label      |               |Surrogate| Species      |Mode  |Factor|      |
'KENTUCKY'    , 'All'         ,'All'    ,'All'         ,'All' ,1.50 ,'UNIT','m',
```

将使所有排放源中的所有物种的排放量增加50％，但仅限于肯塔基州的网格中。要使用此选项，需要一个或多个包含地理区域定义的I/O API格式的输入文件。对于每个感兴趣的空间区域，此类文件应包含一个单独的变量。每个变量都是从0.0到1.0的实数的网格字段，其中0.0标明该网格在感兴趣区域之外，而1.0标明该网格完全在感兴趣区域内部。区域边界网格单元应具有归属于该区域的地理分数（例如，在肯塔基州35％和田纳西州65％的网格单元中，代表肯塔基州蒙版的变量的数字为0.35。

CMAQ通过运行脚本中标识的环境变量来读取这些蒙版文件。例如：

```
setenv US_STATES /home/${CMAQ_HOME}/CCTM/scripts/us_states.nc
```

如果使用了来自多个蒙版文件的变量，则需要在运行脚本中定义每个蒙版文件。

排放控制名称列表的*地区注册（RegionsRegistry）*部分将每个“区域标签（Region Label）”映射到特定文件上的特定变量。这是默认名称列表中的*地区注册（RegionsRegistry）*部分：

```
&RegionsRegistry
 RGN_NML  =   
 !          | Region Label   | File_Label  | Variable on File
 !<Default>    'EVERYWHERE'  ,'N/A'        ,'N/A',
 !<Example>    'WATER'       ,'CMAQ_MASKS' ,'OPEN',
 !<Example>    'ALL'         ,'CMAQ_MASKS' ,'ALL',
/
```

如上所示，默认情况下，区域标签（Region Label）“EVERYWHERE”处于活动状态，并返回在整个区域中统一操作的蒙版。“File_Label”字段在运行脚本中标识环境变量，该环境变量存储包含蒙版的文件的位置和名称。用户可以将其修改为所需的任何名称，只要它与运行脚本上的变量名称一致即可。“文件上的变量（Variable on File）”字段标识输入文件上的变量，该变量存储要用于此区域的网格化字段。上面提供了两种情况的示例。

第一个示例，需要在运行脚本中定义的文件“CMAQ_MASKS”中，定义一个标签名为“WATER”的区域，并对应到变量“OPEN”（*open water*的缩写）。使用此“WATER”区域，将仅对开放水域网格单元以及沿海岸线的一部分应用缩放规则。第二个示例为具有许多所需变量的文件提供了快捷方式（例如，美国的各个州）。用户可以调用“ALL”关键字，将读取所有变量并与“区域标签”存储在一起，该“区域标签”等于文件上变量的名称，而不是逐个列出文件上的所有变量并将其显式链接到“区域标签（Region Label）”。

CMAS数据仓库上有两个蒙版示例文件：美国各州的网格蒙版文件和NOAA气候区域网格蒙版文件。这些蒙版文件可用于12US1建模网格区域（网格原点x=-2556000m，y=-1728000m；列数=459，行数=299）。

* [CMAS数据仓库Google Drive上的网格蒙版文件](https://drive.google.com/drive/folders/1x9mJUbKjJaMDFawgy2PUbETwEUopAQDl)
* [CMAS中心Dataverse上的网格蒙版文件元数据](https://doi.org/10.15139/S3/XDYYB9)


## B.5 气溶胶尺寸分布

CMAQv5.3中对气溶胶尺寸分布的处理已更新为与国家排放清单和排放处理工具（如SMOKE、MOVES、SPECIATE和Specification Tool）中处理颗粒大小和模式的方式更加一致。具体而言，在这些工具中，通常将气溶胶排放参数化为两种主要模式：细（Fine）和粗（Coarse）。尽管这些模式的尺寸分布参数（即总数、直径、标准偏差等）在排放源之间会有所不同，但以前版本的CMAQ假定所有一次细颗粒物在排放时都具有相同的尺寸分布。粗粒子被假定具有较大的直径，但在所有来源（风吹扬尘和海浪排放除外）上该参数也是相同的。

在CMAQv5.3中，用户通过“排放控制名称列表”的[EmissionScalingRules](CMAQ_UG_appendixB_emissions_control.md#b3-emission-scaling-rules)部分将粒子排放替代物链接到CMAQ粒子物种。默认映射规则的示例可以在CMAQ存储库中的任何“排放控制名称列表”中找到。下面的三行分配了所有源的硫酸盐、铵盐和硝酸盐颗粒物的排放量。

```
! Region      | Stream Label  |Emission | CMAQ-        |Phase/|Scale |Basis |Op  
!  Label      |               |Surrogate| Species      |Mode  |Factor|      |
'EVERYWHERE'  , 'ALL'         ,'PSO4'   ,'ASO4'        ,'FINE',1.0   ,'UNIT','a',
'EVERYWHERE'  , 'ALL'         ,'PNH4'   ,'ANH4'        ,'FINE',1.0   ,'UNIT','a',
'EVERYWHERE'  , 'ALL'         ,'PNO3'   ,'ANO3'        ,'FINE',1.0   ,'UNIT','a',
```

CMAQ-物种（Species）字段应填充大宗化学名称（例如ASO4、AEC、AK、ACA等）。换句话说，应省略通常表示气溶胶种类名称模式的“i”，“j”或“k”。在名为“aerolist”的数组中的源文件“[AERO_DATA.F](../../../CCTM/src/aero/aero6/AERO_DATA.F)”中存在有效的气溶胶批量名称列表。用户还应该使用“相/模态（Phase/Mode）”字段来识别要填充的气溶胶模态。在上面的示例中，所有规则都将“FINE”模态标识为目标模态。CMAQ使用此值来查找尺寸分布参数（直径和标准偏差）以适用于此特定排放。

EmissionScalingRules部分中的气溶胶模态关键字链接到“排放控制名称列表”的SizeDistributions部分中的参考模太标签可以一次为所有源进行这些分配，如初始化“FINE”和“COARSE”模式的前两个默认条目所示，也可以按源的形式进行分配，如下所示为风吹扬尘和海浪排放气溶胶。

```
&SizeDistributions
 SD_NML    =
 !         | Stream Label   | Mode Keyword | Ref. Mode
 !<Default>  'ALL'          ,'FINE'        ,'FINE_REF',
 !<Default>  'ALL'          ,'COARSE'      ,'COARSE_REF',
             'WBDUST'       ,'FINE'        ,'FINE_WBDUST',
             'WBDUST'       ,'COARSE'      ,'COARSE_WBDUST',
             'SEASPRAY'     ,'FINE'        ,'FINE_SEASPRAY',
             'SEASPRAY'     ,'COARSE'      ,'COARSE_SEASPRAY',
 !<Example>  'AIRCRAFT'     ,'FINE'        ,'AIR_FINE',   !To use these examples, you
 !<Example>  'AIRCRAFT'     ,'COARSE'      ,'AIR_COARSE', ! must add entries for AIR_FINE
                                                          ! and AIR_COARSE to the data structure
                                                          ! em_aero_ref in AERO_DATA.
```

“Ref. Mode”标签用于在[AERO_DATA.F](../../../CCTM/src/aero/aero6/AERO_DATA.F)中查找尺寸分布参数。此文件中定义了以下参考模式：

```
TYPE em_aero
    Character( 20 ) :: name
    Real            :: split( n_mode )  ! dimensionless
    Real            :: dgvem( n_mode )  ! meters
    Real            :: sgem ( n_mode )  ! dimensionless
END TYPE em_aero
INTEGER, PARAMETER  :: n_em_aero_ref = 9

TYPE( em_aero ), Parameter :: em_aero_ref( n_em_aero_ref ) = (/

!              ----Name----     -----Split-----    ---Geo. Mean Diameter---   ---Stnd Dev.---
& em_aero('FINE_REF       ',(/0.1,0.9,0.0/),(/0.06E-6,0.28E-6 ,6.0E-6 /),(/1.7,1.7,2.2/)), ! Default Accum and Aitken Mode
& em_aero('ACC_REF        ',(/0.0,1.0,0.0/),(/0.06E-6,0.28E-6 ,6.0E-6 /),(/1.7,1.7,2.2/)), ! Just Accumulation Mode
& em_aero('COARSE_REF     ',(/0.0,0.0,1.0/),(/0.06E-6,0.28E-6 ,6.0E-6 /),(/1.7,1.7,2.2/)), ! Just Coarse Mode
& em_aero('UNITY_REF      ',(/1.0,1.0,1.0/),(/0.06E-6,0.28E-6 ,6.0E-6 /),(/1.7,1.7,2.2/)), ! Used for online sectors (e.g. SeaSpray)
& em_aero('ZERO_REF       ',(/0.0,0.0,0.0/),(/0.06E-6,0.28E-6 ,6.0E-6 /),(/1.7,1.7,2.2/)), ! Zero out the emissions
& em_aero('FINE_WBDUST    ',(/0.0,1.0,0.0/),(/0.06E-6,1.391E-6,5.26E-6/),(/1.7,2.0,2.0/)), ! Default Fine Wind-Blown Dust Parameterization
& em_aero('COARSE_WBDUST  ',(/0.0,0.0,1.0/),(/0.06E-6,1.391E-6,5.26E-6/),(/1.7,2.0,2.0/)), ! Default Coarse Wind-Blown Dust Param.
& em_aero('FINE_SEASPRAY  ',(/0.0,1.0,0.0/),(/0.06E-6,1.391E-6,5.26E-6/),(/1.7,2.0,2.0/)), ! Fine Sea Spray Parameterization is Dynamic.
& em_aero('COARSE_SEASPRAY',(/0.0,0.0,1.0/),(/0.06E-6,1.391E-6,5.26E-6/),(/1.7,2.0,2.0/))  ! Coarse Sea Spray Parameterization is Dynamic.
                                                                                           !  The values here are not actually used but
                                                                                           !  are replaced in SSEMIS when FACNUM and FACSRF
                                                                                           !  are calculated online.
& /)
````

用户可以根据需要添加任意多个新的尺寸分布，只要它们使变量n_em_aero_ref递增到始终等于查找数组（em_aero_ref）中的尺寸分布数即可。

CMAQ将使用通过相/模态（phase/mode）关键字链接到每个排放比例缩放规则的尺寸分布参考值来计算每种气溶胶一次排放应在内部的“i”，“j”和“k”模式中所占的比例气溶胶模块。乍一看，似乎EmissionsScalingRules部分中的相/模态（phase/mode）关键字，SizeDistributions部分中的相应模式关键字和参考模式标签之间的链接步骤是不必要的，但是它起着重要的作用。如前所述，很常见的是，即使尺寸分布参数可能相差很大，来自各种来源的相似尺寸的模式也会被通用名称（例如“FINE”和“COARSE”）所引用。通过SizeDistributions部分中提供的链接步骤，可以分别指定几个流的参数，但是所有参数都标记为“FINE”，并在EmissionsScalingRules部分中使用一个规则应用。

在上面的示例中，细模式的风吹扬尘链接到“FINE_WBDUST”，细模式的海浪气溶胶链接到“FINE_SEASPRAY”，所有其他来源链接到“FINE_REF”。因此，将为这些源中的每一个计算不同的尺寸分布。但是，如果用户希望将所有细模式气溶胶的质量按比例2来缩放，则需要以下排放规则：
```
! Region      | Stream Label  |Emission | CMAQ-        |Phase/|Scale |Basis |Op  
!  Label      |               |Surrogate| Species      |Mode  |Factor|      |
'EVERYWHERE'  , 'ALL'         ,'ALL'    ,'ALL'         ,'FINE',1.0   ,'UNIT','m',
```

## B.6 附加DESID功能

### B.6.1 摘要输出到特定于处理器的日志文件

诊断输出是新排放模块DESID的重要功能。由于排放的影响对于CMAQ预测至关重要，并且由于可用于缩放排放的功能现在非常复杂，因此已将基于文本的全面输出添加到CMAQ日志文件中以提高透明度。

日志文件现在提供了一些信息列表，以帮助保护用户免受诸如排放源与CMAQ物种之间的命名不一致之类的错误的困扰。首先，CMAQ为每个源报告未使用的所有替代物种的数量和名称。其次，它打印用户要求其查找但在任何排放源中都找不到的替代物的名称。如果环境变量：

```
setenv CTM_EMISCHK Y  #> 如果缺少排放输入文件中的替代项，则中止CMAQ
```

设置为“Y”或“True”，则该模型如果找不到任何单个替代项，将会中止运行。如果该变量设置为“N”或“False”，则CMAQ将打印警告并继续。

最后，CMAQ遍历源并输出可用于每个源的尺寸分布模式以及应用于每个源的每个排放的完整列表。这些按CMAQ物种（分别列出了“i”，“j”和“k”模式）进行排序，并替代物种名称，以便可以快速掌握对应用于每个CMAQ物种排放量的换算规则的充分了解。在适用的网格区域，适用的相/模态（phase/mode），输入比例因子，比例基础，操作和最终比例因子的考虑范围内打印列，并考虑到任何分子量的转换（如果需要），以及尺寸分布分数。

### B.6.2 诊断网格化输出文件

现在，使用DESID可以进行许多复杂的缩放过程。建议用户确认排放量已按预期的方式缩放。网格诊断输出是帮助完成此步骤的一种工具。在CMAQ运行脚本中使用以下选项来启用此逐个源的功能：

```
# Gridded Emissions Diagnostic files
# 网格化的排放源诊断文件
  setenv GR_EMIS_DIAG_001 TRUE
  setenv GR_EMIS_DIAG_002 2D

# Stack emissions diagnostic files
# 排气筒源诊断文件
  setenv STK_EMIS_DIAG_001 2DSUM
  setenv STK_EMIS_DIAG_002 2DSUM
  setenv STK_EMIS_DIAG_003 FALSE
  setenv STK_EMIS_DIAG_004 2DSUM
  setenv STK_EMIS_DIAG_005 2DSUM
```

上面的行设置了网格和实时计算排放源的网格化诊断输出文件。每个源可用的值为“TRUE”，“FALSE”，“2D”，“2DSUM”和“3D”。“2D”选项仅打印特定源的地表层的排放。“3D”选项可打印该源填充的所有模型的层。“2DSUM”选项打印一个2D字段，但它等于整个网格化模型区域中的排放列的总和。“TRUE”选项与“2D”选项是相等的。用户还可以使用以下变量设置实时计算源的诊断行为：

```
setenv BIOG_EMIS_DIAG TRUE
setenv MG_EMIS_DIAG TRUE
setenv LTNG_EMIS_DIAG TRUE
setenv DUST_EMIS_DIAG TRUE
setenv SEASPRAY_EMIS_DIAG TRUE
```

创建的网格化诊断输出文件以“CCTM_EMDIAG_[XXX]_[CTM_APPL]_[DATE].nc”的格式命名，其中XXX是排放源标签，CTM_APPL是CCTM运行脚本中定义的项目名称，DATE是模拟的日期。要更改所有排放源的诊断输出的默认值，请修改“EMIS_DIAG”变量：

```
setenv EMIS_DIAG TRUE
```  

此变量设置所有源的默认行为。如果运行脚本中提供了任何特定源的变量，它们将覆盖此默认值。

诊断文件上打印的排放速率反映了所有已应用的换算规则，并在将排放添加到CMAQ传输模块之前被写入。由于模型是按时间插值的，因此写入诊断文件的排放速率很可能不会及时与输入文件中的排放速率相对应。在大多数情况下，排放速率将是排放量输入的时间点，即每小时的开始时刻之前的一半的时间步长。因此，将比例缩放的排放直接与输入文件中的排放速率进行比较对用户并不是完全有帮助的。但是，定性比较它们可能会有所帮助。

<!-- BEGIN COMMENT -->

[<< 附录A](CMAQ_UG_appendixA_model_options.md) - [返回](../README.md) - [附录C >>](CMAQ_UG_appendixC_spatial_data.md)<br>
CMAQ用户指南 (c) 2020<br>

<!-- END COMMENT -->
