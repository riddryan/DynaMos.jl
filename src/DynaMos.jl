"""
DynaMo enables the formulation, simulation, control, and optimization
of dynamic multi-body systems. There is a focus on methods for studying locomotion
such as finding limit cycles & analysis of model stability.
"""
module DynaMos

using SymPy
using ImmutableArrays
import Base.prepend!
import SymPy.subs

export Body, Body2D, ground2D, core_pos_2D, AddTimeDependence
# Define time
t = symbols("t",nonnegative=true,real=true)

abstract Body

include("util.jl")
include("core.jl")
include("timederiv.jl")
include("ground.jl")
include("Body2D.jl")
include("Body3D.jl")

end # module
