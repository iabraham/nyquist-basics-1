### A Pluto.jl notebook ###
# v0.20.3

using Markdown
using InteractiveUtils

# ╔═╡ 10000000-0000-0000-0000-000000000001
md"""
# Nyquist Criterion: Visualizing the Argument Principle

This notebook demonstrates the **Argument Principle**, which is the mathematical foundation of the Nyquist stability criterion.

## Transfer Function

$$H(s) = \frac{s - 3}{s^2 - 4s + 8} = \frac{s - 3}{(s - 2 - 2i)(s - 2 + 2i)}$$

| Singularity | Location |
|:---|:---|
| **Zero** $z_1$ | $s = 3$ |
| **Pole** $p_1$ | $s = 2 + 2i$ |
| **Pole** $p_2$ | $s = 2 - 2i$ |

## The Argument Principle

The argument (angle) of $H(s)$ decomposes as:

$$\angle H(s) = \underbrace{\angle(s - z_1)}_{\text{zero contribution}} - \underbrace{\angle(s - p_1) - \angle(s - p_2)}_{\text{pole contributions}}$$

As a point $s$ traverses a **closed clockwise contour** $C$:

- If a singularity $q$ is **inside** $C$: the angle $\angle(s - q)$ accumulates a net change of $\mathbf{-360°}$.
- If a singularity $q$ is **outside** $C$: the angle $\angle(s - q)$ returns to its original value (net change $= 0°$).

Therefore, with $Z$ zeros and $P$ poles inside $C$ (CW traversal):

$$\text{Net change of } \angle H(s) = Z \times (-360°) - P \times (-360°) = (P - Z) \times 360°$$

The number of **clockwise** encirclements of the origin by $H(C)$ is $N = Z - P$.

## The Three Cases Below

| Case | Inside $C$ | $N = Z - P$ | $H(C)$ |
|:---|:---|:---|:---|
| **Case 1** | Zero $z_1 = 3$ | $1 - 0 = 1$ | Encircles origin **once clockwise** |
| **Case 2** | Pole $p_1 = 2+2i$ | $0 - 1 = -1$ | Encircles origin **once counter-clockwise** |
| **Case 3** | Nothing | $0 - 0 = 0$ | Does **not** encircle origin |

Use the **sliders** to trace a point $s(t)$ along each contour. Watch the angle evolution plot below each contour: when the point completes the full loop, angles of singularities **inside** the contour show a net $-360°$ change.
"""

# ╔═╡ 10000000-0000-0000-0000-000000000002
begin
	using Plots
	using PlutoUI
	gr()
end

# ╔═╡ 10000000-0000-0000-0000-000000000003
begin
	# Transfer function
	H(s) = (s - 3) / (s^2 - 4*s + 8)

	# Singularities
	z₁ = 3.0 + 0.0im        # zero  at s = 3
	p₁ = 2.0 + 2.0im        # pole  at s = 2 + 2i
	p₂ = 2.0 - 2.0im        # pole  at s = 2 - 2i

	N_pts = 300              # number of contour sample points
	θ_vec = range(0, 2π, length = N_pts + 1)[1:N_pts]

	# Figure layout shared across all three sections
	FIG_SIZE   = (960, 820)              # overall figure dimensions (px)
	PANEL_SIZE = (440, 380)              # s-plane / H-plane sub-panel hint
	FIG_LAYOUT = @layout([a{0.5w} b{0.5w}; c{1.0w}])
end

# ╔═╡ 10000000-0000-0000-0000-000000000004
"""
    unwrap(angles)

Unwrap a vector of angles (radians) so that successive differences are in (−π, π].
Returns a new vector with no 2π jumps.
"""
function unwrap(angles::AbstractVector{<:Real})
	out = float.(copy(angles))
	for k in 2:length(out)
		Δ = out[k] - out[k-1]
		out[k] = out[k-1] + (mod(Δ + π, 2π) - π)
	end
	return out
end

# ╔═╡ 20000000-0000-0000-0000-000000000001
md"""
---
## Case 1 — Contour Encircles the Zero ($z_1 = 3$)

The contour $C_1$ is a **horizontal ellipse** (semi-axes $1.5 \times 1.0$) centred at $z_1 = 3$, traversed **clockwise**.

**Inside $C_1$:** Zero $z_1 = 3$  
**Outside $C_1$:** Poles $p_1, p_2$

**Prediction:**  
- $\angle(s - z_1)$ net change: $-360°$ (zero is inside)  
- $\angle(s - p_1)$, $\angle(s - p_2)$ net change: $0°$ (poles are outside)  
- $\angle H(s)$ net change: $-360°$ → $H(C_1)$ encircles origin **once clockwise**

Move the slider to trace $s(t)$ around $C_1$ and observe the angle evolution.
"""

