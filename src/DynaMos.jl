"""
DynaMo enables the formulation, simulation, control, and optimization
of dynamic multi-body systems. There is a focus on methods for studying locomotion
such as finding limit cycles & analysis of model stability.
"""
module DynaMos

using SymPy
using ImmutableArrays
using Parameters

import Base: prepend!, *, getindex, convert, zeros, size, length, ==, setindex!
import SymPy.subs, SymPy.symbols

export Body, Body2D, ground2D
export connection2D, free2D, hinge2D, hingeslider2D, slider2D, sliderx2D, slidery2D
export SymFloat
export AddTimeDependence, timederiv
export DynaMo, DynaMo2D, DynaMo3D
export ==

# Define time
t = symbols("t",nonnegative=true,real=true)

abstract DynaMo
abstract Body

include("SymFloat.jl")
include("util.jl")
include("connections2D.jl")
include("timederiv.jl")
include("ground.jl")
include("Body2D.jl")
include("TimeDependentStates.jl")
# include("Body3D.jl")
# include("DynaMo2D.jl")

end # module
