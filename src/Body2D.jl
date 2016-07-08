type Body2D
name::ASCIIString
parent::Body2D
connection::ASCIIString
q::Vector{Sym}
u::Vector{Sym}
position::Vector2{Sym}
velocity::Vector2{Sym}
mass::Sym
inertia::Sym
# Default body is ground (its parent is itself)
Body2D() = ground(new())

Body2D(name,parent,connection,q,u,position,velocity,mass,inertia) =
new(name,parent,connection,q,u,position,velocity,mass,inertia)
end

# Default body ground, it's parent body is itself.
function ground(body::Body2D)
  body.name = "ground"
  body.parent = body
  body.connection = "none"
  body.position = zeros(Sym,2)
  body.velocity = zeros(Sym,2)
  body.mass = Sym(Inf)
  body.inertia = Sym(Inf)
  return body
end


function Body2D(name::ASCIIString)
  body = Body2D(name,Body2D())
  # body = Body2D()
  body.name = name
  return body
end

function Body2D(name::ASCIIString,parent::Body2D)
  body = Body2D(name,parent,"none")
  # body = Body2D()
  return body
end

function Body2D(name::ASCIIString,parent::Body2D,
  connection::ASCIIString)
  q = zeros(Sym,3)
  u = zeros(Sym,3)

  P = [SymFunction("x_"*name) SymFunction("y_"*name) SymFunction("angle_"*name)]
  V = [SymFunction("vx_"*name) SymFunction("vy_"*name) SymFunction("angvel_"*name)]
  if connection == "hinge"
    q[1] = P[3]
    u[1] = V[3]
    L = Sym("l_"*name)
    position = [cos(q) sin(q)].*L
  elseif connection == "slider-x"
    q[1] = P[1]
    u[1] = V[1]
    position = [q Sym(0)]
  elseif connection == "slider-y"
    q[1] = P[2]
    u[1] = V[2]
    position  = [Sym(0) q]
  elseif connection == "slider-x-y"
    q = P[1:2]
    u = V[1:2]
    position = [q[1] q[2]]
  elseif connection == "hinge-slider"
    q = [P[3] SymFunction("r_"*name)]
    u = [V[3] SymFunction("vr_"*name)]
    position = [cos(q[1]) sin(q[1])]*q[2]
  else
    q = P
    u = V
  end
  q = q[q .!= 0]
  u = u[u .!= 0]

  t = symbols("t");
  diffmap = [q[i] => u[i] for i in eachindex(q)]
  velocity = fullderiv(position,t,diffmap)
  body = Body2D(name,parent,connection,q,u,position,velocity)
  # return body
  return Body2D()
end
#
# function Body2D(name::ASCIIString,parent::Body2D,
#   connection::ASCIIString,q::Sym,u::Sym,
#   position::Vector,velocity::Vector)
#
#   mass = "m_"*name
#   inertia = "I_"*name
#
# end
