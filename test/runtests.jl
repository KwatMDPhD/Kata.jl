using Test: @test

using Kata

# ----------------------------------------------------------------------------------------------- #

using Pkg: activate, test

using Nucleus

# ---- #

cd(cp(pkgdir(Kata, "data"), joinpath(tempdir(), "Kata"); force = true))

Nucleus.Path.rea(".")

# ---- #

for fi in (".DS_Store", ".ds_store", ".DS Store")

    touch(fi)

    Kata.delete()

    @test lastindex(readdir()) === 7

end

# ---- #

Kata.rename("Aa", "Zz")

# ---- #

const live = true

# ---- #

Kata.name("code"; live)

# ---- #

Kata.name("human"; live)

# ---- #

Kata.name("date"; live)

# ---- #

Kata.name("datehuman"; live)

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

for na in ("Name.jl", "Name.pr")

    Kata.make(na)

    Kata.match()

    activate(".")

    test()

    cd("..")

end

# ---- #

cd(pkgdir(Kata))

Kata.match()
