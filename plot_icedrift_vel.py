#!/bin/python
import sys
import matplotlib as mpl
import matplotlib.pylab as plt
from netCDF4 import Dataset
import numpy as np
from mpl_toolkits.basemap import Basemap
from pyproj import Proj, transform
import gdal
import osr

mpl.use('Agg')
mpl.rcParams['font.size']=20;


file_name=str(sys.argv[1])
figure_out=str(sys.argv[2])

#varname_u=str(sys.argv[2])
#varname_v=str(sys.argv[3])



ncin=Dataset(file_name);
#dimnames=ncin.dimensions.keys()
#print(dimnames)
#for i in range(len(dimnames)):
#  print(dimnames[i])
#  if ('lon' in dimnames[i]): lon_name=dimnames[i] ;
#  if ('lat' in dimnames[i]): lat_name=dimnames[i] ;
varname_u='idu'
varname_v='idv'
lon_name='lon'
lat_name='lat'
lon=ncin.variables[lon_name][:];
lat=ncin.variables[lat_name][:];
u=np.squeeze(ncin.variables[varname_u][:]);
v=np.squeeze(ncin.variables[varname_v][:]);
qual=np.squeeze(ncin.variables['qual'][:]);

#  from scipy import ndimage
#u_sm=ndimage.median_filter(u, size=20)
#v_sm=ndimage.median_filter(v, size=20)

vel=np.sqrt(u*u+v*v);
ncin.close();


ncinb=Dataset('topo_bsbd.nc');
bath=ncinb.variables['bathymetry'][:];
lonb=ncinb.variables['lon_T'][:];
latb=ncinb.variables['lat_T'][:];
ncinb.close();

mask=bath*0.;
mask[:,:]=0.
mask[bath>1.]=1.;

qualf=qual;
qualf[qual<0.1]=np.NaN;
print( u.shape)

dc=5
lon_p=lon[::dc]
lat_p=lat[::dc]
u_p=u[::dc,::dc]
v_p=v[::dc,::dc]
vel_p=np.sqrt(u_p*u_p+v_p*v_p);
#lon_length=lon.shape;
#s=3.*15./lon_length;




inProj = Proj(init='epsg:4326')
outProj = Proj(init='epsg:3301')
x1,y1 = 24.5,60.2
x2,y2 = transform(inProj,outProj,x1,y1)
print( x2,y2)

lonb2,latb2 = np.meshgrid(lonb, latb)
lonbx2,latbx2 = transform(inProj,outProj,lonb2,latb2)



lon2,lat2 = np.meshgrid(lon, lat)
lonx2,latx2 = transform(inProj,outProj,lon2,lat2)

fig=plt.figure(figsize=(15,12));
ax=fig.add_subplot(111);
ax.contour(lonbx2, latbx2, mask,levels=[0.5],  colors=[(0.5,0.5,0.5) ],alpha=0.2)
#p0=ax.quiver(xx, yy, uproj,vproj,scale=50)
p0=ax.pcolor(lonx2, latx2, vel,vmin=0,vmax=0.2)


ax.set_xlim([250000, 900000]);
ax.set_ylim([6300000, 6750000]);
cbaxes = fig.add_axes([0.75, 0.13, 0.03, 0.3]) 
cbl=plt.colorbar(p0,cmap=plt.cm.PuBu,cax=cbaxes)
cbl.set_label('Ice drift velocity [m/s]')
#fig.savefig(figure_out+'_mod_uv_LEST97.png')
#plt.axis('off')
ax.set_axis_off()
fig.savefig(figure_out+'_mod_uv_LEST97.tif',bbox_inches='tight')
#add: from PIL import Image
#Image.open(figure_out+'_mod_uv_LEST97.png').save(figure_out+'_mod_uv_LEST97.j2k')


fig=plt.figure(figsize=(15,12));
ax=fig.add_subplot(111);
ax.contour(lonbx2, latbx2, mask,levels=[0.5],  colors=[(0.5,0.5,0.5) ],alpha=0.2)
#p0=ax.quiver(xx, yy, uproj,vproj,scale=50)
p0=ax.pcolor(lonx2, latx2, qualf,vmin=0,vmax=100)
ax.set_xlim([250000, 900000]);
ax.set_ylim([6300000, 6750000]);
cbaxes = fig.add_axes([0.75, 0.13, 0.03, 0.3]) 
cbl=plt.colorbar(p0,cmap=plt.cm.PuBu,cax=cbaxes)
cbl.set_label('Ice drift quality [%]')
fig.savefig(figure_out+'_qual_uv_LEST97.png')



#gdal_translate  -gcp 200 200 250000 6300000 test.j2k test2.j2k

lonp2,latp2 = np.meshgrid(lon_p, lat_p)
lonpx2,latpx2 = transform(inProj,outProj,lonp2,latp2)

