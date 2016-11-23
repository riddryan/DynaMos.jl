immutable Body2D <: Body
name::String
parent::Body
connection::connection2D
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
function Body2D(name::String)
  body = Body2D(name,ground2D())
  return body
end
"""
Give the body this body moves relative to (its parent). Default = ground
"""
function Body2D(name::String,parent::Body)
  body = Body2D(name,parent,free2D(name))
  return body
end

function Body2D(name::String,parent::Body,connection::String)
  Body2D(name,parent,eval(Expr(:call,parse(connection),:($name))))
end

function Body2D(name::String,parent::Body,
  connection::connection2D)

  mass = SymFloat(symbols("m_"*name,nonnegative=true,real=true))
  inertia = SymFloat(symbols("I_"*name,nonnegative=true,real=true))

  return Body2D(name,parent,connection,mass,inertia)
end
