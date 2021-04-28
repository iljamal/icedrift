#!/bin/bash 

echo -e " $log_str :   executing $0  "

#yy=2018
opt="-O -L -f nc4 -z zip_3"

yy=$1 #2020
mm=$2 #04
dd=$3 #01
cdo=$cdo_exec
tstr=$yy$mm$dd"000000"
tstr2=$yy$mm$dd


flist=`ls $raw_dir/nrt.cmems-du.eu/Core/SEAICE_BAL_SEAICE_L4_NRT_OBSERVATIONS_011_011/FMI-BAL-SEAICE_DRIFT-SAR-NRT-OBS/$yy/$mm/ice_drift_baltic_$yy*_$yy$mm$dd*`
if [ -z "$flist" ]; then echo -e " ${ER_C} file list of patches is empty ";echo "1" > $ICD_EXIT_STATUS ;
else 
echo  -e  " $log_str :  flist is not empty" 
#echo -e " $log_str  : flist is " $flist
fi
#exit

ni=0
for file in $flist;do 
  let ni++
  echo "      *** patch $ni"
  echo "         data from file  $file "  
  #file=nrt.cmems-du.eu/Core/SEAICE_BAL_SEAICE_L4_NRT_OBSERVATIONS_011_011/FMI-BAL-SEAICE_DRIFT-SAR-NRT-OBS/2021/03/ice_drift_baltic_20210301045644_20210301045644.nc
  #t1=`cdo showattsglob $file `
  #t2=`cdo showattsglob $file | grep stop_date`

  t1=`ncdump -h  $file | grep start_date | tr -d "\t" |tr -d " "`
  t2=`ncdump -h  $file | grep stop_date | tr -d "\t" |tr -d " "`
  eval ${t1:1}
  eval ${t2:1}
  #eval "$t1"
  #eval "$t2"

#  echo $start_date
#  date -d$start_date "+%s"
#  echo $stop_date
#  date -d$stop_date "+%s"
  ts1=$(date -d$start_date "+%s")
  ts2=$(date -d$stop_date "+%s")
  dx_str=sea_ice_x_displacement
  dy_str=sea_ice_y_displacement
  qstr=ice_drift_quality
  dts=$(($ts2-$ts1))
  echo  "       t1:$start_date ,$ts1 ; t2:$stop_date ,$ts2 "

# Calculate the velocity components (idu, idv); moving average over 3x3 box  
  $cdo_exec $opt smooth9 -remapbil,ice_grid.dat -expr,"idu=$dx_str/$dts;idv=$dy_str/$dts;t1=$ts1+0*$dx_str;t2=$ts2+0*$dx_str;qual=$qstr"   $file   $data_dir/ice_drift_patches.$yy$mm$dd.$ni.nc
  
  #cdo $opt remapbil,ice_grid.dat -expr,"idu=$dx_str/$dts;idv=$dy_str/$dts;t1=$ts1+0*$dx_str;t2=$ts1+0*$dx_str;qual=$qstr"   $file   $data_dir/ice_drift_times.$yy$mm$dd.$ni.nc

done
echo -e " $log_str  :    calculating data from $ni files across the Baltic Sea" 
#  Mean velocity over the all patches

$cdo_exec -O -L -f nc2 ensmean $data_dir/ice_drift_patches.$tstr2.*.nc  $data_dir/ice_drift_ensmean.$tstr2.nc
$cdo_exec -O -L -f nc2 expr,"id_mod=sqrt(idu*idu+idv*idv)"  $data_dir/ice_drift_ensmean.$tstr2.nc  $data_dir/ice_drift_mod.$tstr2.nc

echo  -e  " $log_str :  data  ready in $data_dir/"
echo  -e  " $log_str :   ncview  $data_dir/ice_drift_ensmean.$tstr2.nc"
echo  -e  " $log_str :   qgis  $data_dir/ice_drift_mod.$tstr2.nc"



