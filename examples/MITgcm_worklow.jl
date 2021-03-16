### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 8cf4d8ca-84eb-11eb-22d2-255ce7237090
begin
	using MITgcmTools, PlutoUI, Printf
	exps=verification_experiments()
	🏁 = "🏁"
end

# ╔═╡ f588eaba-84ef-11eb-0755-bf1b85b2b561
begin
	imgA="https://user-images.githubusercontent.com/20276764/111042787-12377e00-840d-11eb-8ddb-64cc1cfd57fd.png"
	imgB="https://user-images.githubusercontent.com/20276764/97648227-970b9780-1a2a-11eb-81c4-65ec2c87efc6.png"
	md"""# MITgcm_workflow.jl

	### 


	Here we use scan an MITgcm run folder interactivetly to generate something like this:
	
	$(Resource(imgA, :width => 240))
	
	### 
	
	$(Resource(imgB, :width => 120))
	"""
end

# ╔═╡ 98b6621c-85ab-11eb-29d1-af0433598c6a
md"""## Select model configuration:

_Note: changing this top level parameter should update multiple-choice menus and results below_
"""

# ╔═╡ a28f7354-84eb-11eb-1830-1f401bf2db97
@bind myexp Select([exps[i].name for i in 1:length(exps)],default="advect_xy")

# ╔═╡ 2ff78cac-868b-11eb-2d56-79ea1f874453
begin
	iexp=findall([exps[i].name==myexp for i in 1:length(exps)])[1]
	
	md"""###
	
	name = $(exps[iexp].name)
	
	build options = $(exps[iexp].build)
	
	run options = $(exps[iexp].run)
	"""
end

# ╔═╡ d7f2c656-8512-11eb-2fdf-47a3e57a55e6
begin
	pth=joinpath(MITgcm_path,"verification",exps[iexp].name,"run")
	function list_namelist_files(pth)
		tmpA=readdir(pth)
		tmpA=tmpA[findall([length(tmpA[i])>3 for i in 1:length(tmpA)])]
		tmpA=tmpA[findall([tmpA[i][1:4]=="data" for i in 1:length(tmpA)])]
	end
	dats=list_namelist_files(pth)
	try
		@bind mydats Select([dats[i] for i in 1:length(dats)])
	catch e
		"Error: could not find any namelist in $(pth)"
	end
end

# ╔═╡ c7670d00-868c-11eb-1889-4d3ffe621dd2
md"""## Modify parameter file

Model config currently monitored is **$(exps[iexp].name)**. 

Below we modify `endTime` in the `PARM03` parameter group, in two steps.

1. Modify parameter

```
tmplist=deepcopy(nml)
i1=findall((nml.groups.==:PARM03))[1]
tmplist.params[i1][:endTime]=400000.
```

2. Update parameter file

```
rm(fil)
write(fil,tmplist)
```
"""

# ╔═╡ 348c692e-84fe-11eb-3288-dd0a1dedce90
begin
	fil=joinpath(MITgcm_path,"verification",exps[iexp].name,"run",mydats)
	nml=read(fil,MITgcm_namelist())
	🏁
end

# ╔═╡ ca7bb004-8510-11eb-379f-632c3b40723d
try
	@bind nmlgroup Select(String.(nml.groups))
catch e
	"Error: could not find any namelist in $(pth)"
end

# ╔═╡ f051e094-85ab-11eb-22d4-5bd61ac572a1
md"""## Browse model parameters:

**Once the model has been run for a configuration**, then `data` and `PARM01` should be found in the model run directory. One can simply use the `MITgcm run()` function to rerun model configurations.

Selected model : **$(exps[iexp].name)**; namelist file : **$mydats**; parameter group : **$nmlgroup**
"""

# ╔═╡ 15746ef0-8617-11eb-1160-5f48a95d94d0
begin
	tmplist=deepcopy(nml)
	i1=findall((nml.groups.==:PARM03))[1]
	tmplist.params[i1][:endTime]=400000.
	
	rm(fil)
	write(fil,tmplist)	
	🏁
end

# ╔═╡ 52d7c7a2-8693-11eb-016f-4fc3eb516d44
begin
        inml=findall(nml.groups.==Symbol(nmlgroup))[1]
        tmpA=nml.params[inml]
        params=(; zip(keys(tmpA),values(tmpA))...)
        🏁
end

# ╔═╡ 345071c4-8611-11eb-1a91-e914c1f315d5
[(keys(params)[i],values(params)[i]) for i in 1:length(params)]

# ╔═╡ Cell order:
# ╟─f588eaba-84ef-11eb-0755-bf1b85b2b561
# ╟─98b6621c-85ab-11eb-29d1-af0433598c6a
# ╟─a28f7354-84eb-11eb-1830-1f401bf2db97
# ╟─2ff78cac-868b-11eb-2d56-79ea1f874453
# ╟─f051e094-85ab-11eb-22d4-5bd61ac572a1
# ╟─d7f2c656-8512-11eb-2fdf-47a3e57a55e6
# ╟─ca7bb004-8510-11eb-379f-632c3b40723d
# ╟─345071c4-8611-11eb-1a91-e914c1f315d5
# ╟─c7670d00-868c-11eb-1889-4d3ffe621dd2
# ╠═15746ef0-8617-11eb-1160-5f48a95d94d0
# ╟─8cf4d8ca-84eb-11eb-22d2-255ce7237090
# ╟─348c692e-84fe-11eb-3288-dd0a1dedce90
# ╟─52d7c7a2-8693-11eb-016f-4fc3eb516d44
