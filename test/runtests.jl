using Test: @test

using Kata

# ----------------------------------------------------------------------------------------------- #

using Pkg: activate, test

using Nucleus

# ---- #

const PK = pkgdir(Kata)

# ---- #

cd(cp(joinpath(PK, "da"), joinpath(tempdir(), "Kata"); force = true))

Nucleus.Path.rea('.')

# ---- #

for ba in (".DS_Store", ".ds_store", ".DS store", ".DS Store")

    touch(ba)

    Kata.delete()

    @test lastindex(readdir()) === 11

end

# ---- #

for (a1, a2) in (("Yy", "Ll"),)

    Kata.rename(a1, a2)

end

# ---- #

for st in ("", "Aa/Bb", "Aa/.Bb", "Aa/bb", "Aa/BB")

    Kata.lo(st)

end

# ---- #

const ST_ = "code", "human", "datehuman"

# ---- #

for st in ST_

    Kata.name(st)

end

# ---- #

for st in ST_

    Kata.name(st; live = true)

    sleep(8)

end

# ---- #

for (a1, a2) in (('Z', 'M'), ('z', 'm'))

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
    (("Aa.jl", joinpath(PK, "TEMPLATE.jl")), ("/Bb/Cc.pr", joinpath(PK, "TEMPLATE.pr")))

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
