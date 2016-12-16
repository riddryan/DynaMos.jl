using DynaMos
using Base.Test
using SymPy

# Test 2D ground
g = ground2D()
@assert g.mass.val == [Inf]
@assert g.position.val == [0,0]
@assert g == ground2D()

# Test connections
name = "testbody"
free2D(name)
hinge2D(name)
hingeslider2D(name)
c1 = slider2D(name,Sym(0))
c2 = sliderx2D(name)
slidery2D(name)

@assert c1 == c2

#Test bodies
b = Body2D()
@assert b == Body2D()
