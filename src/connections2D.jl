"""
Define types of connections for bodies in 2D.
Defines how body moves relative to its parent. OPTIONS:

1) free2 body can translate in x & y, and rotate about z
2) hinge2 body can rotate about z
3) slider-x2 can translate in x
4) slider-x-y2 can translate in x & y
5) hingeslider2 can rotate about z, and translate along the direction
"""

abstract connection2
"""
Body free to translate in x & y, rotate in z.
"""
type free2 <: connection2
q::SymFloat
u::SymFloat
a::SymFloat
L::SymFloat
A::SymFloat
position::SymFloat
velocity::SymFloat
angle::SymFloat
angularvelocity::SymFloat
end

function free2()
  free2("")
end
"""
Supply name of the body to make variables distinct.
"""
function free2(name::ASCIIString)
  q= statesyms(["x", "y", "a"]*"_"*name)
  u = statesyms(["vx", "vy", "va"]*"_"*name)
  a = statesyms(["ax", "ay", "aa"]*"_"*name)
  L = Sym(0)
  A = Sym(0)
  position = q[1:2]
  velocity = u[1:2]
  angle= q[3]
  angularvelocity = u[3]
  free2(q,u,a,L,A,position,velocity,angle,angularvelocity)
end

"""
Body rotates about z.
"""
type hinge2 <: connection2
q::Vector{Sym}
u::Vector{Sym}
a::Vector{Sym}
L::Sym
A::Sym
position::Vector{Sym}
velocity::Vector{Sym}
angle::Vector{Sym}
angularvelocity::Vector{Sym}
end

function hinge2()
   hinge2("")
end
"""
Supply name of the body to make variables distinct.
"""
function hinge2(name::ASCIIString)
  q= statesyms(["a"]*"_"*name)
  u = statesyms(["va"]*"_"*name)
  a = statesyms(["aa"]*"_"*name)
  L = Sym("L_"*name)
  A = Sym(0)
  position = L*[cos(q[1]), sin(q[1])]
  velocity = L*[-sin(q[1]), cos(q[1])]
  angle= [q[1]]
  angularvelocity = [u[1]]
end

"""
Body rotates about z, and translates along that angle.
"""
type hingeslider2 <: connection2
q::Vector{Sym}
u::Vector{Sym}
a::Vector{Sym}
L::Sym
A::Sym
position::Vector{Sym}
velocity::Vector{Sym}
angle::Vector{Sym}
angularvelocity::Vector{Sym}
end

function hingeslider2()
   hingeslider2("")
end
"""
Supply name of the body to make variables distinct.
"""
function hingeslider2(name::ASCIIString)
  q= statesyms(["a","r"]*"_"*name)
  u = statesyms(["va","vr"]*"_"*name)
  a = statesyms(["aa","ar"]*"_"*name)
  L = Sym(0)
  A = Sym(0)
  position = q[2]*[cos(q[1]), sin(q[1])]
  velocity = timederiv(position,q,u)
  angle= [q[1]]
  angularvelocity = [u[1]]
end
