#!/bin/bash 

echo " $log_str :	executing $0  $1 $2 $3 " 

yy=$1
mm=$2
dd=$3
tstr=$yy$mm$dd
#echo 'check2: ' `cat $ICD_EXIT_STATUS`

#exit
# DOWNLOAD data from CMEMS  
./get_data_ICEDRIFT.sh $yy $mm $dd #    >> log.icedrift.download  2>&1
if [ `cat $ICD_EXIT_STATUS` == 1 ]; then echo -e "${ER_C} $log_str aborting due to ICD_EXIT_STATUS=1 at @f:$0 l:$LINENO"; exit;fi

# CALCULATE icedrift data (cdo, NetCDF)
./do_calc_ICEDRIFT.sh $yy $mm $dd
if [ `cat $ICD_EXIT_STATUS` == 1 ]; then echo -e "${ER_C} $log_str aborting due to ICD_EXIT_STATUS=1 at @f:$0 l:$LINENO"; exit;fi

# PLOT icedrift data	(python, gdal, GeoTIFF, JP2)
./do_plot_ICEDRIFT.sh $yy $mm $dd
if [ `cat $ICD_EXIT_STATUS` == 1 ]; then echo -e "${ER_C} $log_str aborting due to ICD_EXIT_STATUS=1 at @f:$0 l:$LINENO"; exit;fi


# TODO  cleanup 
# rm -r $raw_dir/*$tstr*
# rm -r $data_dir/*$tstr*
# rm $data_dir/ice_drift_patches.*
# rm -r $plot_dir/*$tstr*
# CHECK for the whole bs
#qgis $data_dir/ice_drift_mod.$tstr2.nc

exit
