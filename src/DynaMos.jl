"""
DynaMo enables the formulation, simulation, control, and optimization
of dynamic multi-body systems. There is a focus on methods for studying locomotion
such as finding limit cycles & analysis of model stability.
"""
module DynaMos

using SymPy
using ImmutableArrays
using Parameters
import Base.prepend!, Base.*, Base.getindex, Base.convert
import SymPy.subs, SymPy.symbols

export Body, Body2D, ground2D
export core_pos_2D, AddTimeDependence
export DynaMo, DynaMo2D, DynaMo3D

# Define time
t = symbols("t",nonnegative=true,real=true)

abstract DynaMo
abstract Body

include("SymFloat.jl")
include("util.jl")
include("connections2D.jl")
# include("core.jl")
# include("timederiv.jl")
include("ground.jl")
include("Body2D.jl")
# include("Body3D.jl")
# include("DynaMo2D.jl")

end # module