fig=plt.figure(figsize=(15,12));
ax=fig.add_subplot(111);
ax.contour(lonbx2, latbx2, mask,levels=[0.5], colors=[(0.5,0.5,0.5) ],alpha=0.2)
ax.contour(lonx2, latx2, qualf,levels=[30], colors=[(0.5,0.,0.5) ],alpha=0.2)

p0=ax.quiver(lonpx2,latpx2, u_p/vel_p,v_p/vel_p,vel_p,cmap=plt.cm.Blues,scale=50,clim=(-0.2, 0.2))
#p0=ax.pcolor(lonx2, latx2, vel,vmin=0,vmax=0.2)
#cbaxes = fig.add_axes([0.75, 0.13, 0.03, 0.3]) 
#cbl=plt.colorbar(p0,cmap=plt.cm.PuBu,cax=cbaxes)
#cbl.set_label('Ice drift velocity [m/s]')
#cbl.set_clim(.0, .2)

ax.set_xlim([ 250000,  900000]);
ax.set_ylim([6300000, 6750000]);
#plt.set_clim(self, vmin=0., vmax=0.2)

ax.set_axis_off()
fig.savefig(figure_out+'_vect_uv_LEST97.tif',bbox_inches='tight')
#fig.savefig(figure_out+'_vect_uv_LEST97.png')
fig.savefig(figure_out+'_vect_uv_LEST97.tif')

#add: from PIL import Image
#Image.open(figure_out+'_vect_uv_LEST97.png').save(figure_out+'_vect_uv_LEST97.j2k')

exit()




fig=plt.figure(figsize=(15,15));
ax=fig.add_subplot(111);
#map = Basemap(projection='tmerc', resolution='i',
#              lat_0=58, lon_0=23,
#              llcrnrlon=9., 
#              llcrnrlat=53., 
#              urcrnrlon=33., 
#              urcrnrlat=66.)
#map.drawcoastlines()

#uproj,vproj,xx,yy = map.transform_vector(\
#        u_p,v_p,lon_p,lat_p,5,10,returnxy=True,masked=False)
#p0=ax.quiver(xx, yy, uproj,vproj,scale=50)

#p0=ax.pcolor(lon_p, lat_p, vel_p,vmin=0,vmax=1000)

#p1=ax.quiver(lon_p, lat_p, u_p/vel_p,v_p/vel_p,scale=50,cmap=plt.cm.jet)
#p2=ax.quiver(lon_p, lat_p, u_p/vel_p,v_p/vel_p,vel_p,alpha=0.5,scale=50)
#plt.colorbar(p1, cmap=plt.cm.jet)

map = Basemap( llcrnrlon=9.7, llcrnrlat=53., urcrnrlon=32.1, urcrnrlat=66, resolution='i', \
              projection='lcc', lat_1=60., lat_2=67., lat_0=58, lon_0=23)
lon2, lat2 = np.meshgrid(lon_p, lat_p)
x, y = map(lon2, lat2)
#yy = np.arange(0, y.shape[0], 4)
#xx = np.arange(0, x.shape[1], 4)
#points = np.meshgrid(yy, xx)


#, vel_p
map.quiver(x, y, 
    u_p/vel_p, v_p/vel_p,scale=1/0.01, 
    cmap=plt.cm.jet,width=0.001,headwidth=5)
#map.drawmapboundary(fill_color='w')
#map.fillcontinents(color='green', lake_color='w', zorder = 0)
map.drawcoastlines(color = '0.85')

#map.quiver(x[points], y[points], 
#    u[points], v[points], vel_p[points],
#    cmap=plt.cm.autumn)

fig.savefig(figure_out+'_vect_uv.png')



fig2=plt.figure(figsize=(15,15));
ax=fig2.add_subplot(111);
#p1=ax.pcolor(lon, lat, vel,vmin=0,vmax=1000,shading='auto')
#p2=ax.streamplot(lon, lat, u,v, density=2, color='b', linewidth=1)
map = Basemap(llcrnrlon=9.7, llcrnrlat=53., urcrnrlon=32.1, urcrnrlat=66, resolution='i', \
              projection='lcc', lat_1=60., lat_2=67., lat_0=58, lon_0=23)
map.drawcoastlines(color = '0.85')

dc=1
lon_s=lon[::dc]
lat_s=lat[::dc]
lon2, lat2 = np.meshgrid(lon_s, lat_s)
x, y = map(lon2, lat2)
p1=map.pcolormesh(x, y, vel,  vmin=0., vmax=.1) #,vmin=0,vmax=1000
cbaxes = fig2.add_axes([0.75, 0.13, 0.03, 0.3]) 
cbl=plt.colorbar(p1,cmap=plt.cm.PuBu,cax=cbaxes)
cbl.set_label('Ice drift velocity [m/s]')
#cbl.set_label('Ice drift shift [m]')

fig2.savefig(figure_out+'_mod_uv.png')


## 



