#!/bin/bash

      echo -e "${GREEN} >> conf. icedrift ${NC}" 

## local config
##  MY LIBRARIES

## if Initiate for crontab execution  set those custom path for hdf/netcdf and cdo libraries
#export PATH=$HOME/libs/bin/:$PATH
#export LD_LIBRARY_PATH=$HOME/libs/lib:${LD_LIBRARY_PATH}
#export LD_RUN_PATH=$HOME/libs/lib:${LD_LIBRARY_PATH}
#HDFDIR=$HOME/libs/HDF5-1.12.0-Linux/HDF_Group/HDF5/1.12.0/
#export LD_LIBRARY_PATH=$HDFDIR/lib:${LD_LIBRARY_PATH}
#export LD_RUN_PATH=$HDFDIR/lib:${LD_RUN_PATH}
#export PATH=$HDFDIR/bin/:$PATH

export python_exec=python3
export cdo_exec=cdo 
export ncdump_exec=ncdump 
# TODO test if executables are working

# COPERNICUS username  and password
export cmems_user=jizotova
export cmems_pasw=wVMMfa91

export icedrift_dir=$HOME/icedrift

export plot_dir=$icedrift_dir/icedrift_plot

export raw_dir=$icedrift_dir/icedrift_raw

export data_dir=$icedrift_dir/icedrift_data

export prod_dir=$icedrift_dir/icedrift_product

export run_mode=ser # op:current date or ser:date according to given date (see below)

export date_mode=stop  # start:date1 as ref;  stop:date2 as ref      

#  gdal_edit.py  gdalwarp gdal_translate  -  make sure you have those commands 
#export gdal_exec=

cd $icedrift_dir
ls
# TODO check if executables are working 
#Create directories 
echo -e "${GREEN} >>     creating directories ${NC}"

mkdir -p $icedrift_dir $raw_dir $plot_dir $data_dir  $prod_dir

##  LOG variables
rm log.*
RED='\033[0;31m' # RED
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

export log_str="  ~ "
export log_str_c=" ${GREEN} ~ "
export ER_C="$RED !  $NC"
log_line="---------------"
mkdir $icedrift_dir/logs/
export ICD_EXIT_STATUS="log.icd_exit_status.txt"
echo "0" > $ICD_EXIT_STATUS
#echo ' check1: ' `cat $ICD_EXIT_STATUS`


##  Date calc 
case $run_mode in
"ser")
echo -e "${GREEN}  runmode:  $run_mode  ${NC} "

 yy_in=2021
 mm_in=02
 dd_in=16

  dte="$yy_in-$mm_in-$dd_in"                      # input date
  sdte=`date --date "$dte" +"%Y-%m-%d"`;;          # new date
"op")
echo -e "${GREEN}  runmode:  $run_mode  ${NC} "
  sdte=`date +"%Y-%m-%d"`;;          # new date
esac


  yy=`date +'%Y' -d$sdte`                     #  formating
  mm=`date +'%m' -d$sdte`
  dd=`date +'%d' -d$sdte`
log_file="log.icedrift_$yy.$mm.$dd.txt"

#

#cd $icedrift_dir
echo -e "${GREEN} >> start of update icedrift ${NC}"
echo -e "${YELLOW} $log_str : runing  icedrift update for $dd-$mm-$yy $NC" 
echo -e "${YELLOW} $log_str :     at  $icedrift_dir $NC" 

  ./run_icedrift.sh $yy $mm $dd     >> $log_file  2>&1

#echo "$log_line " \n "     Summary" \n "$log_line"   
grep $log_str $log_file
echo "$log_line  "


echo -e "${GREEN} >>  end of update ${NC}"
mv $log_file $icedrift_dir/logs/
exit







