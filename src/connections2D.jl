"""
Define types of connections for bodies in 2D.
Defines how body moves relative to its parent. OPTIONS:

1) free2 body can translate in x & y, and rotate about z
2) hinge2 body can rotate about z
3) slider-x2 can translate in x
4) slider-x-y2 can translate in x & y
5) hingeslider2 can rotate about z, and translate along the direction
"""
type connection2D
q::Array{Sym}
u::Array{Sym}
a::Array{Sym}
L::Sym
A::Sym
position::Array{Sym}
velocity::Array{Sym}
angle::Sym
angularvelocity::Sym
end

function connection2D(name::String,pnames::Array{String,1},L::Sym,A::Sym,pos::Array{Sym,1},
  ang::Sym)
  (q,u,a) = connectvars(pnames)
  vel = timederiv(pos,q,u)
  angvel = timederiv(ang,q,u)
  return connection2D(q,u,a,L,A,pos,vel,ang,angvel)
end

function connectvars(varnames::Array{String})
  q= statesyms(varnames)
  u = statesyms("v"*varnames)
  a = statesyms("a"*varnames)
  return q,u,a
end

function offsetvars(name::String)
  L = symbols("L_"*name,real=true)
  A = symbols("A_"*name,real=true)
  return L, A
end

function values{T<:connection2D}(x::T)
  A = fieldnames(x)
  tuple([x.(A[i]) for i in eachindex(A)]...)
end

function free2D(name::String)
  posvarnames = ["x","y","a"]*"_"*name
  q = statesyms(posvarnames)
  L = Sym(0)
  A = Sym(0)
  pos = q[1:2]
  ang = q[3]
  return connection2D(name,posvarnames,L,A,pos,ang)
end

function hinge2D(name::String)
  posvarnames = ["a_"*name]
  q = statesyms(posvarnames)
  L = symbols("L_"*name,real=true)
  A = Sym(0)
  pos = L*[cos(q[1]),sin(q[1])]
  ang = q[1]
  return connection2D(name,posvarnames,L,A,pos,ang)
end

function hingeslider2D(name::String)
  posvarnames = ["a","r"]*"_"*name
  q = statesyms(posvarnames)
  L = Sym(0)
  A = Sym(0)
  pos = q[2]*[cos(q[1]),sin(q[1])]
  ang = q[1]
  return connection2D(name,posvarnames,L,A,pos,ang)
end

function slider2D(name::String,ang::Sym)
  posvarnames = ["r_"*name]
  q = statesyms(posvarnames)
  L = Sym(0)
  A = Sym(0)
  pos = q[1] *  [cos(ang), sin(ang)]
  return connection2D(name,posvarnames,L,A,pos,ang)
end

sliderx2D(name::String) = slider2D(name,Sym(0))
slidery2D(name::String) = slider2D(name,Sym(0))
