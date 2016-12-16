@with_kw type Body2D <: Body
name::String = "None"
parent::Body = ground2D()
connection::connection2D = free2D("None")
mass::SymFloat = SymFloat(symbols("m_None",nonnegative=true,real=true))
inertia::SymFloat = SymFloat(symbols("I_None",nonnegative=true,real=true))
end
function ==(b1::Body2D,b2::Body2D)
 f = fieldnames(b1)
 for i in f
   if getfield(b1,i) != getfield(b2,i)
     return false
   end
 end
 return true
end
