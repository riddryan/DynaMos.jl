module DynaMo
#=
DynaMo package allows formulation, simulation, control, and optimization
of multi-body systems. There is a focus on methods for studying locomotion:
such as finding limit cycles & analysis of model stability.
=#

using SymPy
using ImmutableArrays

export Body2D

include("Body2D.jl")
include("core.jl")
end # module
