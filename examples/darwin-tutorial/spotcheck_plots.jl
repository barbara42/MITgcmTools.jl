using CairoMakie
using Glob
using NCDatasets

##################
# copy and paste in the correct config_id
# (from the output of darwin-setup)
##################
x,y = [203, 127]
config_id = "LORES_temp-16.666666666666668-nutrients-11.666666666666666" # CHANGE ME
data_folder = "ecco_gud_20220927_0001" # CHANGE ME
savefigs = false

# place to save plots to 
outdir = dirname(Base.source_path())*"/poster_graphs/"

# load nc file into ds 
folder = "/Users/birdy/Documents/eaps_research/darwin3/verification/darwin-single-box/run"
rundir = joinpath(folder, config_id, "run")
glob_dir = joinpath(rundir, data_folder)
alldata = glob("3d*.nc", glob_dir)
ds = Dataset(alldata)

##################
# plots
##################

# nutrients 
nut_fig = Figure()
fig_locs = [[1,1], [1,2],
            [2,1], [2,2], 
            [3,1], [3,2]]
fig_loc_idx = 1
for i = 2:7
    tracer_id = length(string(i)) < 2 ? "0"*string(i) : string(i)
    tracer_name = "TRAC"*tracer_id 
    tracer_ds = ds[tracer_name]
    fig_x, fig_y = fig_locs[fig_loc_idx]
    p = lines(nut_fig[fig_x, fig_y], tracer_ds[1, 1, 1, :]; 
                axis=(; title=tracer_ds.attrib["description"], ylabel=tracer_ds.attrib["units"], xlabel="time",
                xlabelsize=10, ylabelsize=10, xticklabelsize=10, yticklabelsize=10))
    global fig_loc_idx+=1
end
Label(nut_fig[0, :], text = "Nutrients at $y", textsize = 20)
display(nut_fig)

# bacteria  
bac_fig = Figure()
fig_locs = [[1,1], [1,2], [2,1:2]]
fig_loc_idx = 1
for i = 68:70
    tracer_id = length(string(i)) < 2 ? "0"*string(i) : string(i)
    tracer_name = "TRAC"*tracer_id 
    tracer_ds = ds[tracer_name]
    fig_x, fig_y = fig_locs[fig_loc_idx]
    p = lines(bac_fig[fig_x, fig_y], tracer_ds[1, 1, 1, :]; 
                axis=(; title=tracer_ds.attrib["description"], ylabel=tracer_ds.attrib["units"], xlabel="time"))
    global fig_loc_idx+=1
end
Label(bac_fig[0, :], text = "Bacteria at $y", textsize = 20)
display(bac_fig)

# Pico 
pico_fig = Figure()
fig_locs = [[1,1], [1,2], [2,1], [2,2]]
fig_loc_idx = 1
for i = 21:24
    tracer_id = length(string(i)) < 2 ? "0"*string(i) : string(i)
    tracer_name = "TRAC"*tracer_id 
    tracer_ds = ds[tracer_name]
    fig_x, fig_y = fig_locs[fig_loc_idx]
    p = lines(pico_fig[fig_x, fig_y], tracer_ds[1, 1, 1, :]; 
                axis=(; title=tracer_ds.attrib["description"], ylabel=tracer_ds.attrib["units"], xlabel="time"))
    global fig_loc_idx+=1
end
Label(pico_fig[0, :], text = "Pico Phytoplankton at $y", textsize = 20)
display(pico_fig)

# zooplankton 
zoo_fig = Figure()
fig_locs = [[1,1], [1,2], [1, 3], [1, 4], 
            [2,1], [2,2], [2, 3], [2, 4],
            [3,1], [3,2], [3, 3], [3, 4],
            [4,1], [4,2], [4, 3], [4, 4]]
fig_loc_idx = 1
for i = 52:67
    tracer_id = length(string(i)) < 2 ? "0"*string(i) : string(i)
    tracer_name = "TRAC"*tracer_id 
    tracer_ds = ds[tracer_name]
    fig_x, fig_y = fig_locs[fig_loc_idx]
    p = lines(zoo_fig[fig_x, fig_y], tracer_ds[1, 1, 1, :]; 
                axis=(; title=tracer_ds.attrib["description"], ylabel=tracer_ds.attrib["units"], xlabel="time",
                xlabelsize=10, ylabelsize=10, xticklabelsize=10, yticklabelsize=10))
    global fig_loc_idx+=1
end
Label(zoo_fig[0, :], text = "Zooplankton at $y", textsize = 20)
display(zoo_fig)

################## nutrient sums ##################
nut_tot_fig = Figure()
# sum of all nitrogren 
# NO3, NO2, NH4, DON, PON, and biomass
bio_n = ds["TRAC20"] .* (16/106)
for i = 21:70 # all biomass creatures
    tracer_id = length(string(i)) < 2 ? "0"*string(i) : string(i)
    tracer_name = "TRAC"*tracer_id 
    global bio_n = bio_n + ds[tracer_name]*(16/106)
end
no3 = ds["TRAC02"]
no2 = ds["TRAC03"]
nh4 = ds["TRAC04"]
don = ds["TRAC09"]
pon = ds["TRAC13"]
total_nitrogen = no3 + no2 + nh4 + don + pon + bio_n
n_plot = lines(nut_tot_fig[1,1], total_nitrogen[1, 1, 1, :]; axis=(; title="Total Nitrogen", ylabel=no2.attrib["units"]))

# sum of all iron 
# FeT, DOFe, POFe
# TODO: add biomass iron
feT = ds["TRAC06"]
doFe = ds["TRAC11"]
poFe = ds["TRAC15"]
total_iron = feT + doFe + poFe
fe_plot = lines(nut_tot_fig[2,1], total_iron[1, 1, 1, :], axis=(; title="Total Iron", ylabel=feT.attrib["units"]))


# phosphorus 
# PO4 + POP + DOP + biomass*r_pc
r_pc = 0.008333333333333333 # phosphorus carbon ratio 
#bio_p = pro * r_pc
bio_p = ds["TRAC20"] * r_pc
for i = 21:70 # all biomass creatures 
    tracer_id = length(string(i)) < 2 ? "0"*string(i) : string(i)
    tracer_name = "TRAC"*tracer_id 
    global bio_p = bio_p + ds[tracer_name]*r_pc
end
po4 = ds["TRAC05"]
dop = ds["TRAC10"]
pop = ds["TRAC14"]
total_phosphorous = po4 + pop + dop + bio_p
p_plot = lines(nut_tot_fig[3,1], total_phosphorous[1, 1, 1, :], axis=(; title="Total Phosphorus", xlabel="time", ylabel=po4.attrib["units"]))

display(nut_tot_fig)