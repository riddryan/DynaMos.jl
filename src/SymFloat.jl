type SymFloat
sym::Vector{Sym}
val::Vector{Float64}
end
function SymFloat(name::ASCIIString)
  SymFloat([Sym(name)])
end
function SymFloat(var::Sym)
  SymFloat([var])
end
function SymFloat(sym::Array{Sym})
  SymFloat(sym,zeros(Float64,size(sym)))
end

function convert(::Type{SymFloat},x::Sym)
  x = SymFloat(x)
end
function convert(::Type{SymFloat},x::ASCIIString)
  x = SymFloat(x)
end
function convert(::Type{SymFloat},x::Array{Sym})
  x = SymFloat(x)
end

function getindex(A::SymFloat,inds...)
  SymFloat(A.sym[inds...],A.val[inds...])
end
