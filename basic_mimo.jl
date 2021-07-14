### A Pluto.jl notebook ###
# v0.15.1

using Markdown
using InteractiveUtils

# ╔═╡ e8e7117d-3192-448c-8fc6-7ab72a309a26
import Pkg

# ╔═╡ 1f566450-e4ae-11eb-1a2f-6b1525f00f42
try
	using PlutoUI
catch e
	Pkg.add("PlutoUI")
end

# ╔═╡ 92811e04-862a-4bbb-8e34-d4a32e8d1593
try
	using Plots
catch e
	Pkg.add("Plots")
end

# ╔═╡ b5f66993-6a77-49c7-ac3e-5e6bedc0d5bf
using Markdown

# ╔═╡ 8bb403ba-bd3d-4777-9d8b-8391a0af313c
using InteractiveUtils

# ╔═╡ 0bb51d95-4d31-431d-887d-5069d0f5f809


# ╔═╡ d9b0be35-8d18-4a50-9eb3-b45188904ac2
md"""
# Basic parameters
"""

# ╔═╡ ec3f9c47-b0af-4f5d-91fe-2d56cb1b0200
begin
	c = 299_792_458 #speed of light

	f = 800e6 #frequency
	λ = c/f #wavelength
	k = 2π/λ #wavenumber
end

# ╔═╡ 2efe2730-f236-434f-b458-d9e9d23c0343
md"""
# Far-field in free-space
"""

# ╔═╡ 552df6eb-efeb-46e0-a0a6-c6732835f59c
begin
	#Electric field at distance r, angle of departure ϕ
	E(f, t, r, ϕ) = cos( 2*π*f*(t - r/c)) / r
	t_0 = 1000 #some arbitrary time
	r_0 = 1000 #some arbitrary distance
	ϕ_0 = 0 #some arbitrary direction
	
	
	p1 = plot(r -> E(f,t_0,r,ϕ_0), r_0, r_0 + 5λ, ylabel="E", xlabel = "distance (r)", 
		title="Far field as a function of distance")
	
end

# ╔═╡ 69ffee53-85d7-46c6-93f6-dc0d95c224ec
md"""
Important observations:

* Field amplitude (voltage) decreases inversely with distance-Thus, Power has “inverse-square law”

* Per meter (for a given time), phase changes by wave-number 𝑘=2𝜋𝑓/𝑐=2𝜋/𝜆

* Per second, phase changes by 𝑓 (by definition ofc)

* Change of phase happens at a much faster rate than the change of amplitude, when the radiation frequency is microwave or larger (cellular communication frequencies)

"""

# ╔═╡ 4e5021ef-f8da-4bc5-867d-c74e8edf8ae2
md"""
# Far-field with two antenna elements
"""

# ╔═╡ 10c519a4-8e19-48aa-bb8a-7614340f6842
d_λ = 0.5 # distance between the antennas in the unit of wavelength

# ╔═╡ 6d70d8ed-3918-4e92-957d-395c4218f892
md"""
The far-field at some distance r and angle 𝜙 can be seen as superposition of two sinusoids that differ only in phase  by 𝑘 ∗𝑑 sin⁡(𝜙)=2 𝜋 (𝑑/𝜆)sin⁡(𝜙)=2 𝜋 𝑑_𝜆 sin⁡(𝜙)

If we ignore the amplitude, this can be concisely written in the “phasor” notation.
𝐻(𝜙)= e^(−𝑗 𝜓)+𝑒^(−𝑗 (𝜓−2𝜋𝑑_𝜆  sin⁡(𝜙))).  
The “effective” channel in terms of received power as a function of angle of departure 𝜙 is thus |𝐻(𝜙)|^2

Note: The pattern is not dependent on 𝜓
md"""

# ╔═╡ 2ce75e47-632c-4ada-92ca-df01afc6db8a
begin
	
	#Two antennas
	E_total(f, t, r, ϕ) = E(f, t, r, ϕ) + E(f, t, r + d_λ*sin(ϕ), ϕ)
	
	#scatter!(ϕ -> E_total(f,0,r_0,ϕ), -π, π)
	#for t=0:0.1:1
	# scatter!(ϕ -> E_total(f,t,r_0,ϕ), -π, π)
	#end
	
	#Phasor notation at a distance r, AoD ϕ
	ψ = 0.0 #Arbitrary
	H(ϕ) = exp(-im* ψ) + exp(-im * (ψ - 2π*d_λ*sin(ϕ) )) 
	
	plot(ϕ -> 10*log10(abs(H(ϕ))^2),-π/2 - π/4, π/2 + π/4, ylims=(-20, Inf), xlabel = "Angle of Departure (ϕ)", ylabel ="Power gain (dB)")
end

# ╔═╡ 826dbc15-21f2-4a63-a87d-172c7b708cba
md"""
# More antennas
"""

