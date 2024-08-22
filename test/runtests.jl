using Kata

using Aqua: test_all

using Test: @test

test_all(Kata; deps_compat = false)

# ----------------------------------------------------------------------------------------------- #

# ---- #

using Pkg: activate, test

# ---- #

cd(cp(pkgdir(Kata, "data"), joinpath(tempdir(), "Kata"); force = true))

run(`open .`)

# ---- #

for fi in (".DS_Store", ".ds_store", ".DS Store")

    touch(fi)

    @info readdir()

    Kata.remove()

    @info readdir()

end

# ---- #

Kata.rename("Aa", "Zz")

# ---- #

Kata.autoname("code"; live = true)

# ---- #

Kata.autoname("human"; live = true)

# ---- #

Kata.autoname("date"; live = true)

# ---- #

Kata.autoname("datehuman"; live = true)

# ---- #

Kata.rewrite('A', 'Z')

# ---- #

Kata.rewrite('a', 'z')

# ---- #

Kata.format_web()

# ---- #

Kata.format_jl()

# ---- #

Kata.git_diff

# ---- #

Kata.git_push

# ---- #

const NA = "TitleCase.jl"

# ---- #

Kata.make(NA)

cd(NA)

# ---- #

Kata.reset()

# ---- #

activate(".")

test()
