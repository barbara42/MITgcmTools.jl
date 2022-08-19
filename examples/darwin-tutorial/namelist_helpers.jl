
module NamelistHelpers

export update_param

function update_param(file_name, group_name, param_name, new_param_value)
    # read the contents of the data file into a namelist 
    data_file = file_name
    fil = joinpath(rundir, data_file)
    nml = read(fil, MITgcm_namelist())

    # which param group do you want to modify?
    nmlgroup = group_name
    group_idx =findall(nml.groups.==Symbol(nmlgroup))[1]
    parms = nml.params[group_idx]

    # what parameter do you want to modify?
    p_name = param_name
    p_value = new_param_value

    # write changed parameter
    # tmptype= haskey(nml.params[group_idx], Symbol(p_name)) ? typeof(nml.params[group_idx][Symbol(p_name)]) : typeof(p_value)
    #nml.params[group_idx][Symbol(p_name)]=parse(tmptype,p_value)
    nml.params[group_idx][Symbol(p_name)] = p_value
    tmpfil=joinpath(rundir,data_file)
    rm(tmpfil)
    write(tmpfil,nml)
    tmpfil=joinpath("tracked_parameters",data_file)
    ClimateModels.git_log_fil(config_obj,tmpfil,"updated $(p_name) parameter file in $(data_file) to $(p_value)")
end # update_param

# common time steps in seconds 
@enum SECONDS begin
    one_week=604800 
    two_weeks=604800*2
end # enum 

# TODO: create enums for diagnostic names (and name them better?)
# TODO: what should the initial frequency be? - in file
function update_diagnostic_freq(diagnostic_num, frequency)
    update_param("data.diagnostics", "diagnostics_list", "frequency($diagnostic_num)", frequency)
end

function tracer_num_to_name(num)
    tracer_id = length(string(num)) < 2 ? "0"*string(i) : string(i)
    tracer_name = "TRAC"*tracer_id 
    return tracer_name
end

function tracer_name_to_num(name)
    return parse(Int64, name[5:6])
end

function update_tracer(tracer_name, new_value)
    tracer_num = tracer_name_to_num(tracer_name)
    update_param("data.ptracers", "PTRACERS_PARM01", "PTRACERS_ref( :,$tracer_num)", new_value)
end

update_tracers(tracer_names)

# nutrients (name -> tracer name)
@enum TRACERS begin
    # DIC = "TRAC01"
    # NO3 = "TRAC02"
    # NO3 = "TRAC03"
    # NH4 = "TRAC04"
    # PO4 = "TRAC05"
    # FeT = "TRAC06"
    # SiO2 = "TRAC07"
    # DOC = "TRAC08"
    # DON = "TRAC09"
    # DOP = "TRAC10"
    # DOFe = "TRAC11"
    # POC = "TRAC12"
    # PON = "TRAC13" 
    # POP = "TRAC14"
    # POFe  = "TRAC15"
    # POSi = "TRAC16"
    # PIC = "TRAC17"
    # ALK = "TRAC18"
    # O2 = "TRAC19"
    # CDOM = "TRAC20"
    DIC = 1
    NO3 = 2
    NO3 = 3
    NH4 = 4
    PO4 = 5
    FeT = 6
    SiO2 = 7
    DOC = 8
    DON = 9
    DOP = 10
    DOFe = 11
    POC = 12
    PON = 13 
    POP = 14
    POFe  = 15
    POSi = 16
    PIC = 17
    ALK = 18
    O2 = 19
    CDOM = 20
end

end # module 