# ╔═╡ 20000000-0000-0000-0000-000000000002
begin
	# Clockwise ellipse around z₁ = 3 (semi-axes 1.5 × 1.0)
	# Clockwise: real part = cos(θ), imaginary part = −sin(θ)  as θ: 0→2π
	C₁ = [3.0 + 1.5*cos(t) - im*1.0*sin(t) for t in θ_vec]
	H₁ = H.(C₁)

	# Pre-compute unwrapped angles for each factor
	φz_C1  = unwrap(angle.(C₁ .- z₁))   # ∠(s − z₁)
	φp1_C1 = unwrap(angle.(C₁ .- p₁))   # ∠(s − p₁)
	φp2_C1 = unwrap(angle.(C₁ .- p₂))   # ∠(s − p₂)
	φH_C1  = unwrap(angle.(H₁))          # ∠H(s)
end

# ╔═╡ 20000000-0000-0000-0000-000000000003
@bind t₁ PlutoUI.Slider(1:N_pts, default=1, show_value=true)

# ╔═╡ 20000000-0000-0000-0000-000000000004
let
	s  = C₁[t₁]
	h  = H₁[t₁]
	idx = 1:t₁

	# ── s-plane ──────────────────────────────────────────────────────────────
	sp = plot(real.(C₁), imag.(C₁),
		lc=:royalblue, lw=2, label="Contour C₁",
		title="s-plane  (step $t₁ / $N_pts)",
		xlabel="Re(s)", ylabel="Im(s)",
		xlims=(-0.5, 5.5), ylims=(-2.5, 2.5),
		aspect_ratio=:equal, legend=:outertopright,
		size=PANEL_SIZE)

	# Lines from each singularity to current point (visualise the angle)
	plot!(sp, [real(z₁), real(s)], [imag(z₁), imag(s)],
		lc=:darkgreen, lw=1.5, ls=:dash, label="")
	plot!(sp, [real(p₁), real(s)], [imag(p₁), imag(s)],
		lc=:crimson,   lw=1.5, ls=:dash, label="")
	plot!(sp, [real(p₂), real(s)], [imag(p₂), imag(s)],
		lc=:purple,    lw=1.5, ls=:dash, label="")

	# Singularities
	scatter!(sp, [real(z₁)], [imag(z₁)],
		ms=10, mc=:darkgreen, marker=:circle, label="Zero z₁=3")
	scatter!(sp, [real(p₁)], [imag(p₁)],
		ms=10, mc=:crimson,   marker=:xcross, label="Pole p₁=2+2i")
	scatter!(sp, [real(p₂)], [imag(p₂)],
		ms=10, mc=:purple,    marker=:xcross, label="Pole p₂=2−2i")

	# Current point
	scatter!(sp, [real(s)], [imag(s)],
		ms=10, mc=:darkorange, marker=:star5, label="s(t)")

	# ── H(s)-plane ───────────────────────────────────────────────────────────
	hp = plot(real.(H₁), imag.(H₁),
		lc=:royalblue, lw=2, label="H(C₁)",
		title="H(s)-plane",
		xlabel="Re(H(s))", ylabel="Im(H(s))",
		aspect_ratio=:equal, legend=:outertopright,
		size=PANEL_SIZE)
	scatter!(hp, [0.0], [0.0],
		ms=10, mc=:black, marker=:circle, label="Origin")
	scatter!(hp, [real(h)], [imag(h)],
		ms=10, mc=:darkorange, marker=:star5, label="H(s(t))")

	# ── Angle evolution ───────────────────────────────────────────────────────
	ap = plot(idx, rad2deg.(φz_C1[idx]),
		lc=:darkgreen, lw=2.5, label="∠(s − z₁)  [zero, inside C₁]",
		title="Unwrapped Angle Evolution",
		xlabel="Step along contour", ylabel="Angle  (degrees)",
		legend=:outertopright)
	plot!(ap, idx, rad2deg.(φp1_C1[idx]),
		lc=:crimson, lw=2, label="∠(s − p₁)  [pole, outside C₁]")
	plot!(ap, idx, rad2deg.(φp2_C1[idx]),
		lc=:purple,  lw=2, label="∠(s − p₂)  [pole, outside C₁]")
	plot!(ap, idx, rad2deg.(φH_C1[idx]),
		lc=:royalblue, lw=2.5, ls=:dash, label="∠H(s)  (zero − poles)")

	# Reference lines
	hline!(ap, [0.0],    lc=:black, lw=1, ls=:dot, label="0° ref")
	hline!(ap, [-360.0], lc=:gray,  lw=1, ls=:dot, label="−360° ref")
	hline!(ap, [360.0],  lc=:gray,  lw=1, ls=:dot, label="+360° ref")

	# Net-change annotation when slider is at the end
	if t₁ == N_pts
		Δz  = round(rad2deg(φz_C1[end]  - φz_C1[1]),  digits=0)
		ΔH  = round(rad2deg(φH_C1[end]  - φH_C1[1]),  digits=0)
		annotate!(ap, N_pts*0.55, rad2deg(φz_C1[end]) + 25,
			text("Net Δ∠(s−z₁) = $(Δz)°", 9, :darkgreen, :left))
		annotate!(ap, N_pts*0.55, rad2deg(φH_C1[end]) - 25,
			text("Net Δ∠H = $(ΔH)°", 9, :royalblue, :left))
	end

	plot(sp, hp, ap,
		layout = FIG_LAYOUT,
		size = FIG_SIZE)
