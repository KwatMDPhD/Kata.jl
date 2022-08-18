using Clean

using OnePiece

jl = joinpath(@__DIR__, "dirty.jl")

Clean.clean(jl)

nb = joinpath(@__DIR__, "dirty.ipynb")

Clean.clean(nb)

Clean.clean(jl, nb)
