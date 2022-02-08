using Clean

jl = joinpath(@__DIR__, "runtests.jl")

nb = joinpath(@__DIR__, "runtests.ipynb")

;

## clean_jl

Clean.clean_jl(jl)

## clean_nb

Clean.clean_nb(nb)

## clean

Clean.clean(jl)

Clean.clean(nb)

Clean.clean(jl, nb)
