@with_kw type DynaMo2D <: DynaMo
  name::ASCIIString
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

function addBody(m::DynaMo2D,name::ASCIIString;parent::Body=ground2D,
  connection::ASCIIString=free)
  body = Body2D(name,parent,connection)
  push!(m.bodies,body)
  return body
end

function MaximalMassMatrix(m::DynaMo)
  N = length(m.bodies)*m.fulldim
  M = zeros(Sym,N,N)
  for i in m.bodies

    M(
  end
  return M
end

function VelocityJacobian(m::DynaMo)
  J = zeros(Sym,3*length(m.bodies),m.DOF)
  for (i,body) in enumerate(m.bodies)
    J[m.fulldim*(i-1)+1:m.fulldim*i,:] = VelocityJacobian(body,m)
  end
  return J
end

function VelocityJacobian(b::Body,m::DynaMo)
  return vcat(TranslationVelocityJacobian(b,m),AngularVelocityJacobian(b,m))
end

function AngularVelocityJacobian(m::DynaMo)
  J = zeros(Sym,m.angdim*length(m.bodies),m.DOF)

  for (i,body) in enumerate(m.bodies)
    J[m.angdim*(i-1)+1:m.angdim*i,:] = AngularVelocityJacobian(body,m)
  end
  return J
end

function AngularVelocityJacobian(b::Body,m::DynaMo)
  return LinEq(b.angularvelocity,m.VelocityStates)
end

function TranslationalVelocityJacobian(m::DynaMo)
  J = zeros(Sym,m.dim*length(m.bodies),m.DOF)
  for (i,body) in enumerate(m.bodies)
    J[m.dim*(i-1)+1:m.dim*i,:] = TranslationalVelocityJacobian(body,m)
  end
  return J
end

function TranslationalVelocityJacobian(b::Body,m::DynaMo)
  return LinEq(b.velocity,m.VelocityStates)
end

function J = LinEq(M::Vector{Sym},x::Vector{Sym})
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
