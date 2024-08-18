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

Kata.rename('A', 'Z')

# ---- #

Kata.rename('a', 'z')

# ---- #

Kata.autoname("code"; live = true)

# ---- #

Kata.autoname("human"; live = true)

# ---- #

Kata.replace('A', 'Z')

# ---- #

Kata.replace('a', 'z')

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
