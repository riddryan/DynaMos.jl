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
  subout = diff(subdiffout,t)
  for i in eachindex(subout)
    dxdt = subs(dxdt,subout[i]=>subin[i])
  end
  if size(dxdt)[end] == 1
    dxdt = squeeze(dxdt,ndims(dxdt))
  end
  return dxdt
end

function timederiv(x::Array{SymPy.Sym},body::Body)
  # the derivative of the position and velocity states are the velocity and accelerations
  # respectively
  return timederiv(x,[body.q, body.u],[body.u,body.a])
end

# function timederiv(x::Array{SymPy.Sym},m::model)
#
# end
