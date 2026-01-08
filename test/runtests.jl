using Kata

# ------------------------------------ #

using Pkg: activate, test

########################################

cd(cp(Kata.P1, joinpath(tempdir(), "Kata"); force = true))

run(`open --background .`)

########################################

Kata.rename("yy", "jj")

Kata.name(; live = true)

########################################

Kata.rewrite("zz", "Kk")

########################################

Kata.make("Name.jl")

Kata.beautify()

Kata.match()

activate(".")

test()

########################################

cd(pkgdir(Kata))

Kata.match()
