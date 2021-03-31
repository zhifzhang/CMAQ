# CMAQ Installation & Benchmarking Tutorial

Purpose: This guide describes how to install and run the CMAQ test case, which serves two different purposes. The first being to familiarize the user with the CMAQ suite of programs and how they work together, and secondly to verify the installation of the software on your system via benchmarking. 

Benchmarking refers to a simulation that is used to verify that the software is installed correctly.  Benchmarking CMAQ is recommended in the following circumstances:
- Installation by a new user
- Installation on a new server     
- Following kernel upgrades
- Following Fortran/C compiler upgrades
- Following netCDF or I/O API library upgrades

## System Checks 

The following support software are required for compiling and running CMAQ.  

1. Fortran and C compilers, e.g., [Intel](https://software.intel.com/en-us/fortran-compilers), [Portland Group](http://www.pgroup.com), [Gnu](https://gcc.gnu.org/wiki/GFortran)
2. [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
2. Message Passing Interface (MPI), e.g., [OpenMPI](https://www.open-mpi.org) or [MVAPICH2](http://www.mcs.anl.gov/research/projects/mpich2).
3. Latest release of [netCDF-C](https://www.unidata.ucar.edu/software/netcdf/docs/getting_and_building_netcdf.html) and [netCDF-Fortran](https://www.unidata.ucar.edu/software/netcdf/docs/building_netcdf_fortran.html) **built without netCDF4, HDF5, HDF4, DAP client, PnetCDF, or zlib support** 
4. [I/O API](https://www.cmascenter.org/download/software/ioapi/ioapi_3-2.cfm?DB=TRUE) version 3.2 **tagged 20200828**
(note: if you have not installed the above libraries, please see the CMAQ_UG_tutorial_build_[gcc/intel/pgi].md tutorials available here: 
https://github.com/USEPA/CMAQ/tree/master/DOCS/Users_Guide/Tutorials

The suggested hardware requirements for running the CMAQ Southeast Benchmark case on a Linux workstation are:

1. Linux environment with a 16 processors
2. 16 GB RAM
3. 400 GB hard drive storage

## Install CMAQ and Required Libraries 

In the directory where you would like to install CMAQ, create the directory issue the following command to clone the EPA GitHub repository for CMAQv5.3.2:

```
git clone -b master https://github.com/USEPA/CMAQ.git CMAQ_REPO
```

For instructions on installing CMAQ from Zip files, see [Chapter 5](../CMAQ_UG_ch05_running_a_simulation.md).

## Check Out a new Branch in the CMAQ Repository 

Checking out a new branch is a good idea even if you are not doing code development, per se. It is likely that you will want to retrieve new updates in the future, and an easy way to do this is through the master branch in the git repo. Thus, it is beneficial to leave it unperturbed if possible.
```
cd CMAQ_REPO
git checkout -b my_branch
```

## Configure the CMAQ build environment

The user has two options for building an environment. She or he may build and run CMAQ components directly in the repository structure (object files and executables will be ignored with .gitignore), or they may extract the build and run scripts out of the repository and work in a separate location. If you would like to build directly in the repository, skip to "Install the CMAQ Libraries" below.

### Build and run in a user-specified directory outside of the repository
In the top level of CMAQ_REPO, the bldit_project.csh script will automatically replicate the CMAQ folder structure and copy every build and run script out of the repository so that you may modify them freely without version control.

In bldit_project.csh, modify the variable $CMAQ_HOME to identify the folder that you would like to install the CMAQ package under. For example:
```
set CMAQ_HOME = /home/username/CMAQ_v5.3.2
```
Now execute the script.
```
./bldit_project.csh
```

## Link the CMAQ Libraries
The CMAQ build scripts require the following libraries and INCLUDE files to be available in the CMAQ_LIB directory (Note: the CMAQ_LIB gets set automatically by the config_cmaq.csh script, where `CMAQ_LIB = $CMAQ_HOME/lib`): 

- netCDF C library files are located in the `$CMAQ_LIB/netcdf/lib` directory
- netCDF Fortran library files are located in the `$CMAQ_LIB/netcdff/lib` directory
- I/O API library, include files and module files are located in the `$CMAQ_LIB/ioapi` directory
- MPI library and INCLUDE files are located in the `$CMAQ_LIB/mpi` directory

The config_cmaq.csh script will automatically link the required libraries into the CMAQ_LIB directory. Set the locations of the netCDF, I/O API, and MPI installations on your Linux system with the following config_cmaq.csh environment variables:

- `setenv IOAPI_INCL_DIR`: the location of the I/O API include header files on your system.
- `setenv IOAPI_LIB_DIR`: the location of compiled I/O API libraries on your system.
- `setenv NETCDF_LIB_DIR`: the location of the netCDF C library installation on your system.
- `setenv NETCDF_INCL_DIR`: the location of the netCDF C include files on your system.
- `setenv NETCDFF_LIB_DIR`: the location of the netCDF Fortran library installation on your system.
- `setenv NETCDFF_INCL_DIR`: the location of the netCDF Fortran include files on your system.
- `setenv MPI_LIB_DIR`: the location of the MPI (OpenMPI or MVAPICH) on your system.

For example, if your netCDF C libraries are installed in /usr/local/netcdf/lib, set `NETCDF_LIB_DIR` to /usr/local/netcdf/lib. Similarly, if your I/O API library is installed in /home/cmaq/ioapi/Linux2_x86_64gfort, set `IOAPI_LIB_DIR` to /home/cmaq/ioapi/Linux2_x86_64gfort. 

*1.* Check the names of the I/O API and netCDF libraries using the `ioapi_lib` and `netcdf_lib` script variables.

*2.* Check the name of the MPI library using the `mpi_lib` script variable. For MVAPICH use `-lmpich`; for openMPI use `-lmpi`.

Links to these libraries will automatically be created when you run any of the build or run scripts. To manually create these libraries (this is optional), execute the config_cmaq.csh script, identifying the compiler in the command line [intel | gcc | pgi]:
```
source config_cmaq.csh [compiler] 
```
You may also identify the version of the compiler if you wish it to be identified in build directory and executable names. This is optional. For example:
```
source config_cmaq.csh gcc 9.1
```

## Install the CMAQ input reference/benchmark data

Download the CMAQ two day reference data from the [CMAS Center Data Warehouse SE532BENCH](https://drive.google.com/drive/folders/1jAKw1EeEzxLSsmalMplNwYtUv08pwUYk?usp=sharing) Google Drive folder and copy to `$CMAQ_DATA`. Navigate to the `$CMAQ_DATA` directory, unzip and untar the two day benchmark input and output files:

```
cd $CMAQ_DATA
tar xvzf CMAQv5.3.2_Benchmark_2Day_Input.tar.gz
tar xvzf CMAQv5.3.2_Benchmark_2Day_Output_Optimized.tar.gz
tar xzvf CMAQv5.3.2_Benchmark_2Day_Output_Debug.tar.gz
```

The CMAQ benchmark test case is a two day simulation for July 1-2 2016 on a 100 column x 80 row x 35 layer 12-km resolution domain over the southeast U.S.  
- The benchmark data is also available form the US EPA annoymous ftp server: https://gaftp.epa.gov/exposure/CMAQ/V5_3_2/Benchmark/WRFv4.1.1-CMAQv5.3.2/
- Metadata for the CMAQ benchmark test case is posted on the CMAS Center Dataverse site: https://doi.org/10.15139/S3/IQVABD 

#### A note about differences in the v5.3+ and v5.3 benchmark data
Starting with CMAQv5.3.2, the benchmark data contains a grid mask file for the United States  GRIDMASK_STATES_12SE1.nc, and new input tar file, but the only difference for the input tar file is the gridmask file.  
The CMAQv5.3.2 output tar files are provided for the CMAQ-ISAM Benmark case, which includes the standard CMAQv5.3.2 output in addition to the new _SA_ output files.
For CMAQv5.3.1, the benchmark data for the July 2016 test case over the Southeast US provided both input and output files.
The CMAQv5.3.1 input datasets were identical to those released wtih v5.3 but additional files are now included in the .tar.gz files that will allow users to test the WRFv4.1.1-CMAQv5.3+ coupled model on the Southeast US benchmark domain. As a result, there is no need for users who have already downloaded the v5.3 Southeast benchmark input data to download the v5.3+ files unless they are planning to run the coupled model.  The Southeast benchmark output data for v5.3.2 is slightly different from what was released with v5.3.1 and v5.3 as described in the [CMAQv5.3.2 Release Notes FAQ](../../Release_Notes/CMAQ_FAQ.md).


## Compiling CMAQ

*Before proceeding, it should be noted that building the ICON and BCON executables are optional steps when working specifically with the benchmark data. This is because the initial condition and boundary condition files have been provided for you within the benchmark data set. For further information on these preprocessors please reference [Chapter 4](../CMAQ_UG_ch04_model_inputs.md).*   

Create the model executables for CCTM using the steps shown below. 

##### Configuration for multi-processor runs (default):

```
set ParOpt #>  Option for MPI Runs
````

##### Configuration for single-processor runs (optional):

For single-processor computing, edit the CCTM build script (bldit_cctm.csh) to indicate a single-processor run by commenting out set ParOpt as shown below. 

```
#set ParOpt #> Option for Single Processor Runs
````

#### Configure CMAQ benchmark Science Modules:

The build directory parameters for the benchmark test case include the following:

-   Multiprocessor simulation 
-   3-D Advection Scheme: wrf_cons
-   Horizontal diffusion: Multiscale
-   Vertical diffusion: ACM2_M3Dry
-   Deposition: M3Dry
-   Chemistry solver: EBI
-   Aerosol module: AERO7
-   Cloud module: ACM_AE7
-   Mechanism: cb6r3_ae7_aq
-   Online biogenic emissions
-   Inline plume rise

To configure these parameters, the CCTM Science Modules within the bldit_cctm.csh need to be set. The comments within the script itself should help guide the user on the options for each variable and how to set them. Further information on variable names can be found in 
[Appendix A](../Appendix/CMAQ_UG_appendixA_model_options.md).

Following the requisite changes to the CCTM build script, use the following command to create the CCTM executable: 

```
cd $CMAQ_HOME/CCTM/scripts
./bldit_cctm.csh [compiler] [version] |& tee bldit.cctm.log
```

## Configure the CCTM script 

For an MPI configuration with 16 processors,

```
cd $CMAQ_HOME/CCTM/scripts
```

Edit the CCTM run script (run_cctm_Bench_2016_12SE1.csh) for the MPI configuration and compiler that you will use:

```
setenv compiler gcc
setenv compilerVrsn 9.1
setenv INPDIR  ${CMAQ_DATA}/CMAQv5.3.2_Benchmark_2Day_Input
@ NPCOL 4 ; @ NPROW = 4
```

Most clustered multiprocessor systems require a command to start the MPI run-time environment. The default CCTM run script uses the *mpirun* command. Consult your system administrator to find out how to invoke MPI when running multiprocessor applications.

For single-processor computing, set PROC to serial:

```
set PROC     = serial
```

CCTM Science Configuration Options set to **Y** in the RunScript for the benchmark case include the following: 

-  ```CTM_OCEAN_CHEM``` - use ocean halgoen chemistry and sea spray aerosol emissions
-  ```KZMIN``` - minimum eddy diffusivity in each grid cell determined by land use fraction
-  ```PX_VERSION``` - WRF PX land surface model 
-  ```CTM_ABFLUX``` - bidirectional ammonia flux for online deposition velocities
-  ```CTM_BIDI_FERT_NH3``` - subtract fertilizer NH3 from emissions because it will be handled by the BiDi calculation
-  ```CTM_SFC_HONO``` - surface HONO interaction
-  ```CTM_GRAV_SETL``` - vdiff aerosol gravitational sedmentation
-  ```CTM_BIOGEMIS``` - online biogenic emissions

To configure these parameters, the Science Options within the $CMAQ_HOME/CCTM/scripts/run_cctm_Bench_2016_12SE1.csh need to be set. The comments within the script itself should help guide the user on the options for each variable and how to set them. Further information on variable names can be found in 
[Appendix A](../Appendix/CMAQ_UG_appendixA_model_options.md).

After configuring the MPI settings for your Linux system, check the rest of the script to ensure the correct path, date and names are used for the input data files. Per the note above, different Linux systems have different requirements for submitting MPI jobs.  The command below is an example of how to submit the CCTM run script and may differ depending on the MPI requirements of your Linux system. 

```
./run_cctm_Bench_2016_12SE1.csh |& tee cctm.log
```

## Confirm that the Benchmark Simulation Completed

To confirm that the benchmark case ran to completion view the run.benchmark.log file. For MPI runs, check each of the CTM_LOG_[ProcessorID]*.log files. A successful run will contain the following line at the bottom of the log(s):

``>>---->  Program completed successfully  <----<<``

Note: If you are running on multiple processors the log file for each processor is also moved from the $CMAQ_HOME/CCTM/scripts directory to the benchmark output directory: 

```
$CMAQ_DATA/output_CCTM_v532_[compiler]_Bench_2016_12SE1
```
and these log files have the name convention: 

```
CTM_LOG_[ProcessorID].v532_[compiler]_[APPL]_[YYYYMMDD]
CTM_LOG_[ProcessorID].v532_gcc_Bench_2016_12SE1_20160701
```

The benchmark output results will have been placed in the directory: 

```
$CMAQ_DATA/output_CCTM_v532_[compiler]_Bench_2016_12SE1
```

and can include upto 23 netCDF-type files: ACONC, AOD_DIAG, APMDIAG, APMVIS, B3GTS_S, CGRID, CONC, DEPV, DRYDEP, DUSTEMIS, LTNGCOL, LTNGHRLY, MEDIA_CONC, PHOTDIAG1, PHOTDIAG2, PMDIAG, PMVIS, SOILOUT, SSEMIS, VDIFF, VSED, WETDEP1, and WETDEP2.


Common errors in a CCTM simulation include the following:
- Incorrect paths to input files. Look in the CCTM screen output (capture in your log file) for an Error message about an input file not being found.  
- Incorrect MPI implementation. A series of MPI errors at the end of the log file often indicate that the MPI job was not submitted correctly.   

Check the last few lines of the CCTM output log for messages to help diagnose why the simulation did not complete.

## Check the CMAQ Benchmark Results

To determine if CMAQ is correctly installed on your Linux system compare the results from your benchmark simulation to the reference output data downloaded from the CMAS Center. This data was generated on a Linux system with the following specifications:
- Linux Kernel 3.10.0-514.el7.x86_64
- Red Hat Enterprise Linux Server 7.3 (Maipo) (use command: cat /etc/os-release)
- GNU GCC compiler version 9.1.0, 16 processors with OpenMPIv4.0.1 and I/O APIv3.2 tagged version 20200828
- Debug mode turned off (```set Debug_CCTM``` commented out in $CMAQ_HOME/CCTM/scripts/bldit_cctm.csh)
- Debug mode turned on  (```set Debug_CCTM``` uncommented in $CMAQ_HOME/CCTM/scripts/bldit_cctm.csh)
- CMAQv5.3.2

CMAQv.5.3.2 output for a two day benchmark case is provided for both the debug mode turned off (Optimized) and the debug mode turned on (Debug) version to allow the user to compare their answers to either. To reduce the impact of compiler flags on the model output, it is preferable to use the debug version. To compare model results obtained while achieving faster run times due to compiler optimization, the Optimized version output is also provided.

The CMAQv5.3.2 reference output data includes a set of CCTM_ACONC_\*.nc files with layer 1 average model species concentrations for each model hour for 226 variables and a set of CCTM_WETDEP1_\*.nc files with cumulative hourly wet deposition fluxes for an additional 136 variables. The CCTM_SA_ACONC_\*.nc, CCTM_SA_CGRID_\*.nc, CCTM_SA_CONC_\*.nc, CCTM_SA_WETDEP_\*.nc and CCTM_SA_DRYDEP_\*.nc are generated when you run the CMAQ-ISAM benchmark. See the [CMAQ-ISAM Tutorial](../Tutorials/CMAQ_UG_tutorial_ISAM.md) for more information.

Use your netCDF evaluation tool of choice to evaluate your benchmark results. For example, [VERDI](https://www.verdi-tool.org/) is a visualization tool to view CCTM results as tile plots. Statistical comparison of the results can be made with the I/O API Tools or R. 

Note, even with a successful installation and run of the benchmark case, some differences between your simulation and the reference data can occur due to differences in domain decomposition for multi-processor simulations as well as differences in compiler.  These differences tend to manifest in upper layers of the model and are mostly found in predicting aerosol water (AH2O) and aerosol acidity (AH3OP), while differences are smaller for other key species like ASO4, ANO3, ACL, ALOO1, etc. These species have short atmospheric lifetimes with large changes in time and space derivatives or have model physics sensitive to small changes in concentration. Predicting these species is more sensitivity to small changes in machine precision and accuracy.

