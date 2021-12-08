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

Clean.clean_jl(jl)

Clean.clean_nb(nb)

Clean.clean(jl)

Clean.clean(nb)

Clean.clean(jl, nb)

rm(TE; recursive = true)

println("Removed ", TE)
