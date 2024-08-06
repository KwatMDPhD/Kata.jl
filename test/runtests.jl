using Kata

using Aqua: test_all

using Test: @test

test_all(Kata; deps_compat = false)

# ----------------------------------------------------------------------------------------------- #

# ---- #

using Pkg: activate, test

# ---- #

for (st, re) in (
    ("aa_bb", "Aa Bb"),
    ("DNA RNA protein", "DNA RNA Protein"),
    ("this is an antigen", "This Is an Antigen"),
    ("this is AN antigen", "This Is AN Antigen"),
    ("i'm a scientist", "I'm a Scientist"),
    ("i'M A scientist", "I'M A Scientist"),
    ("1st", "1st"),
    ("1ST", "1ST"),
    ("2nd", "2nd"),
    ("2ND", "2ND"),
    ("3rd", "3rd"),
    ("3RD", "3RD"),
    ("4th", "4th"),
    ("5TH", "5TH"),
    ("Acute Dyspnea in the Office", "Acute Dyspnea in the Office"),
)

    @test Kata._title(st) == re

end

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
