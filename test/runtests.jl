using Kata

using Test: @test

# ----------------------------------------------------------------------------------------------- #

using Pkg: activate, test

# ---- #

cd(cp(pkgdir(Kata, "data"), joinpath(tempdir(), "Kata"); force = true))

run(`open .`)

# ---- #

for fi in (".DS_Store", ".ds_store", ".DS Store")

    touch(fi)

    @info readdir()

    Kata.delete()

    @info readdir()

end

# ---- #

Kata.rename("Aa", "Zz")

# ---- #

Kata.name("code"; live = true)

# ---- #

Kata.name("human"; live = true)

# ---- #

Kata.name("date"; live = true)

# ---- #

Kata.name("datehuman"; live = true)

# ---- #

Kata.rewrite('A', 'Z')

# ---- #

Kata.rewrite('a', 'z')

# ---- #

Kata.format()

# ---- #

Kata.festdi

# ---- #

Kata.adcopu

# ---- #

const NA = "TitleCase.jl"

# ---- #

Kata.make(NA)

# ---- #

cd(NA)

# ---- #

Kata.match()

# ---- #

activate(".")

# ---- #

test()
