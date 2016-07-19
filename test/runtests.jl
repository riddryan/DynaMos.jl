using DynaMo
using Base.Test
using SymPy

# Test 2D ground
g = ground2D()
@test g.mass == Inf
@test g.position == [0,0]

# Test hinge joint
testname = "test"
jointname = "hinge"
sep = "_"
h = Body2D(testname,g,jointname)
@test h.connection == jointname