# ╔═╡ ef3836fc-4f4b-4886-a8a1-2101b7c45454
begin
	
	#More antennas - keep power normalized in total
	function H_n(n, ϕ) #n = number of antennas
	   H_val = 0
	   for  i=0:n-1
	     H_val += exp(-im * (ψ - 2π*i*d_λ*sin(ϕ) )) 
	   end
	   return (1/sqrt(n)) * H_val
	end 
	
	plot(ϕ -> 10*log10(abs(H_n(3, ϕ))^2),-π/2 , π/2 , ylims=(-20, 20), label = "3antennas")
	plot!(ϕ -> 10*log10(abs(H_n(6, ϕ))^2),-π/2, π/2, ylims=(-20, 20), label = "6antennas")
	plot!(xlabel = "Angle of Departure (ϕ)", ylabel ="Power (dB)")
end

# ╔═╡ 1cb144ed-bbe6-4f14-85b2-cf50233959c1
md"""
With more antennas:

* Directivity along the “boresight” increases => “array gain”

* Lobes show up

* Need to think about total transmit power to have apple-to-apple comparison


"""

# ╔═╡ 108e2cc9-5f10-476a-9b73-1a1dbb23aef1
md"""
# We can adjust the pattern

* If the whole point of having an array of antenna was to get more gains along boresite (at the expense of coverage elsewhere), this would be not be very useful. After all, not all users will be in the boresight.

* If we knew the relative position of the receiver (AoD), can we steer the pattern such that it has highest gain/power towards the direction of the UE? Yes we can! 

* How? So far we assumed  the antennas transmitted in-phase (the 𝜓). Nobody says we need to do that. Also, nobody says, we need to transmit with equal amplitude if we could share the transmit power between the radiating elements

"""

# ╔═╡ 912c51af-88d9-478c-8aca-0e8005957428
md"""
# The simple but powerful idea of “precoding”
"""

# ╔═╡ c81de313-d4d2-47a6-966c-6e436c6c4c85
begin
	function S_T(ϕ, n) 
			#Steering vector transposed
		    S = [exp(im*2π*(i-1)*d_λ*sin(ϕ)) for i=1:n]
		    reshape(S,1,length(S))
	end 
	md"""
	Steering vector defined as follows
	"""
end

# ╔═╡ 643bbfa2-1eeb-45c4-aa79-73e2f822909d


# ╔═╡ 0dda1617-a306-4c79-b9b5-83225fc3e790


# ╔═╡ 2a2fbbcd-f6d4-4845-b561-c8690576d649
begin

	   
		W_all_2port = [1 1   1   1
		               1 im -1  -im]
		n = 2
	md"""
	NR rank 1 Precoders for 2 transmit antennas
	"""
end

# ╔═╡ 50b7941d-574f-4109-9253-1f7150d77d1a
begin
	plot()
	ϕ_set = -π/2:0.01:π/2
	Pwr = []
	i = 0
	display(plot())
	for col in eachcol(W_all_2port)
	    W = (1/sqrt(2)) * col
	    W = reshape(W, length(W), 1)
	   
	    H_eff = [S_T(ϕ, n)*W for ϕ in ϕ_set]
	    Pwr = [10*log10(abs(h[1])^2) for h in H_eff]
		plot!(ϕ_set, Pwr, ylims=(-20, 20), label=("PMI Index", i))
		i = i + 1
	end
	plot!()
end

# ╔═╡ Cell order:
# ╠═e8e7117d-3192-448c-8fc6-7ab72a309a26
# ╠═1f566450-e4ae-11eb-1a2f-6b1525f00f42
# ╠═92811e04-862a-4bbb-8e34-d4a32e8d1593
# ╠═b5f66993-6a77-49c7-ac3e-5e6bedc0d5bf
# ╠═8bb403ba-bd3d-4777-9d8b-8391a0af313c
# ╠═0bb51d95-4d31-431d-887d-5069d0f5f809
# ╠═d9b0be35-8d18-4a50-9eb3-b45188904ac2
# ╠═ec3f9c47-b0af-4f5d-91fe-2d56cb1b0200
# ╠═2efe2730-f236-434f-b458-d9e9d23c0343
# ╠═552df6eb-efeb-46e0-a0a6-c6732835f59c
# ╠═69ffee53-85d7-46c6-93f6-dc0d95c224ec
# ╠═4e5021ef-f8da-4bc5-867d-c74e8edf8ae2
# ╠═10c519a4-8e19-48aa-bb8a-7614340f6842
# ╠═6d70d8ed-3918-4e92-957d-395c4218f892
# ╠═2ce75e47-632c-4ada-92ca-df01afc6db8a
# ╠═826dbc15-21f2-4a63-a87d-172c7b708cba
# ╠═ef3836fc-4f4b-4886-a8a1-2101b7c45454
# ╠═1cb144ed-bbe6-4f14-85b2-cf50233959c1
# ╠═108e2cc9-5f10-476a-9b73-1a1dbb23aef1
# ╠═912c51af-88d9-478c-8aca-0e8005957428
# ╠═c81de313-d4d2-47a6-966c-6e436c6c4c85
# ╠═643bbfa2-1eeb-45c4-aa79-73e2f822909d
# ╠═0dda1617-a306-4c79-b9b5-83225fc3e790
# ╠═2a2fbbcd-f6d4-4845-b561-c8690576d649
# ╠═50b7941d-574f-4109-9253-1f7150d77d1a
