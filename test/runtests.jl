using GLMakie
using Test
using ViewChainLattice

@testset "ViewChainLattice" begin
    vectors = [[1, 1, -1], [1, -1, 1], [0, 2, 0]]

    @test chain_coordinates(vectors) == [(0, 0, 0), (1, 1, -1), (2, 0, 0), (2, 2, 0)]
    @test lattice_bounds(chain_coordinates(vectors)) == ((-1, -1, -2), (3, 3, 1))
    @test length(lattice_segments(lattice_bounds(chain_coordinates(vectors)))) > 0

    fig, ax = plot_chain_lattice(vectors, padding = 1)
    @test fig isa Figure
    @test ax isa Axis3
end
