using GeoMakie, CairoMakie, NCDatasets

# load up seed file 
seed_file = "/Users/birdy/Documents/eaps_research/gcm_analysis/gcm_data/jan_7_2022/3d.0000000000.nc"
ds = Dataset(seed_file)

x = 203
y = 121
lon_conv = x - 180
lat_conv = y - 80

#lons = -180:179
lons = 0:359
lats = -80:79
field = [exp(cosd(l)) + 3(y/90) for l in lons, y in lats]

fig = Figure()
ax = GeoAxis(fig[1,1], dest = "+proj=eqearth +lon_0=180")
#ax = GeoAxis(fig[1,1])
surface!(ax, lons, lats, ds["TRAC01"][:,:,1,1]; shading = false)
scatter!(ax, [60], [-30], markersize=20, color=:red)
display(fig)