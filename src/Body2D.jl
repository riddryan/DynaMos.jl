immutable Body2D <: Body
name::ASCIIString
parent::Body
connection::ASCIIString
q::Vector{Sym}
u::Vector{Sym}
a::Vector{Sym}
lengthoffset::Sym
angleoffset::Sym
position::Vector2{Sym}
velocity::Vector2{Sym}
angle::Sym
mass::Sym
inertia::Sym
end
function Body2D()
  return Body2D("None")
end
function Body2D(name::ASCIIString)
  body = Body2D(name,ground2D())
  return body
end

function Body2D(name::ASCIIString,parent::Body)
  body = Body2D(name,parent,"free")
  return body
end

function Body2D(name::ASCIIString,parent::Body,
  connection::ASCIIString)

  # q = AddTimeDependence(core_pos_2D[connection])
  # u = AddTimeDependence(core_vel_2D[connection])
  # a = AddTimeDependence(core_acc_2D[connection])
  q = core_pos_2D[connection]
  u = core_vel_2D[connection]
  a = core_acc_2D[connection]

  return Body2D(name,parent,connection,q,u,a)
end

function Body2D(name::ASCIIString,parent::Body,
  connection::ASCIIString,q::Vector{Sym},u::Vector{Sym},a::Vector{Sym})

  # Distance Offset from joint
  if connection != "hinge"
      L = Sym(0)
    else
      L = symbols("l_"*name,nonnegative=true,real=true)
  end

  # Angle Offset
  A = Sym(0)

  return Body2D(name,parent,connection,q,u,a,L,A)
end

function Body2D(name::ASCIIString,parent::Body,
  connection::ASCIIString,q::Vector{Sym},u::Vector{Sym},a::Vector{Sym},
  L::Sym,A::Sym)

  # List of positions for connections
  if connection == "hinge"
    position = [cos(q), sin(q)].*L
    angle = q[1]
  elseif connection == "slider-x"
    position = [q, Sym(0)]
    angle = Sym(0)
  elseif connection == "slider-y"
    position  = [Sym(0), q]
    angle = Sym(0)
  elseif connection == "slider-x-y"
    position = q[1:2]
    angle = Sym(0)
  elseif connection == "hinge-slider"
    position = [cos(q[1]), sin(q[1])]*q[2]
    angle = q[1]
  else
    position = q[1:2]
    angle = q[3]
  end

  # Differentiate position w.r.t. time to get velocities and set derivative of
  # q to be equal to u (by definition).  We first use AddTimeDependence so that
  # timederiv knows that the velocity states (u) are the derivatives of the position states (q)
  velocity = timederiv(AddTimeDependence(position),q,u)
  return Body2D(name,parent,connection,q,u,a,L,A,Vector2(position),Vector2(velocity),angle)
end

function Body2D(name::ASCIIString,parent::Body,
  connection::ASCIIString,q::Vector{Sym},u::Vector{Sym},a::Vector{Sym},
  L::Sym,A::Sym,position::Vector2{Sym},velocity::Vector2{Sym},angle::Sym)

  mass = symbols("m_"*name,positive=true,real=true)
  inertia = symbols("I_"*name,positive=true,real=true)

  return Body2D(name,parent,connection,q,u,a,L,A,position,velocity,angle,mass,inertia)
end
