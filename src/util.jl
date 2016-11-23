"""
Add a string to the beginning of each element of each key of a dict
"""
function prepend!(d::Dict,pre::String)
  dnew = deepcopy(d)
  for key in keys(d)
    for (i,dname) in enumerate(d[key])
      dnew[key][i] = pre*dname
    end
  end
  return dnew
end

function subs(x::Array{Sym},subin::Array{Sym},subout::Array{Sym})
  y = deepcopy(x)
  for i in eachindex(subin)
    y = subs(y,subin[i],subout[i])
  end
  return y
end

function subs(x::Sym,subin::Array{Sym},subout::Array{Sym})
  y = deepcopy(x)
  for i in eachindex(subin)
    y = subs(y,subin[i],subout[i])
  end
  return y
end

function *(x::Array{String},val::String)
  for i in eachindex(x)
    x[i] = x[i]*val
  end
  return x
end

function *(val::String,x::Array{String})
  for i in eachindex(x)
    x[i] = val*x[i]
  end
  return x
end

# function convert(::Type{Array{Sym,1}},x::Sym)
#   x = [Sym(x)]
# end