end

# ╔═╡ 30000000-0000-0000-0000-000000000001
md"""
---
## Case 2 — Contour Encircles a Pole ($p_1 = 2 + 2i$)

The contour $C_2$ is an **egg-shaped curve** centred at $p_1 = 2 + 2i$, traversed **clockwise**.  
(Parametric: $s(\theta) = (2 + 2i) + (0.9\cos\theta + 0.1\cos 2\theta) - i\,(0.8\sin\theta + 0.1\sin 2\theta)$)

**Inside $C_2$:** Pole $p_1 = 2 + 2i$  
**Outside $C_2$:** Zero $z_1 = 3$, Pole $p_2 = 2 - 2i$

**Prediction:**  
- $\angle(s - p_1)$ net change: $-360°$ (pole $p_1$ is inside)  
- $\angle(s - z_1)$, $\angle(s - p_2)$ net change: $0°$ (outside)  
- $\angle H(s)$ net change: $+360°$ → $H(C_2)$ encircles origin **once counter-clockwise**
"""

# ╔═╡ 30000000-0000-0000-0000-000000000002
begin
	# Egg-shaped (asymmetric) clockwise contour around p₁ = 2 + 2i
	C₂ = [(2.0 + 2.0im) +
		  (0.9*cos(t) + 0.1*cos(2*t)) -
		  im*(0.8*sin(t) + 0.1*sin(2*t))
		  for t in θ_vec]
	H₂ = H.(C₂)

	φz_C2  = unwrap(angle.(C₂ .- z₁))
	φp1_C2 = unwrap(angle.(C₂ .- p₁))
	φp2_C2 = unwrap(angle.(C₂ .- p₂))
	φH_C2  = unwrap(angle.(H₂))
end

# ╔═╡ 30000000-0000-0000-0000-000000000003
@bind t₂ PlutoUI.Slider(1:N_pts, default=1, show_value=true)

