using NCDatasets
using CairoMakie
using Glob
using Statistics

include("./namelist_helpers.jl")
using .NamelistHelpers

# multipliers = [1, 2, 3, 4, 5, 6, 7, 8]
# temp_seeds = LinRange(10,25,8)

# multipliers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
# temp_seeds = LinRange(8,25,10)

multipliers = [0.5, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
temp_seeds = LinRange(6,30,12)

n_steps = 10
multipliers = LinRange(0, 15, n_steps)
temp_seeds = LinRange(0, 30, n_steps)

# create new nc files with all the data from one run in a single file
folder = "/Users/birdy/Documents/eaps_research/darwin3/verification/darwin-single-box/run"
for temp in temp_seeds
    for mult in multipliers
        # set up the config 
        config_id = "LORES_temp-$temp-nutrients-$mult"
        println(config_id)
        data_folder = "ecco_gud_20220927_0001" # CHANGE ME
        rundir = joinpath(folder, config_id, "run")
        glob_dir = joinpath(rundir, data_folder)
        alldata = glob("3d*.nc", glob_dir) # all 20 years 
        try 
            ds = Dataset(alldata)
            rounded_temp = round(temp, digits=4)
            rounded_mult = round(mult, digits=4)
            write("3d.LORES-temp-$rounded_temp-nutrients-$rounded_mult.nc", ds)
            println("done with NEW_SEED_temp-$rounded_temp-nutrients-$rounded_mult")
        catch e
            println("Wrong date in the ecoo folder causing error")
            println(e)
            continue
        end
    end
end

# datasets_list = Vector{NCDataset}()
# for (lon, lat) in coords
#     # path = "/Users/birdy/Documents/eaps_research/julia stuff/MITgcmTools.jl/3d.gradients-20yrs-203-121.nc"
#     config_id ="gradients-all-plankton-AUG-20yrs-$lon-$lat" # CHANGE ME
    
#     ds = Dataset("3d."*config_id*".nc")
#     append!(datasets_list, [ds])
# end

# # # SINGLE DS 

# # lon = 203
# # lat = 125
# # config_id = "gradients-20yrs-$lon-$lat"
# # ds = Dataset("3d."*config_id*".nc", "a")

# # Tracer IDs
# nutrients = 1:19 
# pico = 21:24
# zoo = 52:67
# bacteria = 68:70

# x = 1
# y = 1
# z = 1
# t = 200 # last ummm year-ish?  

# for i in range(1, length=length(datasets_list))
#     ds = datasets_list[i]
#     # TODO: is there a way to do this without iterating over the variables?
#     # average biomass over the last year for each tracer  
#     pico_avgs = zeros(Float32, 0)
#     for tracer_id in pico
#         tracer = tracer_id_to_name(tracer_id)
#         append!(pico_avgs, [mean(ds[tracer][x,y,z,t:end])])
#     end

#     zoo_avgs = zeros(Float32, 0)
#     for tracer_id in zoo
#         tracer = tracer_id_to_name(tracer_id)
#         append!(zoo_avgs, [mean(ds[tracer][x,y,z,t:end])])
#     end

#     bact_avgs = zeros(Float32, 0)
#     for tracer_id in bacteria
#         tracer = tracer_id_to_name(tracer_id)
#         append!(bact_avgs, [mean(ds[tracer][x,y,z,t:end])])
#     end

#     all_avgs = zeros(Float32, 0)
#     append!(all_avgs, bact_avgs, pico_avgs, zoo_avgs)
#     #p = barplot(1:length(all_avgs), all_avgs, axis = (;title="Species Distribution $i"))
#     #display(p)
# end
# # how much biomass is there total? 
# # what portion is each tracer? 
# # tbl = (
# #     x = vcat(fill(1,length(bacteria)), fill(2,length(pico)), fill(3,length(zoo))),
# #     bact = bact_avgs,
# #     pico = pico_avgs,
# #     zoo = zoo_avgs
# # )
# # # plot: size vs biomass
# # barplot(vcat(fill(1,length(bacteria)), fill(2,length(pico)), fill(3,length(zoo))),
# #         vcat(bact_avgs, pico_avgs, zoo_avgs),
# #         # dodge = tbl.grp,
# #         # color = tbl.grp,
# #         axis = (xticks = (1:3, ["bacteria", "pico", "zoo"]),
# #                 title = "Biomass by Type"),
# #         )




# # using Rasters 
# # using Glob 
# # using Plots

# # filelist = glob("3d.gradients*.nc")
# # series = RasterSeries(filelist, Ti([1,2]))

# # for each variabel, average over the last year

# # for each "ti" (aka seed lat) display stacked bar plot of community composition 
# # i.e. c01, c02, stacked on top of each other 

# # MAKE BAR PLOT STACKED 


# # doing it for only one latitude spot at first 
# ds = datasets_list[2]
# # TODO: is there a way to do this without iterating over the variables?
# # average biomass over the last year for each tracer  
# pico_avgs = zeros(Float32, 0)
# for tracer_id in pico
#     tracer = tracer_id_to_name(tracer_id)
#     append!(pico_avgs, [mean(ds[tracer][x,y,z,t:end])])
# end

# zoo_avgs = zeros(Float32, 0)
# for tracer_id in zoo
#     tracer = tracer_id_to_name(tracer_id)
#     append!(zoo_avgs, [mean(ds[tracer][x,y,z,t:end])])
# end

# bact_avgs = zeros(Float32, 0)
# for tracer_id in bacteria
#     tracer = tracer_id_to_name(tracer_id)
#     append!(bact_avgs, [mean(ds[tracer][x,y,z,t:end])])
# end

# # size dictionary 
# # key: tracer name, value: tuple, (size label, size value, size id)
# size_dict = Dict(
#     # pico 
#     "TRAC21" => ("s2", 0.6, 2),
#     "TRAC22" => ("s3", 0.9, 3),
#     "TRAC23" => ("s4", 1.4, 4),
#     "TRAC24" => ("s5", 2, 5),
#     # zoo
#     "TRAC52" => ("s7", 4.5, 7),
#     "TRAC53" => ("s8", 6.6, 8),
#     "TRAC54" => ("s9", 10, 9),
#     "TRAC55" => ("s10", 15, 10),
#     "TRAC56" => ("s11", 22, 11),
#     "TRAC57" => ("s12", 32, 12),
#     "TRAC58" => ("s13", 47, 13),
#     "TRAC59" => ("s14", 70, 14),
#     "TRAC60" => ("s15", 104, 15),
#     "TRAC61" => ("s16", 154, 16),
#     "TRAC62" => ("s17", 228, 17),
#     "TRAC63" => ("s18", 338, 18),
#     "TRAC64" => ("s19", 502, 19),
#     "TRAC65" => ("s20", 744, 20),
#     "TRAC66" => ("s21", 1103, 21),
#     "TRAC67" => ("s22", 1636, 22),
#     # Bacteria
#     "TRAC68" => ("s1", 0.4, 1),
#     "TRAC69" => ("s2", 0.6, 2),
#     "TRAC70" => ("s3", 0.9, 3)
# )

# """
#     get_tracers(start, stop, prefix)

# Generates a list of tracer names using designated string as prefix.
# """
# function get_tracer_names_from_id_list(ids)
#     tracers = String[]
#     for i in ids
#         tracer_id = length(string(i)) < 2 ? "0"*string(i) : string(i)
#         tracer_name = "TRAC"*tracer_id
#         push!(tracers, tracer_name)
#     end
#     return tracers
# end

# tracer_names = append!(get_tracer_names_from_id_list(pico), get_tracer_names_from_id_list(zoo),get_tracer_names_from_id_list(bacteria))
# biomass = append!(pico_avgs, zoo_avgs, bact_avgs)
# tbl = (
#     tracer_names=tracer_names,
#     tracer_ids = 1:23,
#     biomass=biomass,
#     size_class=[size_dict[x][1] for x in tracer_names],
#     size_id = [size_dict[x][3] for x in tracer_names],
#     size_values=[size_dict[x][2] for x in tracer_names]
# )

# barplot(tbl.size_id, tbl.biomass)