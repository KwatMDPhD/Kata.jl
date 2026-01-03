using Kata

for st in sort!(
    filter!(st -> st != "runtests.jl" && !isdir(st), readdir());
    by = st -> parse(Int, split(st, '.'; limit = 2)[1]),
)

    @info "🎬 Running $st"

    run(`julia --project $st`)

end

# ------------------------------------ #

using Pkg: activate, test

using Test: @test

cd(cp(pkgdir(Kata, "in"), joinpath(tempdir(), "Kata"); force = true))

run(`open --background .`)

Kata.rename("yy", "jj")

Kata.name(; live = true)

for (a1, a2) in (('Z', 'K'), ('z', 'k'))

    Kata.rewrite(a1, a2)

end

const ST = "Name.jl"

Kata.make(ST)

@test basename(pwd()) === ST

Kata.beautify()

Kata.match()

activate(".")

test()

cd(pkgdir(Kata))

Kata.match()
