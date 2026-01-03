using Kata

# ------------------------------------ #

using Pkg: activate, test

cd(cp(pkgdir(Kata, "in"), joinpath(tempdir(), "Kata"); force = true))

run(`open --background .`)

Kata.rename("yy", "jj")

Kata.name(; live = true)

Kata.rewrite('Z', 'K')

Kata.rewrite('z', 'k')

Kata.make("Name.jl")

Kata.match()

Kata.beautify()

activate(".")

test()

cd(pkgdir(Kata))

Kata.match()
