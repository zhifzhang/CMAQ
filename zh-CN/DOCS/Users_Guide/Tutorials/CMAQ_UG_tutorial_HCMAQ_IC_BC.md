## CMAQ 教程 ##
### 从季均半球CMAQ输出文件中创建初始条件和边界条件 ###
目的：本教程将引导用户逐步从通过CMAS数据仓库分发的季均半球CMAQ输出文件创建初始条件和边界条件（假设用户已经为目标建模区域生成了MCIP文件）。

下载季均半球CMAQ输出文件：https://drive.google.com/file/d/15Vt6f5WuyN8RiLRjTlKeQUHjYbZ6QCrA/view?usp=sharing


------------


### 步骤1：从CMAS数据仓库获取季均半球CMAQ输出文件 </strong>

EPA发布的季均半球CMAQ输出文件中包含了2016年在北半球进行的半球CMAQ模拟得出的季均3D物种浓度，该模拟采用CMAQv5.3的预发行版，使用以下配置进行：

- 模型版本：CMAQv5.3 beta2（2018年2月），包括完整的卤素和DMS化学成分
- 网格间距：覆盖北半球，采用极地立体网格，间距为108×108km
- 垂直层数：44
- 气象场：WRF3.8  
- 化学机理：CB6R3M_AE7_KMTBR  
- 干沉积：M3DRY  

该文件名为CCTM_CONC_v53beta2_intel17.0_HEMIS_cb6r3m_ae7_kmtbr_m3dry_2016_quarterly_av.nc，可以在此处下载

https://drive.google.com/file/d/15Vt6f5WuyN8RiLRjTlKeQUHjYbZ6QCrA/view?usp=sharing

### 步骤2（可选）：改变已下载的季均半球CMAQ输出文件中的时间 </strong>

