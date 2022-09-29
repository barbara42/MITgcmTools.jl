using Rasters 
using Glob 

# load up all the datasets from each 20-year run 
coords = [[203, 121], [203, 125], [203, 130], [203, 135], [203, 140], [203, 145]]
folder = "/Users/birdy/Documents/eaps_research/darwin3/verification/darwin-single-box/run"

lon = 203
lat = 121
config_id = "gradients-20yrs-$lon-$lat" # CHANGE ME
data_folder = "ecco_gud_20220823_0001" # CHANGE ME
rundir = joinpath(folder, config_id, "run")
glob_dir = joinpath(rundir, data_folder)
alldata = glob("3d*.nc", glob_dir) # all 20 years 

A = Raster(alldata)


# for (lon, lat) in coords
#     config_id = "gradients-20yrs-$lon-$lat" # CHANGE ME
#     data_folder = "ecco_gud_20220823_0001" # CHANGE ME
#     rundir = joinpath(folder, config_id, "run")
#     glob_dir = joinpath(rundir, data_folder)
#     alldata = glob("3d*.nc", glob_dir) # all 20 years 
#     global ds = Dataset(alldata)
#     append!(datasets_list, [ds])
# end
