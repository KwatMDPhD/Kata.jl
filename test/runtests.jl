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

for na in ("code", "human", "datehuman", "date")

    Kata.name(na; live = true)

end

# ---- #

for (s1, s2) in (('A', 'Z'), ('a', 'z'))

    Kata.rewrite(s1, s2)

end

# ---- #

Kata.beautify()

# ---- #
# TODO

Kata.update

# ---- #
# TODO

Kata.festdi

# ---- #
# TODO

Kata.adcopu

# ---- #
# TODO

Kata.path

# ---- #
# TODO

Kata.make_pair

# ---- #

for ba in ("Name.jl", "Name.pr")

    Kata.make(ba)

    activate(".")

    test()

    cd("..")

end

# ---- #

for ba in ("Name.jl", "Name.pr")

    cd(ba)

    Kata.match()

    cd("..")

end

# ---- #

cd(pkgdir(Kata))

Kata.match()
