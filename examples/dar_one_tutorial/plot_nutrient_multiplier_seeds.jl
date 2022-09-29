using NCDatasets
using Plots

multipliers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
temp_seeds = LinRange(8,25,10)
x = 203
y = 105
z= 1
#t = 50 # OCTOBER
t = 40 # AUG

seed_file = "/Users/birdy/Documents/eaps_research/gcm_analysis/gcm_data/jan_7_2022/3d.0000000000.nc"
ds = Dataset(seed_file)

################## nutrient sums ##################

# sum of all nitrogren 
# NO3, NO2, NH4, DON, PON, and biomass
bio_n = ds["TRAC20"][x,y,z,t] * (16/106)
for i = 21:70 # all biomass creatures
    tracer_id = length(string(i)) < 2 ? "0"*string(i) : string(i)
    tracer_name = "TRAC"*tracer_id 
    global bio_n = bio_n + ds[tracer_name][x,y,z,t]*(16/106)
end
no3 = ds["TRAC02"][x,y,z,t]
no2 = ds["TRAC03"][x,y,z,t]
nh4 = ds["TRAC04"][x,y,z,t]
don = ds["TRAC09"][x,y,z,t]
pon = ds["TRAC13"][x,y,z,t]
total_nitrogen = no3 + no2 + nh4 + don + pon + bio_n
# n_plot = lines(nut_tot_fig[1,1], total_nitrogen[x, y, z, t]; axis=(; title="Total Nitrogen", ylabel=no2.attrib["units"]))

# sum of all iron 
# FeT, DOFe, POFe
# TODO: add biomass iron
feT = ds["TRAC06"][x,y,z,t]
doFe = ds["TRAC11"][x,y,z,t]
poFe = ds["TRAC15"][x,y,z,t]
total_iron = feT + doFe + poFe
# fe_plot = lines(nut_tot_fig[2,1], total_iron[1, 1, 1, :], axis=(; title="Total Iron", ylabel=feT.attrib["units"]))


# phosphorus 
# PO4 + POP + DOP + biomass*r_pc
r_pc = 0.008333333333333333 # phosphorus carbon ratio 
#bio_p = pro * r_pc
bio_p = ds["TRAC20"][x,y,z,t] * r_pc
for i = 21:70 # all biomass creatures 
    tracer_id = length(string(i)) < 2 ? "0"*string(i) : string(i)
    tracer_name = "TRAC"*tracer_id 
    global bio_p = bio_p + ds[tracer_name][x,y,z,t]*r_pc
end
po4 = ds["TRAC05"][x,y,z,t]
dop = ds["TRAC10"][x,y,z,t]
pop = ds["TRAC14"][x,y,z,t]
total_phosphorous = po4 + pop + dop + bio_p
# p_plot = lines(nut_tot_fig[3,1], total_phosphorous[1, 1, 1, :], axis=(; title="Total Phosphorus", xlabel="time", ylabel=po4.attrib["units"]))

# display(nut_tot_fig)

nitrogen = zeros(0)
phosphorus = zeros(0)
iron = zeros(0)
for mult in multipliers
    append!(nitrogen, total_nitrogen * mult)
    append!(phosphorus, total_phosphorous * mult)
    append!(iron, total_iron * mult)
end

# TODO: add line for station aloha and alaska 
display(scatter(multipliers,nitrogen, title="total nitrogren"))
display(scatter(multipliers,phosphorus, title="total phosphorus"))
display(scatter(multipliers,iron, title="total iron"))