如果要生成初始条件和边界条件的时间段不在2015年10月16日12:00 GMT和2017年1月16日0:00 GMT之间，则需要调整下载文件中的时间戳以包含所需的时间段。这可以通过使用与[I/O API]( https://www.cmascenter.org/ioapi/ )一起发布的`m3tools`实用工具中的`m3tshift`这样的工具来完成。

从步骤1中下载的季均浓度文件包含六次时间戳（10/16/2015 12:00、1/16/2016 0:00、4/16/2016 12:00、7/17/2016 0:00、10/16/2016 12:00、以及1/16/2017 0:00），分别代表秋季、冬季、春季、夏季、秋季和冬季的季均值。秋季被定义为2016年9月1日至11月30日，冬季被定义为2016年1月1日至2月29日以及12月1日至12月31日，春季被定义为2016年3月1日至5月31日，夏季被定义为2016年6月1日至8月31日。请注意，与第一时间戳关联的浓度值与与第五时间戳关联的浓度值相同，因为两者均表示秋季。同样，与第二时间戳关联的浓度值与与第六时间戳关联的浓度值相同，因为它们都代表冬季。

一个脚本示例如下所示，其采用`m3tshift`工具将所有六个时间戳转换成两年，以支持在2013年10月16日12:00 GMT至2015年1月17日0:00 GMT之间的建模期间使用ICON和BCON生成初始条件和边界条件。

```
#!/bin/csh -f

set EXEC = /path/to/m3tshift
#> 设置m3tshift所在路径

#> Year to be entirely encompassed by the time stamps in the time-shifted output file
#> 设置改变时间后的输出文件中的时间戳将完全包含的年份
set TARGET_YEAR = 2014

#> Path to the seasonal average H-CMAQ file downloaded from the CMAS data warehouse
#> This path will also be used to store the time-shifted output file
#> 从CMAS数据仓库下载的季均H-CMAQ文件的路径，此路径还将用于存储改变时间后的输出文件
set DATADIR = /path/to/downloaded_data

#> Name of the seasonal average H-CMAQ file downloaded from the CMAS data warehouse
#> 从CMAS数据仓库下载的季均H-CMAQ文件的文件名
set AV_CONC_INFILE = CCTM_CONC_v53beta2_intel17.0_HEMIS_cb6r3m_ae7_kmtbr_m3dry_2016_quarterly_av.nc

#> Name of the time-shifted seasonal average H-CMAQ file 
#> 输出的改变时间后的季均H-CMAQ文件的文件名
set AV_CONC_OUTFILE = CCTM_CONC_v53beta2_intel17.0_HEMIS_cb6r3m_ae7_kmtbr_m3dry_${TARGET_YEAR}_quarterly_av.nc

setenv INFILE ${DATADIR}/${AV_CONC_INFILE}
setenv OUTFILE ${DATADIR}/${AV_CONC_OUTFILE}

#> Invoke m3shift to shift the time stamps to the target year
#> Note that the first time stamp represents the fall of the previous year
#> 调用m3shift将时间戳转换为目标年份。请注意，第一个时间戳代表上一年的秋天

@ TARGET_YEAR = ${TARGET_YEAR} - 1

${EXEC} << EOF
INFILE
2015289
120000
${TARGET_YEAR}289
120000
21960000
131760000
OUTFILE
EOF
```

### 步骤3（可选）：映射到其他化学机理 </strong>

如果将cb6r3_ae7_aq，cb6r3_ae7_aqkmt2或cb6r3m_ae7_kmtbr以外的化学机理用于区域尺度的CMAQ模拟，则下载文件中的物种需要映射到该其他化学机理。在BCON和ICON源代码旁的[目录]( ../../../PREP/bcon/map2mech )中提供了一个示例脚本，该脚本用于使用`combine`程序从cb6r3m_ae7_kmtbr映射到racm_ae6_aq、saprc07tc_ae6_aq或saprc07tic_ae7i_aq。该目录中还提供了用于机理映射的物种定义文件。

### 步骤4：编译ICON和BCON可执行文件 </strong>

要编译ICON和BCON可执行文件，请从CMAQ主目录运行以下命令：

```
cd $CMAQ_HOME/PREP/icon/scripts
./bldit_icon.csh [compiler] [version] |& tee build_icon.log
```

```
cd $CMAQ_HOME/PREP/bcon/scripts
./bldit_bcon.csh [compiler] [version] |& tee build_bcon.log
```

### 步骤5：运行ICON以创建初始条件 </strong>

下面的运行脚本使用[`ICON`]( ../../../PREP/icon )程序，根据在步骤1/步骤2（可选）/步骤3（可选）中获得的季均半球CMAQ输出文件，为用户的目标区域创建初始条件。通过将ICTYPE设置为regrid，运行脚本将以_regrid_模式调用ICON，因为初始条件是从CONC文件派生的。在下面的示例中，APPL、GRID_NAME、GRIDDESC、MET_CRO_3D_FIN和DATE的设置反映的是CMAQ东南部区域基准测试案例的情况，需要用户进行修改以指向其模拟区域的相应文件并反映预期的模拟开始日期。环境变量CTM_CONC_1和MET_CRO_3D_CRS都应指向在步骤1/步骤2（可选）/步骤3（可选）中下载的文件的完整路径。

```
#!/bin/csh -f

# ======================= ICONv5.3 Run Script ========================
# Usage: run.icon.csh >&! icon_v53.log &                                   
#
# To report problems or request help with this script/program:         
#             http://www.cmascenter.org
# ==================================================================== 

# ==================================================================
#> Runtime Environment Options
# ==================================================================

#> Choose compiler and set up CMAQ environment with correct 
#> libraries using config.cmaq. Options: intel | gcc | pgi
 setenv compiler intel 

#> Source the config_cmaq file to set the run environment
 pushd ../../../
 source ./config_cmaq.csh $compiler
 popd

#> Check that CMAQ_DATA is set:
 if ( ! -e $CMAQ_DATA ) then
    echo "   $CMAQ_DATA path does not exist"
    exit 1
 endif
 echo " "; echo " Input data path, CMAQ_DATA set to $CMAQ_DATA"; echo " "

#> Set General Parameters for Configuring the Simulation
 set VRSN     = v53                     #> Code Version
 set APPL     = SE53BENCH               #> Application Name
 set ICTYPE   = regrid                  #> Initial conditions type [profile|regrid]

#> Set the working directory:
 set BLD      = ${CMAQ_HOME}/PREP/icon/scripts/BLD_ICON_${VRSN}_${compilerString}
 set EXEC     = ICON_${VRSN}.exe  
 cat $BLD/ICON_${VRSN}.cfg; echo " "; set echo

#> Horizontal grid definition 
 setenv GRID_NAME SE53BENCH               #> check GRIDDESC file for GRID_NAME options
#setenv GRIDDESC $CMAQ_DATA/$APPL/met/mcip/GRIDDESC #> grid description file 
 setenv GRIDDESC /work/MOD3DATA/SE53BENCH/met/mcip/GRIDDESC
 setenv IOAPI_ISPH 20                     #> GCTP spheroid, use 20 for WRF-based modeling

#> I/O Controls
 setenv IOAPI_LOG_WRITE F     #> turn on excess WRITE3 logging [ options: T | F ]
 setenv IOAPI_OFFSET_64 YES   #> support large timestep records (>2GB/timestep record) [ options: YES | NO ]
 setenv EXECUTION_ID $EXEC    #> define the model execution id

# =====================================================================
# ICON Configuration Options
#
# ICON can be run in one of two modes:                                     
#     1) use default profile inputs (IC = profile)
#     2) regrids CMAQ CTM concentration files (IC = regrid)     
# =====================================================================

 setenv ICON_TYPE ` echo $ICTYPE | tr "[A-Z]" "[a-z]" ` 

# =====================================================================
#> Input/Output Directories
# =====================================================================

 set OUTDIR   = $CMAQ_HOME/data/icon       #> output file directory

# =====================================================================
#> Input Files
#  
#  Profile Mode (IC = profile)
#     IC_PROFILE = static/default IC profiles 
#     MET_CRO_3D_FIN = the MET_CRO_3D met file for the target domain 
#  Regrid mode (IC = regrid) (includes nested domains, windowed domains,
#                             or general regridded domains)
#     CTM_CONC_1 = the CTM concentration file for the coarse domain          
#     MET_CRO_3D_CRS = the MET_CRO_3D met file for the coarse domain
#     MET_CRO_3D_FIN = the MET_CRO_3D met file for the target nested domain 
#                                                                            
# NOTE: SDATE (yyyyddd) and STIME (hhmmss) are only relevant to the
#       regrid mode and if they are not set, these variables will 
#       be set from the input MET_CRO_3D_FIN file
# =====================================================================
#> Output File
#     INIT_CONC_1 = gridded IC file for target domain
# =====================================================================

 if ( $ICON_TYPE == profile ) then
    setenv IC_PROFILE $BLD/avprofile_cb6r3m_ae7_kmtbr_hemi2016_v53beta2_m3dry_col051_row068.csv
    setenv MET_CRO_3D_FIN /work/MOD3DATA/SE53BENCH/met/mcip/METCRO3D_160701.nc
    setenv INIT_CONC_1    "$OUTDIR/ICON_${VRSN}_${APPL}_${ICON_TYPE} -v"
 endif
 
 if ( $ICON_TYPE == regrid ) then
    setenv CTM_CONC_1 /path/to/CCTM_CONC_v53beta2_intel17.0_HEMIS_cb6r3m_ae7_kmtbr_m3dry_2016_quarterly_av.nc
    setenv MET_CRO_3D_CRS /path/to/CCTM_CONC_v53beta2_intel17.0_HEMIS_cb6r3m_ae7_kmtbr_m3dry_2016_quarterly_av.nc
    setenv MET_CRO_3D_FIN /work/MOD3DATA/SE53BENCH/met/mcip/METCRO3D_160701.nc
    set DATE = `date -ud "2016-07-01" +%Y%j` #> Convert YYYY-MM-DD to YYYYJJJ
#    setenv SDATE           ${DATE}
#    setenv STIME           000000
    setenv INIT_CONC_1    "$OUTDIR/ICON_${VRSN}_${APPL}_${ICON_TYPE}_${DATE} -v"
 endif

 
#>- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

 if ( ! -d "$OUTDIR" ) mkdir -p $OUTDIR

 ls -l $BLD/$EXEC; size $BLD/$EXEC
 unlimit
 limit

#> Executable call:
 time $BLD/$EXEC

 exit() 
 ```
 
### 步骤6：运行BCON以创建边界条件 </strong>

下面的运行脚本使用[`BCON`]( ../../../PREP/bcon )程序，根据在步骤1/步骤2（可选）/步骤3（可选）中获得的季均半球CMAQ输出文件，为用户的目标区域创建边界条件。通过将BCTYPE设置为regrid，运行脚本将以_regrid_模式调用BCON，因为边界条件是从CONC文件派生的。在下面的示例中，APPL、GRID_NAME、GRIDDESC、MET_CRO_3D_FIN和DATE的设置反映的是CMAQ东南部区域基准测试案例的情况，需要用户进行修改以指向其模拟区域的相应文件并反映预期的模拟开始日期。环境变量CTM_CONC_1和MET_CRO_3D_CRS都应指向在步骤1/步骤2（可选）/步骤3（可选）中下载的文件的完整路径。

```
#!/bin/csh -f

# ======================= BCONv5.3 Run Script ======================== 
# Usage: run.bcon.csh >&! bcon_v53.log &                                
#
# To report problems or request help with this script/program:        
#             http://www.cmascenter.org
# ==================================================================== 

# ==================================================================
#> Runtime Environment Options
# ==================================================================

#> Choose compiler and set up CMAQ environment with correct 
#> libraries using config.cmaq. Options: intel | gcc | pgi
 setenv compiler intel 

#> Source the config_cmaq file to set the run environment
 pushd ../../../
 source ./config_cmaq.csh $compiler
 popd

#> Check that CMAQ_DATA is set:
 if ( ! -e $CMAQ_DATA ) then
    echo "   $CMAQ_DATA path does not exist"
    exit 1
 endif
 echo " "; echo " Input data path, CMAQ_DATA set to $CMAQ_DATA"; echo " "

#> Set General Parameters for Configuring the Simulation
 set VRSN     = v53                     #> Code Version
 set APPL     = SE53BENCH               #> Application Name
 set BCTYPE   = regrid                  #> Boundary condition type [profile|regrid]

#> Set the build directory:
 set BLD      = ${CMAQ_HOME}/PREP/bcon/scripts/BLD_BCON_${VRSN}_${compilerString}
 set EXEC     = BCON_${VRSN}.exe  
 cat $BLD/BCON_${VRSN}.cfg; echo " "; set echo

#> Horizontal grid definition 
 setenv GRID_NAME SE53BENCH               #> check GRIDDESC file for GRID_NAME options
#setenv GRIDDESC $CMAQ_DATA/$APPL/met/mcip/GRIDDESC #> grid description file 
 setenv GRIDDESC /work/MOD3DATA/SE53BENCH/met/mcip/GRIDDESC
 setenv IOAPI_ISPH 20                     #> GCTP spheroid, use 20 for WRF-based modeling

#> I/O Controls
 setenv IOAPI_LOG_WRITE F     #> turn on excess WRITE3 logging [ options: T | F ]
 setenv IOAPI_OFFSET_64 YES   #> support large timestep records (>2GB/timestep record) [ options: YES | NO ]
 setenv EXECUTION_ID $EXEC    #> define the model execution id

# =====================================================================
#> BCON Configuration Options
#
# BCON can be run in one of two modes:                                     
#     1) use default profile inputs (BC type = profile)
#     2) regrids CMAQ CTM concentration files (BC = regrid)     
# =====================================================================

 setenv BCON_TYPE ` echo $BCTYPE | tr "[A-Z]" "[a-z]" `

# =====================================================================
#> Input/Output Directories
# =====================================================================

 set OUTDIR   = $CMAQ_HOME/data/bcon       #> output file directory

# =====================================================================
#> Input Files
#  
#  Profile mode (BC type = profile)
#     BC_PROFILE = static/default BC profiles 
#     MET_BDY_3D_FIN = the MET_BDY_3D met file for the target domain 
#  Regrid mode (BC = regrid) (includes nested domains, windowed domains,
#                             or general regridded domains)
#     CTM_CONC_1 = the CTM concentration file for the coarse domain          
#     MET_CRO_3D_CRS = the MET_CRO_3D met file for the coarse domain
#     MET_BDY_3D_FIN = the MET_BDY_3D met file for the target nested domain
#                                                                            
# NOTE: SDATE (yyyyddd), STIME (hhmmss) and RUNLEN (hhmmss) are only 
#       relevant to the regrid mode and if they are not set,  
#       these variables will be set from the input MET_BDY_3D_FIN file
# =====================================================================
#> Output File
#     BNDY_CONC_1 = gridded BC file for target domain
# =====================================================================
 
 if ( $BCON_TYPE == profile ) then
    setenv BC_PROFILE $BLD/avprofile_cb6r3m_ae7_kmtbr_hemi2016_v53beta2_m3dry_col051_row068.csv
    setenv MET_BDY_3D_FIN /work/MOD3DATA/SE53BENCH/met/mcip/METBDY3D_160701.nc
    setenv BNDY_CONC_1    "$OUTDIR/BCON_${VRSN}_${APPL}_${BCON_TYPE} -v"
 endif

 if ( $BCON_TYPE == regrid ) then 
    setenv CTM_CONC_1 /path/to/CCTM_CONC_v53beta2_intel17.0_HEMIS_cb6r3m_ae7_kmtbr_m3dry_2016_quarterly_av.nc
    setenv MET_CRO_3D_CRS /path/to/CCTM_CONC_v53beta2_intel17.0_HEMIS_cb6r3m_ae7_kmtbr_m3dry_2016_quarterly_av.nc
    setenv MET_BDY_3D_FIN /work/MOD3DATA/SE53BENCH/met/mcip/METBDY3D_160701.nc
    set DATE = `date -ud "2016-07-01" +%Y%j` #> Convert YYYY-MM-DD to YYYYJJJ
#    setenv SDATE           ${DATE}
#    setenv STIME           000000
#    setenv RUNLEN          240000
    setenv BNDY_CONC_1    "$OUTDIR/BCON_${VRSN}_${APPL}_${BCON_TYPE}_${DATE} -v"
 endif


# =====================================================================
#> Output File
# =====================================================================
 
#>- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

 if ( ! -d "$OUTDIR" ) mkdir -p $OUTDIR

 ls -l $BLD/$EXEC; size $BLD/$EXEC
 unlimit
 limit

#> Executable call:
 time $BLD/$EXEC

 exit() 
```
