module ViewChainLattice

using GLMakie

export chain_coordinates, lattice_bounds, lattice_segments, plot_chain_lattice

function _as_int3(value)
    if length(value) != 3
        throw(ArgumentError("Each lattice vector must contain exactly 3 integer entries."))
    end

    if !all(v -> isa(v, Integer), value)
        throw(ArgumentError("Lattice vectors must contain integer values."))
    end

    ints = Int.(value)
    return (ints[1], ints[2], ints[3])
end

"""
    chain_coordinates(vectors)

Return the cumulative lattice-chain coordinates obtained by adding each vector end to end.
The result is a Vector of 3-tuples, with the first coordinate fixed at (0, 0, 0).
"""
function chain_coordinates(vectors::AbstractVector)
    coords = Vector{NTuple{3,Int}}(undef, length(vectors) + 1)
    coords[1] = (0, 0, 0)

    for i in eachindex(vectors)
        step = _as_int3(vectors[i])
        coords[i + 1] = coords[i] .+ step
    end

    return coords
end

function lattice_bounds(coords::AbstractVector{<:Tuple}; padding = 1)
    if isempty(coords)
        throw(ArgumentError("No lattice coordinates were provided."))
    end

    lower = map(d -> minimum(p[d] for p in coords) - padding, 1:3)
    upper = map(d -> maximum(p[d] for p in coords) + padding, 1:3)
    return Tuple(lower), Tuple(upper)
end

function lattice_segments(bounds)
    lower, upper = bounds
    segments = Vector{Tuple{Point3f,Point3f}}()

    for x in lower[1]:upper[1]
        for y in lower[2]:upper[2]
            push!(segments, (Point3f(x, y, lower[3]), Point3f(x, y, upper[3])))
        end
        for z in lower[3]:upper[3]
            push!(segments, (Point3f(x, lower[2], z), Point3f(x, upper[2], z)))
        end
    end

    for y in lower[2]:upper[2]
        for z in lower[3]:upper[3]
            push!(segments, (Point3f(lower[1], y, z), Point3f(upper[1], y, z)))
        end
    end

    return segments
end

function _is_even_or_zero(v)
    iv = Int(round(v))
    return iv == 0 || iseven(iv)
end

function plot_chain_lattice(vectors::AbstractVector; padding = 1, lattice_color = :gray70, chain_color = :black, backbone_width = 4)
    coords = chain_coordinates(vectors)
    bounds = lattice_bounds(coords; padding = padding)
    fig = Figure()
    ax = Axis3(fig[1, 1], aspect = :data, title = "Lattice-confined chain")

    for (start, stop) in lattice_segments(bounds)
        if all(_is_even_or_zero, (start[1], start[2], start[3], stop[1], stop[2], stop[3]))
            lines!(ax, [start[1], stop[1]], [start[2], stop[2]], [start[3], stop[3]], color = lattice_color, linewidth = 0.7)
        end
    end

    chain_points = [Point3f(p...) for p in coords]
    lines!(ax, chain_points, color = chain_color, linewidth = backbone_width)

    return fig, ax
end

end
