#!/bin/bash
[[ -n "${0}" ]] || { echo -e "\n### Usage ###\n./TargetForwardSimulation \n"; exit 0 ; }

# pass parameter files
source parameter

# local id (from 0 to $ntasks-1)
if [ $system == 'slurm' ]; then
    iproc=$SLURM_PROCID  
elif [ $system == 'pbs' ]; then
    iproc=$PBS_VNODENUM
fi

IPROC_WORKING_DIR=$( seq --format="$WORKING_DIR/%06.f/" $iproc $iproc ) # working directory (on local nodes, where specfem runs)
IPROC_DATA_DIR=$( seq --format="$DATA_DIR/%06.f/" $iproc $iproc )
rm -rf $IPROC_WORKING_DIR
mkdir -p $IPROC_WORKING_DIR

cd $IPROC_WORKING_DIR

##echo "####### copy executables & input files ######"
cp -r $SUBMIT_DIR/bin ./
cp -r $SUBMIT_DIR/DATA ./
#cp -r $SUBMIT_DIR/parameter ./

if [ $Wscale -gt 0 ]; then 
cp -r $wavelet_path ./
fi

cp -r $SUBMIT_DIR/SU_process ./

mkdir -p DATA_obs DATA_syn OUTPUT_FILES SEM

# Source location
export xs=$(awk -v "line=$(($iproc+1))" 'NR==line { print $1 }' DATA/sources.dat)
export zs=$(awk -v "line=$(($iproc+1))" 'NR==line { print $2 }' DATA/sources.dat)

if $DISPLAY_DETAILS ; then
echo "source $(($iproc+1)) -- location xs=$xs zs=$zs"
fi
### echo " edit SOURCE "
   FILE="./DATA/SOURCE"
   sed -e "s/^xs.*$/xs =    $xs/g" $FILE > temp;  mv temp $FILE
   sed -e "s/^zs.*$/zs =    $zs/g" $FILE > temp;  mv temp $FILE
   sed -e "s/^time_function_type.*$/time_function_type = ${time_function_type} /g" $FILE > temp;  mv temp $FILE
   sed -e "s/^f0.*$/f0 =    $f0/g" $FILE > temp;  mv temp $FILE
   sed -e "s/^factor.*$/factor =    $amp_factor/g" $FILE > temp;  mv temp $FILE

##### edit 'Par_file' #####
   FILE="./DATA/Par_file"
   sed -e "s#^SIMULATION_TYPE.*#SIMULATION_TYPE = 1 #g"  $FILE > temp; mv temp $FILE
   sed -e "s#^SAVE_FORWARD.*#SAVE_FORWARD = .false. #g"  $FILE > temp; mv temp $FILE
   sed -e "s/^nt.*$/nt =    $NSTEP/g" $FILE > temp;  mv temp $FILE
   sed -e "s/^deltat.*$/deltat =    $deltat/g" $FILE > temp;  mv temp $FILE
   sed -e "s#^USER_T0.*#USER_T0 = $t0 #g"  $FILE > temp; mv temp $FILE
   sed -e "s#^SU_FORMAT.*#SU_FORMAT = .true.#g"  $FILE > temp; mv temp $FILE

if  $ExistDATA; then
if [ $iproc -eq 0 ]; then
echo
echo " Use exisiting data ..."
echo
fi
# edit on how you copy your data
# synthetic test
cp -r $IPROC_DATA_DIR/*  DATA_obs/

# process & stores output (design its own process flow for different data)
  if ${XCOMP}; then
  sh  ./SU_process/data_process.sh DATA_obs/Ux_file_single.su DATA_obs/Ux_file_single_processed.su
  fi
  if ${YCOMP}; then
  sh ./SU_process/data_process.sh DATA_obs/Uy_file_single.su DATA_obs/Uy_file_single_processed.su
  fi
  if ${ZCOMP}; then
  sh ./SU_process/data_process.sh DATA_obs/Uz_file_single.su DATA_obs/Uz_file_single_processed.su
  fi
  if ${PCOMP}; then
  sh ./SU_process/data_process.sh DATA_obs/Up_file_single.su DATA_obs/Up_file_single_processed.su
  fi


else # self-generated data

if [ $iproc -eq 0 ]; then
echo
echo "  Generate DATA using SPECFEM  ..."
echo
fi

## echo " link target model ..."
   cp $target_velocity_file  ./DATA/model_velocity.dat
   if $attenuation; then
   cp $target_attenuation_file ./DATA/model_attenuation.dat
   fi
   if $anisotropy; then
   cp $target_anisotropy_file ./DATA/model_anisotropy.dat
   fi
   ./bin/prepare_model.exe

   # cleans output files
   rm -rf ./OUTPUT_FILES/*
   ##### stores setup
   cp ./DATA/Par_file ./OUTPUT_FILES/
   cp ./DATA/SOURCE ./OUTPUT_FILES/

   ##### forward simulation (data) #####
   ./bin/xmeshfem2D > OUTPUT_FILES/output_mesher.txt
   ./bin/xspecfem2D > OUTPUT_FILES/output_solver.txt

# save
  cp OUTPUT_FILES/*_file_single.su            DATA_obs/
  #mkdir -p $IPROC_DATA_DIR
  #cp -r DATA_obs/* $IPROC_DATA_DIR/

# process & stores output (use the process flow for syn)
  if ${XCOMP}; then
  sh ./SU_process/syn_process.sh DATA_obs/Ux_file_single.su DATA_obs/Ux_file_single_processed.su
  fi
  if ${YCOMP}; then  
  sh ./SU_process/syn_process.sh DATA_obs/Uy_file_single.su DATA_obs/Uy_file_single_processed.su
  fi
  if ${ZCOMP}; then
  sh ./SU_process/syn_process.sh DATA_obs/Uz_file_single.su DATA_obs/Uz_file_single_processed.su
  fi
  if ${PCOMP}; then
  sh ./SU_process/syn_process.sh DATA_obs/Up_file_single.su DATA_obs/Up_file_single_processed.su
  fi

    
fi # exist data

