TE = joinpath(tempdir(), "Clean.test", "")

if isdir(TE)

    rm(TE; recursive = true)

end

mkdir(TE)

println("Made ", TE)

using Revise
using BenchmarkTools

using Clean

jl = joinpath(@__DIR__, "runtests.jl")

nb = joinpath(@__DIR__, "runtests.ipynb")

Clean.clean(jl)

Clean.clean(jl, nb)

Clean.clean_nb(nb)

rm(TE; recursive = true)

println("Removed ", TE)
