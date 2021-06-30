#!/bin/bash 

echo  -e " $log_str :   executing $0  "


#yy=2018
opt="-O -L -f nc4 -z zip_3"

yy=$1 #2020
mm=$2 #04
dd=$3 #01

tstr=$yy$mm$dd"000000"
tstr2=$yy$mm$dd

echo  -e " $log_str :     Ploting  plot_icedrift_vel.py ...  "
$python_exec plot_icedrift_vel.py $data_dir/ice_drift_ensmean.$tstr2.nc $plot_dir/Plot_$tstr2

#  Commented  commands are for vector plot/product

for ptag in mod vect qual;do
#  Add georeferences  to tif-file step 1
echo  -e " $log_str :     Converting step 1  gdal_edit.py ...  "
gdal_edit.py -a_srs "epsg:3301" -a_ullr 250000 6750000 900000 6300000  $plot_dir/Plot_$tstr2'_'$ptag'_uv_LEST97.tif'
#gdal_edit.py -a_srs "epsg:3301" -a_ullr 250000 6750000 900000 6300000 $prod_dir/Plot_$tstr2'_vect_uv_LEST97.tif'

# Add georeferences  to tif-file  step 2
echo  -e " $log_str :     Converting step 2  gdalwarp ...  "
gdalwarp -overwrite  -t_srs "epsg:3301" -te 250000 6300000 900000 6750000 $plot_dir/Plot_$yy$mm$dd'_'$ptag'_uv_LEST97.tif' $plot_dir/Plot_gt_$tstr2'_'$ptag'_uv_LEST97.tif'
cp $plot_dir/Plot_gt_$yy$mm$dd'_'$ptag'_uv_LEST97.tif' $prod_dir/
#convert  $plot_dir/Plot_gt_$yy$mm$dd'_'$ptag'_uv_LEST97.tif'  tmp.$ptag.jpeg
done

#gdalwarp -overwrite  -t_srs "epsg:3301" -te 250000 6300000 900000 6750000 $plot_dir/Plot_$yy$mm$dd'_vect_uv_LEST97.tif' $plot_dir/Plot_gt_$tstr2'_vect_uv_LEST97.tif'

# Convert to jpeg2000
#echo -e  " $log_str :     Converting step 3  gdal_translate ...  "
#gdal_translate -of JP2OpenJPEG $plot_dir/Plot_gt_$tstr2'_mod_uv_LEST97.tif' $plot_dir/Plot_$tstr2'_mod_uv_LEST97.jp2'

# Copy & rename the plot into different folder
#cp $plot_dir/Plot_$tstr2'_mod_uv_LEST97.jp2' $prod_dir/Plot_moduv_LEST97.$tstr2'.jp2'
#cp $plot_dir/Plot_gt_$yy$mm$dd'_mod_uv_LEST97.tif' $prod_dir/
#cp $plot_dir/Plot_gt_$yy$mm$dd'_vect_uv_LEST97.tif' $prod_dir/
#cp $plot_dir/Plot_gt_$yy$mm$dd'_qual_uv_LEST97.tif' $prod_dir/

echo  -e  " $log_str :   qgis   $prod_dir/Plot_moduv_LEST97.$tstr2.jp2"


#gdal_translate -of JP2OpenJPEG $plot_dir/Plot_gt_$tstr2'_vect_uv_LEST97.tif' $plot_dir/Plot_$tstr2'_vect_uv_LEST97.jp2'




#done

