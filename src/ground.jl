abstract Body

"""
ground is the root body that defines the global coordinate frame.

ground has infinite mass an infinite inertia.

There are 2D & 3D types (ground2D & ground3D)
"""
immutable ground2D <: Body
  position::SymFloat
  velocity::SymFloat
  mass::SymFloat
  inertia::SymFloat
end

immutable ground3D <: Body
  position::SymFloat
  velocity::SymFloat
  mass::SymFloat
  inertia::SymFloat
end

function ground2D()
  g = ground2D(zeros(SymFloat,2),
  zeros(SymFloat,2),
  SymFloat(Sym("mground"),Inf),
  SymFloat(Sym("Iground"),Inf))

  return g
end

function ground3D()
  I = Sym("Iground")
  return ground3D(zeros(SymFloat,3),zeros(SymFloat,3),SymFloat(Sym("mground"),Inf),SymFloat(diagM([I,I,I]),diagM([Inf,Inf,Inf])))
end
