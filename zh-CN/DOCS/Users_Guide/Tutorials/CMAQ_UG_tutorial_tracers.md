## CMAQ教程（注意由于没有理解一些术语，本文件没有翻译完成）
### 将化学惰性示踪剂物种添加到CMAQ
目的：本教程将引导您逐步完成将化学惰性示踪剂添加到CMAQ模型的过程。其他详细信息可参见[CMAQ用户指南]( ../README.md )。


------------


### 步骤1：创建示踪剂物质清单

根据[CMAQ OGD]( ../CMAQ_UG_ch04_model_inputs.md#Table3-4 )中的表3.4创建清单。每种示踪剂物质一行，格式如下（有关缩写的更多信息，请参见下表）：

<a id=Table3-4></a>

<center> **从CMAQ UG表3-4修订** </center>

| **行**| **列** |**名称** | **类型**| **说明** |**语法选项**:|
|-----|-----|----------------------|----------|--------------------------------------------|----------------------------|
| 1 || File Type |字符串|用于描述气相（GC）、气溶胶（AE）、非反应性（NR）和示踪剂（TR）清单的字符串|{TR_nml}|
| 3 || Header ID | 字符串 |用于定义与清单有关的数据结构的字符串|{TR_SPECIES_DATA = }|
| 5 |1| SPECIES | 字符串 |CMAQ 物质名称,例如NO, HNO<sub>3</sub>, PAR; 取决于采用的化学反应机理|-|
||2| MOLWT| 整数 |该物质的分子量|-|
|  |3| IC | 字符串 |用于CMAQ物质的IC/替代物质名称（IC=initial condition，初始条件）|{'物质名称', ' '}|
|  |4| FAC | 整数 |IC/BC浓度的比例因子|{任意整数: 如果未指定IC，默认取-1}|
|  |5| BC | 字符串 |用于CMAQ物质的替代物质名称（BC=boundary condition，边界条件）|{'物质名称', ' '}|
|  |6| FAC | 整数 |IC/BC浓度的比例因子|{任意整数: 如果未指定BC，默认取-1}|
| |7| DRYDEP SURR | 字符串 |CMAQ物质的沉降速率变量名称|-|
| |8| FAC | 整数 |沉降速率的比例因子|{任意整数: 如果未指定SURR，默认取-1}|
| |9| WET-SCAV SURR | 字符串 |湿沉降清除替代物质|-|
| | 10 | FAC | 整数 |清除的比例因子|{任意整数: 如果未指定SURR，默认取-1}|
|| 11 | TR2AE SURR | 字符串 |气溶胶转化物种|-|
|| 12 | TR2AQ SURR | 字符串 |气-水转化物种|-|
|| 13 | TRNS | 字符串 |传输开关。 * 注意: 对于一种污染物，可以使用标记为"TRNS"的一列来同时打开/关闭污染物的对流和扩散开关，也可以使用标记为"ADV"（advection，对流）和"DIFF"（diffusion，扩散）的单独的两列来分别打开/关闭对流和扩散的开关。 *|{YES/NO}|
|| 14 | DDEP | 字符串 |是否输出干沉降文件|{YES/NO}|
|| 15 | WDEP | Real |是否输出湿沉降文件|{YES/NO}|
|| 16 | CONC | 字符串 |是否输出浓度文件|{YES/NO}|

下面的示例清单文件定义了六个示踪物质种类。


```
&TR_nml

TR_SPECIES_DATA =

!SPECIES     ,MOLWT   ,IC           ,IC_FAC         ,BC        ,BC_FAC      ,DEPV       ,DEPV_FAC  ,SCAV     ,SCAV_FAC ,TR2AE      ,TR2AQ ,ADVC  ,DIFF  ,DDEP  ,WDEP  ,CONC 
'O3_BC'      ,48.0    ,''          ,-1              ,'O3'      , 1          ,'VD_O3'    ,1         ,'O3'     , 1        ,''        ,''   ,'YES' ,'YES' ,'YES' ,'YES' ,'YES',
'CO_BC'      ,28.0    ,''          ,-1              ,'CO'      , 1          ,'VD_CO'    ,1         ,'CO'     , 1        ,''        ,''   ,'YES' ,'YES' ,'YES' ,'YES' ,'YES', 
'O3_IC'      ,48.0    ,'O3'        , 1              ,''        ,-1          ,'VD_O3'    ,1         ,'O3'     , 1        ,''        ,''   ,'YES' ,'YES' ,'YES' ,'YES' ,'YES', 
'O3_BC_50PC' ,48.0    ,''          ,-1              ,'O3'      ,0.5         ,'VD_O3'    ,1         ,'O3'     , 1        ,''        ,''   ,'YES' ,'YES' ,'YES' ,'YES' ,'YES',
'CO_EMIS'    ,28.0    ,''          ,-1              ,''        ,-1          ,'VD_CO'    ,1         ,'CO'     , 1        ,''        ,''   ,'YES' ,'YES' ,'YES' ,'YES' ,'YES', 
'ICT_50PPB'  , 1.0    ,'ICT_50PPB' , 1              ,''        ,-1          ,''         ,-1        ,         ,-1        ,''        ,''   ,'YES' ,'YES' ,''    ,''    ,'YES'
/

```

** 第一个示踪物种 O3_BC
  * 定义为与臭氧分子量相同
  * 未映射到任何排放物种
  * 使用缩放系数为1的臭氧干沉降速率（VD_O3）作为干沉积的替代
  * 使用臭氧作为其清除替代，缩放比例为1
  * 会尝试从边界条件文件中名为'O3'的物种获取其边界条件，比例因子为1
  * 未映射到任何初始条件，因此使用默认缩放因子-1
  * 不参与气-气溶胶转换或气-水转换
  * 将进行对流和扩散
  * 将被写入DDEP（干沉降），WDEP（湿沉降）和CONC（浓度）输出文件
  
**第二种示踪物种 CO_BC
  * 定义为与CO分子量相同
  * 未映射到任何排放物种
  * 使用缩放系数为1的CO干沉积速度（VD_CO）作为干沉积的替代
  * 使用CO作为其清除替代，其缩放比例为1
  * 会尝试从边界条件文件中名为'CO'的物种获取其边界条件，比例因子为1
  * 未映射到任何初始条件，因此使用默认缩放因子-1
  * 不参与气-气溶胶转换或气-水转换
  * 将进行对流和扩散
  * 将被写入DDEP（干沉降），WDEP（湿沉降）和CONC（浓度）输出文件

** 第三种示踪物 O3_IC
  * 定义为与臭氧分子量相同
  * 未映射到任何排放物种
  * 使用缩放系数为1的臭氧干沉降速率（VD_O3）作为干沉积的替代
  * 使用臭氧作为其清除替代，缩放比例为1
  * 将尝试从初始条件文件中名为'O3'的物种获取其初始条件，比例因子为-1
  * 未指定边界条件，因此使用默认缩放因子-1
  * 不参与气-气溶胶转换或气-水转换
  * 将进行对流和扩散
  * 将被写入DDEP（干沉降），WDEP（湿沉降）和CONC（浓度）输出文件
  
** 第四种示踪物 O3_BC_50PC
  * 定义为与臭氧分子量相同
  * 未映射到任何排放物种类
  * 使用以1换算的臭氧干沉积速度（VD_O3）作为干沉积的替代物
  * 使用臭氧作为其清除代用品，缩放比例为1
  * 将尝试从边界条件文件中名为'O3'的物种获取其边界条件，比例因子为0.5
  * 未映射到任何边界条件，因此使用默认缩放因子-1
  * 不参与气-气溶胶转换或气-水转换
  * 将进行对流和扩散
  * 将被写入DDEP（干沉降），WDEP（湿沉降）和CONC（浓度）输出文件
  
** 第五种示踪物 CO_EMIS
  * 定义为具有与CO相同的分子量
  * 使用比例因子为1的一氧化碳排放作为其替代排放量
  * 使用缩放系数为1的CO干沉积速度（VD_CO）作为干沉积的替代
  * 使用CO作为其清除代理，其缩放比例为1
  * 未映射到任何初始/边界条件替代，因此使用默认缩放因子-1
  * 不参与气-气溶胶转换或气-水转换
  * 将进行对流和扩散
  * 将被写入DDEP（干沉降），WDEP（湿沉降）和CONC（浓度）输出文件
  
** 最后一种示踪物种 ICT_50PPB
  * 定义为具有1 g/mol的分子量
  * 未映射到任何排放物种
  * 未映射到任何干沉积速度替代物，即未进行干沉积，因此使用默认缩放因子-1
  * 未映射到任何清除代理，即不进行清除，因此使用默认缩放因子-1
  * 将尝试从初始条件文件中名为ICT_50PPB的物种中获取其初始名称
  * 未映射到任何边界条件，因此使用默认缩放因子-1
  * 不参与气-气溶胶转换或气-水转换
  * 将进行对流和扩散
  * 不会写入DDEP（干沉降）和WDEP（湿沉降）输出文件
  * 将被写入CONC（浓度）输出文件

### 步骤2：将示踪剂添加到初始条件（IC）、边界条件（BC）、排放文件中

根据所需的应用，需要将在跟踪器名称列表中为每个跟踪器定义的排放替代和IC/BC替代添加到相应的CMAQ输入文件，即排放、初始条件、边界条件文件。

The CO_EMIS tracer defined in STEP1 has an emission surrogate that needs to be mapped in a standard emission file (the first four tracers do not have any emission surrogate while the fifth tracer uses CO as its emission surrogate). The first four tracers have a IC/BC surrogates that are contained in standard initial or boundary condition files, while the last tracer, ICT_50PPB, does not have an IC that is contained in a standard IC file. This section provides the necessary steps to add an emissions surrogate to the emissions file and a sample scripts that add the necessary species to an existing initial condition file.

Note that adding species (if any) to the initial condition file is only necessary for the first day of the simulation while boundary condition and/or emission species (if any) need to be added to the boundary condition and/or emission files for all days of the simulation. Since all tracers defined above will be written to the CGRID file using their names as defined in column 1 of the namelist file, and since the CGRID file will be used to provide initial conditions to CMAQ after the first day of simulation, the tracer species names defined in column 1 were also used as the names of the IC/BC surrogate in column 9 in the sample tracer namelist file for those tracers that use an IC/BC surrogate.   


#### Script to add O3_IC and ICT_50PPB to an existing initial condition file ####

The run script below uses the [`combine`](../../POST/combine) program to add species ICT_50PB to an existing initial condition file. . ICT_50PPB is set to a constant mixing ratio of 0.05 ppm for all grid cells. From the CMAQ Home directory run the following commands to build the combine executable: 

```
cd $CMAQ_HOME/POST/combine/scripts
./bldit_combine.csh [compiler] [version] |& tee build_combine.log
```

After the combine executable is successfully built, create the following run script in the same folder: 

```
#!/bin/csh

#> Location of CMAQv5.2 benchmark case
 set CMAQ_DATA = $CMAQ_HOME/data
 set OUTDIR = $CMAQ_DATA/SE52BENCH

#> Set the working directory
 set BASE  = $cwd      

 cd $BASE; date; set timestamp; echo " "; set echo

#> Timestep run parameters.
 set YEAR     = 2011
 set MONTH    = 07
 set DAY      = 01 
 set MET_YEAR = 11

#> Use GENSPEC switch to generate a new specdef file (does not generate output file).

 setenv GENSPEC Y

#> Define name of new species definition file to be created

 setenv SPECIES_DEF ${OUTDIR}/SpecDef_CGRID_SE52BENCH.txt

 if (-e ${SPECIES_DEF}) 'rm' ${SPECIES_DEF}


#> Define name of input and output files needed for combine program.

   setenv INFILE1 ${CMAQ_DATA}/SE52BENCH/ref_output/cctm/CCTM_CGRID_v52_intel_SE52BENCH_$YEAR$MONTH$DAY.nc

   setenv OUTFILE ${OUTDIR}/SE52BENCH/CCTM_CGRID_v52_intel_SE52BENCH_added_tracer_$YEAR$MONTH$DAY.nc


#> Executable call:
#>
#> In this first call, we only generate the specdef file that contains all the
#> species contained in the existing boundary condition file. OUTFILE is not
#> created

   /usr/bin/time $BINDIR/combine.${VRSN}.exe

#>
#> define the tracer species to be added to the boundary condition file using the
#> "combine" specdef syntax
#>

   echo "O3_IC            ,ppmV            ,O3[1], Variable O3_IC"            >! ${OUTDIR}/species_def_tracer.txt
   echo "ICT_50PPB        ,ppmV            ,0.05, Variable ICT_50PPB"         >> ${OUTDIR}/species_def_tracer.txt

#>
#> concatenate the specdep file containing the existing species and the file
#> containing the additional tracer species
#>

cat ${SPECIES_DEF} ${OUTDIR}/species_def_tracer.txt >! ${OUTDIR}/species_CGRID_D51a_12CalnexBench_added_tracer.txt

#> Redefine the name of specdef file
 setenv SPECIES_DEF ${OUTDIR}/species_CGRID_D51a_12CalnexBench_added_tracer.txt

#> Reset the GENSPEC switch to not generate a new specdef file but to generate an output file
 setenv GENSPEC N

#> Executable call:
#>
#> In this second call, the modified specdef file is used
#> and an output file containing all the original species
#> as well as the added tracer species is created

   /usr/bin/time $BINDIR/combine.${VRSN}.exe

#>
#> Remove the temporary file with the tracer definitions
#>

'rm' ${OUTDIR}/SpecDef_tracer.txt

 date
 exit()

```

Once the script is made, execute the run script with the following commands:

```
./run.{script_name}.csh |& tee run.combine.log
```

The CO_EMIS tracer is designed to track the fate of CO emissions without any influence from initial or boundary conditions and therefore no IC/BC surrogate was specified and no additional species needs to be added to the initial condition file for this tracer. However, it must be specified in the [emissions input](CMAQ_UG_ch04_model_inputs.md#EmissionsInputs) file. Depending on the mechanism the user plans to use navigate the [CMAQ repository](CMAQ_UG_ch05_running_CMAQ.md#5.3TheCMAQRepositoryStructure) to find the EmissCtrl_{mechanism_name}.nml file. For example if running the cb6r3_ae7_aq mechanism, edit EmissCtrl_cb6r3_ae7_aq.nml file to include the following line after the Custom Mapping Examples in the Emissions Scaling Rules section: 

```
   !Tracer
   'EVERYWHERE', 'ALL'         ,'CO'     ,'CO_EMIS'          ,'GAS'  ,1.  ,'UNIT','a',
```

Further details on how to change and customize the emissions control file to the users specification outside the scope of this tutorial can be found in the [emissions tutorial](CMAQ_UG_tutorial_emissions.md). 


### STEP 3: Modify CMAQ run script</strong>

In the CMAQ run script, replace the default tracer namelist file `Species_Table_TR_0.nml` with the custom tracer namelist file created in STEP 1. Also replace the original input files (initial conditions, boundary conditions, and/or emissions) with the modified input files created in Step 2.
