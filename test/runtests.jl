using Kata

using Aqua: test_all

using Test: @test

test_all(Kata; deps_compat = false)

# ----------------------------------------------------------------------------------------------- #

# ---- #

using Pkg: activate, test

# ---- #

cd(cp(pkgdir(Kata, "data"), joinpath(tempdir(), "Kata"); force = true))

# ---- #

run(`open .`)

# ---- #

Kata.style("code"; live = true)

# ---- #

Kata.style("human"; live = true)

# ---- #

Kata.rename('A', 'Z')

# ---- #

Kata.rename('a', 'z')

# ---- #

Kata.rename("Zz", "Yy")

# ---- #

Kata.replace('A', 'Z')

# ---- #

Kata.replace('a', 'z')

# ---- #

Kata.replace("Zz", "Yy")

# ---- #

const NA = "TitleCase.jl"

# ---- #

Kata.make(NA)

# ---- #

cd(NA)

# ---- #

for pa in ("README.md", ".gitignore", joinpath("test", "runtests.jl"))

    #run(`vi $(joinpath(pwd(), pa))`)

end

# ---- #

Kata.reset()

# ---- #

activate(".")

# ---- #

test()

# ---- #

Kata.format_web()

# ---- #

Kata.format_jl()
