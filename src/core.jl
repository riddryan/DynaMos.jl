"""
This script defines the relationship between connections and the names of their variables.
In an intermediate step, it creates these variables, which are then used to define the actual
position of the body in relative to its origin as a function of these variables.

E.G.  The connection "hinge" has one variable "a" corresponding to the angle that the
joint is at.
"""
# Define possible connections and the name of their positional degrees of freedom
core_pos_2D = Dict()

# 1 DOF
core_pos_2D["slider-x"] = ["x"]
core_pos_2D["slider-y"] = ["y"]
core_pos_2D["hinge"] = ["a"]

# 2 DOF
core_pos_2D["slider-x-y"] = ["x", "y"]
core_pos_2D["hinge-slider"] = ["a","r"]

# 3 DOF
core_pos_2D["none"] = ["x", "y", "a"]
core_pos_2D["free"] = ["x", "y", "a"]

# Velocity variable names are the position names prepended with a "v"
core_vel_2D = prepend!(core_pos_2D,"v")

# Acceleration variable names are the position names prepended with a "a"
core_acc_2D = prepend!(core_pos_2D,"a")

# Available connections
core_connection_names_2D = collect(keys(core_vel_2D))

#
core_Loffset = symbols("Loffset",nonnegative=true,real=true)

core_Aoffset = symbols("Aoffset",real=true)

#
