using Clean

using OnePiece

jl = "dirty.jl"

Clean.clean(jl)

nb = "dirty.ipynb"

Clean.clean(nb)

Clean.clean(jl, nb)
