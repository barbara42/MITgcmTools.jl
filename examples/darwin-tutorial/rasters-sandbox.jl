using Rasters

seed_file = "/Users/birdy/Documents/eaps_research/gcm_analysis/gcm_data/jan_7_2022/3d.0000000000.nc"
ds_r = RasterStack(seed_file)


# get dims, y is 4th, testing to see what value is at index
ds_r.dims[4][102]