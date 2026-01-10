using Kata

# ------------------------------------ #

using Pkg: activate, test

########################################

for st in filter!(!=(".keep"), readdir(Kata.P2))

    rm(joinpath(Kata.P2, st); recursive = true)

end

for st in filter!(!=(".keep"), readdir(Kata.P1))

    cp(joinpath(Kata.P1, st), joinpath(Kata.P2, st))

end

cd(Kata.P2)

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
