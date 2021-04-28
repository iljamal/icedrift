#!/bin/bash 

echo -e  " $log_str :   executing $0  "

opt="-O -L -f nc4 -z zip_3"

yy=$1 #2020
mm=$2 #04
dd=$3 #01

tstr=$yy$mm$dd"000000"
tstr2=$yy$mm$dd

#    ice_drift_baltic_20210305045622_20210305161340.nc
file="ice_drift_baltic_"$yy$mm$dd* #"20210305045622_20210305161340.nc
link="ftp://nrt.cmems-du.eu/Core/SEAICE_BAL_SEAICE_L4_NRT_OBSERVATIONS_011_011/FMI-BAL-SEAICE_DRIFT-SAR-NRT-OBS/$yy/$mm/"
#ftp://nrt.cmems-du.eu/Core/SEAICE_BAL_SEAICE_L4_NRT_OBSERVATIONS_011_011/FMI-BAL-SEAICE_DRIFT-SAR-NRT-OBS/2021/03/ice_drift_baltic_20210305045622_20210305161340.nc


echo -e  " $log_str :	downloading pattern 'ice_drift_baltic_$yy$mm$dd*.nc  "
echo -e  " $log_str :	from  "
echo  -e " $log_str :	 $link  " 

# TODO  check if available
# if data not available reite log, ICD_EXIT_STATUS=1  and exit

case $date_mode in
"start")
echo -e  " $log_str :  date_mode:$date_mode "
#  yy,mm,dd  is START day   
wget  -P $raw_dir -r -A 'ice_drift_baltic_'$yy$mm$dd'*.nc' --user "$cmems_user" --password "$cmems_pasw" $link;;
"stop")
echo -e  " $log_str :  date_mode:$date_mode "

#  yy,mm,dd  is STOP day
wget  -P $raw_dir -r -A 'ice_drift_baltic_'$yy'*_'$yy$mm$dd'*.nc' --user "$cmems_user" --password "$cmems_pasw" $link;;
esac
#echo wget  -P $raw_dir -r -A 'ice_drift_baltic_'$yy$mm$dd'*.nc' --user "$cmems_user" --password "$cmems_pasw" $link
# TODO  check data
# if data corrupted  write log, ICD_EXIT_STATUS=1

exit

