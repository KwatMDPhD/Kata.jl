using Test: @test

using Kata

# ----------------------------------------------------------------------------------------------- #

using Pkg: activate, test

using Nucleus

# ---- #

const PK = pkgdir(Kata)

# ---- #
# TODO: Rename files

cd(cp(joinpath(PK, "da"), joinpath(tempdir(), "Kata"); force = true))

Nucleus.Path.rea('.')

# ---- #

for ba in (".DS_Store", ".ds_store", ".DS store", ".DS Store")

    touch(ba)

    Kata.delete()

    @test lastindex(readdir()) === 14

end

# ---- #

for (a1, a2) in (("Yy", "Nn"),)

    Kata.rename(a1, a2)

end

# ---- #

for st in ("code", "human", "datehuman")

    @info st

    Kata.name(st)

end

# ---- #

for (a1, a2) in (('Z', 'O'), ('z', 'o'))

    Kata.rewrite(a1, a2)

end

# ---- #
# TODO

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

for (pa, re) in
    (("A.jl", joinpath(PK, "TEMPLATE.jl")), ("/A/B.pr", joinpath(PK, "TEMPLATE.pr")))

    @test Kata.path(pa) === re

end

# ---- #
# TODO

Kata.make_pair

# ---- #

const BA_ = "Name.jl", "Name.pr"

# ---- #

for ba in BA_

    Kata.make(ba)

    cd("..")

end

# ---- #

for ba in BA_

    cd(ba)

    Kata.match()

    cd("..")

end

# ---- #

for ba in BA_

    cd(ba)

    activate(".")

    test()

    cd("..")

end

# ---- #

cd(PK)

Kata.match()
