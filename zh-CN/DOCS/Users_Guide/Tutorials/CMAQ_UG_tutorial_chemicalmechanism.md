## CMAQ教程 ##

作者: Elyse Pennington (epenning@caltech.edu)

### 修改CMAQ化学机理 ###


目标：修改CMAQ中的气相和气溶胶化学机理，创建新的求解器，并在Github中提交修改。本教程包括影响SOA前体和产物的示例，但不包括对臭氧或其他自由基化学的影响。注意：如果对气相机理进行了重大修改以改变了自由基平衡，则应对照替代求解器（如ros3或smvgear）来检查修改机理的ebi实现。本示例不包括这种重大修改。

### 要编辑的文件 ##
1. mech_*.def
2. AE namelist
3. GC namelist
4. NR namelist
5. EmissCtrl namelist
6. AERO_DATA.F
7. SOA_DEFN.F
8. hlconst.F
9. SpecDef_*.txt
10. SpecDef_Dep_*.txt


### 要使用的工具
1. chemmech (详见[说明文档](../../../UTIL/chemmech/README.md))
2. create_ebi (详见[说明文档](../../../UTIL/create_ebi/README.md))


<a id=modifychem></a>
## 修改化学机理 ##
### 1. 如果您想在Github代码库中提交化学机制的变化，请查阅下述的[git说明](#github)。


<a id=mech_def></a>
### 2. 修改mech.def.
位于$CMAQ_REPO/CCTM/src/MECHS/${mechanism}/mech_${mechanism}.def中的mech.def文件列出了CMAQ中的所有化学反应。[chemmech文档]( ../../../UTIL/chemmech/README.md )中描述了反应速率常数的格式，这些常数取决于温度、大气密度、水蒸气、阳光、模型物种以及诸如氧气和甲烷混合比等相关常数。该文档还提供了有关mech.def（化学机理定义）部分和格式设置规则的更详细说明。
- 所有化学反应的开头必须设置名称，并把名称放在< >括号中。
- 所有化学反应的结尾必须输入#符号，#符号后是反应速率常数，单位是cm<sup>3</sup>/(molecules s)
- 在本教程中，所有的化学反应都会重新生成氧化物。

在本示例中，我们通过使气相前体物TPROD与OH反应生成两种半挥发性气相物质SVTPROD1、SVTPROD2，以添加Odum两种产物模型，其α值为0.15和0.8（摩尔），反应速率常数为4.5×10^<sup>-11</sup> cm<sup>3</sup>/(molecules s):
```
<TWOPROD> TPROD + OH = OH + 0.15 * SVTPROD1 + 0.80 * SVTPROD2 #4.50E-11;
```
从气相IVOC物种（NONVG）反应生成持久性的、积累模式的SOA物种（ANONVJ），SOA产率为5％摩尔，反应速率常数为2×10<sup>-11</sup> cm<sup>3</sup>/(molecules s):
```
<NONV> NONVG + OH = OH + 0.05 * ANONVJ #2.00E-11;
```


