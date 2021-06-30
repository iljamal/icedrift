#!/bin/bash

# Color definitions
RED='\033[0;31m' # RED
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

      echo -e "${YELLOW} >> conf. icedrift ${NC} configure file from  '$1'" 

## local config as command line input
# Check if file exists
if [ ! -f "$1" ]; then    echo -e " ${RED} ERROR: '$1' does not exist.  ${NC}";    exit
fi

## READ  USER  configuation
source $1

# Check if variables are non-empty and wether the executables exist
if [[ -z ${cmems_user} ]] ; 
then     echo -e " ${RED} ERROR: 'cmems_user' variable is empty. Check your configuration in $1  ${NC}";exit; fi

if [[ -z ${cdo_exec} ]] ; 
then    echo -e " ${RED} ERROR: 'cdo_exec' variable is empty. Check your configuration in $1  ${NC}";exit
else    if ! command -v ${cdo_exec} &> /dev/null; then 	    echo -e " ${RED} ERROR: ${cdo_exec}   could not be found ${NC}";     exit;    fi
fi

if [[ -z ${python_exec} ]] ; 
then    echo -e " ${RED} ERROR: 'python_exec' variable is empty. Check your configuration in $1  ${NC}";exit; 
else    if ! command -v ${python_exec} &> /dev/null; then 	    echo -e " ${RED} ERROR: ${python_exec}   could not be found${NC}";     exit;    fi
fi

if [[ -z ${ncdump_exec} ]] ; 
then    echo -e " ${RED} ERROR: 'ncdump_exec' variable is empty. Check your configuration in $1  ${NC}";exit; # fi
else    if ! command -v ${ncdump_exec} &> /dev/null; then 	    echo -e "  ${RED} ERROR:  ${ncdump_exec}   could not be found${NC}";     exit;    fi
fi
# TODO do some more checks ...
#export gdal_exec=
echo -e "${GREEN} >>     config done ...  ${NC}"

cd $icedrift_dir
#Create directories 
echo -e "${GREEN} >>     creating directories ${NC}"

mkdir -p $icedrift_dir $raw_dir $plot_dir $data_dir  $prod_dir

##  LOG variables
rm log.*

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
if [[ -z ${yy_in} ]] ; then     echo -e " ${RED} ERROR: 'yy_in' variable is empty. Check your configuration in $1  ${NC}";exit
fi
# yy_in=2021
# mm_in=02
# dd_in=16

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







