@with_kw type DynaMo2D <: DynaMo
  name::String
  bodies::Vector{Body2D} = Body2D[]
  springs::Vector{Spring2D} = Spring2D[]
  phases::Vector{Phase} = Phase[]
  contacts::Vector{Body2D} = Body2D[]
  J::Matrix{Sym} = Matrix{Sym}[]
  MM::Matrix{Sym} = Matrix{Sym}[]
  SpringForces::Vector{Sym} = Vector{Sym}[]
  PositionStates::Vector{Sym} = Vector{Sym}[]
  VelocityStates::Vector{Sym} = Vector{Sym}[]
  States::Vector{Sym} = Vector{Sym}[]
  dim::Int = 2
  angdim::Int = 1
  fulldim::Int = 3
end

function addBody(m::DynaMo2D,name::String;parent::Body=ground2D,
  connection::String=free)
  body = Body2D(name,parent,connection)
  push!(m.bodies,body)
  return body
end

function MaximalMassMatrix(m::DynaMo)
  N = length(m.bodies)*m.fulldim
  M = zeros(SymFloat,N,N)
  for (i,body) in enumerate(m.bodies)
    dex = m.dim*(i-1)+ 1
    M[dex,dex] = body.mass
    M[dex+1,dex+1] = body.mass
    M[dex+2,dex+2] = body.inertia
  end
  return M
end

function poseJacobian(m::DynaMo)
  J = zeros(SymFloat,3*length(m.bodies),m.DOF)
  for (i,body) in enumerate(m.bodies)
    J[m.fulldim*(i-1)+1:m.fulldim*i,:] = poseJacobian(body,m)
  end
  return J
end



function poseJacobian(b::Body,m::DynaMo)
  return vcat(translationVelocityJacobian(b,m),angularVelocityJacobian(b,m))
end

function poseJacobianDot(b::Body,m::DynaMo)
  poseJacobianDot = timederiv(poseJacobian(b,m))
end

function angularVelocityJacobian(m::DynaMo)
  J = zeros(SymFloat,m.angdim*length(m.bodies),m.DOF)

  for (i,body) in enumerate(m.bodies)
    J[m.angdim*(i-1)+1:m.angdim*i,:] = angularVelocityJacobian(body,m)
  end
  return J
end

function angularVelocityJacobian(b::Body,m::DynaMo)
  return linEq(b.angularvelocity,b.connection.u)
end

function translationalVelocityJacobian(m::DynaMo)
  J = zeros(SymFloat,m.dim*length(m.bodies),m.DOF)
  for (i,body) in enumerate(m.bodies)
    J[m.dim*(i-1)+1:m.dim*i,:] = translationalVelocityJacobian(body,m)
  end
  return J
end

function translationalVelocityJacobian(b::Body,m::DynaMo)
  return linEq(b.velocity,b.connection.u)
end

function J = linEq(M::Vector{Sym},x::Vector{Sym})
  return [coeff(i,j) for i in M, j in x]
end

function DOF(m::DynaMo)
  val = 0
  for body in m.bodies
    val += DOF(body)
  end
  return val
end

function DOF(b::Body)
  return length(b.q)
end
