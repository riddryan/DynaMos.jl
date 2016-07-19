"""
Create variables that are functions of time.  Used to define the positional DOF of a body.
"""
macro StateVars(x...)
  show(x)
  q = Expr(:block)
  ss = []
  for s in x
    push!(ss,s)

    # Set the symbol equal to a symbolic function of time
    push!(q.args,
      Expr(:(=), s,
        Expr(:call,
          Expr(:call, :(SymFunction), string(s))
        ,:t)
      )
    )

  end
  eval(Main, q)
end

"""
Create variables that depend on time
"""
function AddTimeDependence(varname::ASCIIString)
  return SymFunction(varname)(t)
end
function AddTimeDependence(x::Sym)
  s = string(x)
  m = match(r"\(",s)
  if m != nothing
    s = s[1:m.offset-1]
  end
  return SymFunction(s)(t)
end
function AddTimeDependence(varvector::Vector)
  v = zeros(Sym,size(varvector))
  for i in eachindex(varvector)
    v[i] = AddTimeDependence(varvector[i])
  end
  return v
end
function AddTimeDependence(vardict::Dict)
  d = deepcopy(vardict)
  for key in keys(d)
    d[key] = AddTimeDependence(vardict[key])
  end
  return d
end

"""
Remove dependence on time from SymPy variables and assume they are real.
"""
function RemoveTimeDependence(x::Sym)
  s = string(x)
  m = match(r"\(",s)
  if m != nothing
    s = s[1:m.offset-1]
  end
  return symbols(s, real = true)
end
function RemoveTimeDependence(x::Sym)
  v = zeros(Sym,size(x))
  for i in x
    v[i] = RemoveTimeDependence(x[i])
  end
  return v
end
function RemoveTimeDependence(x::Dict)
  d = deepcopy(x)
  for key in keys(d)
    d[key] = RemoveTimeDependence(x[key])
  end
  return d
end

"""
Add a string to the beginning of each element of each key of a dict
"""
function prepend!(d::Dict,pre::ASCIIString)
  dnew = deepcopy(d)
  for key in keys(d)
    for (i,dname) in enumerate(d[key])
      dnew[key][i] = pre*dname
    end
  end
  return dnew
end

"""
timederiv(x) Take time derivative of symbolic expression x.

timederiv(x,subdiffout,subin) also substitutes the derivative of subdiffout with
the symbols in subin.  IE the symbols in subin are the time derivatives of
the symbols in subdiffout.

timederiv(x,body) uses the properties of body to determine the relationship between
variables (that the velocity states are the time derivative of position states, etc.).

timederiv(x,model) same as timederiv(x,model) but with the info of the whole model
"""
function timederiv(x::Array{SymPy.Sym})
  dxdt = diff(x,t)
end

function timederiv(x::Array{SymPy.Sym},subdiffout::Array{SymPy.Sym,1},subin::Array{SymPy.Sym,1})
  if length(subdiffout) != length(subin)
    error("subdiffout and subin must have same dimensions")
  end

  dxdt = timederiv(x)

  # Substitute deriviative of subdiffout for diffin
  diffout = diff(subdiffout,t)
  for i in diffout
    dxdt = subs(dxdt,diffout[i],diffin[i])
  end

  return dxdt
end

function timederiv(x::Array{SymPy.Sym},body::Body)
  # the derivative of the position and velocity states are the velocity and accelerations
  # respectively
  return timederiv(x,[body.q, body.u],[body.u,body.a])
end

# function subs(x::ImmutableArrays.ImmutableArray,subin,subout,oargs...)
#   y = Vector(length(x))
#   for i in eachindex(x)
#     y[i] = subs(x[i],subin,subout,oargs...)
#   end
# end

# function timederiv(x::Array{SymPy.Sym},m::model)
#
# end
