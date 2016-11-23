function statesyms(x::Array{String,1})
  y = zeros(Sym,length(x))
  for i in eachindex(x)
    y[i] = symbols(x[i],real=true)
  end
  return y
end

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
function AddTimeDependence(varname::String)
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
function RemoveTimeDependence(x::Array{Sym,1})
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
