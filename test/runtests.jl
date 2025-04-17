using Test: @test

using Kata

# ----------------------------------------------------------------------------------------------- #

using Pkg: activate, test

using Nucleus

# ---- #

cd(cp(pkgdir(Kata, "data"), joinpath(tempdir(), "Kata"); force = true))

Nucleus.Path.rea('.')

# ---- #

for ba in (".DS_Store", ".ds_store", ".DS Store")

    touch(ba)

    Kata.delete()

    @test lastindex(readdir()) === 7

end

# ---- #

Kata.rename("Aa", "Zz")

# ---- #

Kata.name("code"; live = true)

# ---- #

Kata.name("human"; live = true)

# ---- #

Kata.name("datehuman"; live = true)

# ---- #

Kata.name("date"; live = true)

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

for ba in ("Name.jl", "Name.pr")

    Kata.make(ba)

    Kata.match()

    activate(".")

    test()

    cd("..")

end

# ---- #

cd(pkgdir(Kata))

Kata.match()
