TE = joinpath(tempdir(), "Clean.test")

if isdir(TE)

    rm(TE; recursive = true)

    println("Removed ", TE, ".")

end

mkdir(TE)

println("Made ", TE, ".")

using Clean

jl = joinpath(@__DIR__, "runtests.jl")

nb = joinpath(@__DIR__, "runtests.ipynb")

Clean.clean_jl(jl)

Clean.clean_nb(nb)

Clean.clean(jl)

Clean.clean(nb)

Clean.clean(jl, nb)

if isdir(TE)

    rm(TE; recursive = true)

    println("Removed ", TE, ".")

end
