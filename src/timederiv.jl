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
function timederiv(x::SymPy.Sym)
  dxdt = diff(x,t)
end

"""
Take time derivative of x, where subdiffout specifies what symbols in x depend on time.
Also replace the time derivatives of subdiffout with the symbols in subin.

For example if you have a variable x that depends on time, this looks for x,
replaces it with x(t), take the derivative which produces expressions like:
Derivative(x(t),t), which then are replaced with the symbol defined in subin,
for example vx.

julia> @syms x vx
julia> pos = x^2
julia> vel = timederiv(pos,x,vx)
2*x*vx
"""
function timederiv(x,subdiffout::Array{SymPy.Sym,1},subin::Array{SymPy.Sym,1})
  if length(subdiffout) != length(subin)
    error("subdiffout and subin must have same dimensions")
  end

  # Make subdiffout depend on time
  subdiffoutT = AddTimeDependence(subdiffout)
  x = subs(x,subdiffout,subdiffoutT)

  # Take derivative
  dxdt = timederiv(x)

  # Substitute deriviative of subdiffout for diffin
  diffout = diff(subdiffoutT,t)
  for i in eachindex(diffout)
    dxdt = subs(dxdt,diffout[i],subin[i])
  end

  # remove time dependence
  return dxdt = subs(dxdt,subdiffoutT,subdiffout)
end

# function timederiv(x::SymPy.Sym,v...)
#   return dxdt = timederiv([x],v...)
# end

function timederiv(x::Array{SymPy.Sym},body::Body)
  # the derivative of the position and velocity states are the velocity and accelerations
  # respectively
  return timederiv(x,[body.q, body.u],[body.u,body.a])
end
