using Clean
using OnePiece

TE = OnePiece.path.make_temporary("Clean.test")

jl = joinpath(@__DIR__, "runtests.jl")

Clean.clean(jl)

nb = joinpath(@__DIR__, "dirty.ipynb")

Clean.clean(nb)

Clean.clean(jl, nb, joinpath(dirname(@__DIR__), "src", "Clean.jl"))
