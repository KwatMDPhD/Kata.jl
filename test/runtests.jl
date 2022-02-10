TE = joinpath(tempdir(), "Clean.test")

mkpath(TE)

using Clean

jl = joinpath(@__DIR__, "runtests.jl")

nb = joinpath(@__DIR__, "runtests.ipynb")

Clean.clean_jl(jl)

Clean.clean_nb(nb)

Clean.clean(jl)

Clean.clean(nb)

Clean.clean(jl, nb)

rm(TE; recursive = true)
