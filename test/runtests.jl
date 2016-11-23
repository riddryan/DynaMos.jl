using DynaMo
using Base.Test
using SymPy

# Test 2D ground
g = ground2D()
@assert g.mass.val == Inf
@assert g.position.val == [0,0]

# Test connections
free2D("testbody")
hinge2D("testbody")
hingeslider2D("testbody")
c1 = slider2D("testbody",[Sym(0),Sym(1)])
sliderx2D("testbody")
c2 = slidery2D("testbody")

@test c1 == c2

# Test bodies
@newbody freebody ground2D free2D 0 0
