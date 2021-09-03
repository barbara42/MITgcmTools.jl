### A Pluto.jl notebook ###
# v0.15.1

using Markdown
using InteractiveUtils

# ╔═╡ 3668f786-9597-11eb-01a1-87d34b49eef9
begin

	using Pkg
	Pkg.activate()
	
	#packages for I/O, interpolation, etc	
	using MITgcmTools, MeshArrays, Plots
		
	🏁 = "🏁"
end

# ╔═╡ 19095067-33f5-495f-bc4d-ee6dacbf6ca8
begin
	md"""# HS94_plotmap.jl

	### 


	Here we read MITgcm output for temperature and interpolate it via **`MeshArrays.jl`** to generate something like this:
	
	![plot](https://user-images.githubusercontent.com/20276764/113531401-b1780d00-9596-11eb-8e96-990cf9533ada.png)
	"""
end

# ╔═╡ fa968801-6892-4475-9b27-56472ca611b4
function modify_params_HS94(myexp)
	par_path=joinpath(myexp.folder,string(myexp.ID),"log","tracked_parameters")

	fil=joinpath(par_path,"data")
	nml=read(fil,MITgcm_namelist())

	nml.params[1][:useSingleCpuIO]=true
	
	nml.params[3][:nIter0]=43200
	nml.params[3][:nTimeSteps]=720
	nml.params[3][:monitorFreq]= 21600.0

	write(fil,nml)
	#git_log_fil(myexp,fil,"update parameter file : "*split(fil,"/")[end])

	fil=joinpath(par_path,"data.pkg")
	nml=read(fil,MITgcm_namelist())

	nml.params[1][:useDiagnostics]=false
	nml.params[1][:useMNC]=false

	write(fil,nml)
	#git_log_fil(myexp,fil,"update parameter file : "*split(fil,"/")[end])

end	

# ╔═╡ 1bd679ff-64d3-4d5b-b828-0967182c90c3
begin
	exps=verification_experiments()
	iexp=findall([exps[i].configuration=="hs94.cs-32x32x5" for i in 1:length(exps)])[1]
	myexp=exps[iexp]
end

# ╔═╡ aad7e042-ba39-4518-8f3e-da59b77c13cb
begin
	setup(myexp)
	modify_params_HS94(myexp)
	pth_run=joinpath(myexp.folder,string(myexp.ID),"run")

	fil1="pickup.0000043200.data"
	!isfile(joinpath(pth_run,fil1)) ? cp(joinpath(PICKUP_hs94_path,fil1),joinpath(pth_run,fil1)) : nothing
	fil2="pickup.0000043200.meta"
	!isfile(joinpath(pth_run,fil2)) ? cp(joinpath(PICKUP_hs94_path,fil2),joinpath(pth_run,fil2)) : nothing

	#readdir(joinpath(myexp.folder,string(myexp.ID),"log"))
	step1=🏁
end

# ╔═╡ 0aa37844-b4b9-4f58-adf7-15ae9a490993
begin
	step1
	MITgcmTools.launch(myexp)
	step2=🏁
end

# ╔═╡ b77f7ff2-da7e-41b3-b3f6-3819b09cd33c
begin
	step2

	Γ = GridLoad_mdsio(myexp)
	
	## Interpolation setup for plotting
	lon=[i for i=-179.5:1.0:179.5, j=-89.5:1.0:89.5]
	lat=[j for i=-179.5:1.0:179.5, j=-89.5:1.0:89.5]
	(f,i,j,w,_,_,_)=InterpolationFactors(Γ,vec(lon),vec(lat))
	IntFac=(f,i,j,w)
	step3=🏁
end

# ╔═╡ 56a76f42-7d83-4600-a9a2-2b675b6efcaa
begin
	
	#list of output files (1 per time record)
	ff=readdir(pth_run); fil="T.0000"
	ff=ff[findall(occursin.(fil,ff).*occursin.(".data",ff))]	
	nt=length(ff)
	γ=Γ.XC.grid
	
	#function used to plot one time record
	function myplot(fil)
	    T=read(joinpath(pth_run,fil),MeshArray(γ,Float64))
	    TT=Interpolate(T,IntFac...)
	    contourf(vec(lon[:,1]),vec(lat[1,:]),TT,clims=(260.,320.))
	end
	
	##
	
	f1=myplot(ff[end])	
	step4=🏁
end

# ╔═╡ ee0e6f28-aa26-48de-8ddd-8bb2d1102ee9
begin
	dt=6
	anim = @animate for i ∈ 1:dt:nt
	    myplot(ff[i])
	end
	pp=tempdir()*"/"
	gif(anim,pp*"hs94.cs.gif", fps = 8)
end

# ╔═╡ Cell order:
# ╟─19095067-33f5-495f-bc4d-ee6dacbf6ca8
# ╟─fa968801-6892-4475-9b27-56472ca611b4
# ╟─0aa37844-b4b9-4f58-adf7-15ae9a490993
# ╟─aad7e042-ba39-4518-8f3e-da59b77c13cb
# ╟─1bd679ff-64d3-4d5b-b828-0967182c90c3
# ╟─3668f786-9597-11eb-01a1-87d34b49eef9
# ╟─b77f7ff2-da7e-41b3-b3f6-3819b09cd33c
# ╟─56a76f42-7d83-4600-a9a2-2b675b6efcaa
# ╟─ee0e6f28-aa26-48de-8ddd-8bb2d1102ee9
