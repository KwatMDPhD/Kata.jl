using Kata

# ------------------------------------ #

using Pkg: activate, test

using Test: @test

cd(cp(pkgdir(Kata, "in"), joinpath(tempdir(), "Kata"); force = true))

run(`open --background .`)

Kata.rename("xx", "mm")

Kata.name(; live = true)

for (a1, a2) in (('Y', 'N'), ('y', 'n'))

    Kata.rewrite(a1, a2)

end

const ST = "Name.jl"

Kata.make(ST)

@test basename(pwd()) === ST

Kata.beautify()

Kata.match()

activate(".")

test()

cd(pkgdir(Kata))

Kata.match()
