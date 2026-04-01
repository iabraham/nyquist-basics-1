# Visualizing contours in complex plane for Nyquist basics

A [Pluto.jl](https://plutojl.org/) notebook for visualising the **Argument Principle**.

## What's in the notebook

Transfer function studied:

$$H(s) = \frac{s - 3}{s^2 - 4s + 8}, \quad z_1 = 3, \quad p_{1,2} = 2 \pm 2i$$

The notebook has **three interactive sections**, one per case:

| Case | Contour encloses | Slider shows | Predicted outcome |
|------|-----------------|--------------|-------------------|
| 1 | Zero $z_1 = 3$ (horizontal ellipse) | Point on $C_1$ | $H(C)$ encircles origin **once clockwise** |
| 2 | Pole $p_1 = 2+2i$ (egg shape) | Point on $C_2$ | $H(C)$ encircles origin **once counter-clockwise** |
| 3 | Nothing (wavy circle near $-2$) | Point on $C_3$ | $H(C)$ does **not** encircle origin |

Each section shows:

- **Left panel** – *s*-plane with the closed contour, poles/zeros marked, current traversal point, and dashed lines from each singularity to the current point (so you can watch the subtended angles).
- **Right panel** – *H(s)*-plane with the image curve $H(C)$ and the corresponding current image point relative to the origin.
- **Bottom panel** – *Unwrapped angle evolution* plot: for each singularity $q$, traces $\angle(s - q)$ (radians, unwrapped) from the start to the current step. When $q$ is **inside** the contour the line drifts by exactly −360°; when outside it returns to 0°.

<p align="center">
  <img src="https://itabrah2.web.engr.illinois.edu/GIFs/nyquist-anim.gif" />
</p>


## How to run

1. Install [Julia](https://julialang.org/) 1.x (any 1.x release).
2. Open a Julia REPL (terminal) and navigate to the directory containing
   `nyquist_visualization.jl` (or navigate to the directory and then start a
Julia REPL there).
2. Install Pluto from the REPL:
   ```julia
   julia> import Pkg; Pkg.add("Pluto")
   ```
3. Launch the notebook:
   ```julia
   julia> import Pluto; Pluto.run()
   ```
   Then open `nyquist_visualization.jl` from the Pluto home screen.  
   Pluto will automatically install `Plots` and `PlutoUI` on first run.
