immutable Body2D <: Body
name::ASCIIString
parent::Body
connection::connection2
q::SymFloat
u::SymFloat
a::SymFloat
lengthoffset::SymFloat
angleoffset::SymFloat
position::SymFloat
velocity::SymFloat
angle::SymFloat
angularvelocity::SymFloat
mass::SymFloat
inertia::SymFloat
end

"""
Create a rigid body
"""
function Body2D()
  return Body2D("None")
end
"""
Give the rigid body a name. Default = "None"
"""
function Body2D(name::ASCIIString)
  body = Body2D(name,ground2D())
  return body
end
"""
Give the body this body moves relative to (its parent). Default = ground
"""
function Body2D(name::ASCIIString,parent::Body)
  body = Body2D(name,parent,free2(name))
  return body
end
"""
How this body is connected to its parent. OPTIONS:
1) free2 body can translate in x & y, and rotate about z
2) hinge2 body can rotate about z
3) slider-x2 can translate in x
4) slider-x-y2 can translate in x & y
5) hinge-slider2 can rotate about z, and translate along the direction
Default = free2
"""
function Body2D(name::ASCIIString,parent::Body,
  connection::connection2)
  c = connection

  return Body2D(name,parent,c,c.q,c.u,c.a,c.L.c.A)
end

function Body2D(name::ASCIIString,parent::Body,
  connection::ASCIIString,q::Vector{Sym},u::Vector{Sym},a::Vector{Sym},
  L::Sym,A::Sym,position::Vector2{Sym},velocity::Vector2{Sym},angle::Sym,angularvelocity::Sym)

  mass = SymFloat(symbols("m_"*name,nonnegative=true,real=true))
  inertia = SymFloat(symbols("I_"*name,nonnegative=true,real=true))

  return Body2D(name,parent,connection,q,u,a,L,A,position,velocity,angle,angularvelocity,mass,inertia)
end
