# ViewChainLattice.jl

A small Julia package for visualizing lattice-confined chains in 3D.

The input is a `Vector` of 3-element integer vectors, for example:

```julia
using ViewChainLattice

vectors = [
    [1, 1, -1],
    [1, -1, 1],
    [0, 2, 0],
]

fig, ax = plot_chain_lattice(vectors, padding = 1)
display(fig)
```

The module accumulates the step vectors end to end, draws the chain backbone in bold black lines, and overlays an integer lattice in thin gray lines. The resulting `Axis3` plot is mouse-rotatable.