# ╔═╡ 30000000-0000-0000-0000-000000000004
let
	s  = C₂[t₂]
	h  = H₂[t₂]
	idx = 1:t₂

	# ── s-plane ──────────────────────────────────────────────────────────────
	sp = plot(real.(C₂), imag.(C₂),
		lc=:royalblue, lw=2, label="Contour C₂",
		title="s-plane  (step $t₂ / $N_pts)",
		xlabel="Re(s)", ylabel="Im(s)",
		xlims=(-0.5, 5.5), ylims=(-0.5, 4.0),
		aspect_ratio=:equal, legend=:outertopright)

	plot!(sp, [real(z₁), real(s)], [imag(z₁), imag(s)],
		lc=:darkgreen, lw=1.5, ls=:dash, label="")
	plot!(sp, [real(p₁), real(s)], [imag(p₁), imag(s)],
		lc=:crimson,   lw=1.5, ls=:dash, label="")
	plot!(sp, [real(p₂), real(s)], [imag(p₂), imag(s)],
		lc=:purple,    lw=1.5, ls=:dash, label="")

	scatter!(sp, [real(z₁)], [imag(z₁)],
		ms=10, mc=:darkgreen, marker=:circle, label="Zero z₁=3")
	scatter!(sp, [real(p₁)], [imag(p₁)],
		ms=10, mc=:crimson,   marker=:xcross, label="Pole p₁=2+2i  ← inside")
	scatter!(sp, [real(p₂)], [imag(p₂)],
		ms=10, mc=:purple,    marker=:xcross, label="Pole p₂=2−2i")
	scatter!(sp, [real(s)], [imag(s)],
		ms=10, mc=:darkorange, marker=:star5, label="s(t)")

	# ── H(s)-plane ───────────────────────────────────────────────────────────
	hp = plot(real.(H₂), imag.(H₂),
		lc=:royalblue, lw=2, label="H(C₂)",
		title="H(s)-plane",
		xlabel="Re(H(s))", ylabel="Im(H(s))",
		aspect_ratio=:equal, legend=:outertopright)
	scatter!(hp, [0.0], [0.0],
		ms=10, mc=:black, marker=:circle, label="Origin")
	scatter!(hp, [real(h)], [imag(h)],
		ms=10, mc=:darkorange, marker=:star5, label="H(s(t))")

	# ── Angle evolution ───────────────────────────────────────────────────────
	ap = plot(idx, rad2deg.(φz_C2[idx]),
		lc=:darkgreen, lw=2, label="∠(s − z₁)  [zero, outside C₂]",
		title="Unwrapped Angle Evolution",
		xlabel="Step along contour", ylabel="Angle  (degrees)",
		legend=:outertopright)
	plot!(ap, idx, rad2deg.(φp1_C2[idx]),
		lc=:crimson, lw=2.5, label="∠(s − p₁)  [pole, inside C₂]")
	plot!(ap, idx, rad2deg.(φp2_C2[idx]),
		lc=:purple,  lw=2, label="∠(s − p₂)  [pole, outside C₂]")
	plot!(ap, idx, rad2deg.(φH_C2[idx]),
		lc=:royalblue, lw=2.5, ls=:dash, label="∠H(s)  (zero − poles)")

	hline!(ap, [0.0],    lc=:black, lw=1, ls=:dot, label="0° ref")
	hline!(ap, [-360.0], lc=:gray,  lw=1, ls=:dot, label="−360° ref")
	hline!(ap, [360.0],  lc=:gray,  lw=1, ls=:dot, label="+360° ref")

	if t₂ == N_pts
		Δp1 = round(rad2deg(φp1_C2[end] - φp1_C2[1]), digits=0)
		ΔH  = round(rad2deg(φH_C2[end]  - φH_C2[1]),  digits=0)
		annotate!(ap, N_pts*0.55, rad2deg(φp1_C2[end]) - 30,
			text("Net Δ∠(s−p₁) = $(Δp1)°", 9, :crimson, :left))
		annotate!(ap, N_pts*0.55, rad2deg(φH_C2[end]) + 25,
			text("Net Δ∠H = $(ΔH)°", 9, :royalblue, :left))
	end

	plot(sp, hp, ap,
		layout = FIG_LAYOUT,
		size = FIG_SIZE)
end

# ╔═╡ 40000000-0000-0000-0000-000000000001
md"""
---
## Case 3 — Contour Encircles Neither Pole nor Zero

The contour $C_3$ is a **wavy circle** centred at $-2 + 0i$, traversed **clockwise**.  
(Parametric radius: $r(\theta) = 0.75 + 0.15\sin(3\theta)$, giving a slightly three-lobed shape.)

**Inside $C_3$:** Nothing (no poles or zeros)  
**Outside $C_3$:** Zero $z_1 = 3$, Poles $p_1, p_2$

**Prediction:**  
- All angles return to their initial values (net change $= 0°$)  
- $\angle H(s)$ net change: $0°$ → $H(C_3)$ does **not** encircle the origin
"""

# ╔═╡ 40000000-0000-0000-0000-000000000002
begin
	# Wavy circle (three-lobe) centred at −2, no poles/zeros inside
	C₃ = [(-2.0 + 0.0im) +
		  (0.75 + 0.15*sin(3*t))*cos(t) -
		  im*(0.75 + 0.15*sin(3*t))*sin(t)
		  for t in θ_vec]
	H₃ = H.(C₃)

	φz_C3  = unwrap(angle.(C₃ .- z₁))
	φp1_C3 = unwrap(angle.(C₃ .- p₁))
	φp2_C3 = unwrap(angle.(C₃ .- p₂))
	φH_C3  = unwrap(angle.(H₃))
end

# ╔═╡ 40000000-0000-0000-0000-000000000003
@bind t₃ PlutoUI.Slider(1:N_pts, default=1, show_value=true)