<a id=GCnml></a>
### 3. 编辑GC名称列表文件
位于$CMAQ_REPO/CCTM/src/MECHS/${mechanism}/GC_${mechanism}.nml中的GC名称列表文件定义了气相物质及其物理和化学性质。
您必须在GC名称列表文件中为添加到[mech.def]( #mech_def )中的每种气相物质添加一个新的行。有关更多信息，请参见[第4章]( ../CMAQ_UG_ch04_model_inputs.md )。
必须将上述示例中的TPROD、SVTPROD1、SVTPROD2和NONVG物种添加到GC名称列表文件中，因为它们是气相物质。每列的描述可以在[第4章]( ../CMAQ_UG_ch04_model_inputs.md )中找到。在此示例中，与CMAQ中的许多其他VOCs物种类似，TPROD不参与干沉积，因此'DRYDEP SURR'和'DDEP'为空，FAC为-1。而NONVG（如上述定义的IVOC物种）、SVTPROD1和SVTPROD2由于挥发性低，参与了干沉积。本教程没有说明创建新的干沉积替代物的过程，但在实际中是可以这样做的，并替换'VD_GEN_ALD'。下面的[hlconst.F]( #hlconst )部分介绍了WET-SCAV SURR。'GC2AE SURR'列出了在[SOA_DEFN.F]( #SOA_DEFN )中气相和气溶胶相之间分配的物种。
```
!SPECIES        ,MOLWT   ,IC     ,IC_FAC ,BC     ,BC_FAC ,DRYDEP SURR       ,FAC  ,WET-SCAV SURR     ,FAC ,GC2AE SURR     ,GC2AQ SURR,TRNS  ,DDEP  ,WDEP  ,CONC
'SVTPROD1'      ,216.66  ,''     ,-1     ,''     ,-1     ,'VD_GEN_ALD'      , 1   ,'SVTPROD1'        , 1  ,'SVTPROD1'     ,''        ,'Yes' ,'Yes' ,'Yes' ,'Yes',
'SVTPROD2'      ,182.66  ,''     ,-1     ,''     ,-1     ,'VD_GEN_ALD'      , 1   ,'SVTPROD2'        , 1  ,'SVTPROD2'     ,''        ,'Yes' ,'Yes' ,'Yes' ,'Yes',
'TPROD'         ,168.66  ,''     ,-1     ,''     ,-1     ,''                ,-1   ,'TPROD'           , 1  ,''             ,''        ,'Yes' ,''    ,'Yes' ,'Yes',
'NONVG'         ,119.54  ,''     ,-1     ,''     ,-1     ,'VD_GEN_ALD'      , 1   ,'NONVG'           , 1  ,''             ,''        ,'Yes' ,'Yes' ,'Yes' ,'Yes'
```



<a id=AEnml></a>
### 4. 编辑AE名称列表文件
位于$CMAQ_REPO/CCTM/src/MECHS/${mechanism}/AE_${mechanism}.nml的AE名称列表文件定义了所有气溶胶相物种及其物理和化学性质。
您必须为添加到[AERO_DATA.F]( #AERO_DATA )的每个气溶胶相物种添加一个新行。有关更多信息，请参见[第4章]( ../CMAQ_UG_ch04_model_inputs.md )。
必须将ANONVJ和Odum两种产物模型中的气溶胶产物加到AE名称列表文件中。半挥发性的Odum两种产物SVTPROD1和SVTPROD2通过ATPROD1J和ATPROD2J在气体和累积模式气溶胶相之间分配。列描述可以在[第4章]( ../CMAQ_UG_ch04_model_inputs.md )中找到。
```
!SPECIES   ,MOLWT   ,IC     ,IC_FAC ,BC     ,BC_FAC ,DRYDEP SURR ,FAC ,WET-SCAV SURR  ,FAC ,AE2AQ SURR     ,TRNS    ,DDEP    ,WDEP    ,CONC
'ATPROD1J' ,216.66  ,''     ,-1     ,''     ,-1     ,'VMASSJ'    , 1  ,'ORG_ACCUM'    , 1  ,'SOA_ACCUM'    ,'Yes'   ,'Yes'   ,'Yes'   ,'Yes',
'ATPROD2J' ,182.66  ,''     ,-1     ,''     ,-1     ,'VMASSJ'    , 1  ,'ORG_ACCUM'    , 1  ,'SOA_ACCUM'    ,'Yes'   ,'Yes'   ,'Yes'   ,'Yes',
'ANONVJ'   ,135.54  ,''     ,-1     ,''     ,-1     ,'VMASSJ'    , 1  ,'ORG_ACCUM'    , 1  ,'SOA_ACCUM'    ,'Yes'   ,'Yes'   ,'Yes'   ,'Yes',
```



<a id=NRnml></a>
### 5. 编辑NR名称列表文件
位于$CMAQ_REPO/CCTM/src/MECHS/${mechanism}/NR_${mechanism}.nml中的NR名称列表文件定义了不在mech.def文件中的气相物种及其理化特性。该文件中的物质通常是在气相和气溶胶相之间分配的半挥发性气体。
您必须为每个非反应性物种（如果有的话）添加一个新行，以添加到未在[mech.def](#mech_def)中明确建模的化学机理中。有关每一列中信息的描述，请参见[第4章]( ../CMAQ_UG_ch04_model_inputs.md )。
本教程中使用的示例不包括需要添加到NR名称列表中的物种。请参阅倍半萜SOA反应机理作为NR物种的示例（例如，参阅$CMAQ_REPO/CCTM/src/MECHS/${mechanism}/和$CMAQ_REPO/CCTM/src/aero/aero6/中的SESQRXN、SVSQT和ASQTJ）。



<a id=EmissCtrl></a>
### 6. 编辑排放控制文件
位于$CMAQ_REPO/CCTM/src/MECHS/${mechanism}/EmissCtrl_${mechanism}.nml中的排放控制文件描述了如何输入排放。mech.def或GC、AE和NR名称列表中包含的直接排放的任何新物种都应包含在此文件中。如何添加新物种的示例可以详见!> CUSTOM MAPPING EXAMPLES <!一节，更多说明可以参见[DESID教程]( CMAQ_UG_tutorial_emissions.md )。



<a id=SpecDef></a>
### 7. 编辑SpecDef文件
位于$CMAQ_REPO/CCTM/src/MECHS/${mechanism}/SpecDef_{mechanism}.txt中的SpecDef文件用于汇总CMAQ的输出物种（例如，转换为PM<sub>2.5</sub>）以及转换单位。它用于运行后处理工具[combine]( ../../../POST/combine/README.md )。
要将气相物种的单位转换为ppb，请添加以下行：
```
NEWGAS          ,ppbV      ,1000.*NEWGAS[1]
```
要将新物种添加到OA质量中，请将其添加到适当的POA或SOA变量中。例如，要添加新的SOA累积模式气溶胶物种ANEWJ、请在ASOMJ中添加'+ANEWJ[1]'。此更改将反映在使用ASOMJ的后续变量定义中。

如果您的模拟区域是城市地区，则将AGLYJ从AORGB（生物源VOC生成的气溶胶）转移到AORGA（人为源VOC生成的SOA）。

在某些情况下，您可能要从SOA中删除pcSOA。在这种情况下，必须创建减去APCSOJ的新变量。例如，要在不使用pcSOA的情况下计算PM<sub>1</sub> SOA，请更新以下变量：
```
AOMJ_MP         ,ug m-3    ,APOMJ[0]  + ASOMJ[0] - APCSOJ[1]
ATOTJ_MP        ,ug m-3    ,ASO4J[1]+ANO3J[1]+ANH4J[1]+ANAJ[1]+ACLJ[1] \
                           +AECJ[1]+AOMJ_MP[0]+AOTHRJ[1]+AFEJ[1]+ASIJ[1]  \
                           +ATIJ[1]+ACAJ[1]+AMGJ[1]+AMNJ[1]+AALJ[1]+AKJ[1]
PM1_TOT_MP      ,ug m-3    ,ATOTI[0]*PM1AT[3]+ATOTJ_MP[0]*PM1AC[3]+ATOTK[0]*PM1CO[3]
```
要更新SpecDef_Dep_{mechanism}.txt文件中的OC变量或OC变量的沉积，您必须知道新的有机气溶胶物种的OM:OC比例。



<a id=SOA_DEFN></a>
### 8. 编辑SOA_DEFN.F文件
SOA_DEFN.F describes SOA precursors, SOA species and their properties dealing with gas to particle partitioning. It is located at $CMAQ_REPO/CCTM/src/aero/aero6/SOA_DEFN.F. Note that the aero7 directory is linked to the aero6 directory.

You must add a row for every new SOA species and increase n_oa_list by the number of species added to the list.

To add semivolatile species that partition between the gas and aerosol phases (with a gas-phase species defined in the [GC namelist](#GCnml)), include their effective saturation concentrations (C*) and enthalpies of vaporization. In this example, ATPROD1 has the corresponding gas-phase species SVTPROD1 and has C* = 0.95 ug/m<sup>3</sup> and enthalpy of vaporization = 131 J/mol. ATPROD2 has the corresponding gas-phase species SVTPROD2 and has C* = 485 ug/m<sup>3</sup> and enthalpy of vaporization = 101 J/mol:
```
& oa_type('ATPROD1', 'SVTPROD1', '        ',  0.0000,     0.95, 131.0E3,   F ),
& oa_type('ATPROD2', 'SVTPROD2', '        ',  0.0000,   485.00, 101.0E3,   F )
```
To add a nonvolatile aerosol species:
```
& oa_type('ANONV  ', '        ', '        ',  0.0000,   1.E-10,   1.0E0,   T )
```
Note that these aerosol definitions do not include a specification of the size bin they fall into. That is instead defined in the [AE namelist](#AEnml) by I, J, or K (for Aitken, accumulation, or coarse mode aerosol, respectively) at the end of the variable name.



<a id=AERO_DATA></a>
### 9. Edit AERO_DATA.F
AERO_DATA.F defines all aerosol species and some of their properties. It is located at $CMAQ_REPO/CCTM/src/aero/aero6/AERO_DATA.F. Note that the aero7 directory is linked to the aero6 directory.

You must add a row for every new aerosol species and increase n_aerolist be the number of species added to the list.

To add a semivolatile organic aerosol species, set OM to T, set no_M2Wet to T, calculate korg from e.g. Pye et al., ACP, 2017, and use properties that match other organic species:
```
& spcs_list_type('ATPROD1 ', cm_set, 1400.0, T,F,  0,  2.8, 6.1,T, 'DUST  ', 0.09),
& spcs_list_type('ATPROD2 ', cm_set, 1400.0, T,F,  0,  2.8, 6.1,T, 'DUST  ', 0.05),
```
To add a nonvolatile organic aerosol species, set no_M2Wet to F:
```
& spcs_list_type('ANONV   ', cm_set, 1400.0, F,F,  0,  2.8, 6.1,T, 'DUST  ', 0.07),
```
Note that these aerosol definitions do not include a specification of the size bin they fall into. That is instead defined in the [AE namelist](#AEnml) by I, J, or K (for Aitken, accumulation, or coarse mode aerosol, respectively) at the end of the variable name.



<a id=hlconst></a>
### 10. Edit hlconst.F
hlconst.F calculates Henry's Law constants for species that participate in wet deposition. It's located in the relevant cloud directory at $CMAQ_REPO/CCTM/src/cloud/*/hlconst.F.

Each new row corresponds to a name used in the 'WET-SCAV SURR' column of the [GC namelist](#GCnml). Increase MXSPCS by the number of species added to the list.

Based on the additions to the [GC namelist](#GCnml) in these examples, wet deposition surrogates must be added for TPROD, SVTPROD1, SVTPROD2, and NONVG. The first 3 columns are row numbers in the data matrix. Column 4 is the name of the wet deposition surrogate used in the [GC namelist](#GCnml) and will often be the same as the species name. Column 5 is the Henry's law constant at 298.15 K (M/atm). Column 6 is the enthalpy; for organic semivolatile species with unknown enthalpy, 6.0E+03 may be used. See references listed in hlconst.F for models to calculate Henry's Law constants where experimental data is unavailable.
```
      DATA SUBNAME(217), A(217), E(217) / 'TPROD           ', 3.87E+02,  6.0E+03 /
      DATA SUBNAME(218), A(218), E(218) / 'SVTPROD1        ', 2.97E+06,  6.0E+03 /
      DATA SUBNAME(219), A(219), E(219) / 'SVTPROD2        ', 7.99E+05,  6.0E+03 /
      DATA SUBNAME(220), A(220), E(220) / 'NONVG           ', 2.22E+03,  6.0E+03 /

```
Dry deposition surrogates may also be added, but are not covered in this tutorial.



<a id=copy_src></a>
### 11. Build CMAQ_PROJECT.
See [Chapter 5](../CMAQ_UG_ch05_running_a_simulation.md) or the [Tutorials](README.md) for more information.


<a id=chemmech_build></a>
### 12. Build chemmech.
Copy the source code from CMAQ_REPO to CMAQ_PROJECT.
```
cp -r $CMAQ_REPO/UTIL/chemmech/ $CMAQ_PROJECT/UTIL/
```
Edit $CMAQ_PROJECT/UTIL/chemmech/scripts/bldit_chemmech.csh to make sure the correct compiler is set. Then run the build script.
```
./bldit_chemmech.csh
```



<a id=chemmech_run></a>
### 13. Run chemmech.
Edit run_chemmech.csh
- COMPILER
- Update correct Mechanism
- Set Mpath to the location of the [mech.def](#mech_def) file you modified above.
- Change the location of the tracer namelist file
```
set TR_NML = $CMAQ_REPO/CCTM/src/MECHS/trac0/Species_Table_TR_0.nml
```
Run:
```
./run_chemmech.csh
```
If successful, it will output, for example:
```
Normal Completion of CHEMMECH
Author is NAME
output written to ../output/saprc07tic_ae7i_aq-Sep-02-2020
```
and will write RXNS_DATA_MODULE.F90 and RXNS_FUNC_MODULE.F90 to the output path. Check the output mechanism csv, html, and markdown files to confirm that chemmech ran correctly. Copy the two Fortran files to $CMAQ_REPO/CCTM/src/MECHS/${Mechanism}/.



<a id=ebi_build></a>
### 14. Build+run create_ebi.
Copy the source code from CMAQ_REPO to CMAQ_PROJECT.
```
cp -r $CMAQ_REPO/UTIL/create_ebi/ $CMAQ_PROJECT/UTIL/
```
Move bldrun_create_ebi.csh up one directory (from $CMAQ_PROJECT/UTIL/create_ebi/scripts/ to $CMAQ_PROJECT/UTIL/create_ebi/). Edit bldrun_create_ebi.csh:
- COMPILER
- Update MECH for your mechanism.
- Set RXNS_DATA to the location of your chemmech output files.
- Set PAR_NEG_FLAG, DEGRADE_SUBS, SOLVER_DELT, and all MECH_*(species) variables to the setting that matches your mechanism. E.g. for saprc07tic_ae7i_aq:
```
 setenv PAR_NEG_FLAG    F    
 setenv DEGRADE_SUBS    F    
 setenv SOLVER_DELT     1.25 
```
The reactions added in this tutorial do not affect radical species in ozone chemistry. If it did, we recommend checking predictions using the EBI solver against an alternative gas solver listed in the cctm build script such as ros3 and smvgear. Check Table 1 in the [create_ebi documentation](../../../UTIL/create_ebi/README.md) as an initial list of radical species that may require such benchmarking. The list grows if new radical cycles are added to a mechanism such as radicals from halogen compounds.
Run:
```
./bldrun_create_ebi.csh
```
If successful, it will output:
```
The following 10 output files were created:
     hrdriver.F
     hrsolver.F
     hrdata_mod.F
     hrinit.F
     hrg1.F
     hrg2.F
     hrg3.F
     hrg4.F
     hrprodloss.F
     hrrates.F
Program CR_EBI_SOLVER completed successfully
if ( F == T ) then
exit ( )
```
and will write the hr*.F files to /work/MOD3DEV/eap/CMAQv532/UTIL/create_ebi/output/ebi_${Mechanism}-$DATE-${COMPILER}/. Copy the hr*.F files to $REPO/CCTM/src/gas/ebi_${Mechanism}/.



<a id=cctm_build></a>
### 15. Build the CCTM executable.
See [Chapter 5](../CMAQ_UG_ch05_running_a_simulation.md) or the [Tutorials](README.md) for more information. This will include all of the new files from $CMAQ_REPO/CCTM/src/ in $CMAQ_PROJECT/CCTM/BLD.


<a id=cmaq_run></a>
### 16. Run CCTM and post-processing tools.
See [Chapter 5](../CMAQ_UG_ch05_running_a_simulation.md) for more information about running the CCTM. See [Chapter 8](../CMAQ_UG_ch08_analysis_tools.md) for more information about running AMET, combine, sitecmp, etc. While running these post-processing tools, be sure to set file paths to the new files created in $CMAQ_REPO or $CMAQ_PROJECT/CCTM/BLD.


<a id=github></a>
## Reflecting the changes in Github ##
### 1. Fork from USEPA CMAQ.
On the [CMAQ Github page](../../../README.md), fork the master branch to your personal repository using the Fork button in the upper right.

### 2. Clone.
Clone your repository to your remote account. For example:
```
git clone https://username@github.com/username/CMAQ.git CMAQ_REPO_v532
```
This will request your Github password. You will now see the entire CMAQ repository in the directory you cloned it into. If you enter the top directory (e.g. CMAQ_REPO_v532/), there should now exist a file named .git.

### 3. Rename remote.
Rename the remote link. For example:
```
git remote rename origin dev_push_repo
```

### 4. Link to USEPA CMAQ.
Link the cloned repo to the USEPA Github repo.
```
git remote add dev_repo https://username@github.com/USEPA/CMAQ.git
```

### 5. Branching.
When modifying your repository, it's a good idea to check out a new branch. To create the branch:
```
git branch newchem
```
To move to that branch:
```
git checkout newchem
```
To look at all of your branches:
```
git branch
```
The branch you're currently working from will have an asterisk.

### 6. Modify the mechanism according to the [instructions](#modifychem) above.
If the USEPA repository is updated by EPA, you will see a statement such as "This branch is X commits behind USEPA:master" in Github online. You will likely want to keep your CMAQ up-to-date and will want to pull the updates to your repo. Make sure the files you've edited are backed up.
Check the names of your remotes using:
```
git remote -v
```
If you've followed these instructions, your repository should be named dev_push_repo and the USEPA's repository should be named dev_repo. To pull in the updates from USEPA's master branch:
```
git pull dev_repo master
```
To view a summary of the changes you've made to your repo since your last commit, type "git status" from anywhere in the repo. If you've followed the instructions above, you should see:
```
# On branch newchem
# Changes not staged for commit:
#   (use "git add <file>..." to update what will be committed)
#   (use "git checkout -- <file>..." to discard changes in working directory)
#
#       modified:   CCTM/src/MECHS/saprc07tic_ae7i_aq/AE_saprc07tic_ae7i_aq.nml
#       modified:   CCTM/src/MECHS/saprc07tic_ae7i_aq/EmissCtrl_saprc07tic_ae7i_aq.nml
#       modified:   CCTM/src/MECHS/saprc07tic_ae7i_aq/GC_saprc07tic_ae7i_aq.nml
#       modified:   CCTM/src/MECHS/saprc07tic_ae7i_aq/RXNS_DATA_MODULE.F90
#       modified:   CCTM/src/MECHS/saprc07tic_ae7i_aq/RXNS_FUNC_MODULE.F90
#       modified:   CCTM/src/MECHS/saprc07tic_ae7i_aq/SpecDef_saprc07tic_ae7i_aq.txt
#       modified:   CCTM/src/MECHS/saprc07tic_ae7i_aq/mech_saprc07tic_ae7i_aq.def
#       modified:   CCTM/src/aero/aero6/AERO_DATA.F
#       modified:   CCTM/src/aero/aero6/SOA_DEFN.F
#       modified:   CCTM/src/cloud/acm_ae6/hlconst.F
#       modified:   CCTM/src/gas/ebi_saprc07tic_ae7i_aq/hrdata_mod.F
#       modified:   CCTM/src/gas/ebi_saprc07tic_ae7i_aq/hrdriver.F
#       modified:   CCTM/src/gas/ebi_saprc07tic_ae7i_aq/hrg1.F
#       modified:   CCTM/src/gas/ebi_saprc07tic_ae7i_aq/hrg2.F
#       modified:   CCTM/src/gas/ebi_saprc07tic_ae7i_aq/hrg3.F
#       modified:   CCTM/src/gas/ebi_saprc07tic_ae7i_aq/hrg4.F
#       modified:   CCTM/src/gas/ebi_saprc07tic_ae7i_aq/hrinit.F
#       modified:   CCTM/src/gas/ebi_saprc07tic_ae7i_aq/hrprodloss.F
#       modified:   CCTM/src/gas/ebi_saprc07tic_ae7i_aq/hrrates.F
#       modified:   CCTM/src/gas/ebi_saprc07tic_ae7i_aq/hrsolver.F
#       modified:   bldit_project.csh
```
To see a list of all lines that have been modified in those files, type "git diff".

### 7. Commit the changes.
To stage all modified files in current directory for commit:
```
git add -u
```
To stage specific files for commit:
```
git add [filename1] [filename2]
```
To commit:
```
git commit
```
A page indicating all changes in the commit will be displayed. Enter a description at the top and close the page using :x and Enter.

### 8. Push the changes to your Github respository.
Make sure you don't push the changes to the USEPA CMAQ Github!

To push your changes from your newchem branch to your Github repository:
```
git push dev_push_repo newchem
```
You should now be able to see these changes in Github online.


