type SymFloat
sym::Vector{Sym}
val::Vector{Float64}
end
SymFloat(name::ASCIIString) = SymFloat([Sym(name)])
SymFloat(var::Sym) = SymFloat([var])
SymFloat(sym::Array{Sym}) = SymFloat(sym,zeros(Float64,size(sym)))
SymFloat{T<:Real}(num::T) = SymFloat(Sym(num))
# SymFloat(num::Int64) = SymFloat(Sym(num))
SymFloat{T<:Real}(M::Array{T}) = SymFloat(Sym(M))
getindex(A::SymFloat,inds...) = SymFloat(A.sym[inds...],A.val[inds...])

convert(::Type{SymFloat},x::ASCIIString) = SymFloat(x)
convert(::Type{SymFloat},x::Sym) = SymFloat(x)
convert(::Type{SymFloat},x::Array{Sym}) = SymFloat(x)

zeros(::Type{SymFloat},d...) = SymFloat(zeros(Sym,d...))

size(x::SymFloat) = size(x.val)
length(x::SymFloat) = length(x.val)

convert{T<:Real}(::Type{Array{T,1}}, x::T) = [x]
convert(::Type{Array{Sym,1}},x::Sym) = [x]
