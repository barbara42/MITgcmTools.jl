using NCDatasets
using MITgcmTools, ClimateModels
include("./namelist_helpers.jl")
using .NamelistHelpers

# assumes build has already happened 

function setup_new_config(config_id)
    # create config
	config_name = "darwin-single-box" # the name of the sub-folder inside the model code, does not change
    folder = joinpath(MITgcm_path[1], "verification", config_name, "run")
	config_obj = MITgcm_config(configuration=config_name, ID=config_id, folder=folder)
	setup(config_obj)
	println("done with setting up configuration $config_id")
    return config_obj
end


function main()
    #coords = [[203, 102], [203, 107], [203, 112], [203, 117], [203, 122], [203, 127]]
    coords = [[203, 100], [203, 105], [203, 110], [203, 115], [203, 120], [203, 125], [203, 130], [203, 135]]

    z= 1
    #t = 50 # OCTOBER
    t = 40 # AUG

    for (x, y) in coords
        # set up the config 
        config_id = "gradients-all-plankton-AUG-20yrs-$x-$y"
        config_obj = setup_new_config(config_id)
        
        # diagnostic frequency
        frequency = 2592000 # month
        update_diagnostic_freq(1, frequency, config_obj)
        update_diagnostic_freq(2, frequency, config_obj)
        update_diagnostic_freq(4, frequency, config_obj)
        update_diagnostic_freq(5, frequency, config_obj)
        update_diagnostic_freq(6, frequency, config_obj)
        update_diagnostic_freq(7, frequency, config_obj)
        update_diagnostic_freq(8, frequency, config_obj)
        update_diagnostic_freq(10, frequency, config_obj)
        update_diagnostic_freq(11, frequency, config_obj)


        # timing 
        update_param("data", "PARM03", "nenditer", 2880*20, config_obj) # end after 20 years
        
        # load a seed file
        seed_file = "/Users/birdy/Documents/eaps_research/gcm_analysis/gcm_data/jan_7_2022/3d.0000000000.nc"
        ds = Dataset(seed_file)

        # update parameters 
        nutrients = 1:19 
        pico = 21:24
        others = 25:51
        zoo = 52:67
        bacteria = 68:70

        update_tracers(nutrients, ds, x, y, z, t, config_obj)
        update_tracers(pico, ds, x, y, z, t, config_obj)
        update_tracers(others, ds, x, y, z, t, config_obj)
        update_tracers(zoo, ds, x, y, z, t, config_obj)
        update_tracers(bacteria, ds, x, y, z, t, config_obj)

        dar_one_run(config_obj)
    end
end 

main()
