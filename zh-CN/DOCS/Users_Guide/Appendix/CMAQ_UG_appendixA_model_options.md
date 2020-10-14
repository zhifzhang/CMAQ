
<!-- BEGIN COMMENT -->

[<< 图件和表格清单](../CMAQ_UG_tables_figures.md) - [返回](../README.md) - [附录B >>](CMAQ_UG_appendixB_emissions_control.md)

<!-- END COMMENT -->

* * *

# 附录A 模型选项

<!-- BEGIN COMMENT -->

<a id=TOC_A></a>
## 目录:

* [A.1 配置选项 (config_cmaq.csh)](#config_cmaq.csh)
* [A.2 编译选项 (bldit_cctm.csh)](#bldit_cctm.csh)
* [A.3 运行选项 (run_cctm.csh)](#run_cctm.csh)
	* [MPI设置，MPI Configuration](#MPI_Config)
	* [垂向幅度，Vertical Extent](#Vertical_Ext)
	* [时间步长设置，Timestep Configuration](#Timestep_Config)
	* [CCTM设置选项，CCTM Configuration Options](#CCTM_Config_Options)
	* [同步时间步长和公差选项，Synchronization Time Step and Tolerance Options](#Syn_time_Option)
	* [科学选项，Science Options](#Science_Options)
	* [处理分析选项，Process Analysis Options](#Process_Analysis_Options)
	* [I/O控制，I/O Controls](#I/O_Controls)
	* [气溶胶诊断控制，Aerosol Diagnostics Controls](#Aersol_Diagnostics_Controls)
	* [诊断输出标志，Diagnostic Output Flags](#Diagnostic_Output_Flags)
	* [非实时计算排放源设置，Offline Emissions Configuration](#Offline_Emissions_Config)
	* [闪电NOx排放设置，Lightning NOx Configuration](#Lightning_NOx_Config)
	* [实时计算生物源排放设置，Online Biogenic Emissions Configuration](#Online_Bio_Config)
	* [风吹扬尘排放源设置，Windblown Dust Emissions Configuration](#windblown_dust_config)

<!-- END COMMENT -->

<a id=config_cmaq.csh></a>

## A.1 配置选项 (config_cmaq.csh)

<!-- BEGIN COMMENT -->

[返回顶部](#TOC_A)

<!-- END COMMENT -->

配置变量的一致性对于构建CMAQ本身（而不仅仅是其库）至关重要。因此，CMAQ包括配置脚本config_cmaq.csh，以帮助为CMAQ及其关联库强制执行一致的环境设置。以下列出了config_cmaq.csh为构建过程定义的变量，并给出了这些变量的建议设置。

请注意，对于多处理器应用程序，建议为Fortran编译器（myFC）指定Fortran MPI包装器脚本mpif90。使用此脚本，而不是直接调用Fortran编译器，可以确保并行构建过程中包含编译器的完整MPI组件套件（库和包含文件）。

-   `CMAQ_HOME` <a id=CMAQ_HOME></a>
    CMAQ的安装目录。例如，如果您要将CMAQ源代码安装在`/home/user/CMAQ`文件夹，可以在bash中采用如下命令来设置CMAQ_HOME：`export CMAQ_HOME=/home/user/CMAQ`；在csh下，可采用如下命令：`setenv CMAQ_HOME /home/user/CMAQ`；注意在CMAQv5.2之前本变量的名称为M3HOME

-   `CMAQ_DATA`<a id=CMAQ_DATA></a>
    由config_cmaq.csh自动设置；注意在CMAQv5.2之前本变量的名称为M3DATA

-   `CMAQ_LIB`<a id=CMAQ_LIB></a>
    由config_cmaq.csh自动设置；注意在CMAQv5.2之前本变量的名称为M3LIB

-   `compiler`<a id=compiler_config></a>
    设置用于编译CMAQ的Fortran编译器类型，包括：intel、pgi、gcc

-   `compilerVrsn`<a id=compilerVrsn></a>
    （可选项）设置用于编译CMAQ的Fortran编译器版本号；如果您使用此变量，在创建构建目录和可执行文件时，会在目录名称中的编译器类型之后加上版本号

-   `IOAPI_INCL_DIR`<a id=IOAPI_INCL_DIR></a>
    您Linux系统上I/O API include文件的安装目录

-   `IOAPI_LIB_DIR`<a id=IOAPI_LIB_DIR></a>
    您Linux系统上I/O API library文件的安装目录

-   `NETCDF_LIB_DIR`<a id=NETCDF_LIB_DIR></a>
    您Linux系统上netCDF C Library文件的安装目录
    
-   `NETCDF_INCL_DIR`<a id=NETCDF_LIB_DIR></a>
    您Linux系统上netCDF C include文件的安装目录

-   `NETCDFF_LIB_DIR`<a id=NETCDF_LIB_DIR></a>
    您Linux系统上netCDF Fortran Library文件的安装目录
    
-   `NETCDFF_INCL_DIR`<a id=NETCDF_LIB_DIR></a>
    您Linux系统上netCDF Fortran include文件的安装目录

-   `MPI_LIB_DIR`<a id=MPI_LIB_DIR></a>
    您Linux系统上Message Passing Interface（MPI）Library文件的安装目录

    -   `ioapi_lib`<a id=ioapi_lib></a>
    您Linux系统上I/O API library的名称，设置为"-lioapi"

-   `netcdf_lib`<a id=netcdf_lib></a>
    您Linux系统上netCDF library C的名称，如果您的netCDF版本低于4.2.0，设置为"-lnetcdf"，如果使用4.2.0或更高版本，设置为"-lnetcdff -lnetcdf"
    
-   `netcdff_lib`<a id=netcdf_lib></a>
    您Linux系统上netCDF Fortran library的名称，如果使用4.2.0或更高版本，设置为"-lnetcdff"，如果使用4.2.0之前的版本，此库与C库捆绑在一起（NetCDF在4.2.0版本以前只有一个C库，自从4.2.0版本开始，将C库和Fortran库分开了，因此如使用4.2.0或更高版本的NetCDF，需要同时设置NetCDF-C和NetCDF-Fortran）

-   `pnetcdf_lib`<a id=pnetcdf_lib></a>
    您Linux系统上parallel netCDF library的名称，设置为"-lpnetcdf"

-   `mpi_lib`<a id=mpi_lib></a>
    您Linux系统上MPI library的名称，如使用MVAPICH设置为"-lmpich"，如使用OpenMPI设置为"-lmpi"

-   `myFC`<a id=myFC></a>
    设置为与用来编译netCDF的`FC`（Fortran编译器）一致

-   `myCC`<a id=myCC></a>
    设置为与用来编译netCDF的`CC`（C编译器）一致

-   `myFSTD` <a id=myFSTD></a>
	您Linux系统上的标准模式Fortran编译器优化标志，用于CMAQ的推荐设置详见发布的脚本文件

-   `myDBG` <a id=myDBG></a>
	您Linux系统上的Debug模式Fortran编译器优化标志，用于CMAQ的推荐设置详见发布的脚本文件

-   `myLINK_FLAGS` <a id=myLINK_FLAGS></a>
	您Linux系统上的Fortran编译链接器标志，用于CMAQ的推荐设置详见发布的脚本文件

-   `myFFLAGS`<a id=myFFLAGS></a>
	您Linux系统上的Fixed-format Fortran编译器优化标志，用于CMAQ的推荐设置详见发布的脚本文件

-   `myCFLAGS`<a id=myCFLAGS></a>
	您Linux系统上的C编译优化标志，用于CMAQ的推荐设置详见发布的脚本文件

-   `myFRFLAGS`<a id=myFRFLAGS></a>
	您Linux系统上的Free form-format Fortran编译器优化标志，用于CMAQ的推荐设置详见发布的脚本文件

-   `extra_lib`<a id=extra_lib></a>
	设置为您Linux系统上进行编译所需的其他库；用户可能需要在发布的脚本文件中更改此设置，才能移植到他们的系统。

-   `EXEC_ID`<a id=EXEC_ID></a>
    构建标记，由config_cmaq.csh自动设置

-   `CMAQ_REPO` <a id=CMAQ_REPO></a> 
	用户CMAQ存储库的位置。如果用户在存储库目录中构建CMAQ，则它将等于CMAQ_HOME。如果用户在储存库目录之外构建CMAQ，则用户必须提供储存库文件夹位置。

<a id=bldit_cctm.csh></a>
## A.2 编译选项 (bldit_cctm.csh)

<!-- BEGIN COMMENT -->

[返回顶部](#TOC_A)

<!-- END COMMENT -->

此处列出的配置选项是在CCTM可执行文件的编译过程中通过CCTM/scripts文件夹下的构建脚本bldit_cctm.csh设置的。调用这些选项时，它们将创建一个固定于指定配置的二进制可执行文件。要更改这些选项，必须重新编译CCTM并创建一个新的可执行文件。

有一部分CCTM科学模块具有多个选项。以下对这些选项进行简要说明。

通过在CCTM构建脚本中取消注释该行，可以调用以下选项。反之，使用“#”注释脚本中的行以关闭该选项。

-   `CompileBLDMAKE`<a id=CopySrc></a>  
    取消注释以从源代码重新编译BLDMAKE实用程序，如果注释掉，则是使用现有的BLDMAKE可执行文件来构建CCTM可执行文件。

-   `CopySrc`<a id=CopySrc></a>  
	取消注释以将源代码复制到构建工作（BLD）目录中。如果注释掉，则仅将已编译的对象和可执行文件放置在BLD目录中。

-   `MakeFileOnly`<a id=MakeFileOnly></a>  
	取消注释以生成Makefile，但不编译可执行文件。Makefile将位于BLD目录中，随后可通过在BLD目录中键入“make”来用于手动编译可执行文件。如果注释掉，则在调用bldit_cctm.csh脚本时创建Makefile并同时编译可执行文件。
    
-   `ParOpt`<a id=ParOpt></a>  
	构建一个可在多处理器上并行运行的可执行文件。打开此选项需要MPI library和INCLUDE文件。

-   `build_parallel_io`<a id=build_parallel_io></a>  
	 取消注释以使用真正的并行I/O功能构建CMAQ（需要ioapi 3.2和pnetcdf的mpi版本，请参考[附录D](../CMAQ_UG_appendixD_parallel_implementation.md)）。

-   `Debug_CCTM`<a id=CopySrc></a>  
    取消注释以在Debug模式下编译CCTM可执行文件。
    
-   `ISAM_CCTM`<a id=CopySrc></a>  
	取消注释以使用集成源分配方法（ISAM）编译CCTM可执行文件。调用此选项之前，请参阅[用户指南第11章](../CMAQ_UG_ch11_ISAM.md)了解更多信息。
    
-   `build_twoway`<a id=build_twoway></a>  
	取消注释以构建WRF-CMAQ耦合模型，不需要耦合模型时应将该选项注释掉。如果您在运行时遇到任何问题，请联系David Wong（wong.david@epa.gov），以获取有关构建WRF-CMAQ耦合模型的具体说明。

-   `potvortO3`<a id=potvort03></a>   
	取消注释以使用潜在涡度对流层O<sub>3</sub>标度构建CMAQ。在调用此选项之前，请参阅[第6章](../CMAQ_UG_ch06_model_configuration_options.md#613-potential-vorticity-scaling)以获取更多信息。

以下配置可能有多个选项。在CCTM构建脚本时应选择其中一个选项。

-   `ModGrid: [default: Cartesian]`<a id=ModGrid></a>  
	CCTM模型网格配置模块。当前，CMAQ仅支持笛卡尔坐标系。请勿更改此模块设置。
    -   `grid/cartesian`

-   `ModAdv: [default: wrf_cons]`<a id=ModHadv></a>  
	3-D水平模块。有关更多信息请参见[第6章](../CMAQ_UG_ch06_model_configuration_options.md#65-advection)。
    -   `wrf_cons`  
    使用WRF垂直积分柱质量计算垂直对流
    -   `local_cons`  
    使用逐层综合质量守恒方案计算垂直对流
    
-   `ModHdiff: [default: hdiff/multiscale]`<a id=ModHdiff></a>  
	在CMAQv5中，水平扩散模块的唯一选项是`hdiff/multiscale`，它使用基于局部风变形的扩散系数。请勿更改此模块设置。有关更多信息，请参见[第6章](../CMAQ_UG_ch06_model_configuration_options.md#66-horizontal-diffusion)。
    -   `hdiff/multiscale`
    
-   `ModVdiff: [default: vdiff/acm2]`<a id=ModVdiff></a>  
	垂直扩散和表面交换模块。请勿更改此模块设置。有关更多信息，请参见[第6章](../CMAQ_UG_ch06_model_configuration_options.md#67-vertical-diffusion)。
    -   `vdiff/acm2`  
	使用非对称对流模型版本2（Asymmetric Convective Model version 2，ACM2）计算垂直扩散
    
-   `ModDepv: [default: depv/m3dry]`<a id=ModDepv></a>  
	沉降计算模块。用户可以在m3dry和STAGE选项之间进行选择。如果需要CMAQ输出土地利用的特定沉降或气孔通量，则必须选择STAGE选项。有关更多信息，请参见[第6章](../CMAQ_UG_ch06_model_configuration_options.md#68-dry-depositionair-surface-exchange)。
	-   `depv/m3dry`   
	CMAQ m3dry干法沉降程序。这是CMAQ中始终存在的模块的更新版本。有关更多信息，请参见[第6章](../CMAQ_UG_ch06_model_configuration_options.md#681-dry-deposition---m3dry)。
    -   `depv/stage`
    CMAQ STAGE干法沉降程序。此选项是5.3版中的新增功能。有关更多信息，请参见[第6章](../CMAQ_UG_ch06_model_configuration_options.md#682-dry-depostion---stage)。

-   `ModEmis: [default: emis/emis]`<a id=ModEmis></a>  
	CMAQ人为源和自然排放源实时计算模块。当用户运行CCTM脚本时会激活实时计算排放源。请勿更改此模块设置。有关更多信息，请参见[第6章](../CMAQ_UG_ch06_model_configuration_options.md#inline-stream-offline)。
    -   `emis/emis`

-   `ModBiog: [default: biog/beis3]`<a id=ModBiog></a>  
	使用BEIS3模型实时计算生物源排放。当用户运行CCTM脚本时会激活实时计算排放源。请勿更改此模块设置。有关更多信息，请参见[第6章](../CMAQ_UG_ch06_model_configuration_options.md#biogenics) 。
    - `biog/beis3`
	
-   `ModPlmrs: [default: plrise/smoke]`<a id=ModPlmrs></a>  
	使用在SMOKE中实现的Briggs算法实时计算大点源的烟羽抬升。当用户运行CCTM脚本时会激活实时计算烟羽抬升。请勿更改此模块设置。有关更多信息，请参见[第6章](../CMAQ_UG_ch06_model_configuration_options.md#inline-stream-offline)。
    - `plrise/smoke`  

-   `ModCgrds: [default: spcs/cgrid_spcs_nml]`<a id=ModCgrds></a>  
    CMAQ模型物种配置模块。
    -   `spcs/cgrid_spcs_nml`  
    用于配置CMAQ模型物种的名称列表文件
    -   `spcs/cgrid_specs_icl`  
    使用Fortran INCLUDE文件配置CMAQ模型物种

-   `ModPhot: [default: phot/inline]`<a id=ModPhot></a>  
    光解计算模块。有关更多信息，请参见[第6章](../CMAQ_UG_ch06_model_configuration_options.md#6103-photolysis) 。
    -   `phot/inline`  
    使用模拟气溶胶和臭氧浓度实时计算光解速率
    -   `phot/table`  
    使用CMAQ程序JPROC非实时计算晴朗天空的光解速率；向CCTM提供每日光解速率查询表

-   `Mechanism: [default: cb05e51_ae6_aq`]<a id=Mechanism></a>  
	气体、气溶胶和水相化学的化学机理。有关CMAQv5.3中可用的机理选择的列表，请参见[CMAQv5.3化学机理表](../../../CCTM/src/MECHS/README.md)。有关更多信息，请参见[第6章](../CMAQ_UG_ch06_model_configuration_options.md#610-gas-phase-chemistry)。
	
-   `Tracer [default trac0] `<a id=Tracer></a>  
	指定示踪物种类。在CMAQ中调用惰性示踪剂物种需要使用名称列表文件定义示踪剂，并使用这些文件来编译CMAQ程序。该模块的设置对应于``$CMAQ_HOME/CCTM/src/MECHS``目录中的文件夹名称，该目录包含用于示踪剂配置的名称列表文件。默认设置不使用任何示踪剂。
    - `trac[n]`

-   `ModGas: [default: gas/ebi_${Mechanism}]`<a id=ModGas></a>  
     气相化学求解器模块。有关更多信息，请参见[第6章](../CMAQ_UG_ch06_model_configuration_options.md#6102-solvers)。
     -  `smvgear`  
     使用SMVGEAR化学求解器
     -  `ros3`  
     使用Rosenbrock化学求解器
     -  `ebi`  
     使用欧拉向后迭代（EBI）化学求解器

-    `ModDiag` <a id=ModDiag></a>
	 使用各种诊断程序。目前，此处仅实现垂直提取工具。

-   `ModAero: [default: aero7]`<a id=ModAero></a>  
    CMAQ气溶胶模块。有关更多信息，请参见[第6章](../CMAQ_UG_ch06_model_configuration_options.md#611-aerosol-dynamics-and-chemistry)。
    -   `aero7`  
	扩展了海盐排放和热力学的第七代模态CMAQ气溶胶模型；包括用于二次有机气溶胶产生的新公式

-   `ModCloud: [default: cloud/acm_ae6]`<a id=ModCloud></a>  
    CMAQ云模块，用于模拟云对沉降、混合，光解和水相化学的影响。有关更多信息，请参见[第6章](../CMAQ_UG_ch06_model_configuration_options.md#612-aqueous-chemistry-scavenging-and-wet-deposition)。
    -   `cloud/acm_ae6`  
    ACM云处理器，它使用ACM方法来计算AERO6异构化学的对流混合
    -   `cloud/acm_ae6_mp`  
    ACM云处理器，它使用ACM方法来计算具有AERO6和空气有毒物质的异构化学的对流混合；这是CMAQv5中的多污染物机制
    -   `cloud/acm_ae6_kmt`  
	ACM云处理器，它使用ACM方法来计算具有AERO6异构化学的对流混合、具有动力学传质的水相化学、以及Rosenbrock求解器
    -   `cloud/acm_ae6i_kmti`  
	ACM云处理器，它使用ACM方法来计算具有AERO6异构化学的对流混合、具有动力学传质的水相化学、以及具有扩展功能的Rosenbrock求解器，可模拟云滴中SOA的水相形成，请参阅：[CMAQv5.1水化学 ](https://www.airqualitymodeling.org/index.php/CMAQv5.1_Aqueous_Chemistry)。

-   `ModUtil: [default: util]`<a id=ModUtil></a>  
    CMAQ实用程序模块。请勿更改此模块设置。
    -  `util/util`
-
`ModPa: [default: procan/pa]`<a id=ModPa></a>
    在CCTM运行脚本中控制的过程分析。请勿更改此模块设置。
     - `procan/pa`

-   `ModPvO3: [default: pv_o3]`<a id=ModPvO3></a>
	臭氧自由对流层交换的潜在涡度参数化。使用CCTM构建脚本中的potvorO3变量配置此选项。请勿更改此模块设置。有关更多信息，请参见[第6章](../CMAQ_UG_ch06_model_configuration_options.md#613-potential-vorticity-scaling)。
    - `pv_o3`
    
<a id=run_cctm.csh></a>
## A.3 运行选项 (run_cctm.csh)
<!-- BEGIN COMMENT -->

[返回顶部](#TOC_A)

<!-- END COMMENT -->

下面列出的环境变量在CCTM执行期间被调用，并在CCTM运行脚本（位于CCTM/scripts文件夹下）run_cctm.csh中进行设置。

-   `compiler [default: intel]`<a id=compiler></a>
-   `compilerVrsn [default: 13.1]`<a id=compilerVrsn></a>
-   `VRSN [default: v53]`<a id=VRSN></a>
-   `PROC [default: mpi]`<a id=PROC></a>   
设置CCTM将以多处理器并行模式还是单处理器串行模式运行。
    - `mpi`  
	使用MPI多处理器配置。已构建的CCTM可执行文件必须支持MPI，请参见上面的bldit_cctm.csh编译选项。在运行脚本中需要设置处理器数量和Linux系统的其他MPI配置变量。
    - `serial`  
    在单处理器串行模式下运行CCTM。
-   `MECH [default: None]`<a id=MECH></a>  
	CMAQ化学机理。必须与CCTM构建脚本中的`Mechanism`变量设置一致匹配。有关更多信息，请参见[第6章](../CMAQ_UG_ch06_model_configuration_options.md#using-predefined-chemical-mechanisms)。 
-   `APPL [default: SE53BENCH]`<a id=APPL></a>  
    用来标记输出二进制文件和日志文件的项目名称（即自定义的项目文件名）。
-   `RUNID [default: $VRSN_compiler_APPL]`<a id=RUNID></a>  
    运行ID，用于跟踪版本号、编译器和项目名称。
-   `BLD` <a id=BLD></a>  
    CCTM可执行文件的目录路径。
-   `EXEC [default: CCTM_$APPL_$EXECID]`<a id=EXEC></a>  
    CCTM可执行文件的文件名。

<a id=MPI_Config></a>

### MPI设置，MPI Configuration

<!-- BEGIN COMMENT -->

[返回顶部](#TOC_A)

<!-- END COMMENT -->

-   `NPCOL_NPROW [default: 1 1]`<a id=NPCOL_NPROW></a>  
	MPI配置中用于分解模型区域的列数和行数。这对数字的乘积必须等于分配给CCTM模拟的处理器总数。对于串行或单处理器，MPI运行设置为“1 1”。例如，对于8个处理器进行MPI模拟，应设置为“4 2”。
-   `NPROCS [default: 1]`<a id=NPROCS></a>  
	分配给CCTM模拟的处理器数量；等于NPCOL和NPROW的乘积。对于串行或单处理器，MPI运行设置为“1”，否则应设置为NPCOL_NPROW中使用的两个数字的乘积。

<a id=Vertical_Ext></a>

### 垂向幅度，Vertical extent

<!-- BEGIN COMMENT -->

[返回顶部](#TOC_A)

<!-- END COMMENT -->

-    `NZ [default: 35]`<a id=NZ></a>  
	设置模拟的垂直分层数。

<a id=Timestep_Config></a>

### 时间步长设置，Timestep Configuration

<!-- BEGIN COMMENT -->

[返回顶部](#TOC_A)

<!-- END COMMENT -->

-   `NEW_START [default: TRUE]`<a id=NEW_START></a>  
	对于从初始条件文件开始的新模拟，该值应为TRUE。而要从前几天的模拟输出文件来重新启动，请设置为FALSE。对于所有标准运行脚本，循环到模拟的第二天后，此变量将自动设置为FALSE。
-   `START_DATE`<a id=START_DATE></a>  
    公历格式的模拟开始日期(YYYY-MM-DD)  
-   `END_DATE`<a id=END_DATE></a>  
    公历格式的模拟结束日期(YYYY-MM-DD)  
-   `STTIME`<a id=STTIME></a>  
    模拟开始时间(HHMMSS)  
-   `NSTEPS [default: 240000]`<a id=NSTEPS></a>  
    模拟时间步数(HHMMSS) 
-   `TSTEP [default: 010000]`<a id=TSTEP></a>   
    模拟输出的时间步长间隔(HHMMSS)，必须是运行时段长度的倍数。
-   `MET_TSTEP [default: time step of METCRO3D file]`<a id=MET_TSTEP></a> 
	气象输入时间步长间隔（HHMMSS）。希望先指定时间上较粗糙的气象然后输入气象的用户可以使用此环境变量来指定。MET_TSTEP的默认值是METCRO3D文件的时间步长（输入气象数据步长）。但是，用户可以将MET_TSTEP指定为输入气象时间步长的倍数，只要他们加起来等于输出时间步长（定义为环境变量TSTEP）即可。例如，如果气象文件的数据间隔为10分钟，并且期望的输出步长为1小时，则有效的MET_STEPS为{10,20,30,30,60 ...}分钟。
	
<a id=CCTM_Config_Options></a>

### CCTM设置选项，CCTM Configuration Options

<!-- BEGIN COMMENT -->

[返回顶部](#TOC_A)

<!-- END COMMENT -->

-   `GRID_NAME [default: Blank]`<a id=GRID_NAME></a>  
	GRIDDESC文件中包含的网格定义名称，该名称指定模型当前项目的水平网格。
-   `GRIDDESC [default: Path to GRIDDESC file]`<a id=GRIDDESC></a>  
    网格描述文件，用于设置水平网格定义。
-   `CTM_APPL [default: ${RUNID}_${YYYYMMDD}]`<a id=CTM_APPL></a>  
    CCTM日志和输出文件的命名规则。
-   `CONC_SPCS [if commented out, all species]`<a id=CONC_SPCS></a>  
    要写入CCTM_CONC文件的模型物种，还包括温度、相对湿度和压力。如果注释掉本行则代表输出全部物种。有关更多信息，请参见[第6章](../CMAQ_UG_ch07_model_outputs.md#72-cctm-output-files)。
-   `CONC_BLEV_ELEV [if commented out, all layers]`<a id=CONC_BLEV_ELEV></a>  
	写入CCTM_CONC浓度文件的垂直模拟层范围；此变量设置两个数，分别代表底层和顶层，在这之间的所有层上的浓度都会写入CCTM_CONC文件。在示例脚本中，BLEV和ELEV都设置为1，因此仅有模型第一层的浓度数据会被输出。如果注释掉本行则代表输出全部层的浓度。
-   `AVG_CONC_SPCS [if commented out, output all species]`<a id=AVG_CONC_SPCS></a>  
	该选项下设置的物种将会输出每个输出时间步长的积分平均浓度，可以是写入CCTM_CONC文件的任何标准输出种类，包括温度、相对湿度和压力。此列表中的种类将被写入CCTM_ACONC输出文件。如果注释掉本行则代表输出全部物种。有关更多信息，请参见[第6章](../CMAQ_UG_ch07_model_outputs.md#72-cctm-output-files) 。
-   `ACONC_BLEV_ELEV [default: if commented out, all layers]`<a id=ACONC_BLEV_ELEV></a>  
	输出积分平均浓度的模型垂直层的范围；此变量设置两个数，分别代表底层和顶层，在这之间的所有层上的积分平均浓度都会写入CCTM_ACONC文件。例如，将此变量设置为“1 5”将生成模型中1到5层的积分平均浓度。
-   `AVG_FILE_END_TIME [default: N]`<a id=AVG_FILE_END_TIME></a>  
    将ACONC文件输出时间步长的时间戳从默认的每小时开始时更改为每小时结束时。
    - `Y`: 将时间戳记设置为每小时结束时。
    - `N`: 将时间戳记设置为每小时开始时。
-   `EXECUTION_ID [default: Blank]`<a id=EXECUTION_ID></a>  
    CCTM可执行文件的名称；由脚本自动设置。

<a id=Syn_time_Option></a>

### 同步时间步长和公差选项，Synchronization Time Step and Tolerance Options

<!-- BEGIN COMMENT -->

[返回顶部](#TOC_A)

<!-- END COMMENT -->

-   `CTM_MAXSYNC [default: 720]`<a id=CTM_MAXSYNC></a>  
    最大同步时间步长（秒）
-   `CTM_MINSYNC [default: 60]`<a id=CTM_MINSYNC></a>  
    最小同步时间步长（秒） 
-   `SIGMA_SYNC_TOP [default: .70]`<a id=SIGMA_SYNC_TOP></a>  
    通过哪个同步步骤确定的最高sigma级别水平
-   `ADV_HDIV_LIM [default: .9]`<a id=ADV_HDIV_LIM></a>  
	对流时间步长调整的最大水平发散极限
-   `CTM_ADV_CFL [default: .75]`<a id=CTM_ADV_CFL></a>  
    最大Courant-Friedrichs-Lewy（CFL）条件
-   `RB_ATOL [default: 1.0E-07]`<a id=RB_ATOL></a>  
	如果使用Rosenbrock（ros3）光化学求解器，用于收敛计算解决方案的绝对误差取值
	
-   `RB_RTOL [default: 1.0E-03]`<a id=RB_RTOL></a>  
	如果使用Rosenbrock（ros3）光化学求解器，用于收敛计算解决方案的相对误差取值
	
-   `GEAR_ATOL [default: 1.0E-09]`<a id=RB_ATOL></a>  
	如果使用Gear(smvgear)光化学求解器，用于收敛计算解决方案的绝对误差取值
	
-   `GEAR_RTOL [default: 1.0E-03]`<a id=RB_RTOL></a>  
	如果使用Gear(smvgear)光化学求解器，用于收敛计算解决方案的相对误差取值


<a id=Science_Options></a>

### 科学选项，Science Options

<!-- BEGIN COMMENT -->

[返回顶部](#TOC_A)

<!-- END COMMENT -->

-   `CTM_OCEAN_CHEM [default: True]`<a id=CTM_SS_AERO></a>   
	使用实时计算的海浪气溶胶排放和卤素臭氧化学物质。有关更多信息，请参见[第6章](../CMAQ_UG_ch06_model_configuration_options.md#sea-spray)。	
-   `CTM_WB_DUST [default: False]`<a id=CTM_WB_DUST></a>  
	用于在CCTM中实时计算风吹扬尘排放的设置，将此变量设置为Y可启用该选项。同时还应设置下面的环境变量CTM_WBDUST_BELD来确定是否使用MCIP文件中包含的土地利用信息以外的其他网格化土地利用输入文件。有关更多信息，请参见[第6章](../CMAQ_UG_ch06_model_configuration_options.md#wind-blown-dust)。	
- `CTM_WBDUST_BELD [default: UNKNOWN]`<a id=CTM_WBDUST_BELD></a>  
	用于确定风吹扬尘排放源区域的土地利用数据库；如果CTM_WB_DUST = FALSE则本项忽略
    - BELD3: 使用BELD3土地利用数据进行风吹扬尘计算。用户需要指定[第4章](../CMAQ_UG_ch04_model_inputs.md)中描述的DUST_LU_1和DUST_LU_2文件。这些文件通常仅适用于北美区域。
    - UNKNOWN: 使用MCIP提供的土地利用信息进行风吹扬尘计算
-   `CTM_LTNG_NO [default: Y]`<a id=CTM_LING_NO></a>  
	将此变量设置为Y可以启用闪电NO排放，另外还需要设置其他变量来定义闪电NO排放计算的参数，详见下面的`LTNGNO`、`LTNGPARAMS`、`NLDN_STRIKES`和`LTNGDIAG`。有关更多信息，请参见[第6章](../CMAQ_UG_ch06_model_configuration_options.md#lightning-no) 。
-   `KZMIN [default: Y]`<a id=KZMIN></a>  
	如果KZMIN设置为Y，CCTM将从GRID_CRO_2D气象文件中读取城市土地利用分数变量（PURB），并使用此信息来确定每个网格单元中的最小涡流扩散率。在CMAQv5中，主要位于城市的网格单元的KZMIN值为1.0 m<sup>2</sup>/s，而非城市的网格单元的值为0.01 m<sup>2</sup>/s。如果将此变量设置为N，则将不使用PURB变量，并且将在整个建模区域中使用1.0 m<sup>2</sup>/s的统一KZMIN值。
-   `CTM_MOSAIC [default N]`<a id=CTM_MOSAIC></a>  
	设置为Y以输出特定于土地利用的沉降速度和通量。仅当使用STAGE沉降模块时，此选项才可用。有关更多信息，请参见[第6章](../CMAQ_UG_ch06_model_configuration_options.md#682-dry-depostion---stage)。
-   `CTM_FST [default: N]`<a id=CTM_FST></a> 
	设置为Y以输出特定于土地利用的气孔通量。仅当使用STAGE沉降模块且CTM_MOSAIC设置为Y时，此选项才可用。有关更多信息，请参见[第6章](../CMAQ_UG_ch06_model_configuration_options.md#682-dry-depostion---stage)。
-   `PX_VERSION` <a id=PX_VERSION></a>
	是否使用气象文件用于Pleim-Xiu地表模型。如果将此项设置为Y，则输入的气象数据必须包括土壤湿度（SOILM）、土壤温度（SOILT）和土壤类型（ISLTYP）变量，以用于计算土壤NO排放量。此外，来自Pleim-Xiu的土壤特性将用于风吹扬尘模型和STAGE沉降模块中，以计算用于双向氨交换的土壤补偿点。有关更多信息，请参见[第6章](../CMAQ_UG_ch06_model_configuration_options.md#682-dry-depostion---stage)。
-   `CLM_VERSION` <a id=CLM_VERSION></a>
   是否在生成输入气象时使用社区土地模型（Community Land Model，CLM）中的地表模型。如果将此项设置为Y，则输入的气象数据必须包括土壤湿度（SOILM）、土壤温度（SOILT）和土壤类型（ISLTYP）变量，以用于计算土壤NO排放量。此外，来自CLM的土壤特性将用于风吹扬尘模型和STAGE沉降模块中，以计算用于双向氨交换的土壤补偿点。有关更多信息，请参见[第6章](../CMAQ_UG_ch06_model_configuration_options.md#682-dry-depostion---stage)。
-    `NOAH_VERSION` <a id=NOAH_VERSION></a>
   是否在生成输入气象时使用诺亚（Noah）地面模型。如果将此项设置为Y，则输入的气象数据必须包括土壤湿度（SOILM）、土壤温度（SOILT）和土壤类型（ISLTYP）变量，以用于计算土壤NO排放量。另外，来自诺亚（Noah）的土壤特性将用于风吹扬尘模型和STAGE沉降模块中，以计算用于双向氨交换的土壤补偿点。有关更多信息，请参见[第6章](../CMAQ_UG_ch06_model_configuration_options.md#682-dry-depostion---stage)。
-   `CTM_ABFLUX [default: Y]`<a id=CTM_ABFLUX></a>  
	是否使用肥料双向氨通量，以实时计算排放和沉降速度。将此变量设置为Y需要另外四个输入文件，其中包括网格化的农作物分布分数（E2C_LU）、土壤特性（E2C_SOIL）、肥料状况（E2C_CHEM）和农业土壤初始状况文件（INIT_MEDC_1）。开启此选项将在输出的干沉降文件中产生其他变量。
-   `CTM_BIDI_FERT_NH3` <a id=CTM_BIDI_FERT_NH3></a>
	是否从排放量中减去肥料NH3排放，并由双向NH3通量模型处理。注意，还必须通过将CTM_ABFLUX设置为Y来调用双向通量模型。
- `CTM_HGBIDI [default: N]`
	是否使用双向汞通量以实时计算排放量和沉降速度。开启此选项将在输出的干沉降文件中产生其他变量。
- `CTM_SFC_HONO [default: Y]`
	是否包括地表HONO相互作用。有关更多信息，请参见[第6章](../CMAQ_UG_ch06_model_configuration_options.md#6.10.4_HONO)。
-   `CTM_GRAV_SETL [default Y]`<a id=CTM_GRAV_SETL></a>  
	是否使用气溶胶的重力沉降。
-   `CTM_BIOGEMIS [default: Y]`<a id=CTM_BIOGEMIS></a>  
	是否使用实时计算的生物源排放。如果激活此选项，则还必须设置几个其他变量（请参见实时计算的生物源排放设置）。有关更多信息，请参见[第6章](../CMAQ_UG_ch06_model_configuration_options.md#biogenics)。
-   `OPTICS_MIE_CALC  [default: N]`<a id=OPTICS_MIE_CALC></a>    
	在光解速率的实时计算选项中，是否求解米氏（Mie）理论以基于均匀混合的球体计算气溶胶模块的光学性质。
-   `CORE_SHELL_OPTICS [default: N]`<a id=CORE_SHELL_OPTICS></a>    
	在光解速率的实时计算选项中，是否求解米氏（Mie）理论以基于具有元素碳核的球体计算气溶胶模块的光学性质。

<a id=Process_Analysis_Options></a>

### 处理分析选项，Process analysis options

<!-- BEGIN COMMENT -->

[返回顶部](#TOC_A)

<!-- END COMMENT -->

-   `CTM_PROCAN [default: N]`<a id=CTM_PROCAN></a>  
	是否在CCTM中启用过程分析。将此设置为Y并使用$CMAQ_DATA/pacp/pacp.inp配置CCTM的集成处理速率（IPR）和集成反应速率（IRR）设置。启用此选项后，将创建过程分析输出文件。
-   `PA_BCOL_ECOL [default: 0]`<a id=PA_BCOL_ECOL></a>  
	设置过程分析计算的模型网格区域的列的范围。设置为两个数字，分别代表进行过程分析的开始和结束的列的编号。
-   `PA_BROW_EROW [default: 0]`<a id=PA_BROW_EROW></a>  
	设置过程分析计算的模型网格区域的行的范围。设置为两个数字，分别代表进行过程分析的开始和结束的行的编号。
-   `PA_BLEV_ELEV [default: 0]`<a id=PA_BLEV_ELEV></a>  
	设置过程分析计算的模型网格区域的层的范围。设置为两个数字，分别代表进行过程分析的模型最底层和最顶层的编号。
-   `PACM_INFILE` <a id=PACM_INFILE></a>  
	指定所需输出信息的输入文件（由pa_read.F读取）。有关可在此文件中使用的方程式和运算符类型的详细信息，请参见[第9章](../CMAQ_UG_ch09_process_analysis.md)中的表1。CCTM/src/MECHS目录下的每个机制文件夹中都包含一个样本文件。例如，CCTM/src/MECHS/cb6r3_ae7_aq中的文件pa_cb6r3_ae7_aq.ctl提供了IRR和IPR命令的模板。
-   `PACM_REPORT` <a id=PACM_REPORT></a>  
	输出文件显示CMAQ如何转换`PACM_INFILE`中列出的变量，并列出将用于计算IPR和IRR值的反应（包括反应物\产物和产率）。

<a id=I/O_Controls></a>

### I/O控制，I/O Controls

<!-- BEGIN COMMENT -->

[返回顶部](#TOC_A)

<!-- END COMMENT -->

-   `IOAPI_LOG_WRITE [default:False]`<a id=IOAPI_LOG_WRITE></a>  
	设置为T可以打开通过I/O API记录的更多WRITE3日志文件。
-   `FL_ERR_STOP [default: False]`<a id=FL_ERR_STOP></a>  
	设置为T，则程序在输入文件中发现不一致的头文件（headers）时退出。
-   `PROMPTFLAG [default: False]`<a id=PROMPTFLAG></a>  
	打开I/O-API PROMPTFILE交互模式。设置为T以要求交互式提示有关不同的I/O API操作。
-   `IOAPI_OFFSET_64 [default: True]`<a id=IOAPI_OFFSET_64></a>  
	大量时间步记录的I/O API设置。如果您的输出时间步长将产生每个时间步长大于2GB的数据，则需要将其设置为True。

<a id=Aersol_Diagnostics_Controls></a>

### 气溶胶诊断控制，Aerosol Diagnostics Controls

<!-- BEGIN COMMENT -->

[返回顶部](#TOC_A)

<!-- END COMMENT -->

-   `CTM_PMDIAG [default: False]`<a id=CTM_PMDIAG></a>  
	输出气溶胶诊断和属性文件。这些数据是后处理所需的，其气溶胶质量分数在各种大小范围内（例如PM2.5、PM10等）。该文件还包括描述气溶胶尺寸分布的物理参数，包括：干直径、湿直径、标准偏差、湿第二力矩、干第二力矩、湿第三力矩、干第三力矩和密度。
-   `CTM_APMDIAG [default: False]`<a id=CTM_APMDIAG></a>  
	输出每小时平均气溶胶诊断和属性文件。这些数据是后处理所需的，其气溶胶质量分数在各种大小范围内（例如PM2.5、PM10等）。该文件还包括描述气溶胶尺寸分布的物理参数，包括：干直径、湿直径、标准偏差、湿第二力矩、干第二力矩、湿第三力矩、干第三力矩和密度。
-   `APMDIAG_BLEV_ELEV [default: 0]`<a id=APMDIAG_BLEV_ELEV></a>  
	输出每小时平均气溶胶诊断和属性文件的模型网格区域的层的范围。设置为两个数字，分别代表底层和顶层比编号，在这之中的层作为输出的区域。注释掉此变量或将其设置为0以输出所有的层，设置为“1 1”仅输出地表层。

<a id=Diagnostic_Output_Flags></a>

### 诊断输出标志，Diagnostic Output Flags

<!-- BEGIN COMMENT -->

[返回顶部](#TOC_A)

<!-- END COMMENT -->

-   `CTM_CKSUM [default: True]`<a id=CTM_CKSUM></a>  
	将科学处理摘要写入标准输出文件。会影响运行速度和日志文件的大小。
-   `CLD_DIAG [default: False]`<a id=CLD_DIAG></a>  
	输出每小时的湿沉降诊断文件（CTM_WET_DEP_2），其中包括对流湿沉降估算。
-   `CTM_PHOTDIAG [default: False]`<a id=CTM_PHOTDIAG></a>  
	是否输出文件，用于查看模型模型中使用的光解速率以及哪些气象和其他因素决定了速率。采用实时计算方法的会产生三个文件（`CTM_RJ_1`、`CTM_RJ_2`和`CTM_RJ_3`），使用查表法的会产生一个文件（`CTM_RJ_2`）。`CTM_RJ_1`是一个二维文件，其中包含关键的光解速率和辐射参数。`CTM_RJ_2`包含模型区域中使用的光解速率。`CTM_RJ_3`包含用于计算光解速率的数据。
-   `NLAYS_PHOTDIAG [default: 1]` <a id=NLAYS_PHOTDIAG></a>
	`CTM_RJ_2`和`CTM_RJ_3`文件中的层数，允许的值从1到模型区域中的层的编号。仅使用在线计算选项时使用此选项数值。
-   `NWAVE_PHOTDIAG [default:294 303 310 316 333 381 607]` <a id= NWAVE_PHOTDIAG></a>
	`CTM_RJ_3`文件中写入诊断数据的波长。用户可以使用默认值或对其进行子集设置。
	
-   `CTM_SSEMDIAG [default: False]`<a id=CTM_SSEMDIAG></a>  
	将计算出的海盐排放量输出到诊断文件（CTM_SSEMIS_1，netCDF格式）。
-   `CTM_DUSTEM_DIAG [default: False]`<a id=CTM_DUSTEM_DIAG></a>  
	将实时计算的风吹扬尘排放源输出到诊断文件（CTM_DUST_EMIS_1，netCDF格式）。该诊断文件不仅包括总的粉尘排放量，还包括按土地利用类别和粉尘模型参数（例如，网格化的可侵蚀土地利用比例）分类的粉尘排放量。
-   `CTM_DEPV_FILE [default: False]`<a id=CTM_DEPV_FILE></a>  
	输出实时计算沉降速度的每小时诊断文件（CTM_DEPV_DIAG）。
-   `LTNGDIAG [default: False]`<a id=LTNGDIAG></a>  
	输出闪电NO排放诊断文件。
-   `CTM_WVEL [default: Y]`<a id=CTM_WVEL></a>  
	是否将CCTM计算的垂直速度输出到CONC和ACONC文件。
    
<a id=Offline_Emissions_Config></a>

### 非实时计算排放源设置，Offline emissions configuration

<!-- BEGIN COMMENT -->

[返回顶部](#TOC_A)

<!-- END COMMENT -->

-   `N_EMIS_GR `<a id=N_EMIS_GR></a>  
	模型中要使用的非实时计算网格化排放源的数量。有关更多信息，请参见[第6章](../CMAQ_UG_ch06_model_configuration_options.md#inline-stream-offline)。
    
-   `GR_EMIS_### `<a id=GR_EMIS_###></a>  
	编号为###的网格化污染源文件的目录路径和文件名，其中###=001、002、...、NNN_EMIS_GR。有关更多信息，请参见[第6章](../CMAQ_UG_ch06_model_configuration_options.md#inline-stream-offline) 。
    
-   `GR_EMIS_LAB_### `<a id=GR_EMIS_LAB_###></a>  
	编号为###的网格化污染源文件的短标签，其中###=001、002、...、NNN_EMIS_GR。有关更多信息，请参见[第6章](../CMAQ_UG_ch06_model_configuration_options.md#inline-stream-offline)。

-   `GR_EM_SYM_DATE_### [default: False]`<a id=GR_EM_SYM_DATE_###></a>  
	编号为###的网格化污染源是否为典型日类型，其中###=001、002、...、NNN_EMIS_GR。有关更多信息，请参见[第6章](../CMAQ_UG_ch06_model_configuration_options.md#inline-stream-offline)。
    
-   `STK_GRPS_### `<a id=STK_GRPS_###></a>  
	扇区编号为###的排气筒组文件的目录路径和文件名，其中###=001、002、...、NNN_EMIS_PT。每个###指代实时计算烟羽抬升的点源扇区之一。有关更多信息，请参见[第6章](../CMAQ_UG_ch06_model_configuration_options.md#inline-stream-offline)。

-   `STK_EMIS_###`<a id=STK_EMIS_###></a>  
	扇区编号为###的点源文件的目录路径和文件名，其中###=001、002、...、NNN_EMIS_PT。每个###指代烟羽抬升的点源扇区之一。有关更多信息，请参见[第6章](../CMAQ_UG_ch06_model_configuration_options.md#inline-stream-offline)。

-   `STK_EMIS_DIAG_###`<a id=STK_EMIS_DIAG_###></a>  
	是否打开扇区###的点源文件的诊断输出，其中###=001、002、...、NNN_EMIS_PT。每个###指代烟羽抬升的点源扇区之一。诊断输出的数据反映了排放控制接口DESID应用缩放规则后的排放速率。STK_EMIS_DIAG_###的值包括FALSE、TRUE、2D、2DSUM和3D。TRUE和2D选项是同义词，将仅输出地表层的排放源。采用2DSUM选项会输出一个2D文件，其值是通过对每个水平网格单元中的整个排放源列求和而得出的。使用3D选项将输出完整的3D文件。所有选项都提供模拟日所有输出时间步长的输出。有关更多信息，请参见[第6章](../CMAQ_UG_ch06_model_configuration_options.md#inline-stream-offline)。  
    
 -   `STK_EMIS_LAB_### `<a id=STK_EMIS_LAB_###></a>  
	扇区编号###的点源文件的短标签，其中###=001、002、...、NNN_EMIS_PT。每个###指代烟羽抬升的点源扇区之一。有关更多信息，请参见[第6章](../CMAQ_UG_ch06_model_configuration_options.md#inline-stream-offline)。
    
 -   `STK_EM_SYM_DATE_### [default: False]`<a id=STK_EM_SYM_DATE_###></a>  
	扇区编号###的点源文件是否为典型日类型，其中###=001、002、...、NNN_EMIS_PT。每个###指代烟羽抬升的点源扇区之一。有关更多信息，请参见[第6章](../CMAQ_UG_ch06_model_configuration_options.md#inline-stream-offline)。 

-   `EMIS_SYM_DATE [default: False]`<a id=EMIS_SYM_DATE></a>  
	如果未明确设置，GR_EM_SYM_DATE_###和STK_EM_SYM_DATE_###的默认值为false，但是用户可以选择通过设置此环境变量来设置此默认值。用户应注意，如果设置了此变量并且设置了GR_EM_SYM_DATE_###或STK_EM_SYM_DATE_###，则单个源的开关优先于此变量。如果所有离线排放均为典型日类型，则此开关可能很有用。有关更多信息，请参见[第6章]( ../CMAQ_UG_ch06_model_configuration_options.md#inline-stream-offline )。

<a id=Lightning_NOx_Config></a>

### 闪电NOx排放设置，Lightning NOx configuration

<!-- BEGIN COMMENT -->

[返回顶部](#TOC_A)

<!-- END COMMENT -->

-   `LTNGNO [default: "InLine"]`<a id=LTNGNO></a>  
	设置闪电NO排放是是否采用实时计算（InLine、off-line）。可以将此变量设置为闪电NO排放的网格化netCDF格式文件，以使用通过CCTM外部的预处理器计算的闪电NO排放。将此变量设置为“inline”会激活CCTM中的实时排放量计算，并要求LTNGPARMS_FILE变量（请参见下文）提供用于生成实时闪电NO排放量的参数。有关更多信息，请参见[第6章](../CMAQ_UG_ch06_model_configuration_options.md#lightning-no)。

-   `USE_NLDN [default: False]`<a id=USE_NLDN></a>  
	是否使用每小时的NLDN闪电文件来实时计算闪电NO排放。激活此设置需要NLDN_STRIKES输入文件。如果USE_NLDN设置为N且LTNGNO设置为“InLine”，则使用LTNGPARMS_FILE中提供的参数来计算闪电源NO排放。该文件是netCDF格式，其中包含使用参数化方案生成闪电NO排放源的线性回归参数。此外，它还包含云间与云对地的闪电比率、使用对流降水率计算闪电的缩放比例、陆地海洋遮罩参数、以及每个闪电（云对地和云间）产生的NO的摩尔数，这些参数在两种闪电计算方案（NLDN和参数化）中都会使用。如果LTINGNO设置为外部输入文件，则会忽略本选项的设置。有关更多信息，请参见[第6章](../CMAQ_UG_ch06_model_configuration_options.md#lightning-no)。 

-  `CTM_LTNGDIAG_1`<a id=LTNGOUT></a>  
	输出3D的netCDF格式闪电诊断文件；如果`LTNGDIAG = N`则会忽略本选项的设置。

-  `CTM_LTNGDIAG_2`<a id=LTNGOUT></a>  
	输出3D的netCDF格式闪电诊断文件（列合计的总闪电NO排放量）；如果`LTNGDIAG = N`则会忽略本选项的设置。

<a id=Online_Bio_Config></a>

### 实时计算生物源排放设置，Online biogenic emissions configuration

<!-- BEGIN COMMENT -->

[返回顶部](#TOC_A)

<!-- END COMMENT -->

-   `GSPRO [default: Build Directory]`<a id=GSPRO></a>  
	输入ASCII规范配置文件的目录路径和文件名。有关更多信息，请参见[第6章](../CMAQ_UG_ch06_model_configuration_options.md#biogenics)。

-   `B3GRD [default: None]`<a id=B3GRD></a>  
	netCDF格式的网格归一化的生物源排放输入文件。有关更多信息，请参见[第6章](../CMAQ_UG_ch06_model_configuration_options.md#biogenics)。
    
-   `BIOSW_YN [default: Y]`<a id=BIOSW_YN></a>  
	使用霜冻日期开关文件来确定是使用冬季还是夏季的生物源排放。有关更多信息，请参见[第6章](../CMAQ_UG_ch06_model_configuration_options.md#biogenics)。

-   `BIOSEASON [default: False]`<a id=BIOSEASON></a>  
    etCDF格式霜冻日期开关输入文件的文件名。有关更多信息，请参见[第6章](../CMAQ_UG_ch06_model_configuration_options.md#biogenics)。

-   `SUMMER_YN [default: False]`<a id=SUMMER_YN></a>  
	切换夏季的归一化生物源排放。如果BIOSW_YN设置为Y，则忽略此选项设置。注释掉或设置为Y以选择夏季生物源排放因子；设置为N关闭。有关更多信息，请参见[第6章](../CMAQ_UG_ch06_model_configuration_options.md#biogenics)。

-   `PX_VERSION [default: True]`<a id=PX_VERSION></a>  
	是否将Pleim-Xiu地表模型用于输入气象的设置。如果将此选项设置为Y，则输入的气象数据必须包括土壤湿度（SOILM）、土壤温度（SOILT）和土壤类型（ISLTYP）变量，以用于计算土壤NO排放量。

-   `SOILINP [default: [Out Directory/CCTM_SOILOUT_$RUNID_$YESTERDSY]`<a id=SOILINP></a>  
	生物源土壤NO排放文件的目录路径和文件名。如果将NEW_START设置为N或F，则前一天模拟的土壤NO排放文件将是必需的输入文件。有关更多信息，请参见[第6章](../CMAQ_UG_ch06_model_configuration_options.md#biogenics)。

-   `B3GTS_DIAG [default: False]`<a id=B3GTS_DIAG></a>  
	是否将实时计算生物源排放量（质量单位）写入netCDF格式的诊断输出文件（B3GTS_S）。

-   `B3GTS_S [default: [Output Directory]/CCTM_B3GTS_$CTM_APPL.nc`<a id=B3GTS_S></a>  
	设置netCDF格式的生物源排放诊断输出文件（B3GTS_S）的目录路径和文件名。如果B3GTS_DIAG设置为N，则忽略此变量。

<a id=windblown_dust_config></a>

### 风吹扬尘排放源设置，Windblown dust emissions configuration

<!-- BEGIN COMMENT -->

[返回顶部](#TOC_A)

<!-- END COMMENT -->

-   `DUST_LU_1 [default: Path to BELD3 Data]`<a id=DUST_LU_1></a>  
	输入netCDF格式的BELD “A”土地使利用文件，并将其网格化到模型区域。如果`CTM_WBDUST_BELD`设置为BELD3，则使用本选项。

-   `DUST_LU_2 [default: Path to BELD3 Data]`<a id=DUST_LU_2></a>  
	输入netCDF格式的BELD “TOT”土地使利用文件，并将其网格化到模型区域。如果`CTM_WBDUST_BELD`设置为BELD3，则使用本选项。



<!-- BEGIN COMMENT -->

[<< 图件和表格清单](../CMAQ_UG_tables_figures.md) - [返回](../README.md) - [附录B >>](CMAQ_UG_appendixB_emissions_control.md)<br>
 CMAQ用户指南 (c) 2020<br> 
 <!-- END COMMENT -->
