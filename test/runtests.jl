TE = joinpath(tempdir(), "Clean.test")

if isdir(TE)

    rm(TE, recursive = true)

end

mkdir(TE)

#using Revise
using Clean

jl = joinpath(@__DIR__, "runtests.jl")

Clean.clean(jl)

nb = joinpath(@__DIR__, "test.ipynb")

Clean.clean(nb)

Clean.clean(jl, nb, joinpath(dirname(@__DIR__), "src", "Clean.jl"))
