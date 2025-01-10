using Kata

using Test: @test

# ----------------------------------------------------------------------------------------------- #

using Pkg: activate, test

# ---- #

cd(cp(pkgdir(Kata, "data"), joinpath(tempdir(), "Kata"); force = true))

run(`open --background .`)

# ---- #

for fi in (".DS_Store", ".ds_store", ".DS Store")

    touch(fi)

    Kata.delete()

    @test lastindex(readdir()) === 6

end

# ---- #

Kata.rename("Aa", "Zz")

# ---- #

const LI = true

# ---- #

Kata.name("code"; live = LI)

# ---- #

Kata.name("human"; live = LI)

# ---- #

Kata.name("date"; live = LI)

# ---- #

Kata.name("datehuman"; live = LI)

# ---- #

Kata.rewrite('A', 'Z')

# ---- #

Kata.rewrite('a', 'z')

# ---- #

Kata.beautify()

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
