abstract Body

"""
ground is the root body that defines the global coordinate frame.

ground has infinite mass an infinite inertia.

There are 2D & 3D types (ground2D & ground3D)
"""
immutable ground2D <: Body
  position::Vector2{Sym}
  velocity::Vector2{Sym}
  mass::Sym
  inertia::Sym
end

immutable ground3D <: Body
  position::Vector3{Sym}
  velocity::Vector3{Sym}
  mass::Sym
  inertia::Matrix3x3{Sym}
end

function ground2D()
  return ground2D(zeros(Sym,2),zeros(Sym,2),Sym(Inf),Sym(Inf))
end

function ground3D()
  return ground3D(zeros(Sym,3),zeros(Sym,3),Sym(Inf),Sym(diagM([Inf,Inf,Inf])))
end