# ╔═╡ 40000000-0000-0000-0000-000000000004
let
	s  = C₃[t₃]
	h  = H₃[t₃]
	idx = 1:t₃

	# ── s-plane ──────────────────────────────────────────────────────────────
	sp = plot(real.(C₃), imag.(C₃),
		lc=:royalblue, lw=2, label="Contour C₃",
		title="s-plane  (step $t₃ / $N_pts)",
		xlabel="Re(s)", ylabel="Im(s)",
		xlims=(-3.5, 5.0), ylims=(-2.5, 3.5),
		aspect_ratio=:equal, legend=:outertopright)

	plot!(sp, [real(z₁), real(s)], [imag(z₁), imag(s)],
		lc=:darkgreen, lw=1.5, ls=:dash, label="")
	plot!(sp, [real(p₁), real(s)], [imag(p₁), imag(s)],
		lc=:crimson,   lw=1.5, ls=:dash, label="")
	plot!(sp, [real(p₂), real(s)], [imag(p₂), imag(s)],
		lc=:purple,    lw=1.5, ls=:dash, label="")

	scatter!(sp, [real(z₁)], [imag(z₁)],
		ms=10, mc=:darkgreen, marker=:circle, label="Zero z₁=3")
	scatter!(sp, [real(p₁)], [imag(p₁)],
		ms=10, mc=:crimson,   marker=:xcross, label="Pole p₁=2+2i")
	scatter!(sp, [real(p₂)], [imag(p₂)],
		ms=10, mc=:purple,    marker=:xcross, label="Pole p₂=2−2i")
	scatter!(sp, [real(s)], [imag(s)],
		ms=10, mc=:darkorange, marker=:star5, label="s(t)")

	# ── H(s)-plane ───────────────────────────────────────────────────────────
	hp = plot(real.(H₃), imag.(H₃),
		lc=:royalblue, lw=2, label="H(C₃)",
		title="H(s)-plane",
		xlabel="Re(H(s))", ylabel="Im(H(s))",
		aspect_ratio=:equal, legend=:outertopright)
	scatter!(hp, [0.0], [0.0],
		ms=10, mc=:black, marker=:circle, label="Origin")
	scatter!(hp, [real(h)], [imag(h)],
		ms=10, mc=:darkorange, marker=:star5, label="H(s(t))")

	# ── Angle evolution ───────────────────────────────────────────────────────
	ap = plot(idx, rad2deg.(φz_C3[idx]),
		lc=:darkgreen, lw=2, label="∠(s − z₁)  [zero, outside C₃]",
		title="Unwrapped Angle Evolution",
		xlabel="Step along contour", ylabel="Angle  (degrees)",
		legend=:outertopright)
	plot!(ap, idx, rad2deg.(φp1_C3[idx]),
		lc=:crimson, lw=2, label="∠(s − p₁)  [pole, outside C₃]")
	plot!(ap, idx, rad2deg.(φp2_C3[idx]),
		lc=:purple,  lw=2, label="∠(s − p₂)  [pole, outside C₃]")
	plot!(ap, idx, rad2deg.(φH_C3[idx]),
		lc=:royalblue, lw=2.5, ls=:dash, label="∠H(s)  (zero − poles)")

	hline!(ap, [0.0],    lc=:black, lw=1, ls=:dot, label="0° ref")
	hline!(ap, [-360.0], lc=:gray,  lw=1, ls=:dot, label="−360° ref")
	hline!(ap, [360.0],  lc=:gray,  lw=1, ls=:dot, label="+360° ref")

	if t₃ == N_pts
		ΔH = round(rad2deg(φH_C3[end] - φH_C3[1]), digits=0)
		annotate!(ap, N_pts*0.55, rad2deg(φH_C3[end]) + 3,
			text("Net Δ∠H = $(ΔH)°  (no encirclement)", 9, :royalblue, :left))
	end

	plot(sp, hp, ap,
		layout = FIG_LAYOUT,
		size = FIG_SIZE)
end

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
Plots = "~1"
PlutoUI = "~0.7"
julia = "~1"
"""

# ╔═╡ Cell order:
# ╠═10000000-0000-0000-0000-000000000001
# ╠═10000000-0000-0000-0000-000000000002
# ╠═10000000-0000-0000-0000-000000000003
# ╠═10000000-0000-0000-0000-000000000004
# ╠═20000000-0000-0000-0000-000000000001
# ╠═20000000-0000-0000-0000-000000000002
# ╠═20000000-0000-0000-0000-000000000003
# ╠═20000000-0000-0000-0000-000000000004
# ╠═30000000-0000-0000-0000-000000000001
# ╠═30000000-0000-0000-0000-000000000002
# ╠═30000000-0000-0000-0000-000000000003
# ╠═30000000-0000-0000-0000-000000000004
# ╠═40000000-0000-0000-0000-000000000001
# ╠═40000000-0000-0000-0000-000000000002
# ╠═40000000-0000-0000-0000-000000000003
# ╠═40000000-0000-0000-0000-000000000004
# ╟─00000000-0000-0000-0000-000000000001
