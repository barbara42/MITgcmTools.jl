"""
    MITgcm_namelist

Data structure representing a MITgcm _namelist_ file, such as `data.pkg`, 
which contain model parameters (`params`) organized in `groups`

```
using MITgcmTools
fil=joinpath(MITgcm_path,"verification","advect_xy","run","data")
nml=read_namelist(fil)
MITgcm_namelist(nml.groups,nml.params)
MITgcm_namelist(groups=nml.groups,params=nml.params)
MITgcm_namelist(groups=nml.groups)
```
"""
Base.@kwdef struct MITgcm_namelist
    groups :: Array{Symbol,1} = Array{Symbol,1}(undef, 0)
    params :: Array{Dict{Symbol,Any},1} = Array{Dict{Symbol,Any},1}(undef, 0)
end

import Base:read,write
read(fil::AbstractString,nml::MITgcm_namelist) = read_namelist(fil)
write(fil::AbstractString,nml::MITgcm_namelist) = write_namelist(fil,nml)

"""
    MITgcm_config

Concrete type of `AbstractModelConfig` for `MITgcm`    

```
using MITgcmTools
exps=verification_experiments()
exps[end]
```
"""
Base.@kwdef struct MITgcm_config <: AbstractModelConfig
    model :: String = "MITgcm"
    configuration :: String = ""
    options :: Array{String,1} = Array{String,1}(undef, 0)
    inputs :: Array{String,1} = Array{String,1}(undef, 0)
    outputs :: Array{String,1} = Array{String,1}(undef, 0)
    status :: Array{String,1} = Array{String,1}(undef, 0)
    channel :: Channel{Any} = Channel{Any}(10) 
    folder :: String = tempdir()
    ID :: UUID = UUIDs.uuid4()
end
