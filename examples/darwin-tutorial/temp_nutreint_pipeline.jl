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
    # multipliers = [0.5, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
    # temp_seeds = LinRange(6,30,12)
    n_steps = 31
    n_steps = 10
    multipliers = LinRange(0, 15, n_steps)
    temp_seeds = LinRange(0, 30, n_steps)
    x = 203
    y = 105
    z= 1
    #t = 50 # OCTOBER
    t = 40 # AUG

    for temp in temp_seeds
        for mult in multipliers
            # set up the config 
            config_id = "LORES_temp-$temp-nutrients-$mult"
            config_obj = setup_new_config(config_id)
            
            # diagnostic frequency
            frequency = 2592000*12*5 # 5 years
            update_diagnostic_freq(1, frequency, config_obj)
            update_diagnostic_freq(2, frequency, config_obj)
            update_diagnostic_freq(4, frequency, config_obj)
            update_diagnostic_freq(5, frequency, config_obj)
            update_diagnostic_freq(6, frequency, config_obj)
            update_diagnostic_freq(7, frequency, config_obj)
            update_diagnostic_freq(8, frequency, config_obj)
            update_diagnostic_freq(10, frequency, config_obj)
            update_diagnostic_freq(11, frequency, config_obj)


            # how long to run for 
            update_param("data", "PARM03", "nenditer", 2880*15, config_obj) # end after 15 years
            
            # set temperature
            update_temperature(temp, config_obj)

            # load a seed file
            seed_file = "/Users/birdy/Documents/eaps_research/gcm_analysis/gcm_data/jan_7_2022/3d.0000000000.nc"
            ds = Dataset(seed_file)

            # update parameters 
            # nutrients to keep constant: 1 (DIC), 18 (ALK), 19 (O2)
            const_nuts = [1, 18, 19]
            update_tracers(const_nuts, ds, x, y, z, t, config_obj, 1)

            nutrients = 2:17 # not including 1 (DIC), 18 (ALK), 19 (O2)
            pico = 21:24
            cocco = 25:29
            diaz = 30:34
            diatom = 35:43
            mixo_dino = 44:51
            zoo = 52:67
            bacteria = 68:70

            update_tracers(nutrients, ds, x, y, z, t, config_obj, mult)
            update_tracers(pico, ds, x, y, z, t, config_obj, mult)
            update_tracers(cocco, ds, x, y, z, t, config_obj, mult)
            update_tracers(diatom, ds, x, y, z, t, config_obj, mult)
            update_tracers(mixo_dino, ds, x, y, z, t, config_obj, mult)
            update_tracers(zoo, ds, x, y, z, t, config_obj, mult)
            update_tracers(bacteria, ds, x, y, z, t, config_obj, mult)

            dar_one_run(config_obj)
        end # multiplier for
    end # temp for 
end 

main()
